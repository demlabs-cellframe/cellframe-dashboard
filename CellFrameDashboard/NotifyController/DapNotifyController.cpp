#include "DapNotifyController.h"

DapNotifyController::DapNotifyController(QObject * parent) : QObject(parent)
{

    m_node_notify = std::shared_ptr<cellframe_node::notify::CellframeNotificationChannel>(cellframe_node::getCellframeNodeInterface("local")->openNotificationChannel());

    m_node_notify->addNotifyDataCallback([this](const std::string &data)
                                         {
                                             rcvData(QJsonDocument::fromJson(data.c_str()).toVariant());
                                         });

}

void DapNotifyController::rcvData(QVariant data)
{
    if(!data.isValid())
        return;

    QVariantMap map = data.toMap();

    if(m_node_notify->status() == cellframe_node::notify::CellframeNotificationChannel::CONNECTED)
    {
        bool isFirst = false;
        if(m_node_notify->status() != m_connectState)
        {
            m_connectState = m_node_notify->status();
            isFirst = true;
        }
        emit chainsLoadProgress(QVariantMap());
        emit socketState(m_connectState, isFirst);
    }
    else
    {
        m_connectState = m_node_notify->status();
        emit socketState(m_connectState, false);
    }

    if(map.contains("class"))
    {
        QVariant value = map["class"];
        if(value.toString() == "Wallet")
        {

        }
        else if(value.toString() == "NetStates")
        {
            emit netStates(map);
        }
        else if(value.toString() == "chain_init")
        {
            qDebug() << "[DapNotifyController] chain init - " << map;
            emit chainsLoadProgress(map);
        }
    }
}
