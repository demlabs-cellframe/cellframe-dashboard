#include "DapNodeDelStage.h"
#include "../DapMasterNodeKeys.h"

DapNodeDelStage::DapNodeDelStage(DapModulesController *modulesController)
    :DapAbstractMasterNodeCommand(modulesController)
{
    connect(m_serviceController, &DapServiceController::rcvNodeDel, this, &DapNodeDelStage::deletedNode);
}

void DapNodeDelStage::tryDeleteNode(const QVariantMap& masterNodeInfo)
{
    setMasterNodeInfo(masterNodeInfo);
    m_modulesController->sendRequestToService("DapNodeDel", QStringList() << m_masterNodeInfo.value(MasterNode::NETWORK_KEY).toString()
                                                                      << m_masterNodeInfo.value(MasterNode::NODE_ADDR_KEY).toString());
}

void DapNodeDelStage::deletedNode(const QVariant &rcvData)
{
    auto result = rcvData.toString();
    /// Regardless of the answer, we are completing the stage, the output has been implemented with errors so far.

    qInfo() << "----The node has been deleted.-----";
    stageComplated();

    /// TODO: A memo for implementation after editing by the node.
    // if(result.contains("successfully"))
    // {
    //     qInfo() << "----The node has been deleted.-----";
    //     stageComplated();
    // }
    // else
    // {
    //     qDebug() << "[MasterNode] problem delete : " << result;
    //     stopCreationMasterNode(18, "I couldn't deleted a node.");
    // }
}
