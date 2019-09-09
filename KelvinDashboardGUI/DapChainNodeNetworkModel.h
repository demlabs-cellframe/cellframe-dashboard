#ifndef DAPCHAINNODENETWORKMODEL_H
#define DAPCHAINNODENETWORKMODEL_H

#include <QObject>
#include <QTimer>
#include <QHostAddress>
#include <QVariant>

#include "DapNodeType.h"

/// Class model for Network Explorer
class DapChainNodeNetworkModel : public QObject
{
    Q_OBJECT

private:
    QVariant m_data;
    QTimer* m_timerRequest;

protected:
    DapNodeMap m_nodeMap;

public:
    explicit DapChainNodeNetworkModel(QObject *parent = nullptr);
    /// Get data about whole network with nodes
    /// @return QMap where key is address and value is structure about one node
    const DapNodeMap* getDataMap() const;
    /// Get data about onde node by address
    /// @return data's node structure
    const DapNodeData* getNodeData(const QString& aAddress) const;

    /// Get current address of node
    QString getCurrentAddress() const;
    Q_INVOKABLE static DapChainNodeNetworkModel &getInstance();
    /// Get status of node
    /// @return if true - online, else - offline
    Q_INVOKABLE bool isNodeOnline(const QString& aAddress) const;

public slots:
    /// Receive new network data and repaint the screen
    void receiveNewNetwork(const QVariant& aData);
    /// Receive changes status for nodes
    void receiveNodeStatus(const QVariant& aData);
    /// Send request to service about changing status of node
    Q_INVOKABLE void sendRequestNodeStatus(const bool aIsOnline);
    /// Start timer for request new data of network
    Q_INVOKABLE void startRequest();
    Q_INVOKABLE void startRequest(const int aTimeout);
    /// Stop timer for request data of network
    Q_INVOKABLE void stopRequest();

signals:
    /// Signal for changing network
    void changeNodeNetwork();
    /// Signal for request network
    void requestNodeNetwork();
    /// Signal for request status of node
    void requestNodeStatus(bool status);
    /// SIgnal about changing status node
    void changeStatusNode(QString node, bool isOnline);
};


#endif // DAPCHAINNODENETWORKMODEL_H
