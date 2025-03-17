#ifndef DAPNOTIFYCONTROLLER_H
#define DAPNOTIFYCONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QDebug>
#include <QVariantMap>
#include <QIODevice>
#include <QLocalSocket>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QTimer>

#include "CellframeNode.h"
#include "node_globals/NodeGlobals.h"


class DapNotifyController : public QObject
{
    Q_OBJECT
public:
    explicit DapNotifyController(QObject *parent = nullptr);

    void init();

    Q_PROPERTY(bool isConnected READ isConnected NOTIFY notifySocketStateChanged)
    bool isConnected(){return m_isConnected;}

    void stateProcessing(QString status);
    bool getNotifySocketState(){return m_connectState;}


private:
    QJsonDocument parseData(QString className, const QJsonObject obj, QString key, bool isArray);

signals:
    void notifySocketStateChanged(bool connectState);
    void netStates(QVariantMap netState);

    void sigNotifyRcvNetList(QJsonDocument);
    void sigNotifyRcvNetsInfo(QJsonDocument);
    void sigNotifyRcvWalletList(QJsonDocument);
    void sigNotifyRcvWalletsInfo(QJsonDocument);
    void sigNotifyRcvNetInfo(QJsonDocument);
    void sigNotifyRcvWalletInfo(QJsonDocument);

public:
    void rcvData(QVariant);

private slots:
    void timeoutNetRcv();

private:
    QTimer *m_initTimer;
    QTimer *m_timerCheckNetPack;
    bool m_isConnected{false};
    bool m_connectState;
    std::shared_ptr<cellframe_node::notify::CellframeNotificationChannel> m_node_notify;
};

#endif // DAPNOTIFYCONTROLLER_H
