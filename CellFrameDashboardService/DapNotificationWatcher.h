#ifndef DAPNOTIFICATIONWATCHER_H
#define DAPNOTIFICATIONWATCHER_H
#include <QThread>
#include <QIODevice>
#include <QLocalSocket>
#include <QTimer>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>


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
    void slotReconnect();
    void socketDisconnected();

    void socketReadyRead();

    void tcpSocketStateChanged(QAbstractSocket::SocketState socketState);
    void socketStateChanged(QLocalSocket::LocalSocketState socketState);

    void frontendConnected();

signals:
    void rcvNotify(QVariant);

private:
    void reconnectFunc();
    void sendNotifyState(QVariant);

private:
    QString m_listenPath;
    QString m_listenAddr;
    uint16_t m_listenPort;
    QString m_socketState;
    QTimer * m_reconnectTimer;

};

#endif // DAPNOTIFICATIONWATCHER_H
