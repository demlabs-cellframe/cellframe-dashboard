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

    for(auto it=map.begin(); it!=map.end(); it++)
    {
        if(it.key()=="connect_state")
        {
            if(it.value().toString() != QAbstractSocket::SocketState::ConnectedState &&
               it.value().toString() != QAbstractSocket::SocketState::ConnectingState)

            {
                bool isFirst = false;
                if(it.value().toString() != m_connectState)
                    isFirst = true;

                m_connectState = it.value().toInt();
                emit socketState(m_connectState, true, isFirst);
            }
            else
            {
                m_connectState = it.value().toString();
                emit socketState(m_connectState, false, false);
            }
        }
        if(it.key()=="class")
        {
//            TODO: notify net update disabled
            if(it.value().toString() == "Wallet")
            {
                  //qDebug()<<"";
            }
            else if(it.value().toString() == "NetStates")
            {
                    emit netStates(map);
            }
        }
    }
}
