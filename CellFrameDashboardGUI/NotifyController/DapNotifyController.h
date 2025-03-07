#ifndef DAPNOTIFYCONTROLLER_H
#define DAPNOTIFYCONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QDebug>
#include <QVariantMap>
#include <QIODevice>
#include <QLocalSocket>
#include "DapNotificationWatcher.h"

class DapNotifyController : public QObject
{
    Q_OBJECT
public:
    explicit DapNotifyController(QObject *parent = nullptr);

    Q_PROPERTY(bool isConnected READ isConnected NOTIFY isConnectedChanged)
    bool isConnected(){return m_isConnected;}
    bool m_isConnected{false};

signals:
    void socketState(QString state, int isFirst, int isError);
    void netStates(QVariantMap netState);

    void isConnectedChanged(bool isConnected);

public:
    void init();
    void rcvData(QVariant);
    void stateProcessing(QString status);
    QString getSocketState(){return m_connectState;}

private:
    QJsonDocument parseData(QString className, const QJsonObject obj, QString key, bool isArray);

private slots:
    void timeoutNetRcv();

private:
    QString m_connectState;
    DapNotificationWatcher *m_watcher;
    QThread * m_threadNotify;
    QTimer * m_timerCheckNetPack;

signals:
    void sigNotifyRcvNetList(QJsonDocument);
    void sigNotifyRcvNetsInfo(QJsonDocument);
    void sigNotifyRcvWalletList(QJsonDocument);
    void sigNotifyRcvWalletsInfo(QJsonDocument);
    void sigNotifyRcvNetInfo(QJsonDocument);
    void sigNotifyRcvWalletInfo(QJsonDocument);
};

#endif // DAPNOTIFYCONTROLLER_H
