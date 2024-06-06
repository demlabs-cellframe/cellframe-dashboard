#include "DapNotifyController.h"
#include "qjsondocument.h"
#include "qjsonobject.h"

DapNotifyController::DapNotifyController(QObject * parent) : QObject(parent)
{
}

void DapNotifyController::rcvData(QVariant data)
{

    QJsonDocument doc = QJsonDocument::fromJson(data.toString().toUtf8());
    QVariantMap map = doc.object().toVariantMap();
    
//    qDebug() << "[DapNotifyController] [rcvData] A request was received from web3 :" << doc;
    
    if(map.contains("connect_state"))
    {
        QVariant value = map["connect_state"];
        if(value.toString() != QString::number(QAbstractSocket::SocketState::ConnectedState) &&
            value.toString() != QString::number(QAbstractSocket::SocketState::ConnectingState))

        {
            bool isFirst = false;
            if(value.toString() != m_connectState)
                isFirst = true;

            m_connectState = QString::number(value.toInt());
            emit socketState(m_connectState, true, isFirst);
        }
        else
        {
            m_connectState = value.toString();
            emit socketState(m_connectState, false, false);
        }
    }
    if(map.contains("class"))
    {
        QVariant value = map["class"];
//      TODO: notify net update disabled
        if(value.toString() == "Wallet")
        {
            //qDebug()<<"";
        }
        else if(value.toString() == "NetStates")
        {
            emit netStates(map);
        }
    }
}
