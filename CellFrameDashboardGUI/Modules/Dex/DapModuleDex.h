#ifndef DAPMODULEDEX_H
#define DAPMODULEDEX_H

#include <QObject>
#include <QDebug>
#include <QList>
#include <QMap>
#include <QTimer>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "Models/DEXModel/DapTokenPairModel.h"
#include "Models/DEXModel/DapOrderHistoryModel.h"
#include "Models/DEXModel/OrdersHistoryProxyModel.h"
#include "Models/DEXModel/DEXTypes.h"
#include "StockDataWorker/StockDataWorker.h"

class DapModuleDex : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleDex(DapModulesController *parent = nullptr);
    ~DapModuleDex();

    void requestTokenPairs();
    void requestCurrentTokenPairs();
    void requestHistoryTokenPairs();
    void requestHistoryOrders();
    void requestTXList();

    Q_PROPERTY(QString displayText READ getDisplayText NOTIFY currentTokenPairChanged)
    Q_INVOKABLE QString getDisplayText() const { return m_currentPair.displayText; }

    Q_PROPERTY(QString currentRate READ getCurrentRate NOTIFY currentTokenPairChanged)
    Q_INVOKABLE QString getCurrentRate() const { return m_currentPair.rate; }

    Q_PROPERTY(QString token1 READ getToken1 NOTIFY currentTokenPairChanged)
    Q_INVOKABLE QString getToken1() const { return m_currentPair.token1; }

    Q_PROPERTY(QString token2 READ getToken2 NOTIFY currentTokenPairChanged)
    Q_INVOKABLE QString getToken2() const { return m_currentPair.token2; }

    Q_INVOKABLE DEX::InfoTokenPair getCurrentTokenPair() const { return m_currentPair; }

    Q_INVOKABLE void setCurrentTokenPair(const QString& namePair);

    void setStatusProcessing(bool status) override;

signals:
    void currentTokenPairChanged();
    void currentTokenPairInfoChanged();
    void orderHistoryChanged();

private slots:
    void startInitData();

    void respondTokenPairs(const QVariant &rcvData);
    void respondCurrentTokenPairs(const QVariant &rcvData);
    void respondTokenPairsHistory(const QVariant &rcvData);
    void respondOrdersHistory(const QVariant &rcvData);
private:
    void onInit();
    bool isCurrentPair();
    void setOrdersHistory(const QByteArray& data);
private:

    DapModulesController  *m_modulesCtrl = nullptr;
    DapTokenPairModel* m_tokenPairsModel = nullptr;
    DapOrderHistoryModel *m_ordersModel = nullptr;
    OrdersHistoryProxyModel *m_proxyModel = nullptr;
    StockDataWorker *m_stockDataWorker = nullptr;

    QTimer* m_allTakenPairsUpdateTimer = nullptr;
    QTimer* m_curentTokenPairUpdateTimer = nullptr;
    QTimer* m_ordersHistoryUpdateTimer = nullptr;

    QByteArray* m_ordersHistoryCash;
    QList<DEX::Order> m_ordersHistory;

    QMap<QString, DEX::InfoTokenPair> m_tokensPair;
    DEX::InfoTokenPair m_currentPair;

    QString m_currentNetwork;

    bool m_isSandXchangeTokenPriceAverage = false;
    bool m_isSandDapGetXchangeTokenPair = false;

    const int ALL_TOKEN_UPDATE_TIMEOUT = 10000;
    const int CURRENT_TOKEN_UPDATE_TIMEOUT = 1000;
    const int ORDERS_HISTORY_UPDATE_TIMEOUT = 5000;
};

#endif // DAPMODULEDEX_H
