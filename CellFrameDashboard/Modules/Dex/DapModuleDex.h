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
#include "Models/DEXModel/TokenPairsProxyModel.h"
#include "Models/DapStringListModel.h"
#include "StockDataWorker/StockDataWorker.h"
#include "DapWalletsManagerBase.h"
#include "Models/DapTokensWalletModel.h"
#include "Models/TokenProxyModel.h"

class  DapModuleDex : public DapAbstractModule
{
    Q_OBJECT

    enum PairFoundResultType
    {
        NO_PAIR = 0,
        IS_PAIR,
        IS_MIRROR_PAIR,
        BASE_IS_EMPTY
    };

public:
    explicit DapModuleDex(DapModulesController *parent = nullptr);
    ~DapModuleDex();

    void requestTokenPairs();
    void requestCurrentTokenPairs();
    void requestHistoryTokenPairs();
    void requestHistoryOrders();
    void requestTXList();
    void requestOrderPurchase(const QStringList& params);
    void requestOrderCreate(const QStringList& params);

    Q_INVOKABLE void requestOrderDelete(const QString& network, const QString& hash, const QString &fee, const QString &tokenName, const QString &amount);

    Q_PROPERTY(QString networkFilter READ getNetworkFilterText WRITE setNetworkFilterText NOTIFY networkFilterChanged)
    Q_INVOKABLE QString getNetworkFilterText() const { return m_networkFilter; }

    Q_PROPERTY(int stepChart READ getStepChart WRITE setStepChart NOTIFY stepChartChanged)
    Q_INVOKABLE int getStepChart() const { return m_stepChartIndex; }

    Q_PROPERTY(QString displayText READ getDisplayText NOTIFY currentTokenPairChanged)
    Q_INVOKABLE QString getDisplayText() const { return m_currentPair.displayText; }

    Q_PROPERTY(QString currentRate READ getCurrentRate NOTIFY currentTokenPairInfoChanged)
    Q_INVOKABLE QString getCurrentRate() const { return m_currentPair.rate; }

    Q_PROPERTY(bool isReadyDataPair READ getIsReadyDataPair NOTIFY isReadyDataPairChanged)
    Q_INVOKABLE bool getIsReadyDataPair() const { return m_currentPair.isDataReady; }

    Q_PROPERTY(QString token1 READ getToken1 NOTIFY currentTokenPairChanged)
    Q_INVOKABLE QString getToken1() const { return m_currentPair.token1; }

    Q_PROPERTY(QString token2 READ getToken2 NOTIFY currentTokenPairChanged)
    Q_INVOKABLE QString getToken2() const { return m_currentPair.token2; }

    Q_PROPERTY(QString networkPair READ getNetworkPair NOTIFY currentTokenPairChanged)
    Q_INVOKABLE QString getNetworkPair() const { return m_currentPair.network; }

    Q_INVOKABLE QString invertValue();
    Q_INVOKABLE QString invertValue(const QString& price);
    Q_INVOKABLE QString multCoins(const QString& a, const QString& b);
    Q_INVOKABLE QString divCoins(const QString& a, const QString& b);
    Q_INVOKABLE QString minusCoins(const QString& a, const QString& b);
    Q_INVOKABLE int diffNumber(const QString& a, const QString& b);

    Q_INVOKABLE QString tryCreateOrder(bool isSell, const QString& price, const QString& amount, const QString& fee);
    Q_INVOKABLE QString tryExecuteOrder(const QString& hash, const QString& amount, const QString& fee, const QString &tokenName);

    Q_INVOKABLE DEX::InfoTokenPair getCurrentTokenPair() const { return m_currentPair; }

    Q_INVOKABLE void setCurrentTokenPair(const QString& namePair, const QString &network);

    Q_INVOKABLE void setCurrentPrice(const QString& price) { m_currantPriceForCreate = price;}
    Q_INVOKABLE QString getCurrentPrice() const {return m_currantPriceForCreate;}
    Q_INVOKABLE void tokenPairModelCountChanged(int count);

    Q_INVOKABLE bool isValidValue(const QString& value);

