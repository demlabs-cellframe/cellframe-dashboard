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
            if(it.value().toInt() != QAbstractSocket::SocketState::ConnectedState &&
               it.value().toInt() != QAbstractSocket::SocketState::ConnectingState)

            {
                qWarning()<<"Connect Error" << it.value();
                socketError();
            }
        }
        if(it.key()=="class")
        {
            //TODO
        }
    }
}
