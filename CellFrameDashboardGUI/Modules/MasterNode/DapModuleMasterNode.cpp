#include "DapModuleMasterNode.h"
#include <QJsonDocument>
#include <QJsonObject>
#include "../DapTypes/DapCoin.h"

DapModuleMasterNode::DapModuleMasterNode(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_checkStakeTimer(new QTimer())
{
    connect(s_serviceCtrl, &DapServiceController::certificateManagerOperationResult, this, &DapModuleMasterNode::respondCreateCertificate);
    connect(s_serviceCtrl, &DapServiceController::nodeRestart, this, &DapModuleMasterNode::nodeRestart);
    connect(m_modulesCtrl, &DapModulesController::netListUpdated, this, &DapModuleMasterNode::networkListUpdateSlot);

    connect(s_serviceCtrl, &DapServiceController::rcvAddNode, this, &DapModuleMasterNode::addedNode);
    connect(s_serviceCtrl, &DapServiceController::srvStakeDelegateCreated, this, &DapModuleMasterNode::respondStakeDelegate);
    connect(s_serviceCtrl, &DapServiceController::rcvCheckQueueTransaction, this, &DapModuleMasterNode::respondCheckStakeDelegate);

    connect(m_modulesCtrl, &DapModulesController::nodeWorkingChanged, this, &DapModuleMasterNode::workNodeChanged);
    connect(m_checkStakeTimer, &QTimer::timeout, this, &DapModuleMasterNode::checkStake);

}

bool DapModuleMasterNode::checkTokenName() const
{
    return !m_currentNetwork.isEmpty() && m_tokens.contains(m_currentNetwork);
}

QString DapModuleMasterNode::stakeTokenName() const
{
    return checkTokenName() ? m_tokens[m_currentNetwork].first : "-";
}

QString DapModuleMasterNode::mainTokenName() const
{
    return checkTokenName() ? m_tokens[m_currentNetwork].second : "-";
}

QString DapModuleMasterNode::networksList() const
{
    QJsonArray resultArr;
    for(auto net: m_masterNodeInfo.keys())
    {
        QJsonObject obj;
        obj["net"] = net;
        obj["isMaster"] = m_masterNodeInfo[net].isMaster;
        resultArr.append(obj);
    }

    QJsonDocument doc(resultArr);
    return QString::fromUtf8(doc.toJson(QJsonDocument::Compact));
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

//    if(!m_currantStartMaster.isEmpty())
//    {
//        return 1;
//    }

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

    return 0;
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
        if(m_currantStartMaster["isUploadCert"].toBool())
        {
            getInfoCertificate();
        }
        else
        {
            createCertificate();
        }
    }
    break;
    case LaunchStage::UPDATE_CONFIG:
        tryUpdateNetworkConfig();
        break;
    case LaunchStage::RESTARTING_NODE:
        tryRestartNode();
        // Ожидание ноды
        break;

    case LaunchStage::ADDINNG_NODE_DATA:
        addNode();
        break;
    case LaunchStage::SENDING_STAKE:
        stakeDelegate();
        break;
    case LaunchStage::CHECKING_STAKE:
        tryCheckStakeDelegate();
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

    createMasterNode();

    if(m_startStage.isEmpty())
    {
        emit masterNodeCreated();
    }
    else
    {
        emit creationStageChanged();
    }
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
        tryStopCreationMasterNode("There is no certificate name or signature.");
        return;
    }
    qInfo() << "[DapModuleMasterNode] [Creating a master node] A " << m_currantStartMaster["certName"].toString() << " certificate is being created";
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "2"
                                                                                   << m_currantStartMaster["certName"].toString()
                                                                                   << m_currantStartMaster["sign"].toString()
                                                                                   << "public");
}

void DapModuleMasterNode::getHashCertificate(const QString& certName)
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "10" << certName);
}

void DapModuleMasterNode::addNode()
{
    s_serviceCtrl->requestToService("DapAddNodeCommand", QStringList() << m_currantStartMaster["network"].toString());
}

