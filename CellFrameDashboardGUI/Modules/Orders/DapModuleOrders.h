#ifndef DAPMODULEORDERS_H
#define DAPMODULEORDERS_H

#include <QObject>
#include <QDebug>
#include <QQmlContext>

#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "Models/DapOrdersModel.h"

class DapModuleOrders : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleOrders(DapModulesController *parent);
    ~DapModuleOrders();

    Q_INVOKABLE void getOrdersList();

    Q_PROPERTY(int currentTab READ currentTab WRITE setCurrentTab)

    int currentTab() const
    { return m_currentTab; }

public slots:
    void setCurrentTab(int tabIndex);

private:

    enum tabs{
        VPN = 0,
        DEX = 1,
        Stake = 2
    };
    int m_currentTab {VPN};

    DapModulesController* m_modulesCtrl;
    QTimer *m_timerUpdateOrders;

    QPair <bool, bool> s_statusModel{false,false};

    QQmlContext *context;

    DapOrdersModel m_ordersModel;
    QByteArray buffDexOrders;
    QByteArray buffVPNOrders;

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

private slots:
    void slotUpdateOrders();

    void rcvOrdersList(const QVariant &rcvData);
    void rcvXchangeOrderList(const QVariant &rcvData);

    void rcvCreateVPNOrder(const QVariant &rcvData);
    void rcvCreateStakeOrder(const QVariant &rcvData);

};

#endif // DAPMODULEORDERS_H
