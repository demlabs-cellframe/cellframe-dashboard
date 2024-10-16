#include "DapNotifyController.h"

DapNotifyController::DapNotifyController(QObject * parent) : QObject(parent)
{

    m_node_notify = std::shared_ptr<cellframe_node::notify::CellframeNotificationChannel>(cellframe_node::getCellframeNodeInterface("local")->openNotificationChannel());

    m_node_notify->addNotifyDataCallback([this](const std::string &data)
                                         {
                                             rcvData(QJsonDocument::fromJson(data.c_str()).toVariant());
                                         });

    m_node_notify->addNotifyStatusCallback([this](const cellframe_node::notify::CellframeNotificationChannel::E_NOTIFY_STATUS &status)
                                         {
                                            if(status == cellframe_node::notify::CellframeNotificationChannel::CONNECTED)
                                            {
                                                bool isFirst = false;
                                                if(status != m_connectState)
                                                {
                                                    m_connectState = status;
                                                    isFirst = true;
                                                    emit chainsLoadProgress(QVariantMap());
                                                }
                                                emit socketState(m_connectState, isFirst);
                                            }
                                            else
                                            {
                                                m_connectState = status;
                                                emit socketState(m_connectState, false);
                                            }
                                         });

    m_connectState = m_node_notify->status(); //for init
    emit socketState(m_connectState, true);
}

void DapNotifyController::rcvData(QVariant data)
{
    if(!data.isValid())
        return;

    QVariantMap map = data.toMap();

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