void DapModuleMasterNode::stakeDelegate()
{
    QString stakeValue = m_currantStartMaster["stakeValue"].toString();
    auto split = stakeValue.split('.');
    if(split.size() == 1)
    {
        if(split[0].isEmpty())
        {
            stakeValue = "0.0";
        }
        else
        {
            stakeValue = split[0] + ".0";
        }
    }
    else if(split.size() >= 1)
    {
        if(split[0].isEmpty() && !split[1].isEmpty())
        {
            stakeValue = "0." + split[1];
        }
        else if(split[1].isEmpty() && !split[0].isEmpty())
        {
            stakeValue = split[0] + ".0";
        }
        else if(stakeValue.isEmpty())
        {
            tryStopCreationMasterNode("An empty value was specified for freezing m-tokens.");
            return;
        }
    }
    Dap::Coin value256 = stakeValue;
    QString valueDatoshi = value256.toDatoshiString();

    Dap::Coin fee256 = m_currantStartMaster["stakeFee"].toString();
    QString feeDatoshi = fee256.toDatoshiString();
    s_serviceCtrl->requestToService("DapSrvStakeDelegateCommand", QStringList() << m_currantStartMaster["certName"].toString()
                                                                                << m_currantStartMaster["network"].toString()
                                                                                << m_currantStartMaster["walletName"].toString()
                                                                                << valueDatoshi
                                                                                << feeDatoshi);
}

void DapModuleMasterNode::mempoolCheck()
{
    if(m_currantStartMaster.contains("stakeHash"))
    {
        s_serviceCtrl->requestToService("MempoolCheckCommand", QStringList() << m_currantStartMaster["network"].toString()
                                                                             << m_currantStartMaster["stakeHash"].toString());
    }
    else
    {
        tryStopCreationMasterNode("No stake delegate hash found.");
    }
}

void DapModuleMasterNode::checkStake()
{
    if(m_currantStartMaster.contains(QUEUE_HASH_KEY))
    {
        s_serviceCtrl->requestToService("DapCheckQueueTransactionCommand", QStringList()
                                                                                << m_currantStartMaster[QUEUE_HASH_KEY].toString()
                                                                                << m_currantStartMaster["walletName"].toString()
                                                                                << m_currantStartMaster["network"].toString());
    }
    else
    {
        tryStopCreationMasterNode("No stake delegate hash found.");
    }
}

void DapModuleMasterNode::tryCheckStakeDelegate()
{
    checkStake();
    m_checkStakeTimer->start(TIME_OUT_CHECK_STAKE);
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
        tryStopCreationMasterNode("There are node configuration problems.");
        return;
    }
    worker->writeConfigValue(m_currantStartMaster["network"].toString(), "esbocs", "blocks-sign-cert", m_currantStartMaster["certName"].toString());
    worker->writeConfigValue(m_currantStartMaster["network"].toString(), "esbocs", "set_collect_fee", m_currantStartMaster["fee"].toString());
    worker->writeConfigValue(m_currantStartMaster["network"].toString(), "esbocs", "fee_addr",  m_currantStartMaster["walletAddress"].toString());
    worker->writeNodeValue("mempool", "auto_proc", "true");
    worker->saveAllChanges();
    stageComplated();
}

void DapModuleMasterNode::tryRestartNode()
{
    s_serviceCtrl->requestToService("DapNodeRestart", QStringList());
//    stageComplated();
}

void DapModuleMasterNode::respondMempoolCheck(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    QJsonObject result = replyObj["result"].toObject();

    if(!result.contains("hash") || !result.contains("net"))
    {
        qWarning() << "[DapModuleMasterNode] Incorrect data.";
        return;
    }
    QString hash = result["hash"].toString();

    if(m_currantStartMaster["stakeHash"].toString() != hash)
    {
        return;
    }
    QString code;
    if(result.contains("atom"))
    {
        QJsonObject atom = result["atom"].toObject();
        if(!atom.contains("ledger_response_code"))
        {
            return;
        }

        code = atom["ledger_response_code"].toString();
    }

    QString source;
    if(result.contains("source"))
    {
        source = result["source"].toString();
    }

    if(source == "chain" && code == "DAP_LEDGER_TX_CHECK_OK")
    {
        stageComplated();
    }
    else if(source == "mempool")
    {
        qDebug() << "[DapModuleMasterNode] The transaction is in the mempool";
    }
    else
    {
        tryStopCreationMasterNode("The transaction may have failed.");
    }
}

