#ifndef DAPCHAINNODENETWORKHANDLER_H
#define DAPCHAINNODENETWORKHANDLER_H

#include <QObject>
#include <QProcess>
#include <QRegExp>
#include <QDebug>
#include <QDataStream>

#include "DapNodeType.h"

/// Class provides to operations with nodes of network
class DapChainNodeNetworkHandler : public QObject
{
    Q_OBJECT

private:
    /// Current network's name
    QString m_CurrentNetwork;

public:
    /// Standard constructor
    explicit DapChainNodeNetworkHandler(QObject *parent = nullptr);

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
