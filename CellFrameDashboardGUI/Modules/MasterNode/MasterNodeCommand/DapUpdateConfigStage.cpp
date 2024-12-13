#include "DapUpdateConfigStage.h"
#include "DapConfigToolController.h"

DapUpdateConfigStage::DapUpdateConfigStage(DapServiceController *serviceController)
:DapAbstractMasterNodeCommand(serviceController)
{}

void DapUpdateConfigStage::updateConfigForRegistration(const QVariantMap& masterNodeInfo)
{
    auto& controller = DapConfigToolController::getInstance();
    controller.setConfigParam("cellframe-node", "mempool", "auto_proc", "true");
    controller.setConfigParam("cellframe-node", "server", "enabled", "true");
    QString network = masterNodeInfo.value(MasterNode::NETWORK_KEY).toString();
    controller.setConfigParam(network, "general", "node-role", "master");
    controller.setConfigParam(network, "esbocs", "collecting_level", masterNodeInfo.value(MasterNode::STAKE_VALUE_KEY).toString());
    controller.setConfigParam(network, "esbocs", "fee_addr", masterNodeInfo.value(MasterNode::WALLET_ADDR_KEY).toString());
    controller.setConfigParam(network, "esbocs", "blocks-sign-cert", masterNodeInfo.value(MasterNode::CERT_NAME_KEY).toString());
    stageComplated();
}

void DapUpdateConfigStage::updateConfigForCencel(const QVariantMap& masterNodeInfo, const QMap<QString, QVariantMap>& allMasterNode)
{
    auto& controller = DapConfigToolController::getInstance();
    QString network = masterNodeInfo.value(MasterNode::NETWORK_KEY).toString();
    int nodesCount = allMasterNode.size();
    if(nodesCount == 0 || (nodesCount == 1 && allMasterNode.contains(network)))
    {
        controller.setConfigParam("cellframe-node", "mempool", "auto_proc", "false");
        controller.setConfigParam("cellframe-node", "server", "enabled", "false");
    }
    controller.setConfigParam(network, "general", "node-role", "full");
    controller.setConfigParam(network, "esbocs", "collecting_level", "");
    controller.setConfigParam(network, "esbocs", "fee_addr", "");
    controller.setConfigParam(network, "esbocs", "blocks-sign-cert", "");
    stageComplated();
}
