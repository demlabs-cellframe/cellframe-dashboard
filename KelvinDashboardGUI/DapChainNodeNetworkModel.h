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

    Q_INVOKABLE static DapChainNodeNetworkModel &getInstance();
    Q_INVOKABLE bool isNodeOnline(const QString& aAddress) const;

public slots:
    void setData(const QVariant& aData);
    Q_INVOKABLE void setStatusNode(const QString& aAddress, const bool aIsOnline);
    Q_INVOKABLE void startRequest();
    Q_INVOKABLE void startRequest(const int aTimeout);
    Q_INVOKABLE void stopRequest();

signals:
    void changeNodeNetwork();
    void requestNodeNetwork();
    void changeStatusNode(QString node, bool isOnline);
    void appendNode(QMap<QString, QVariant>);
};

#endif // DAPCHAINNODENETWORKMODEL_H
