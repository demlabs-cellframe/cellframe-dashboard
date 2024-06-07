#include "DapModuleMasterNode.h"

DapModuleMasterNode::DapModuleMasterNode(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
{
}

QString DapModuleMasterNode::stakeTokenName() const
{
    if(m_currentNetwork.isEmpty() || !m_stakeTokens.contains(m_currentNetwork))
    {
        return "-";
    }
    return m_stakeTokens[m_currentNetwork];
}

void DapModuleMasterNode::setCurrentNetwork(const QString& networkName)
{
    m_currentNetwork = networkName;
    emit currentNetworkChanged();
}
