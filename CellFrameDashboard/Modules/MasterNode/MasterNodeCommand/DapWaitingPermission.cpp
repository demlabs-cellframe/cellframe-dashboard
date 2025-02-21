#include "DapWaitingPermission.h"
#include "../DapMasterNodeKeys.h"

DapWaitingPermission::DapWaitingPermission(DapServiceController *serviceController)
    :DapAbstractMasterNodeCommand(serviceController)
    , m_listKeysTimer(new QTimer())
{
    connect(m_serviceController, &DapServiceController::rcvGetListKeysCommand, this, &DapWaitingPermission::respondListKeys);
    connect(m_listKeysTimer, &QTimer::timeout, this, &DapWaitingPermission::getListKeys);
}

DapWaitingPermission::~DapWaitingPermission()
{
    delete m_listKeysTimer;
}

void DapWaitingPermission::startWaitingPermission(const QVariantMap &masterNodeInfo)
{
    setMasterNodeInfo(masterNodeInfo);
    getListKeys();
    m_listKeysTimer->start(TIME_OUT_LIST_KEYS);
}

void DapWaitingPermission::getListKeys()
{
    QString nodeMode = DapNodeMode::getNodeMode() == DapNodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    QVariantMap request = {{Dap::KeysParam::NODE_MODE_KEY, nodeMode}
                           ,{Dap::KeysParam::NETWORK_NAME, m_masterNodeInfo.value(MasterNode::NETWORK_KEY).toString()}};
    m_serviceController->requestToService("DapGetListKeysCommand", QStringList() << m_masterNodeInfo.value(MasterNode::NETWORK_KEY).toString());
}

void DapWaitingPermission::respondListKeys(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    if(replyObj.contains("error"))
    {
        qWarning() << "[DapWaitingPermission] [respondListKeys] Error message. " << replyObj["error"].toString();
        m_listKeysTimer->stop();
        stopCreationMasterNode(14, "[respondListKeys]" + replyObj["error"].toString());
        return;
    }
    if(replyObj["result"].isNull())
    {
        m_listKeysTimer->stop();
        stopCreationMasterNode(14, "[respondListKeys] The result is empty in the response.");
        return;
    }
    QJsonObject result = replyObj["result"].toObject();

    if(!result.contains("keys"))
    {
        qWarning() << "[DapModuleMasterNode] Unexpected problem, key -keys- was not found.";
        m_listKeysTimer->stop();
        stopCreationMasterNode(14, "Other problems.");
        return;
    }

    QString curPKey = m_masterNodeInfo.value(MasterNode::CERT_HASH_KEY).toString();
    QString curNodeAddr = m_masterNodeInfo.value(MasterNode::NODE_ADDR_KEY).toString();
    auto keys = result["keys"].toArray();
    for(const auto& itemValue: keys)
    {
        auto item = itemValue.toObject();
        QString nodeAddr;
        if(item.contains("node addr"))
        {
            nodeAddr = item["node addr"].toString();
        }
        else
        {
            qWarning() << "[DapWaitingPermission] Unexpected problem, key -node addr- was not found.";
        }

        if(nodeAddr != curNodeAddr)
        {
            continue;
        }

        QString pKey;

        if(item.contains("pKey hash"))
        {
            pKey = item["pKey hash"].toString();
        }
        else
        {
            qWarning() << "[DapWaitingPermission] Unexpected problem, key -pKey hash- was not found.";
        }

        if(pKey == curPKey)
        {
            qInfo() << "-------The node has been added to the list.-----";
            m_listKeysTimer->stop();
            stageComplated();
            return;
        }
    }

    qInfo() << QString("The node with address %1 and key %2 was not found in the list.").arg(curNodeAddr).arg(curPKey);
}

void DapWaitingPermission::cencelRegistration()
{
    m_listKeysTimer->stop();
    DapAbstractMasterNodeCommand::cencelRegistration();
}
