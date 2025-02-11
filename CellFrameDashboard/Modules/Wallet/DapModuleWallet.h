#ifndef DAPMODULEWALLET_H
#define DAPMODULEWALLET_H

#include <QObject>
#include <QDebug>
#include <QMap>
#include <QPair>
#include <QStringList>

#include "../DapTypes/DapCoin.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "../../Models/DapListWalletsModel.h"
#include "../../Models/DapInfoWalletModel.h"

#include "WalletRestore/wallethashmanager.h"
#include "CommonWallet/DapWalletInfo.h"
#include "CommandKeys.h"
#include "DapWalletsManagerBase.h"
#include "DapDataManagerController.h"
#include "DapTransactionManager.h"

class DapWalletsManagerBase;

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

    Q_PROPERTY(int currentWalletIndex           READ getCurrentIndex        NOTIFY currentWalletChanged)
    Q_PROPERTY(QString currentWalletName        READ getCurrentWalletName   NOTIFY currentWalletChanged)

    Q_INVOKABLE void createWallet(const QStringList &args);
    Q_INVOKABLE void removeWallet(QStringList args);
    Q_INVOKABLE void createPassword(QStringList args);
    Q_INVOKABLE virtual void setCurrentWallet(int index);
    Q_INVOKABLE virtual void setCurrentWallet(const QString& walletName);
    Q_INVOKABLE int getCurrentIndex() const;
    Q_INVOKABLE QString getCurrentWalletName() const;
    Q_INVOKABLE QVariantMap getFee(QString net);
    Q_INVOKABLE QVariantMap getAvailableBalance(QVariantMap);
    Q_INVOKABLE QVariant calculatePrecentAmount(QVariantMap);
    Q_INVOKABLE QVariantMap approveTx(QVariantMap);
    Q_INVOKABLE void sendTx(QVariantMap);
    Q_INVOKABLE void setWalletTokenModel(const QString& network);
    Q_INVOKABLE QString getTokenBalance(const QString &network, const QString& tokenName, const QString& walletName = "") const;
    Q_INVOKABLE QString getAddressWallet(const QString &network, const QString& walletName = "") const;
    Q_INVOKABLE void updateWalletList();
    Q_INVOKABLE void updateWalletInfo();
    Q_INVOKABLE void activateOrDeactivateWallet(const QString& walletName,
                                                const QString& target, const QString& pass = "", const QString& ttl = "");
    Q_INVOKABLE bool isConteinListWallets(const QString& walletName);
private:
    const QMap<QString, CommonWallet::WalletInfo>& getWalletsInfo() const;
protected:
    virtual void setNewCurrentWallet(const QPair<int, QString> newWallet);
    QString getSavedWallet();
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

    void tokenModelChanged();

    void passwordCreated(const QString& message);
protected slots:
    virtual void rcvCreateTx(const QVariant &rcvData);
private slots:
    void slotUpdateData() override;
    void rcvCreateWallet(const QVariant &rcvData);
    void rcvRemoveWallet(const QVariant &rcvData);
    void rcvHistory(const QVariant &rcvData);

    void createTx(QVariant args);

    void requestWalletTokenInfo(QStringList args);

    void walletListChangedSlot();
    void walletInfoChangedSlot(const QString &walletName, const QString &networkName);

    //new slot
    void rcvDefatultTxReply(const QVariant &rcvData);
    void rcvPasswordCreated(const QVariant &rcvData);
private:
    const QPair<int,QString>& getCurrentWallet() const;
    void setCurrentWallet(const QPair<int,QString>& wallet);
    DapWalletsManagerBase* getWalletManager() const;
    DapTransactionManager *getTransactionManager() const;

protected:
    DapTokensWalletModel* m_tokenModel = nullptr;
    QByteArray m_walletListTest;

    DapListWalletsModel* m_walletModel = nullptr;
    DapInfoWalletModel* m_infoWallet = nullptr;
    QByteArray m_walletInfoTest;
    QByteArray m_walletsInfoTest;

private:
    WalletHashManager *m_walletHashManager;
    bool m_isFirstUpdate = false;
};

#endif // DAPMODULEWALLET_H
