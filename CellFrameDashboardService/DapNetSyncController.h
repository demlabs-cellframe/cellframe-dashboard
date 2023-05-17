#ifndef DAPNETSYNCCONTROLLER_H
#define DAPNETSYNCCONTROLLER_H

#include <QObject>
#include <QTimer>
#include <QVariant>
#include <QDebug>
#include <QStringList>
#include <QProcess>
#include <QAbstractSocket>

#include "DapNotificationWatcher.h"

class DapNetSyncController : public QObject
{
    Q_OBJECT
public:
    explicit DapNetSyncController(DapNotificationWatcher* watcher, QObject *parent = nullptr);

private:
    QTimer* m_timerSync;
    DapNotificationWatcher* m_notifWatch;
    QString m_nodeState;
    qint64 m_syncTime{1000*60*10};

private:
    QStringList getNetworkList();
    void goSyncNet(QString net);

private slots:
    void updateTick();
    void rcvNotifState(QString);


signals:

};

#endif // DAPNETSYNCCONTROLLER_H
