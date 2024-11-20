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
    void chainsLoadProgress(QVariantMap netState);

    void isConnectedChanged();

public:
    void init();
    void rcvData(QVariant);
    void stateProcessing(QString status);
    QString getSocketState(){return m_connectState;}

private:
    QString m_connectState;
    DapNotificationWatcher *m_watcher;
    QThread * m_threadNotify;
};

#endif // DAPNOTIFYCONTROLLER_H
