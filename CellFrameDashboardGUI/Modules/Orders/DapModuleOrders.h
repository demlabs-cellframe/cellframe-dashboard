#ifndef DAPMODULEORDERS_H
#define DAPMODULEORDERS_H

#include <QObject>
#include <QDebug>

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

private:
    DapModulesController* m_modulesCtrl;
    QTimer *m_timerUpdateOrders;

    QPair <bool, bool> s_statusModel{false,false};

    QQmlContext *context;

    DapOrdersModel m_ordersModel;

public:
    void initConnect();

private:
    void modelProcessing(const QVariant &rcvData, bool dexFlag);
    void updateOrdersModel();

signals:

private slots:
    void slotUpdateOrders();

    void rcvOrdersList(const QVariant &rcvData);
    void rcvXchangeOrderList(const QVariant &rcvData);

};

#endif // DAPMODULEORDERS_H
