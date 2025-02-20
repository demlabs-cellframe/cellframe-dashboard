#include "DapUpdateStakeData.h"

DapUpdateStakeData::DapUpdateStakeData(DapServiceController *serviceController)
:DapStakeListCommand(serviceController)
{}

void DapUpdateStakeData::tryUpdateStakeData(const QMap<QString, QVariantMap>& nodes)
{
    m_nodes = nodes;
    dataUpdate();
}

void DapUpdateStakeData::dataUpdate()
{
    for(auto& network: m_nodes.keys())
    {
        if(!m_lastNetworkRequest.contains(network))
        {
            QString addr = m_nodes[network][MasterNode::NODE_ADDR_KEY].toString();
            getListKeys(network, addr);
            m_lastNetworkRequest.append(network);
            return;
        }
    }
    qDebug() << "[DapUpdateStakeData] The data update has been completed.";
    emit finished();
}

void DapUpdateStakeData::nodeNotFound()
{
    dataUpdate();
}

void DapUpdateStakeData::errorReceived(int errorNumber, const QString& message)
{
    Q_UNUSED(errorNumber)
    Q_UNUSED(message)
    dataUpdate();
}

void DapUpdateStakeData::nodeFound(const QJsonObject& nodeInfo)
{
    auto valueUpdate = [this, &nodeInfo](const QString& nodeName, const QString& localName) -> bool
    {
        if(nodeInfo.contains(nodeName))
        {
            QString newValue = nodeInfo.value(nodeName).toString();
            QString value = m_nodes.value(m_lastNetworkRequest.last()).value(localName).toString();
            if(newValue != value)
            {
                updateMasterNodeData(m_lastNetworkRequest.last(), localName, newValue);
                return true;
            }
        }
        return false;
    };

    bool isUpdate = false;
    if(valueUpdate("effective value", MasterNode::STAKE_EFFECTIVE_VALUE_KEY)) isUpdate = true;
    if(valueUpdate("stake value", MasterNode::STAKE_VALUE_KEY)) isUpdate = true;
    if(valueUpdate("related weight", MasterNode::STAKE_RELATED_WEIGHT_KEY)) isUpdate = true;
    if(valueUpdate("tx hash", MasterNode::STAKE_HASH_KEY)) isUpdate = true;
    if(isUpdate)
    {
        saveData();
    }
    dataUpdate();
}
