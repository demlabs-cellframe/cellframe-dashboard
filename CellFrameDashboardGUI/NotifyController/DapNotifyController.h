#ifndef DAPNOTIFYCONTROLLER_H
#define DAPNOTIFYCONTROLLER_H

#include <QObject>
#include <QVariant>
#include <QDebug>
#include <QVariantMap>
#include <QIODevice>
#include <QLocalSocket>

class DapNotifyController : public QObject
{
    Q_OBJECT
public:
    explicit DapNotifyController(QObject *parent = nullptr);

signals:
    void socketState(QString state, int isFirst, int isError);
    void netStates(QVariantMap netState);
    void chainsLoadProgress(QVariantMap netState);

public:
    void rcvData(QVariant);

private:
    QString m_connectState;
};

#endif // DAPNOTIFYCONTROLLER_H
