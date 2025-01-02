#include "DapModuleNetworks.h"

DapModuleNetworks::DapModuleNetworks(DapModulesController *parent)
    :DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_networkList(new DapNetworkList())
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("networkListModel", m_networkList);
    connect(m_modulesCtrl, &DapModulesController::networkStatesUpdated, m_networkList, &DapNetworkList::updateNetworksInfo);
}


DapModuleNetworks::~DapModuleNetworks()
{
    disconnect();
    delete m_networkList;
}