void DapModuleMasterNode::respondCreateCertificate(const QVariant &rcvData)
{
    if(m_startStage.isEmpty() || m_startStage.first() != LaunchStage::CHECK_PUBLIC_KEY)
    {
        return;
    }

    QJsonObject replyObj = rcvData.toJsonObject();
    if(!replyObj.contains("command"))
    {
        qDebug() << "Unexpected response from the service. There is no command block.";
        return;
    }
    int command = replyObj["command"].toInt();
    auto data = replyObj["data"].toObject();

    auto checkStatus = [&]() ->bool
    {
        if(replyObj.contains("status"))
        {
            if(replyObj["status"].toString() == "OK")
            {
                tryStopCreationMasterNode("");
                return true;
            }
        }
        return false;
    };

    if(command == 2)
    {
        if(!checkStatus())
        {
            return;
        }

        if(data.contains("completeBaseName") && data["completeBaseName"].toString() == m_currantStartMaster["certName"].toString())
        {
            getHashCertificate(m_currantStartMaster["certName"].toString());
            return;
        }
    }
    else if(command == 10)
    {
        if(!checkStatus())
        {
            return;
        }
        QString certName, hash;
        if(data.contains("fileName"))
        {
            certName = data["fileName"].toString();
        }
        if(data.contains("hash"))
        {
            hash = data["hash"].toString();
        }
        if(!certName.isEmpty() && !hash.isEmpty())
        {
            m_currantStartMaster.insert("certHash", hash);
            stageComplated();
            return;
        }
    }
}

void DapModuleMasterNode::addedNode(const QVariant &rcvData)
{

}

void DapModuleMasterNode::startWaitingNode()
{
    // Инициируем ожидаение запуска ноды.
}

void DapModuleMasterNode::nodeRestart()
{
    // Запустить ожидание старта ноды.
}

void DapModuleMasterNode::networkListUpdateSlot()
{
    QMap<QString, bool> checkList;
    for(auto key: m_masterNodeInfo.keys())
    {
        checkList.insert(key, false);
    }

    QStringList netlist = m_modulesCtrl->getNetworkList();
    for(auto net: netlist)
    {
        if(checkList.contains(net))
        {
            checkList[net] = true;
        }
        else
        {
            addNetwork(net);
        }
    }

    for(auto key: checkList.keys(false))
    {
        if(!m_masterNodeInfo[key].isMaster) m_masterNodeInfo.remove(key);
    }

    emit networksListChanged();
}

void DapModuleMasterNode::addNetwork(const QString &net)
{
    MasterNodeInfo info;
    // TODO
    // insert data for master node

    // temporary random data:
    info.isMaster = net == "Backbone";
    info.publicKey = "0xB236424A551FDE2170ACACE905582B7772234C029C621A023EC04DC6C22B74C2";
    info.nodeAddress = "8343::1E4B::428B::101A";
    info.nodeIP = "127.0.0.1";
    info.nodePort = "8079";
    info.stakeAmount = "22.0921931283 mCELL";
    info.stakeHash = "0xF01C34E60F4BF387EBC07451F988BA07EB8EAAE9B184870A16BF495E53523764";
    info.walletName = "MainWallet";
    info.walletAddr = "0xB236424A551FDE2170ACACE905582B7772234C029C621A023EC04DC6C22B74C2";

    info.validator.availabilityOrder = true;
    info.validator.nodePresence = true;
    info.validator.nodeWeight = "18.21239088%";
    info.validator.nodeStatus = "active";
    info.validator.blocksSigned = "1249";
    info.validator.totalRewards = "0.45 CELL";
    info.validator.networksBlocks = "8042";
    // finish temporary data

    m_masterNodeInfo.insert(net, info);
}

void DapModuleMasterNode::tryStopCreationMasterNode(const QString& message)
{
    // Логика остановки создания мастер ноды
    /// errors
    /// 0 - couldn't create a certificate
    /// 1 - Problems with changing the config
    ///
    qDebug() << "[DapModuleMasterNode] The node registration operation was interrupted.";
}

void DapModuleMasterNode::workNodeChanged()
{
    if(m_startStage.isEmpty() || m_startStage.first() != LaunchStage::RESTARTING_NODE)
    {
        return;
    }
    if(m_modulesCtrl->isNodeWorking())
    {
        stageComplated();
    }
}

