#include "DapNotifyController.h"

DapNotifyController::DapNotifyController(QObject * parent) : QObject(parent)
{

}


void DapNotifyController::rcvData(QVariant data)
{

    qDebug() << data;
    QVariantMap map = data.toMap();

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
                qWarning()<<"Connect Error";
                emit socketState(m_connectState, isFirst, true);
            }
            else
            {
                m_connectState = it.value().toString();
                emit socketState(m_connectState, false, false);
            }
        }
        if(it.key()=="class")
        {
            //TODO
        }
    }
}