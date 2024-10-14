#include "DapModuleNetworks.h"

DapModuleNetworks::DapModuleNetworks(DapModulesController *parent)
    :DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_networkList(new DapNetworksModel())
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("networkListModel", m_networkList);
    connect(m_modulesCtrl, &DapModulesController::netListUpdated, m_networkList, &DapNetworksModel::updateNetworksInfo);

}


DapModuleNetworks::~DapModuleNetworks()
{
    disconnect(m_modulesCtrl, &DapModulesController::netListUpdated, m_networkList, &DapNetworksModel::updateNetworksInfo);
    delete m_networkList;
}
