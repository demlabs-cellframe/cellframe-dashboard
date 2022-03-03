#ifndef DAPNOTIFICATIONWATCHER_H
#define DAPNOTIFICATIONWATCHER_H
#include <QThread>
#include <QIODevice>
#include <QLocalSocket>


class DapNotificationWatcher :public QThread
{
    QIODevice *socket;

    QString address;
    uint16_t port;

    enum SocketType
    {
        TCP,
        Local
    };

    SocketType socketType;

    bool isConnected();
    void processData();

public:
    DapNotificationWatcher();
    void run() override;
};

#endif // DAPNOTIFICATIONWATCHER_H