void DapModuleMasterNode::respondStakeDelegate(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();

    if(replyObj.contains("error"))
    {
        auto error = replyObj["error"].toString();
        qInfo() << "The transaction was not created. Message:" << error;
        tryStopCreationMasterNode("The transaction was not created.");
        return;
    }

    QJsonObject resultObj = replyObj["result"].toObject();

    QString stakeHash, queueHash;
    if(resultObj.contains("tx_hash"))
    {
        stakeHash = resultObj["tx_hash"].toString();
        m_currantStartMaster.insert(STAKE_HASH_KEY, stakeHash);
    }
    if(resultObj.contains("idQueue"))
    {
        queueHash = resultObj["idQueue"].toString();
        m_currantStartMaster.insert(QUEUE_HASH_KEY, queueHash);
    }

    if(!stakeHash.isEmpty() || !queueHash.isEmpty())
    {
        stageComplated();
    }
    else
    {
        qDebug() << "[DapModuleMasterNode] [pespondStakeDelegate]There was a problem with the detention of tokens, we need to make another attempt.";
        tryStopCreationMasterNode("There was a problem with the detention of tokens, we need to make another attempt.");
    }
}

void DapModuleMasterNode::respondCheckStakeDelegate(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    if(!replyObj.contains("result"))
    {
        qWarning() << "[DapModuleMasterNode] Error in the data";
        return;
    }
    auto resultObject = replyObj["result"].toObject();
    QString txHash, queueHash, state;
    auto getItem = [&resultObject](const QString& name, QString& buff)
    {
        if(!resultObject.contains(name))
        {
            qWarning() << QString("[respondCheckStakeDelegate]The \"%1\" element was not found.").arg(name);
            buff = "";
            return;
        }
        buff = resultObject[name].toString();
    };

    getItem(STAKE_HASH_KEY, queueHash);
    getItem("state", state);
    getItem("txHash", txHash);

    if(m_currantStartMaster.contains(STAKE_HASH_KEY) && m_currantStartMaster[STAKE_HASH_KEY].toString() != queueHash)
    {
        qDebug() << "[DapModuleMasterNode][respondCheckStakeDelegate]The response came from another request.";
        return;
    }

    if(state == "mempool")
    {
        if(!m_currantStartMaster.contains(STAKE_HASH_KEY) && !txHash.isEmpty())
        {
            m_currantStartMaster.insert(STAKE_HASH_KEY, txHash);
        }
    }
    else if(state == "notFound")
    {
        if(!m_currantStartMaster.contains(STAKE_HASH_KEY))
        {
            qDebug() << "It looks like the transaction was rejected.";
            tryStopCreationMasterNode("It looks like the transaction was rejected.");
        }
        else
        {
            qInfo() << "We are looking for information about the transaction. By hash: " << m_currantStartMaster[STAKE_HASH_KEY].toString();
            mempoolCheck();
        }
    }
}

QVariantMap DapModuleMasterNode::masterNodeData() const
{
    MasterNodeInfo info = m_masterNodeInfo[m_currentNetwork];
    QVariantMap result;

    result.insert("publicKey", info.publicKey);
    result.insert("nodeAddress", info.nodeAddress);
    result.insert("nodeIP", info.nodeIP);
    result.insert("nodePort", info.nodePort);
    result.insert("stakeAmount", info.stakeAmount);
    result.insert("stakeHash", info.stakeHash);
    result.insert("walletName", info.walletName);
    result.insert("walletAddr", info.walletAddr);

    return result;
}

QVariantMap DapModuleMasterNode::validatorData() const
{
    MasterNodeValidator info = m_masterNodeInfo[m_currentNetwork].validator;
    QVariantMap result;

    result.insert("availabilityOrder", info.availabilityOrder);
    result.insert("nodePresence", info.nodePresence);
    result.insert("nodeWeight", info.nodeWeight);
    result.insert("nodeStatus", info.nodeStatus);
    result.insert("blocksSigned", info.blocksSigned);
    result.insert("totalRewards", info.totalRewards);
    result.insert("networksBlocks", info.networksBlocks);

    return result;
}
