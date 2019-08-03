#ifndef DAPCHAINNODENETWORKMODEL_H
#define DAPCHAINNODENETWORKMODEL_H

#include <QObject>
#include <QTimer>
#include <QHostAddress>
#include <QVariant>

#include "DapNodeType.h"

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
    const DapNodeMap* getDataMap() const;
    const DapNodeData* getNodeData(const QString& aAddress) const;

    QString getCurrentAddress() const;
    Q_INVOKABLE static DapChainNodeNetworkModel &getInstance();
    Q_INVOKABLE bool isNodeOnline(const QString& aAddress) const;

public slots:
    void receiveNewNetwork(const QVariant& aData);
    void receiveNodeStatus(const QVariant& aData);
    Q_INVOKABLE void sendRequestNodeStatus(const bool aIsOnline);
    Q_INVOKABLE void startRequest();
    Q_INVOKABLE void startRequest(const int aTimeout);
    Q_INVOKABLE void stopRequest();

signals:
    void changeNodeNetwork();
    void requestNodeNetwork();
    void requestNodeStatus(bool status);
    void changeStatusNode(QString node, bool isOnline);
    void appendNode(QMap<QString, QVariant>);
};


#endif // DAPCHAINNODENETWORKMODEL_H
