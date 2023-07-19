#include "DapModuleDiagnostics.h"

namespace sendFlagsData
{

bool flagSendData;

bool flagSendSysTime;
bool flagSendDahsTime;
bool flagSendMemory;
bool flagSendMemoryFree;

};

DapModuleDiagnostics::DapModuleDiagnostics(DapModulesController *modulesCtrl, DapAbstractModule *parent)
    : DapAbstractModule(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_modulesCtrl(modulesCtrl)
{
    sendFlagsData::flagSendData       = m_settings.value("SendData").toBool();
    sendFlagsData::flagSendSysTime    = m_settings.value("SendSysTime").toBool();
    sendFlagsData::flagSendDahsTime   = m_settings.value("SendDahsTime").toBool();
    sendFlagsData::flagSendMemory     = m_settings.value("SendMemory").toBool();
    sendFlagsData::flagSendMemoryFree = m_settings.value("SendMemoryFree").toBool();
    s_node_list_selected              = m_settings.value("s_node_list_selected").toJsonDocument();

    s_uptime_timer = new QTimer();
    connect(s_uptime_timer, &QTimer::timeout,
            this, &DapModuleDiagnostics::slot_uptime,
            Qt::QueuedConnection);

    s_uptime_timer->start(1000);

    s_node_list_timer = new QTimer();
    connect(s_node_list_timer, &QTimer::timeout,
            this, &DapModuleDiagnostics::slot_update_node_list,
            Qt::QueuedConnection);
    s_node_list_timer->start(5000);

    s_elapsed_timer = new QElapsedTimer();
    s_elapsed_timer->start();

    s_thread = new QThread(this);

#ifdef Q_OS_LINUX
    m_diagnostic = new LinuxDiagnostic();
#elif defined Q_OS_WIN
    m_diagnostic = new WinDiagnostic();
#elif defined Q_OS_MAC
    m_diagnostic = new MacDiagnostic();
#endif

    m_diagnostic->moveToThread(s_thread);
    s_thread->start();

    connect(m_diagnostic, &AbstractDiagnostic::data_updated,
            this, &DapModuleDiagnostics::slot_diagnostic_data,
            Qt::QueuedConnection);

    m_diagnostic->start_diagnostic();
    m_diagnostic->start_write(sendFlagsData::flagSendData);

    m_diagnostic->set_node_list(s_node_list_selected);
    slot_update_node_list();

    s_serviceCtrl->requestToService("DapVersionController", "version node");
    connect(s_serviceCtrl, &DapServiceController::versionControllerResult, [=] (const QVariant& versionResult)
    {
        QJsonObject obj_result = versionResult.toJsonObject();
        if(obj_result["message"] == "Reply node version")
            m_node_version = obj_result["lastVersion"].toString();
    });
}

DapModuleDiagnostics::~DapModuleDiagnostics()
{
    delete s_uptime_timer;
    delete s_elapsed_timer;

    s_thread->quit();
    s_thread->wait();
    delete m_diagnostic;
    delete s_thread;
}

void DapModuleDiagnostics::slot_diagnostic_data(QJsonDocument data)
{
    qDebug()<<"DapModuleDiagnostics::slot_diagnostic_data";
    //insert uptime dashboard into system info
    QJsonObject obj = data.object();
    QJsonObject system = data["system"].toObject();
    QJsonObject sys_mem = system["memory"].toObject();
    QJsonObject proc = data["process"].toObject();

    system.insert("uptime_dashboard", s_uptime);

    if(!sendFlagsData::flagSendDahsTime)
        system.insert("uptime_dashboard", "blocked");
    if(!sendFlagsData::flagSendSysTime)
        system.insert("uptime", "blocked");
    if(!sendFlagsData::flagSendMemory)
        sys_mem.insert("total", "blocked");
    if(!sendFlagsData::flagSendMemoryFree)
        sys_mem.insert("free", "blocked");


    system.insert("time_update_unix", QDateTime::currentSecsSinceEpoch());
    system.insert("memory",sys_mem);
    obj.insert("system",system);

    if(proc["status"].toString() == "Offline") //if node offline - clear version
        m_node_version = "";
    else if(m_node_version.isEmpty())
        s_serviceCtrl->requestToService("DapVersionController", "version node");

    proc.insert("version", m_node_version);
    obj.insert("process",proc);
    data.setObject(obj);

    m_diagnostic->s_full_info.setObject(obj);

    // calculate sizes

    if(sys_mem["total"].toString() != "blocked")
        sys_mem.insert("total", m_diagnostic->get_memory_string(sys_mem["total"].toString().toUInt()));
    if(sys_mem["free"].toString() != "blocked")
        sys_mem.insert("free", m_diagnostic->get_memory_string(sys_mem["free"].toString().toUInt()));

    proc.insert("memory_use_value", m_diagnostic->get_memory_string(proc["memory_use_value"].toString().toUInt()));
    proc.insert("log_size", m_diagnostic->get_memory_string(proc["log_size"].toString().toUInt()));
    proc.insert("DB_size", m_diagnostic->get_memory_string(proc["DB_size"].toString().toUInt()));
    proc.insert("chain_size", m_diagnostic->get_memory_string(proc["chain_size"].toString().toUInt()));

    system.insert("memory",sys_mem);
    obj.insert("system",system);
    obj.insert("process",proc);
    data.setObject(obj);

    emit signalDiagnosticData(data.toJson()); // sig update gui local data
}

void DapModuleDiagnostics::slot_uptime()
{
    s_uptime = m_diagnostic->get_uptime_string(s_elapsed_timer->elapsed()/1000);
}
void DapModuleDiagnostics::slot_update_node_list()
{
    qDebug()<<"DapModuleDiagnostics::slot_update_node_list";
    QJsonDocument buff = m_diagnostic->get_list_nodes();
    if(buff.toJson() != s_node_list.toJson())
    {
        s_node_list = buff;
        emit nodeListChanged();
    }


    buff.setArray(m_diagnostic->s_selected_nodes_list);
    if(buff.toJson() != s_node_list_selected.toJson())
    {
        s_node_list_selected = buff;
        emit nodeListSelectedChanged();
    }

    buff = m_diagnostic->read_data();
    if(buff.toJson() != s_data_selected_nodes.toJson())
    {
        s_data_selected_nodes = buff;
        DapDiagnosticModel().setModel(&s_data_selected_nodes);
    }

    emit nodesCountChanged();
}

void DapModuleDiagnostics::addNodeToList(QString mac)
{
    qDebug()<<"DapModuleDiagnostics::addNodeToList";
    QJsonArray arr = s_node_list_selected.array();
    QJsonObject obj;
    obj.insert("mac", mac);
    arr.append(obj);
    s_node_list_selected.setArray(arr);

    m_settings.setValue("s_node_list_selected", s_node_list_selected);
    m_diagnostic->set_node_list(s_node_list_selected);

    emit nodeListSelectedChanged();
    slot_update_node_list();
}

void DapModuleDiagnostics::removeNodeFromList(QString mac)
{
    qDebug()<<"DapModuleDiagnostics::removeNodeFromList";
    QJsonArray arr = s_node_list_selected.array();

    for (auto itr = arr.begin(); itr != arr.end(); itr++)
    {
        QJsonObject obj = itr->toObject();
        if(obj["mac"].toString() == mac)
        {
            arr.removeAt(itr.i);
            break;
        }
    }

    s_node_list_selected.setArray(arr);

    m_settings.setValue("s_node_list_selected", s_node_list_selected);
    m_diagnostic->set_node_list(s_node_list_selected);

    emit nodeListSelectedChanged();
    slot_update_node_list();
}

void DapModuleDiagnostics::searchSelectedNodes(QString filtr)
{
    qDebug()<<"DapModuleDiagnostics::searchSelectedNodes";
    QJsonArray arr = s_node_list_selected.array();

    for (auto itr = arr.begin(); itr != arr.end(); itr++)
    {
        QJsonObject obj = itr->toObject();

        if(!obj["mac"].toString().toLower().contains(filtr.toLower()))
        {
            arr.removeAt(itr.i);
            itr--;
        }
    }

    QJsonDocument result;
    result.setArray(arr);
    emit filtrSelectedNodesDone(result.toJson());
}

void DapModuleDiagnostics::searchAllNodes(QString filtr)
{
    qDebug()<<"DapModuleDiagnostics::searchAllNodes";
    QJsonArray arr = s_node_list.array();

    for (auto itr = arr.begin(); itr != arr.end(); itr++)
    {
        QJsonObject obj = itr->toObject();

        if(!obj["mac"].toString().toLower().contains(filtr.toLower()))
        {
            arr.removeAt(itr.i);
            itr--;
        }
    }

    QJsonDocument result;
    result.setArray(arr);
    emit filtrAllNodesDone(result.toJson());

}

QByteArray DapModuleDiagnostics::nodeListSelected() const
{
    return s_node_list_selected.toJson();
}

QByteArray DapModuleDiagnostics::nodeList() const
{
    return s_node_list.toJson();
}

QByteArray DapModuleDiagnostics::dataSelectedNodes() const
{
    return s_data_selected_nodes.toJson();
}

int DapModuleDiagnostics::trackedNodesCount() const
{
    return s_node_list_selected.array().count();
}

int DapModuleDiagnostics::allNodesCount() const
{
    return s_node_list.array().count();
}


bool DapModuleDiagnostics::flagSendData() const
{
    return sendFlagsData::flagSendData;
}

void DapModuleDiagnostics::setflagSendData (const bool &flagSendData)
{
    if(sendFlagsData::flagSendData == flagSendData)
        return;

    sendFlagsData::flagSendData = flagSendData;
    m_settings.setValue("SendData", flagSendData);
    m_diagnostic->start_write(sendFlagsData::flagSendData);
    emit flagSendDataChanged();
}

bool DapModuleDiagnostics::flagSendSysTime() const
{
    return sendFlagsData::flagSendSysTime;
}

void DapModuleDiagnostics::setFlagSendSysTime (const bool &flagSendSysTime)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendSysTime = flagSendSysTime;
    m_settings.setValue("SendSysTime", flagSendSysTime);
    emit flagSendSysTimeChanged();
    m_flag_stop_send_data = false;
}

