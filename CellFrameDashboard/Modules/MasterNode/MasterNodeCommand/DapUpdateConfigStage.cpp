#include "DapUpdateConfigStage.h"
#include "CellframeNode.h"
#include "../DapMasterNodeKeys.h"

DapUpdateConfigStage::DapUpdateConfigStage(DapServiceController *serviceController)
:DapAbstractMasterNodeCommand(serviceController)
{}

void DapUpdateConfigStage::updateConfigForRegistration(const QVariantMap& masterNodeInfo)
{
    setConfigValue("cellframe-node", "mempool", "auto_proc", "true");
    setConfigValue("cellframe-node", "server", "enabled", "true");
    QString network = masterNodeInfo.value(MasterNode::NETWORK_KEY).toString();
    setConfigValue(network, "general", "node-role", "master");
    setConfigValue(network, "esbocs", "collecting_level", masterNodeInfo.value(MasterNode::STAKE_VALUE_KEY).toString());
    setConfigValue(network, "esbocs", "fee_addr", masterNodeInfo.value(MasterNode::WALLET_ADDR_KEY).toString());
    setConfigValue(network, "esbocs", "blocks-sign-cert", masterNodeInfo.value(MasterNode::CERT_NAME_KEY).toString());
    stageComplated();
}

void DapUpdateConfigStage::updateConfigForCancel(const QVariantMap& masterNodeInfo, const QMap<QString, QVariantMap>& allMasterNode)
{
    QString network = masterNodeInfo.value(MasterNode::NETWORK_KEY).toString();
    int nodesCount = allMasterNode.size();
    if(nodesCount == 0 || (nodesCount == 1 && allMasterNode.contains(network)))
    {
        setConfigValue("cellframe-node", "mempool", "auto_proc", "false");
        setConfigValue("cellframe-node", "server", "enabled", "false");
    }
    setConfigValue(network, "general", "node-role", "full");
    setConfigValue(network, "esbocs", "collecting_level", "");
    setConfigValue(network, "esbocs", "fee_addr", "");
    setConfigValue(network, "esbocs", "blocks-sign-cert", "");
    stageComplated();
}

void DapUpdateConfigStage::setConfigValue(QString config, QString group, QString param, QString value)
{
    QtConcurrent::run([config, group, param, value]
    {
        std::string std_config = config.toStdString();
        std::string std_group  = group.toStdString();
        std::string std_param  = param.toStdString();
        std::string std_value  = value.toStdString();

        cellframe_node::getCellframeNodeInterface("local")->setConfigValue(std_config, std_group, std_param, std_value);
    });
}
