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
    /// Data about network with nodes
    QVariant m_data;
    /// Timer for request
    QTimer* m_timerRequest;

protected:
    /// Data about whole network with nodes
    DapNodeMap m_nodeMap;

public:
    /// Standard constructor
    explicit DapChainNodeNetworkModel(QObject *parent = nullptr);

    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapChainNodeNetworkModel &getInstance();
    /// Get data about whole network with nodes
    /// @return QMap where key is address and value is structure about one node
    const DapNodeMap* getDataMap() const;
    /// Get data about node by address
    /// @param aAddress Address of node
    /// @return data's node structure
    const DapNodeData* getNodeData(const QString& aAddress) const;

    /// Get current address of node
    /// @return address of current node
    QString getCurrentAddress() const;
    /// Get status of node
    /// @param aAddress Address of node
    /// @return It is true if node is online
    Q_INVOKABLE bool isNodeOnline(const QString& aAddress) const;

public slots:
    /// Receive new network data and repaint the screen
    /// @param aData data of node network
    void receiveNewNetwork(const QVariant& aData);
    /// Receive changes status for nodes
    /// @param aData data of node network
    void receiveNodeStatus(const QVariant& aData);
    /// Send request to service about changing status of node
    /// @param aIsOnline set new status to node
    Q_INVOKABLE void sendRequestNodeStatus(const bool aIsOnline);
    /// Start timer for request new data of network
    Q_INVOKABLE void startRequest();
    /// @param aTimeout in milliseconds for delay
    Q_INVOKABLE void startRequest(const int aTimeout);
    /// Stop timer for request data of network
    Q_INVOKABLE void stopRequest();

signals:
    /// Signal for changing network
    void changeNodeNetwork();
    /// Signal for request network
    void requestNodeNetwork();
    /// Signal for request status of node
    /// @param status status of node
    void requestNodeStatus(bool status);
    /// SIgnal about changing status node
    /// @param node Address of node
    /// @param aIsOnline new status to node
    void changeStatusNode(QString asNode, bool aIsOnline);
};


#endif // DAPCHAINNODENETWORKMODEL_H
