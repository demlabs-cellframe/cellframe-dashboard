#include "DapDataManagerController.h"

DapDataManagerController::DapDataManagerController(DapModulesController* moduleController)
    : QObject()
{
    qRegisterMetaType<NetworkInfo>();

    if(DapNodeMode::getNodeMode()==DapNodeMode::LOCAL)
    {
        m_networksManager = new DapNetworksManagerLocal(moduleController);
    }
    else
    {
         m_networksManager = new DapNetworksManagerRemote(moduleController);
    }
    m_walletsManager = new DapWalletsManager(moduleController);
    m_feeManager = new DapFeeManager(moduleController);
    m_transactionManager = new DapTransactionManager(moduleController);

    connect(m_networksManager, &DapNetworksManagerBase::networkListChanged, this, &DapDataManagerController::networkListChanged);
    connect(m_networksManager, &DapNetworksManagerBase::isConnectedChanged, this, &DapDataManagerController::isConnectedChanged);
}

const QStringList& DapDataManagerController::getNetworkList() const
{
    Q_ASSERT_X(m_networksManager, "DapDataManagerController", "NetworkManager not found");
    return m_networksManager->getNetworkList();
}

const CommonWallet::FeeInfo& DapDataManagerController::getFee(const QString& network)
{
    Q_ASSERT_X(m_feeManager, "DapDataManagerController", "FeeManager not found");
    return m_feeManager->getFee(network);
}

bool DapDataManagerController::isFeeEmpty()
{
    Q_ASSERT_X(m_feeManager, "DapDataManagerController", "FeeManager not found");
    return m_feeManager->isFeeEmpty();
}

const QPair<int,QString>& DapDataManagerController::getCurrentWallet() const
{
    Q_ASSERT_X(m_walletsManager, "DapDataManagerController", "WalletManager not found");
    return m_walletsManager->getCurrentWallet();
}
