#pragma once

#include "DapWalletsManagerBase.h"
#include <QTimer>

class DapWalletsManager : public DapWalletsManagerBase
{
    Q_OBJECT
public:
    DapWalletsManager(DapModulesController *moduleController);

    void updateWalletList() override;
    void updateWalletInfo() override;

private slots:
    void clearAndUpdateDataSlot();
    void walletsListReceived(const QVariant &rcvData);
    void rcvWalletInfo(const QVariant &rcvData);
    void rcvWalletAddress(const QVariant &rcvData);

    void updateListWallets();
    void requestWalletInfo(const QString &walletAddr, const QString &network);
    void requestWalletAddress(const QString& walletName, const QString &path, const QStringList &netList);
    void alarmTimerSlot();
private:
    void updateAddressWallets();
    void updateInfoWallets(const QString &walletName = "");
    void setIsLoad(CommonWallet::WalletInfo& wallet, bool isLoad);

    inline bool updateWalletModel();
private:
    QTimer* m_walletsListTimer = nullptr;
    QTimer* m_timerUpdateWallet = nullptr;
    QTimer* m_timerAlarmUpdateWallet = nullptr;


    QByteArray m_walletListCash;

    QStringList m_requestInfoWalletsName;
    QString m_lastRequestInfoNetworkName = "";
    bool m_isRequestInfo = false;

    const int TIME_WALLET_LIST_UPDATE = 3000;
    const int TIME_WALLET_INFO_UPDATE = 30000;
    const int TIME_ALARM_REQUEST = 30000;
};

