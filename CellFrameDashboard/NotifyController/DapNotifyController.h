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

#include "CellframeNode.h"


class DapNotifyController : public QObject
{
    Q_OBJECT
public:
    explicit DapNotifyController(QObject *parent = nullptr);

signals:
    void socketState(bool state, int isFirst);
    void netStates(QVariantMap netState);
    void chainsLoadProgress(QVariantMap netState);

public:
    void rcvData(QVariant);

private:
    bool m_connectState;
    std::shared_ptr<cellframe_node::notify::CellframeNotificationChannel> m_node_notify;
};

#endif // DAPNOTIFYCONTROLLER_H
