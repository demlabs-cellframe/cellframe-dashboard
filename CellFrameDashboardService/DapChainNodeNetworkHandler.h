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

private:
    QString m_CurrentNetwork;

public:
    explicit DapChainNodeNetworkHandler(QObject *parent = nullptr);

public:
    /// Get current network name
    /// @return name of current network
    const QString& getCurrentNetwork() const;

public slots:
    /// Change status of a node
    /// @param it is true if a node is online
    void setNodeStatus(const bool aIsOnline);
    /// Get new node network
    /// @return data of node network
    QVariant getNodeNetwork() const;
    /// Set current network
    /// @param name of network
    void setCurrentNetwork(const QString& aNetwork);
};

#endif // DAPCHAINNODENETWORKHANDLER_H
