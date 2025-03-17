#ifndef DAPMODULEORDERS_H
#define DAPMODULEORDERS_H

#include <QObject>
#include <QDebug>
#include <QQmlContext>

#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "Models/DapOrdersModel.h"
#include "Models/OrdersProxyModel.h"

class DapModuleOrders : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleOrders(DapModulesController *parent);
    ~DapModuleOrders();

    Q_INVOKABLE void getOrdersList();

    Q_PROPERTY(int currentTab READ currentTab WRITE setCurrentTab)

    Q_PROPERTY(QString pkeyFilter READ getPkeyFilterText WRITE setPkeyFilterText NOTIFY pkeyFilterChanged)
    Q_INVOKABLE QString getPkeyFilterText() const { return m_pkeyFilter; }

    Q_PROPERTY(QString nodeAddrFilter READ getNodeAddrFilterText WRITE setNodeAddrFilterText NOTIFY nodeAddrFilterChanged)
    Q_INVOKABLE QString getNodeAddrFilterText() const { return m_pkeyFilter; }

    int currentTab() const
    { return m_currentTab; }


public slots:
    void setCurrentTab(int tabIndex);
    void setPkeyFilterText(const QString &pkey);
    void setNodeAddrFilterText(const QString &nodeAddr);

private:

    enum tabs{
        VPN = 0,
        DEX = 1,
        Stake = 2
    };
    int m_currentTab {VPN};

    QTimer *m_timerUpdateOrders;

    QPair <bool, bool> s_statusModel{false,false};

    QQmlContext *context;

    OrdersProxyModel m_ordersProxyModel;
    DapOrdersModel m_ordersModel;
    QByteArray buffDexOrders;
    QByteArray buffVPNOrders;

protected:
    QString m_pkeyFilter = "";
    QString m_nodeAddrFilter = "";

public:
    void initConnect();
    Q_INVOKABLE void createStakeOrder(QStringList args);
    Q_INVOKABLE void createVPNOrder(QStringList args);

private:
    void modelProcessing(const QVariant &rcvData, bool dexFlag);
    void updateOrdersModel();

signals:
    void sigCreateVPNOrder(const QVariant& result);
    void sigCreateStakeOrder(const QVariant& result);
    void pkeyFilterChanged(const QString& pkey);
    void nodeAddrFilterChanged(const QString& nodeAddr);

private slots:
    void slotUpdateOrders();

    void rcvOrdersList(const QVariant &rcvData);
    void rcvXchangeOrderList(const QVariant &rcvData);

    void rcvCreateVPNOrder(const QVariant &rcvData);
    void rcvCreateStakeOrder(const QVariant &rcvData);

};

#endif // DAPMODULEORDERS_H
