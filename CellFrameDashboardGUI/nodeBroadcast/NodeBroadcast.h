#ifndef NODEBROADCAST_H
#define NODEBROADCAST_H

#include <QObject>
#include <QDebug>

class NodeBroadcast : public QObject
{
    Q_OBJECT
public:
    NodeBroadcast(QObject *parent = nullptr);

    Q_INVOKABLE void nodeRequest(const QString& request);

signals:
    void nodeReply(const QString& reply);
};

#endif // NODEBROADCAST_H
