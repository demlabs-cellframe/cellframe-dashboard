#ifndef DAPNOTIFICATIONWATCHER_H
#define DAPNOTIFICATIONWATCHER_H
#include <QThread>
#include <QIODevice>
#include <QLocalSocket>


class DapNotificationWatcher :public QObject
{
    Q_OBJECT
    QIODevice *socket;

public:
    DapNotificationWatcher();
public slots:
    void slotError();
    void socketConnected();
    void socketDisconnected();
    void socketStateChanged(QLocalSocket::LocalSocketState socketState);

    void socketReadyRead();

    void tcpSocketStateChanged(QAbstractSocket::SocketState socketState);

};

#endif // DAPNOTIFICATIONWATCHER_H
