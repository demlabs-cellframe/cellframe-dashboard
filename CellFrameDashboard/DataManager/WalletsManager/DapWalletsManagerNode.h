#pragma once

#include "DapWalletsManagerBase.h"
#include <QTimer>

class DapWalletsManagerNode : public DapWalletsManagerBase
{
    Q_OBJECT
public:
    DapWalletsManagerNode(DapModulesController *moduleController);

    void updateWalletList() override;
protected:
    void initManager() override;
private slots:
    void walletsListReceived(const QVariant &rcvData);
    void rcvWalletInfo(const QVariant &rcvData);

    void updateListWallets();
    void requestWalletInfo(const QString &walletName, const QString &network);

protected slots:
    void currentWalletChangedSlot() override;

private:
    void updateInfoWallets(const QString &walletName = "");
    inline bool updateWalletModel();
private:
    QTimer* m_walletsListTimer = nullptr;
    QTimer* m_timerUpdateWallet = nullptr;
    QTimer* m_timerFeeUpdateWallet = nullptr;

    QByteArray walletListCash;

    QStringList m_requestInfoWallets = {};
    QString m_lastRequestInfoNetworkName = "";
    bool m_isRequestInfo = false;

    const int TIME_WALLET_LIST_UPDATE = 3000;
    const int TIME_WALLET_INFO_UPDATE = 30000;
};

