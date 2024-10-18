#include "DapModuleNetworks.h"

DapModuleNetworks::DapModuleNetworks(DapModulesController *parent)
    :DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_networkList(new DapNetworkList())
{
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("networkListModel", m_networkList);
    connect(m_modulesCtrl, &DapModulesController::networkStatesUpdated, m_networkList, &DapNetworkList::updateNetworksInfo);
}


DapModuleNetworks::~DapModuleNetworks()
{
    disconnect(m_modulesCtrl, &DapModulesController::networkStatesUpdated, m_networkList, &DapNetworkList::updateNetworksInfo);
    delete m_networkList;
}
