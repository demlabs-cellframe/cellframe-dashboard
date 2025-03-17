#include "DapWaitingPermission.h"
#include "../DapMasterNodeKeys.h"

DapWaitingPermission::DapWaitingPermission(DapServiceController *serviceController)
    :DapStakeListCommand(serviceController)
    , m_listKeysTimer(new QTimer())
{
    connect(m_listKeysTimer, &QTimer::timeout, this, &DapWaitingPermission::getListKeysRequest);
}

DapWaitingPermission::~DapWaitingPermission()
{
    delete m_listKeysTimer;
}

void DapWaitingPermission::getListKeysRequest()
{
    getListKeys(m_masterNodeInfo.value(MasterNode::NETWORK_KEY).toString(),
                m_masterNodeInfo.value(MasterNode::NODE_ADDR_KEY).toString());
}

void DapWaitingPermission::startWaitingPermission(const QVariantMap &masterNodeInfo)
{
    setMasterNodeInfo(masterNodeInfo);
    getListKeysRequest();
    m_listKeysTimer->start(TIME_OUT_LIST_KEYS);
}

void DapWaitingPermission::cencelRegistration()
{
    m_listKeysTimer->stop();
    DapAbstractMasterNodeCommand::cencelRegistration();
}

void DapWaitingPermission::nodeFound(const QJsonObject& nodeInfo)
{
    QString curNodeAddr = m_masterNodeInfo.value(MasterNode::NODE_ADDR_KEY).toString();
    QString curPKey = m_masterNodeInfo.value(MasterNode::CERT_HASH_KEY).toString();
    QString pKey;

    if(nodeInfo.contains("pKey hash"))
    {
        pKey = nodeInfo["pKey hash"].toString();
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

void DapWaitingPermission::errorReceived(int errorNumber, const QString& message)
{
    stopCreationMasterNode(errorNumber, message);
}
