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
public:
    DapNotificationWatcher(QObject *parent = 0);
    ~DapNotificationWatcher();

    bool initWatcher();
    const QString& getSocketState() const {return m_socketState;}
public slots:
    void slotError();
    void socketConnected();
    void slotReconnect();
    void socketDisconnected();

    void socketReadyRead();

    void tcpSocketStateChanged(QAbstractSocket::SocketState socketState);
    void socketStateChanged(QLocalSocket::LocalSocketState socketState);

    void frontendConnected();

    void isStartNodeChanged(bool isStart);

signals:
    void rcvNotify(QVariant);
    void changeConnectState(QString);

private:
    void reconnectFunc();
    void sendNotifyState(QVariant);
    QByteArrayList jsonListFromData(QByteArray data);
private:
    QIODevice *m_socket;
    QString m_listenPath;
    QString m_listenAddr;
    uint16_t m_listenPort;
    QTimer * m_reconnectTimer;
    QTimer * m_initTimer;

    QString m_socketState;

    bool m_isStartNode = true;
};

#endif // DAPNOTIFICATIONWATCHER_H