    Q_PROPERTY(QString balance        READ getBalance   NOTIFY currantBalanceChanged)
    Q_INVOKABLE QString getBalance(const QString& tokenName = "") const;
    Q_INVOKABLE void updateBalance();
    Q_INVOKABLE void setCurrentToken(const QString& token);

    Q_INVOKABLE QVariantMap isCreateOrder(const QString& network, const QString& amount, const QString& tokenName);

    void setStatusProcessing(bool status) override;
public slots:
    virtual void setNetworkFilterText(const QString &network);
    void setStepChart(const int &index);

signals:
    void currentTokenPairChanged();
    void currentTokenPairInfoChanged();
    void isReadyDataPairChanged();
    void orderHistoryChanged();
    void txListChanged();

    void dexNetListChanged();
    void networkFilterChanged(const QString& network);
    void stepChartChanged(const int& index);

    void currentRateFirstTime();
    void currantBalanceChanged();
protected slots:
    void startInitData();

    void respondTokenPairs(const QVariant &rcvData);
    void respondCurrentTokenPairs(const QVariant &rcvData);
    void respondTokenPairsHistory(const QVariant &rcvData);
    void respondOrdersHistory(const QVariant &rcvData);
    void respondTxList(const QVariant &rcvData);

    void currentRateFirstTimeSlot();

    void currentWalletChangedSlot();
    void walletInfoChangedSlot(const QString &walletName, const QString &networkName);

private slots:
    void slotUpdateData() override;

protected:
    void onInit();
    bool isCurrentPair();
    void setOrdersHistory(const QByteArray& data);

    QString roundCoins(const QString& str);

    inline PairFoundResultType isPair(const QString& token1, const QString& token2, const QString& network);

    virtual bool setCurrentTokenPairVariable(const QString& namePair, const QString &network);
    virtual void workersUpdate();
    virtual void updateTokenModels();

    void setCurrentRateFromModel();

    const QPair<int,QString>& getCurrentWallet() const;
    DapWalletsManagerBase* getWalletManager() const;

    QStringList getListNetwork() const;

    void updateDexTokenModel();
protected:
    DapTokenPairModel* m_tokenPairsModel = nullptr;

    DapOrderHistoryModel *m_ordersModel = nullptr;
    OrdersHistoryProxyModel *m_proxyModel = nullptr;
    TokenPairsProxyModel *m_tokenPairsProxyModel = nullptr;
    DapStringListModel* m_netListModel = nullptr;
    DapStringListModel* m_rightPairListModel = nullptr;
    StockDataWorker *m_stockDataWorker = nullptr;
    DapTokensWalletModel* m_DEXTokenModel = nullptr;
    TokenProxyModel* m_tokenFilterModelDEX = nullptr;

    QTimer* m_allTakenPairsUpdateTimer = nullptr;
    QTimer* m_curentTokenPairUpdateTimer = nullptr;
    QTimer* m_ordersHistoryUpdateTimer = nullptr;

    QByteArray m_tokenPairsCash;
    QByteArray m_ordersHistoryCash;
    QByteArray m_txListCash;
    QList<DEX::Order> m_ordersHistory;
    QMap<QString, QSet<QString>> m_txListsforWallet;

    QList<DEX::InfoTokenPair> m_tokensPair;
    DEX::InfoTokenPair m_currentPair;

    QString m_networkFilter = "";
    QString m_currentNetwork = "";
    QString m_currentTokenDEX = "";

    QString m_currantPriceForCreate = "";

    bool m_isSandXchangeTokenPriceAverage = false;
    bool m_isSandDapGetXchangeTokenPair = false;

    int m_stepChartIndex = 0;

    const int ALL_TOKEN_UPDATE_TIMEOUT = 60000;
    const int CURRENT_TOKEN_UPDATE_TIMEOUT = 1000;
    const int ORDERS_HISTORY_UPDATE_TIMEOUT = 30000;

    const QRegularExpression REGULAR_VALID_VALUE = QRegularExpression(R"((?=.*[0-9])(?:\d+|\d*\.\d+)$)");
};

#endif // DAPMODULEDEX_H
