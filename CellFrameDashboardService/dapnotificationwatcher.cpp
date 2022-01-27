#include "dapnotificationwatcher.h"
#include <QLocalSocket>
#include <QDebug>

DapNotificationWatcher::DapNotificationWatcher()
{
    socket = new QLocalSocket(this);
    connect(socket, QOverload<QLocalSocket::LocalSocketError>::of(&QLocalSocket::error),
            this, &DapNotificationWatcher::slotError);
    socket->setServerName("/tmp/dap_ntfy_sckt");
    socket->connectToServer(QIODevice::ReadOnly);
}

void DapNotificationWatcher::slotError()
{
    qDebug() << "NOOOOOOOOOOOOOOOOOOO! :((";
}
