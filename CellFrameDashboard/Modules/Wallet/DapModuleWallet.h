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
    Q_INVOKABLE virtual void setCurrentWallet(int index);
    Q_INVOKABLE virtual void setCurrentWallet(const QString& walletName);
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

    Q_INVOKABLE void startUpdateFee() {m_timerFeeUpdateWallet->start(TIME_FEE_UPDATE);}
    Q_INVOKABLE void stopUpdateFee() {m_timerFeeUpdateWallet->stop();}

    Q_INVOKABLE void setCurrentTokenDEX(const QString& token);
    Q_PROPERTY(QString balanceDEX        READ getBalanceDEX   NOTIFY currantBalanceDEXChanged)
    Q_INVOKABLE QString getBalanceDEX(const QString& tokenName = "") const;
    Q_INVOKABLE void updateBalanceDEX();
private:
    void initConnect();
    QVariantMap getBalanceInfo(QString name, QString network, QString feeTicker, QString sendTicker);
    void updateWalletInfo(const QJsonDocument &document);

protected:
    virtual void setNewCurrentWallet(const QPair<int, QString> newWallet);
    virtual void updateWalletModel(QVariant, bool isSingle);
    virtual CommonWallet::WalletInfo creatInfoObject(const QJsonObject& walletObject);
    void restoreIndex();
    void updateDexTokenModel();
    int getIndexWallet(const QString& walletName) const;

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

    void rcvCreateWallet(const QVariant &rcvData);
    void rcvRemoveWallet(const QVariant &rcvData);
    void rcvHistory(const QVariant &rcvData);

    void slotUpdateWallet();
    void createTx(QVariant args);
    void requestWalletTokenInfo(QStringList args);

    void updateListWallets();

    void tryUpdateFee();

protected slots:
    virtual void walletsListReceived(const QVariant &rcvData);
    virtual void rcvCreateTx(const QVariant &rcvData);
    virtual void rcvFee(const QVariant &rcvData);
    void startUpdateCurrentWallet();
private:

    WalletHashManager *m_walletHashManager;
    QTimer *m_timerUpdateListWallets;
    QTimer *m_timerUpdateWallet;
    QTimer *m_timerFeeUpdateWallet;
    DapTokensWalletModel* m_DEXTokenModel = nullptr;
    TokenProxyModel* m_tokenFilterModelDEX = nullptr;
    QString m_currentTokenDEX = "";

protected:
    DapModulesController* m_modulesCtrl;
    DapTokensWalletModel* m_tokenModel = nullptr;
    QByteArray m_walletListTest;
    bool m_firstDataLoad = false;
    DapListWalletsModel* m_walletModel = nullptr;
    QMap<QString, CommonWallet::WalletInfo> m_walletsInfo;
    QPair<int,QString> m_currentWallet = {-1, ""};
    DapInfoWalletModel* m_infoWallet = nullptr;
    QByteArray m_walletInfoTest;
    QMap<QString, CommonWallet::FeeInfo> m_feeInfo;
    QByteArray m_walletsInfoTest;


private:
    const int TIME_FEE_UPDATE = 2000;
    const int TIME_WALLET_UPDATE = 5000;
    const int TIME_LIST_WALLET_UPDATE = 3000;
};

#endif // DAPMODULEWALLET_H