bool DapModuleDiagnostics::flagSendDahsTime() const
{
    return sendFlagsData::flagSendDahsTime;
}

void DapModuleDiagnostics::setFlagSendDahsTime (const bool &flagSendDahsTime)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendDahsTime = flagSendDahsTime;
    m_settings.setValue("SendDahsTime", flagSendDahsTime);
    emit flagSendDahsTimeChanged();
    m_flag_stop_send_data = false;
}

bool DapModuleDiagnostics::flagSendMemory() const
{
    return sendFlagsData::flagSendMemory;
}

void DapModuleDiagnostics::setFlagSendMemory (const bool &flagSendMemory)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendMemory = flagSendMemory;
    m_settings.setValue("SendMemory", flagSendMemory);
    emit flagSendMemoryChanged();
    m_flag_stop_send_data = false;
}

bool DapModuleDiagnostics::flagSendMemoryFree() const
{
    return sendFlagsData::flagSendMemoryFree;
}

void DapModuleDiagnostics::setFlagSendMemoryFree (const bool &flagSendMemoryFree)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendMemoryFree = flagSendMemoryFree;
    m_settings.setValue("SendMemoryFree", flagSendMemoryFree);
    emit flagSendMemoryFreeChanged();
    m_flag_stop_send_data = false;
}

