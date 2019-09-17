#ifndef DAPCHAINNODENETWORKHANDLER_H
#define DAPCHAINNODENETWORKHANDLER_H

#include <QObject>
#include <QProcess>
#include <QRegExp>
#include <QDebug>
#include <QDataStream>

#include "DapNodeType.h"

class DapChainNodeNetworkHandler : public QObject
{
    Q_OBJECT

public:
    explicit DapChainNodeNetworkHandler(QObject *parent = nullptr);

public slots:
    /// Change status of a node
    /// @param it is true if a node is online
    void setNodeStatus(const bool aIsOnline);
    /// Get new node network
    /// @return data of node network
    QVariant getNodeNetwork() const;
};

#endif // DAPCHAINNODENETWORKHANDLER_H
