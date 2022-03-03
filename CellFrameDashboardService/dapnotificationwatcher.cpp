#include "dapnotificationwatcher.h"
#include <QLocalSocket>
#include <QDebug>
#include <dap_config.h>
#include <QTcpSocket>
#include <QTimer>
#include "dapconfigreader.h"

bool DapNotificationWatcher::isConnected()
{
    switch (socketType)
    {
        case SocketType::Local:
        {
            return ((QLocalSocket*)(socket))->state() == QLocalSocket::ConnectedState;
        }
        case SocketType::TCP:
        {
            return ((QTcpSocket*)(socket))->state() == QTcpSocket::ConnectedState;
        }
    }
}

void DapNotificationWatcher::processData()
{
    while (1)
    {
        if (socket->waitForReadyRead(1000))
        {
            if (socket->canReadLine())
            {
                qDebug() << "SOCKET" << socket->readLine();
            }
        }
        if (!isConnected())
            break;
    }
}

DapNotificationWatcher::DapNotificationWatcher()
{

    DapConfigReader configReader;

    QString listen_path = configReader.getItemString("notify_server", "listen_path", "");
    QString listen_address = configReader.getItemString("notify_server", "listen_addr", "");
    uint16_t listen_port = configReader.getItemInt("notify_server", "listen_port", 0);

    //qDebug() << "hhhhhhhhhhhhhh" << listen_path << listen_address << listen_port;

    //QString listen_path = QString::fromLatin1(dap_config_get_item_str_default(g_config, "notify_server", "listen_path",NULL));
    //QString listen_path = "/tmp/node_notify";
    QString listen_path_mode = QString::fromLatin1(dap_config_get_item_str_default(g_config, "notify_server", "listen_path_mode","0600"));

    //QString listen_address = "127.0.0.1";//QString::fromLatin1(dap_config_get_item_str_default(g_config, "notify_server", "listen_address",NULL));
    //uint16_t listen_port = 18888;//dap_config_get_item_uint16_default(g_config, "notify_server", "listen_port",0);

    if (!listen_path.isEmpty())
    {
        address = listen_path;
        port = 0;
        socketType = SocketType::Local;
        socket = new QLocalSocket(this);
    }
    else
    {
        address = listen_address;
        port = listen_port;
        socketType = SocketType::TCP;
        socket = new QTcpSocket(this);
    }
}

void DapNotificationWatcher::run()
{
    qDebug() << "RUNNNN";
    while (1)
    {
        switch (socketType)
        {
            case SocketType::Local:
            {
                ((QLocalSocket*)(socket))->connectToServer(address);
                ((QLocalSocket*)(socket))->waitForConnected(10000);
            }
            case SocketType::TCP:
            {
                ((QTcpSocket*)(socket))->connectToHost(address, port);
                ((QTcpSocket*)(socket))->waitForConnected(10000);
            }
        }
        if (isConnected())
        {
            processData();
        }
    }
}
