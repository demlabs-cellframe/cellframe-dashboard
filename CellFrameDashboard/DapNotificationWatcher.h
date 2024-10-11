#ifndef DAPNOTIFICATIONWATCHER_H
#define DAPNOTIFICATIONWATCHER_H

#include <QThread>
#include <QIODevice>
#include <QLocalSocket>
#include <QTcpSocket>
#include <QTimer>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QDebug>
#include <QProcess>

#include "CellframeNode.h"

class DapNotificationWatcher : public QObject
{
    Q_OBJECT
public:
    DapNotificationWatcher(QObject *parent = 0);
    ~DapNotificationWatcher();

signals:
    void rcvNotify(QVariant); //QVariant - QJsonDocument

private:
    std::shared_ptr<cellframe_node::notify::CellframeNotificationChannel> m_node_notify;
};

#endif // DAPNOTIFICATIONWATCHER_H
