#include "dapnotificationwatcher.h"
#include <QLocalSocket>
#include <QDebug>
#include <dap_config.h>
#include <QTcpSocket>
#include <QTimer>
#include <dapconfigreader.h>
#include <QJsonDocument>


QByteArrayList DapNotificationWatcher::jsonListFromData(QByteArray data)
{
    return data.split('\x00');
}

DapNotificationWatcher::DapNotificationWatcher()
{
    DapConfigReader configReader;

    QString listen_path = configReader.getItemString("notify_server", "listen_path", "");
    QString listen_address = configReader.getItemString("notify_server", "listen_address", "");
    uint16_t listen_port = configReader.getItemInt("notify_server", "listen_port", 0);

    qDebug() << "Tcp config: " << listen_address << listen_port;

    if (!listen_path.isEmpty())
    {
        socket = new QLocalSocket(this);
        connect((QLocalSocket*)socket, QOverload<QLocalSocket::LocalSocketError>::of(&QLocalSocket::error),
                this, &DapNotificationWatcher::slotError);

        connect((QLocalSocket*)socket, &QLocalSocket::connected,
                this, &DapNotificationWatcher::socketConnected);

        connect((QLocalSocket*)socket, &QLocalSocket::disconnected,
                this, &DapNotificationWatcher::socketDisconnected);

        connect((QLocalSocket*)socket, &QLocalSocket::stateChanged,
                this, &DapNotificationWatcher::socketStateChanged);

        ((QLocalSocket*)socket)->connectToServer(listen_path);
        ((QLocalSocket*)socket)->waitForConnected();
    }
    else
    {
        socket = new QTcpSocket(this);
        connect((QTcpSocket*)socket, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::error),
                this, &DapNotificationWatcher::slotError);

        connect((QTcpSocket*)socket, &QTcpSocket::connected,
                this, &DapNotificationWatcher::socketConnected);

        connect((QTcpSocket*)socket, &QTcpSocket::disconnected,
                this, &DapNotificationWatcher::socketDisconnected);

        connect((QTcpSocket*)socket, &QTcpSocket::stateChanged,
                this, &DapNotificationWatcher::tcpSocketStateChanged);

        connect(socket, &QTcpSocket::readyRead, this, &DapNotificationWatcher::socketReadyRead);

        ((QTcpSocket*)socket)->connectToHost(listen_address, listen_port);
        ((QTcpSocket*)socket)->waitForConnected(10000);
    }
}

void DapNotificationWatcher::slotError()
{
    qDebug() << "Socket error" << socket->errorString();
}

void DapNotificationWatcher::socketConnected()
{
    qDebug() << "Socket connected";
    socket->waitForReadyRead(10000);
}

void DapNotificationWatcher::socketDisconnected()
{
    qDebug() << "Socket disconnected";
}

void DapNotificationWatcher::socketStateChanged(QLocalSocket::LocalSocketState socketState)
{
    qDebug() << "Local socket state changed" << socketState;
}

void DapNotificationWatcher::socketReadyRead()
{
    qDebug() << "Ready Read";
    QByteArray data = socket->readLine();
    if (data[data.length() - 1] != '}')
        data = data.left(data.length() - 1);

    if (data[0] != '{')
        data = data.right(data.length() - 1);

    QByteArrayList list = jsonListFromData(data);

    for (int i = 0; i < list.length(); ++i)
    {
        QJsonDocument doc = QJsonDocument::fromJson(data);
        QVariantMap var = doc.toVariant().toMap();
        qDebug() << data << var;
    }

}

void DapNotificationWatcher::tcpSocketStateChanged(QAbstractSocket::SocketState socketState)
{
    qDebug() << "Tcp socket state changed" << socketState;
}
