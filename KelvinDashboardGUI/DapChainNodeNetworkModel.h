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

    Q_INVOKABLE static DapChainNodeNetworkModel &getInstance();
    /// Get data about whole network with nodes
    /// @return QMap where key is address and value is structure about one node
    const DapNodeMap* getDataMap() const;
    /// Get data about onde node by address
    /// @return data's node structure
    const DapNodeData* getNodeData(const QString& aAddress) const;

    /// Get current address of node
    /// @return address of current node
    QString getCurrentAddress() const;
    /// Get status of node
    /// @return It is true if node is online
    Q_INVOKABLE bool isNodeOnline(const QString& aAddress) const;

public slots:
    /// Receive new network data and repaint the screen
    /// @param QMap<QString, QStringList> data of node n
    void receiveNewNetwork(const QVariant& aData);
    /// Receive changes status for nodes
    void receiveNodeStatus(const QVariant& aData);
    /// Send request to service about changing status of node
    Q_INVOKABLE void sendRequestNodeStatus(const bool aIsOnline);
    /// Start timer for request new data of network
    Q_INVOKABLE void startRequest();
    /// @param time in milliseconds for delay
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
