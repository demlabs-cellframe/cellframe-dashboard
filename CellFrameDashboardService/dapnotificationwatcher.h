#ifndef DAPNOTIFICATIONWATCHER_H
#define DAPNOTIFICATIONWATCHER_H
#include <QThread>
#include <QIODevice>
#include <QLocalSocket>


class DapNotificationWatcher : public QObject
{
    Q_OBJECT
    QIODevice *socket;

    QByteArrayList jsonListFromData(QByteArray data);

public:
    DapNotificationWatcher(QObject *parent = 0);
public slots:
    void slotError();
    void socketConnected();
    void socketDisconnected();
    void socketStateChanged(QLocalSocket::LocalSocketState socketState);

    void socketReadyRead();

    void tcpSocketStateChanged(QAbstractSocket::SocketState socketState);

signals:
    void networksStatesReceived(QVariantMap map);

};

#endif // DAPNOTIFICATIONWATCHER_H
