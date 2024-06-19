#include "DapModuleMasterNode.h"
#include <QJsonDocument>
#include <QJsonObject>

DapModuleMasterNode::DapModuleMasterNode(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
{
    connect(s_serviceCtrl, &DapServiceController::certificateManagerOperationResult, this, &DapModuleMasterNode::respondCreateCertificate);
    connect(s_serviceCtrl, &DapServiceController::nodeRestart, this, &DapModuleMasterNode::nodeRestart);
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

int DapModuleMasterNode::startMasterNode(const QVariantMap& value)
{
    /// request code
    /// 0 - OK
    /// 1 - the previous wizard has not been created yet
    /// 2 - some problem
    /// 3 - The certificate name is not appropriate.
    /// 4 -

    if(!m_currantStartMaster.isEmpty())
    {
        return 1;
    }

    if(!value.contains("certName"))
    {
        return 2;
    }

    if(!value["certName"].toString().contains(QString(m_currentNetwork + '.')))
    {
        return 3;
    }

    m_currantStartMaster = value;
    m_startStage = PATTERN_STAGE;
    m_modulesCtrl->getSettings()->setValue("startNodeInfo", m_currantStartMaster);
    saveStageList();
    createMasterNode();
}

void DapModuleMasterNode::createMasterNode()
{
    if(m_startStage.isEmpty())
    {
        return;
    }

    switch(m_startStage.first())
    {
    case LaunchStage::CHECK_PUBLIC_KEY:
    {
        if(m_currantStartMaster["isUploadCert"].toBool()) getInfoCertificate();
        else createCertificate();
    }
        break;
    case LaunchStage::UPDATE_CONFIG:
        tryUpdateNetworkConfig();
        break;
    case LaunchStage::TRY_RESTART_NODE:
        tryRestartNode();
        break;
    case LaunchStage::RESTARTING_NODE:
        // Ожидание ноды
        break;
    case LaunchStage::CREATING_ORDER:
        break;
    case LaunchStage::ADDINNG_NODE_DATA:
        break;
    case LaunchStage::CHECKING_STAKE:
        break;
    case LaunchStage::SENDING_STAKE:
        break;
    case LaunchStage::CHECKING_ALL_DATA:
        break;
    default:
        break;
    }
}

int DapModuleMasterNode::creationStage() const
{
    if(m_startStage.isEmpty())
    {
        return 0;
    }
    return static_cast<int>(m_startStage.first());
}

void DapModuleMasterNode::saveStageList()
{
    QList<int> stageList;
    for (const LaunchStage &stage : m_startStage) {
        stageList.append(static_cast<int>(stage));
    }
    m_modulesCtrl->getSettings()->setValue("startStageNode", QVariant::fromValue(stageList));
}

void DapModuleMasterNode::stageComplated()
{
    if(!m_startStage.isEmpty()) m_startStage.removeFirst();
    else
    {
        qWarning() << "Unexpectedly, the stage stack is empty";
        return;
    }

    if(m_startStage.isEmpty()) emit masterNodeCreated();
    else emit creationStageChanged();

}

void DapModuleMasterNode::loadStageList()
{
    QList<LaunchStage> resultList;
    QList<int> stageList = m_modulesCtrl->getSettings()->value("startStageNode").value<QList<int>>();

    for (int stageInt : stageList)
    {
        resultList.append(static_cast<LaunchStage>(stageInt));
    }

    m_startStage = resultList;
}

void DapModuleMasterNode::createCertificate()
{
    if(!m_currantStartMaster.contains("certName") || !m_currantStartMaster.contains("sign"))
    {
        qWarning() << "There is no certificate name or signature.";
        tryStopCreationMasterNode();
        return;
    }
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "2"
                                                                                   << m_currantStartMaster["certName"].toString()
                                                                                   << m_currantStartMaster["sign"].toString()
                                                                                   << "public");
}

void DapModuleMasterNode::getInfoCertificate()
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "1");
}

void DapModuleMasterNode::tryUpdateNetworkConfig()
{
    auto* worker = m_modulesCtrl->getConfigWorker();
    if(!worker)
    {
        tryStopCreationMasterNode();
        return;
    }
    worker->writeConfigValue(m_currantStartMaster["network"].toString(), "esbocs", "blocks-sign-cert", m_currantStartMaster["certName"].toString());
    worker->writeConfigValue(m_currantStartMaster["network"].toString(), "esbocs", "set_collect_fee", m_currantStartMaster["fee"].toString());
    worker->writeConfigValue(m_currantStartMaster["network"].toString(), "esbocs", "fee_addr",  m_currantStartMaster["walletAddress"].toString());
    worker->writeNodeValue("mempool", "auto_proc", "true");
    worker->saveAllChanges();
    stageComplated();
//    s_serviceCtrl->requestToService("DapNetworkConfigurationCommand", QStringList() << m_currantStartMaster["network"].toString()
//                                                                                    << m_currantStartMaster["certName"].toString()
//                                                                                    << m_currantStartMaster["walletName"].toString()
//                                                                                    << m_currantStartMaster["walletAddress"].toString()
//                                                                                    << m_currantStartMaster["fee"].toString());
}

void DapModuleMasterNode::tryRestartNode()
{
    s_serviceCtrl->requestToService("DapNodeRestart", QStringList());
}

void DapModuleMasterNode::respondCreateCertificate(const QVariant &rcvData)
{
    QJsonObject replyObj = rcvData.toJsonObject();
    if(m_currantStartMaster["isUploadCert"].toBool())
    {
        for(const auto& itemValue: replyObj["data"].toArray())
        {
            auto item = itemValue.toObject();
            if(item["completeBaseName"].toString() == m_currantStartMaster["certName"].toString())
            {
                stageComplated();
                return;
            }
        }
    }
    else if(replyObj.contains("status"))
    {
        if(replyObj["status"].toString() == "OK")
        {
            stageComplated();
            return;
        }
    }
    tryStopCreationMasterNode();
}

void DapModuleMasterNode::startWaitingNode()
{
    // Инициируем ожидаение запуска ноды.
}

void DapModuleMasterNode::nodeRestart()
{
    // Запустить ожидание старта ноды.
    bool a=0;
}

void DapModuleMasterNode::tryStopCreationMasterNode()
{
    // Логика остановки создания мастер ноды
    /// errors
    /// 0 - couldn't create a certificate
    /// 1 - Problems with changing the config
    ///

}
