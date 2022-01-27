#ifndef DAPNOTIFICATIONWATCHER_H
#define DAPNOTIFICATIONWATCHER_H
#include <QThread>
#include <QIODevice>
#include <QLocalSocket>


class DapNotificationWatcher :public QThread
{
    //QIODevice *socket;
    QLocalSocket *socket;
public:
    DapNotificationWatcher();
public slots:
    void slotError();

};

#endif // DAPNOTIFICATIONWATCHER_H
