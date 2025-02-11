#include "DapModuleDiagnostics.h"

DapModuleDiagnostics::DapModuleDiagnostics(DapModulesController *parent)
    : DapAbstractModule(parent)
{
    s_flagSendData        = m_settings.value("SendData").toBool();
    s_node_list_selected  = m_settings.value("s_node_list_selected").toJsonDocument();

    s_node_list_timer = new QTimer();
    connect(s_node_list_timer, &QTimer::timeout,
            this, &DapModuleDiagnostics::slot_update_node_list,
            Qt::QueuedConnection);
    s_node_list_timer->start(5000);

    s_thread = new QThread(this);
    m_diagnostic = new AbstractDiagnostic();
    m_diagnostic->moveToThread(s_thread);
    s_thread->start();

    connect(m_diagnostic, &AbstractDiagnostic::diagtool_socket_change_status,
            this, &DapModuleDiagnostics::slot_connect_status_changed,
            Qt::QueuedConnection);

    connect(m_diagnostic, &AbstractDiagnostic::data_updated,
            this, &DapModuleDiagnostics::slot_diagnostic_data,
            Qt::QueuedConnection);

    m_diagnostic->set_node_list(s_node_list_selected);
    slot_update_node_list();

    m_diagnostic->changeDataSending(s_flagSendData);
    s_socketConnectStatus = m_diagnostic->getConnectDiagStatus();
    emit socketConnectStatusChanged();
}

DapModuleDiagnostics::~DapModuleDiagnostics()
{
    s_thread->quit();
    s_thread->wait();
    delete m_diagnostic;
    delete s_thread;
}

void DapModuleDiagnostics::slot_connect_status_changed(bool status)
{
    s_socketConnectStatus = status;
    if(s_socketConnectStatus)
        m_diagnostic->changeDataSending(s_flagSendData);

    emit socketConnectStatusChanged();
}

void DapModuleDiagnostics::slot_diagnostic_data(QJsonDocument data)
{
    emit signalDiagnosticData(data.toJson()); // sig update gui local data
}

void DapModuleDiagnostics::slot_update_node_list()
{
    QJsonArray listNoMacInfo;
    QJsonDocument data = m_diagnostic->get_list_data(listNoMacInfo);
    QJsonDocument keys = m_diagnostic->get_list_keys(listNoMacInfo);
    try_update_data(keys, data);
    m_diagnostic->update_full_data();
}

void DapModuleDiagnostics::try_update_data(const QJsonDocument list, const QJsonDocument data)
{
    QJsonDocument buffListNode = list;
    if(buffListNode.toJson() != s_node_list.toJson())
    {
        s_node_list = buffListNode;
        emit nodeListChanged();
    }

    buffListNode.setArray(m_diagnostic->s_selected_nodes_list);
    if(buffListNode.toJson() != s_node_list_selected.toJson())
    {
        s_node_list_selected = std::move(buffListNode);
        emit nodeListSelectedChanged();
    }

    QJsonDocument buffData = data;
    if(buffData.toJson() != s_data_selected_nodes.toJson())
    {
        s_data_selected_nodes = std::move(buffData);
        DapDiagnosticModel().setModel(&s_data_selected_nodes);
    }

    emit nodesCountChanged();
}

void DapModuleDiagnostics::addNodeToList(QString mac)
{
    QJsonArray arr = s_node_list_selected.array();
    for(const QJsonValue& objectJson: qAsConst(arr))
    {
        if(objectJson.toObject()["mac"].toString() == mac)
        {
            return;
        }
    }
    QJsonObject obj;
    obj.insert("mac", mac);
    arr.insert(0, obj);
    updateNode(arr);
}

void DapModuleDiagnostics::removeNodeFromList(QString mac)
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

    updateNode(arr);
}

void DapModuleDiagnostics::updateNode(const QJsonArray& array)
{
    s_node_list_selected.setArray(array);

    m_settings.setValue("s_node_list_selected", s_node_list_selected);
    m_diagnostic->set_node_list(s_node_list_selected);

    emit nodeListSelectedChanged();
    slot_update_node_list();
}

void DapModuleDiagnostics::searchSelectedNodes(QString filtr)
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

void DapModuleDiagnostics::searchAllNodes(QString filtr)
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

QByteArray DapModuleDiagnostics::getDiagData() const
{
    return m_diagnostic->get_full_info().toJson();
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
    return s_flagSendData;
}

bool DapModuleDiagnostics::socketConnectStatus() const
{
    return s_socketConnectStatus;
}

void DapModuleDiagnostics::setflagSendData (const bool &flagSendData)
{
    if(s_flagSendData == flagSendData)
        return;

    s_flagSendData = flagSendData;

    m_settings.setValue("SendData", s_flagSendData);
    m_diagnostic->changeDataSending(s_flagSendData);
    emit flagSendDataChanged();
}

