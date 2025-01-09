#ifndef DAPMODULEWALLET_H
#define DAPMODULEWALLET_H

#include <QObject>
#include <QDebug>
#include <QMap>
#include <QPair>

#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "WalletRestore/wallethashmanager.h"
#include "CommonWallet/DapWalletInfo.h"
#include "../../Models/DapListWalletsModel.h"
#include "../../Models/DapInfoWalletModel.h"

class DapModuleWallet : public DapAbstractModule
{
    Q_OBJECT
public:
    enum DapErrors{
        DAP_NO_ERROR = 0,
        DAP_RCV_FEE_ERROR = 1,
        DAP_NOT_ENOUGHT_TOKENS,
        DAP_NOT_ENOUGHT_TOKENS_FOR_PAY_FEE,
        DAP_NO_TOKENS,
        DAP_UNKNOWN_ERROR
    };

public:
    explicit DapModuleWallet(DapModulesController *parent);
    ~DapModuleWallet();

//    QJsonDocument m_walletsModel;
    Q_PROPERTY(int currentWalletIndex           READ getCurrentIndex        NOTIFY currentWalletChanged)
    Q_PROPERTY(QString currentWalletName        READ getCurrentWalletName   NOTIFY currentWalletChanged)

    Q_INVOKABLE void timerUpdateFlag(bool flag);
    Q_INVOKABLE void getWalletsInfo(QStringList args);
    Q_INVOKABLE void requestWalletInfo(const QString &key);
    Q_INVOKABLE void createWallet(QStringList args);
    Q_INVOKABLE void removeWallet(QStringList args);
    Q_INVOKABLE void getTxHistory(QStringList args);
    Q_INVOKABLE void createPassword(QStringList args);
    Q_INVOKABLE void setCurrentWallet(int index);
    Q_INVOKABLE void setCurrentWallet(const QString& walletName);
    Q_INVOKABLE int getCurrentIndex() const {return m_currentWallet.first;}
    Q_INVOKABLE QString getCurrentWalletName() const {return m_currentWallet.second;}
    Q_INVOKABLE void getComission(QString network);
    Q_INVOKABLE QVariantMap getFee(QString net);
    Q_INVOKABLE QVariantMap getAvailableBalance(QVariantMap);
    Q_INVOKABLE QVariant calculatePrecentAmount(QVariantMap);
    Q_INVOKABLE QVariantMap approveTx(QVariantMap);
    Q_INVOKABLE void sendTx(QVariantMap);
    Q_INVOKABLE void setWalletTokenModel(const QString& network);
    Q_INVOKABLE QString getTokenBalance(const QString &network, const QString& tokenName, const QString& walletName = "") const;
    Q_INVOKABLE QString getAddressWallet(const QString &network, const QString& walletName = "") const;

    Q_INVOKABLE QVariantMap isCreateOrder(const QString& network, const QString& amount, const QString& tokenName);

    Q_INVOKABLE void startUpdateFee() {m_timerFeeUpdateWallet->start(TIME_FEE_UPDATE);};
    Q_INVOKABLE void stopUpdateFee() {m_timerFeeUpdateWallet->stop();}

    Q_INVOKABLE void setCurrentTokenDEX(const QString& token);
    Q_PROPERTY(QString balanceDEX        READ getBalanceDEX   NOTIFY currantBalanceDEXChanged)
    Q_INVOKABLE QString getBalanceDEX(const QString& tokenName = "") const;
    Q_INVOKABLE QString getTokenBalance(const QString& tokenName = "") const;
    Q_INVOKABLE void updateBalanceDEX();
private:
    void initConnect();
    void updateWalletModel(QVariant, bool isSingle);
    void setNewCurrentWallet(const QPair<int, QString> newWallet);
    void updateWalletInfo(const QJsonDocument &document);
    void restoreIndex();
    void updateDexTokenModel();
    int getIndexWallet(const QString& walletName) const;

    CommonWallet::WalletInfo creatInfoObject(const QJsonObject& walletObject);
    QVariantMap getBalanceInfo(QString name, QString network, QString feeTicker, QString sendTicker);
signals:
    void sigWalletInfo(const QVariant& result);
    void sigWalletsInfo(const QVariant& result);
    void sigTxCreate(const QVariant& result);
    void sigWalletCreate(const QVariant& result);
    void sigWalletRemove(const QVariant& result);
    void sigHistory(const QVariant& result);

    void walletsModelChanged();
    void listWalletChanged();
    void listWalletFirstChenged();
    void currentWalletChanged();

    void currantBalanceDEXChanged();
    void feeInfoUpdated();

    void tokenModelChanged();
private slots:
    void rcvWalletsInfo(const QVariant &rcvData);
    void rcvWalletInfo(const QVariant &rcvData);
    void rcvCreateTx(const QVariant &rcvData);
    void rcvCreateWallet(const QVariant &rcvData);
    void rcvRemoveWallet(const QVariant &rcvData);
    void rcvHistory(const QVariant &rcvData);

    void slotUpdateWallet();
    void createTx(QStringList args);
    void requestWalletTokenInfo(QStringList args);

    void updateListWallets();
    void walletsListReceived(const QVariant &rcvData);

    void startUpdateCurrentWallet();
    void rcvFee(const QVariant &rcvData);
    void tryUpdateFee();
private:

    WalletHashManager *m_walletHashManager;

    DapModulesController* m_modulesCtrl;
    QTimer *m_timerUpdateListWallets;
    QTimer *m_timerUpdateWallet;
    QTimer *m_timerFeeUpdateWallet;

    QMap<QString, CommonWallet::WalletInfo> m_walletsInfo;
    QMap<QString, CommonWallet::FeeInfo> m_feeInfo;

    DapListWalletsModel* m_walletModel = nullptr;
    DapInfoWalletModel* m_infoWallet = nullptr;
    DapTokensWalletModel* m_tokenModel = nullptr;
    DapTokensWalletModel* m_DEXTokenModel = nullptr;
    TokenProxyModel* m_tokenFilterModelDEX = nullptr;

    QPair<int,QString> m_currentWallet = {-1, ""};
    QByteArray m_walletListTest;
    QByteArray m_walletsInfoTest;
    QByteArray m_walletInfoTest;

    bool m_firstDataLoad = false;
    QString m_currentTokenDEX = "";
private:
    const int TIME_FEE_UPDATE = 2000;
    const int TIME_WALLET_UPDATE = 5000;
    const int TIME_LIST_WALLET_UPDATE = 3000;
};

#endif // DAPMODULEWALLET_H
