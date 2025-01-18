#pragma once

#include <QObject>
#include "DapNetworksManagerBase.h"
#include "DapWalletsManagerBase.h"
#include "Modules/DapModulesController.h"
#include "DapFeeManagerBase.h"

class DapDataManagerController : public QObject
{
    Q_OBJECT
public:
    DapDataManagerController(DapModulesController* moduleController);

    DapNetworksManagerBase* getNetworkManager() const { return m_networksManager; }
    DapWalletsManagerBase* getWalletManager() const { return m_walletsManager; }
    DapFeeManagerBase* getFeeManager() const { return m_feeManager; }
    const QStringList &getNetworkList() const;
    const CommonWallet::FeeInfo& getFee(const QString& network);
    bool isFeeEmpty();

    const QPair<int,QString>& getCurrentWallet() const;
signals:
    void networkListChanged();
    void isConnectedChanged(bool isConnected);
private:
    DapNetworksManagerBase* m_networksManager = nullptr;
    DapWalletsManagerBase* m_walletsManager = nullptr;
    DapFeeManagerBase* m_feeManager = nullptr;
};
