#include "DiagnosticWorker.h"

namespace sendFlagsData
{

bool flagSendData;

bool flagSendSysTime;
bool flagSendDahsTime;
bool flagSendMemory;
bool flagSendMemoryFree;

};

DiagnosticWorker::DiagnosticWorker(DapServiceController * service, QObject * parent)
    : QThread{parent},
      m_service(service)
{

    sendFlagsData::flagSendData       = m_settings.value("SendData").toBool();
    sendFlagsData::flagSendSysTime    = m_settings.value("SendSysTime").toBool();
    sendFlagsData::flagSendDahsTime   = m_settings.value("SendDahsTime").toBool();
    sendFlagsData::flagSendMemory     = m_settings.value("SendMemory").toBool();
    sendFlagsData::flagSendMemoryFree = m_settings.value("SendMemoryFree").toBool();
    s_node_list_selected              = m_settings.value("s_node_list_selected").toJsonDocument();

    s_uptime_timer = new QTimer(this);
    connect(s_uptime_timer, &QTimer::timeout,
            this, &DiagnosticWorker::slot_uptime,
            Qt::QueuedConnection);
    s_uptime_timer->start(1000);

    s_node_list_timer = new QTimer(this);
    connect(s_node_list_timer, &QTimer::timeout,
            this, &DiagnosticWorker::slot_update_node_list,
            Qt::QueuedConnection);
    s_node_list_timer->start(5000);

    s_elapsed_timer = new QElapsedTimer();
    s_elapsed_timer->start();

#ifdef Q_OS_LINUX
    m_diagnostic = new LinuxDiagnostic();
#elif defined Q_OS_WIN
    m_diagnostic = new WinDiagnostic();
#elif defined Q_OS_MAC
    m_diagnostic = new MacDiagnostic();
#endif

    connect(m_diagnostic, &AbstractDiagnostic::data_updated,
            this, &DiagnosticWorker::slot_diagnostic_data,
            Qt::QueuedConnection);

    m_diagnostic->start_diagnostic();
    m_diagnostic->start_write(sendFlagsData::flagSendData);

    m_diagnostic->set_node_list(s_node_list_selected);
    slot_update_node_list();

    m_service->requestToService("DapVersionController", "version node");
    connect(m_service, &DapServiceController::versionControllerResult, [=] (const QVariant& versionResult)
    {
        QJsonObject obj_result = versionResult.toJsonObject();
        if(obj_result["message"] == "Reply node version")
            m_node_version = obj_result["lastVersion"].toString();
    });
}
DiagnosticWorker::~DiagnosticWorker()
{
    delete s_uptime_timer;
    delete s_elapsed_timer;
    delete m_diagnostic;

    quit();
    wait();
}

void DiagnosticWorker::slot_diagnostic_data(QJsonDocument data)
{
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
        sys_mem.insert("total_value", 0);
    if(!sendFlagsData::flagSendMemory)
        sys_mem.insert("total", "blocked");
    if(!sendFlagsData::flagSendMemoryFree)
        sys_mem.insert("free", "blocked");


    system.insert("time_update_unix", QDateTime::currentSecsSinceEpoch());
    system.insert("time_update", QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm"));
    system.insert("memory",sys_mem);
    obj.insert("system",system);

    if(proc["status"].toString() == "Offline") //if node offline - clear version
        m_node_version = "";
    else if(m_node_version.isEmpty())
        m_service->requestToService("DapVersionController", "version node");

    proc.insert("version", m_node_version);
    obj.insert("process",proc);
    data.setObject(obj);

    m_diagnostic->s_full_info.setObject(obj);

    emit signalDiagnosticData(data.toJson()); // sig update gui local data
}

void DiagnosticWorker::slot_uptime()
{
    s_uptime = m_diagnostic->get_uptime_string(s_elapsed_timer->elapsed()/1000);
}
void DiagnosticWorker::slot_update_node_list()
{
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
        NodeModel().setModel(&s_data_selected_nodes);
    }

    emit nodesCountChanged();
}

void DiagnosticWorker::addNodeToList(QString mac)
{
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

void DiagnosticWorker::removeNodeFromList(QString mac)
{
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

void DiagnosticWorker::searchSelectedNodes(QString filtr)
{
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

void DiagnosticWorker::searchAllNodes(QString filtr)
{
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

QByteArray DiagnosticWorker::nodeListSelected() const
{
    return s_node_list_selected.toJson();
}

QByteArray DiagnosticWorker::nodeList() const
{
    return s_node_list.toJson();
}

QByteArray DiagnosticWorker::dataSelectedNodes() const
{
    return s_data_selected_nodes.toJson();
}

int DiagnosticWorker::trackedNodesCount() const
{
    return s_node_list_selected.array().count();
}

int DiagnosticWorker::allNodesCount() const
{
    return s_node_list.array().count();
}


bool DiagnosticWorker::flagSendData() const
{
    return sendFlagsData::flagSendData;
}

void DiagnosticWorker::setflagSendData (const bool &flagSendData)
{
    if(sendFlagsData::flagSendData == flagSendData)
        return;

    sendFlagsData::flagSendData = flagSendData;
    m_settings.setValue("SendData", flagSendData);
    m_diagnostic->start_write(sendFlagsData::flagSendData);
    emit flagSendDataChanged();
}

bool DiagnosticWorker::flagSendSysTime() const
{
    return sendFlagsData::flagSendSysTime;
}

void DiagnosticWorker::setFlagSendSysTime (const bool &flagSendSysTime)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendSysTime = flagSendSysTime;
    m_settings.setValue("SendSysTime", flagSendSysTime);
    emit flagSendSysTimeChanged();
    m_flag_stop_send_data = false;
}

bool DiagnosticWorker::flagSendDahsTime() const
{
    return sendFlagsData::flagSendDahsTime;
}

void DiagnosticWorker::setFlagSendDahsTime (const bool &flagSendDahsTime)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendDahsTime = flagSendDahsTime;
    m_settings.setValue("SendDahsTime", flagSendDahsTime);
    emit flagSendDahsTimeChanged();
    m_flag_stop_send_data = false;
}

bool DiagnosticWorker::flagSendMemory() const
{
    return sendFlagsData::flagSendMemory;
}

void DiagnosticWorker::setFlagSendMemory (const bool &flagSendMemory)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendMemory = flagSendMemory;
    m_settings.setValue("SendMemory", flagSendMemory);
    emit flagSendMemoryChanged();
    m_flag_stop_send_data = false;
}

bool DiagnosticWorker::flagSendMemoryFree() const
{
    return sendFlagsData::flagSendMemoryFree;
}

void DiagnosticWorker::setFlagSendMemoryFree (const bool &flagSendMemoryFree)
{
    m_flag_stop_send_data = true;
    sendFlagsData::flagSendMemoryFree = flagSendMemoryFree;
    m_settings.setValue("SendMemoryFree", flagSendMemoryFree);
    emit flagSendMemoryFreeChanged();
    m_flag_stop_send_data = false;
}
