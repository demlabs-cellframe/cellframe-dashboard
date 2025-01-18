#pragma once

#include "DapWalletsManagerBase.h"
#include <QTimer>

class DapWalletsManagerRemote : public DapWalletsManagerBase
{
    Q_OBJECT
public:
    DapWalletsManagerRemote(DapModulesController *moduleController);
protected:
    void initManager() override;
private slots:
    void walletsListReceived(const QVariant &rcvData);
    void rcvWalletInfo(const QVariant &rcvData);

    void updateListWallets();
    void requestWalletInfo(const QString &walletName, const QString &network);
private:
    void updateInfoWallets();
private:
    QTimer* m_walletsListTimer = nullptr;
    QTimer* m_timerUpdateWallet = nullptr;
    QTimer* m_timerFeeUpdateWallet = nullptr;

    QByteArray walletListCash;

    QString m_lastRequestInfoWalletName = "";
    QString m_lastRequestInfoNetworkName = "";
    bool m_isRequestInfo = false;

    const int TIME_WALLET_LIST_UPDATE = 3000;
    const int TIME_WALLET_INFO_UPDATE = 30000;
};

