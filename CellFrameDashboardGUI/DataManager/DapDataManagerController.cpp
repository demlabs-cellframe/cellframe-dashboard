#include "DapDataManagerController.h"

DapDataManagerController::DapDataManagerController(DapModulesController* moduleController)
    : QObject()
    , m_networksManager(new DapNetworksManager(moduleController))
{
    qRegisterMetaType<NetworkInfo>();
    connect(m_networksManager, &DapNetworksManager::networkListChanged, this, &DapDataManagerController::networkListChanged);
}

QStringList DapDataManagerController::getNetworkList() const
{
    if(m_networksManager)
    {
        return m_networksManager->getNetworkList();
    }
    return QStringList();
}
