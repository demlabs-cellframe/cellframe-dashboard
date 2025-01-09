#include "DapDataManagerController.h"

DapDataManagerController::DapDataManagerController(DapModulesController* moduleController)
    : QObject()
    , m_networksManager(new DapNetworksManager(moduleController))
{
    qRegisterMetaType<NetworkInfo>();
    connect(m_networksManager, &DapNetworksManager::networkListChanged, this, &DapDataManagerController::networkListChanged);
    connect(m_networksManager, &DapNetworksManager::isConnectedChanged, this, &DapDataManagerController::isConnectedChanged);
}

QStringList DapDataManagerController::getNetworkList() const
{
    if(m_networksManager)
    {
        return m_networksManager->getNetworkList();
    }
    qDebug()<<"[DapDataManagerController] The network manager was not found.";
    return QStringList();
}
