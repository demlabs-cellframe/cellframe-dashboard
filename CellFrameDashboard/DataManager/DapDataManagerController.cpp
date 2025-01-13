#include "DapDataManagerController.h"
#include "node_globals/NodeGlobals.h"
#include "DapNetworksManager.h"
#include "DapNetworksManagerRemote.h"

DapDataManagerController::DapDataManagerController(DapModulesController* moduleController)
    : QObject()
    //, m_networksManager(new DapNetworksManagerBase(moduleController))
{
    qRegisterMetaType<NetworkInfo>();

    if(getNodeMode()==LOCAL)
    {
        m_networksManager = new DapNetworksManager(moduleController);
    }
    else
    {
        m_networksManager = new DapNetworksManagerRemote(moduleController);
    }

    connect(m_networksManager, &DapNetworksManagerBase::networkListChanged, this, &DapDataManagerController::networkListChanged);
    connect(m_networksManager, &DapNetworksManagerBase::isConnectedChanged, this, &DapDataManagerController::isConnectedChanged);
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
