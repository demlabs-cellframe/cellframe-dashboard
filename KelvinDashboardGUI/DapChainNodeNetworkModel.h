#ifndef DAPNETWORKEXPLORERCONTROLLER_H
#define DAPNETWORKEXPLORERCONTROLLER_H

#include <QObject>
#include <QHostAddress>
#include <QVariant>
//#include "DapChainNode.h"
#include "DapChainNodeNetworkExplorer.h"

class DapChainNodeNetworkModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant data READ getData WRITE setData NOTIFY dataChanged)

    QVariant m_data;

public:
    explicit DapChainNodeNetworkModel(QObject *parent = nullptr);
    Q_INVOKABLE static DapChainNodeNetworkModel &getInstance();

    QVariant getData() const;

public slots:
    void setData(const QVariant& AData);

signals:
    void appendNode(QMap<QString, QVariant>);
    void dataChanged(QVariant data);
};

#endif // DAPNETWORKEXPLORERCONTROLLER_H
