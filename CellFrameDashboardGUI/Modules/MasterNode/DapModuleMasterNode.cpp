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
    connect(s_serviceCtrl, &DapServiceController::networkStatusReceived, this, &DapModuleMasterNode::respondNetworkStatus);
    connect(s_serviceCtrl, &DapServiceController::rcvNodeListCommand, this, &DapModuleMasterNode::respondNodeListCommand);
    connect(s_serviceCtrl, &DapServiceController::rcvMempoolCheckCommand, this, &DapModuleMasterNode::respondMempoolCheck);

    connect(m_modulesCtrl, &DapModulesController::nodeWorkingChanged, this, &DapModuleMasterNode::workNodeChanged);
    connect(m_checkStakeTimer, &QTimer::timeout, this, &DapModuleMasterNode::checkStake);

    loadStageList();
    loadCurrentRegistration();
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
    emit masterNodeChanged();
}

int DapModuleMasterNode::startMasterNode(const QVariantMap& value)
{
    /// request code
    /// 0 - OK
    /// 1 - the previous wizard has not been created yet
    /// 2 - The certificate name is not specified correctly
    /// 3 - The certificate name is not appropriate.
    /// 4 -

    if(!m_currantStartMaster.isEmpty())
    {
        return 1;
    }

    QString certName = value["certName"].toString();

    if(!certName.contains(QString(m_currentNetwork + '.')))
    {
        return 2;
    }
    certName.remove(QString(m_currentNetwork + '.'));
    certName = certName.trimmed();
    if(certName.isEmpty())
    {
        return 2;
    }

    bool isUploadCert = value["isUploadCert"].toBool();
    if(isUploadCert)
    {
        if(m_certPath.isEmpty())
        {
            return 3;
        }
    }


    m_currantStartMaster = value;
    if(isUploadCert)
    {
        m_currantStartMaster.insert("certPath", m_certPath);
    }

    m_startStage = PATTERN_STAGE;
    saveCurrentRegistration();
    saveStageList();
    createMasterNode();
    emit registrationNodeStarted();
    return 0;
}

void DapModuleMasterNode::createMasterNode()
{
//    stakeDelegate();
//    return;

    if(m_startStage.isEmpty())
    {
        return;
    }

    switch(m_startStage.first().first)
    {
    case LaunchStage::CHECK_PUBLIC_KEY:
    {
        if(m_currantStartMaster["isUploadCert"].toBool())
        {
            moveCertificate();
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
    case LaunchStage::SEND_FORM:

        break;
    case LaunchStage::ORDER_VALIDATOR:
        createStakeOrder();
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
    return static_cast<int>(m_startStage.first().first);
}

void DapModuleMasterNode::saveStageList()
{
    QList<int> stageList;
    QList<int> indexList;
    for (const auto &stage : m_startStage) {
        stageList.append(static_cast<int>(stage.first));
        indexList.append(static_cast<int>(stage.second));
    }
    m_modulesCtrl->getSettings()->setValue("startStageNode", QVariant::fromValue(stageList));
    m_modulesCtrl->getSettings()->setValue("startIndexNode", QVariant::fromValue(indexList));
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
    QList<QPair<LaunchStage, int>> resultList;
    QList<int> stageList = m_modulesCtrl->getSettings()->value("startStageNode").value<QList<int>>();
    QList<int> indexList = m_modulesCtrl->getSettings()->value("startIndexNode").value<QList<int>>();
    if(stageList.size() != indexList.size())
    {
        return;
    }
    for (int i = 0; i < stageList.size(); i++)
    {
        resultList.append({static_cast<LaunchStage>(stageList[i]), indexList[i]});
    }

    m_startStage = resultList;
}

void DapModuleMasterNode::saveCurrentRegistration()
{
    m_modulesCtrl->getSettings()->setValue("currentStartMaster", QVariant::fromValue(m_currantStartMaster));
}

void DapModuleMasterNode::loadCurrentRegistration()
{
    m_currantStartMaster = m_modulesCtrl->getSettings()->value("currentStartMaster").toMap();
}

void DapModuleMasterNode::saveMasterNodeBase()
{
    m_modulesCtrl->getSettings()->setValue("masterNodes", QVariant::fromValue(m_masterNodes));
}

void DapModuleMasterNode::loadMasterNodeBase()
{
    m_masterNodes = m_modulesCtrl->getSettings()->value("masterNodes").value<QMap<QString, QVariantMap>>();
}

void DapModuleMasterNode::createCertificate()
{
    if(!m_currantStartMaster.contains("certName") || !m_currantStartMaster.contains("sign"))
    {
        qWarning() << "There is no certificate name or signature.";
        tryStopCreationMasterNode(0, "There is no certificate name or signature.");
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

void DapModuleMasterNode::requestNodeList()
{
    s_serviceCtrl->requestToService("DapNodeListCommand", QStringList() << m_currantStartMaster["network"].toString());
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
            tryStopCreationMasterNode(1, "An empty value was specified for freezing m-tokens.");
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
        tryStopCreationMasterNode(3, "No stake delegate hash found in the mempool.");
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
        tryStopCreationMasterNode(4, "No stake delegate hash found in the queue.");
    }
}

void DapModuleMasterNode::createStakeOrder()
{
    if(m_currantStartMaster.contains("fee"))
    {
        tryStopCreationMasterNode(7, "The value of the desired commission was not found.");
        return;
    }
    Dap::Coin feeCoin(m_currantStartMaster["fee"].toString());
    QString feeDatoshi = feeCoin.toDatoshiString();
    s_serviceCtrl->requestToService("DapCreateStakeOrder", QStringList()
                                                           << m_currantStartMaster["network"].toString()
                                                           << feeDatoshi
                                                           << m_currantStartMaster["certName"].toString());
}

void DapModuleMasterNode::getInfoNode()
{
    if(!m_isNetworkStatusRequest)
    {
        m_isNetworkStatusRequest = true;
        s_serviceCtrl->requestToService("DapGetNetworkStatusCommand", QStringList() << m_currantStartMaster["network"].toString());
    }
}

void DapModuleMasterNode::getNodeLIst()
{
    if(!m_isNodeListRequest)
    {
        m_isNodeListRequest = true;
        s_serviceCtrl->requestToService("DapNodeListCommand", QStringList() << m_currantStartMaster["network"].toString());
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

void DapModuleMasterNode::moveCertificate()
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "11"
                                                                                   << m_currantStartMaster["certName"].toString()
                                                                                   << m_currantStartMaster["certPath"].toString());
}

void DapModuleMasterNode::dumpCertificate()
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "3" << m_certName << m_certPath);
}

bool DapModuleMasterNode::tryGetInfoCertificate(const QString& filePath)
{
    qDebug() << "[DapModuleMasterNode] Selected file: " << filePath;

    QString tmpFilePath = filePath;
    tmpFilePath.remove("file://");
    QRegularExpression regular = QRegularExpression(R"(\/([a-zA-Z0-9.-_][^\/]+).dcert)");
    QRegularExpressionMatch match = regular.match(tmpFilePath);
    if (!match.hasMatch())
    {
        qDebug() << "[DapModuleMasterNode] unidentified file path";
        return false;
    }
    QString certName = match.captured(1);
    setCertName(certName);
    m_certPath = tmpFilePath;
    dumpCertificate();
    return true;
}

void DapModuleMasterNode::clearCertificate()
{
    setCertName("-");
    setSignature("-");
}

void DapModuleMasterNode::tryUpdateNetworkConfig()
{
    auto* worker = m_modulesCtrl->getConfigWorker();
    if(!worker)
    {
        tryStopCreationMasterNode(5, "There are node configuration problems.");
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
    m_checkStakeTimer->stop();
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
    else
    {
        qDebug() << "[DapModuleMasterNode] The transaction is in the mempool";
        tryStopCreationMasterNode(6, "The transaction may have failed.");
    }
}

void DapModuleMasterNode::respondCreateCertificate(const QVariant &rcvData)
{
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
                return true;
            }
        }
        return false;
    };

    if(command == 2)
    {
        if(m_startStage.isEmpty() || m_startStage.first().first != LaunchStage::CHECK_PUBLIC_KEY)
        {
            return;
        }

        if(!checkStatus())
        {
            tryStopCreationMasterNode(11, "Couldn't create a certificate.");
            return;
        }

        if(data.contains("completeBaseName") && data["completeBaseName"].toString() == m_currantStartMaster["certName"].toString())
        {
            getHashCertificate(m_currantStartMaster["certName"].toString());
            return;
        }
    }
    else if(command == 3)
    {
        QString name;
        if(data.contains("name"))
        {
            name = data["name"].toString();
        }
        if(!name.isEmpty() && name == m_certName && data.contains("signature"))
        {
            setSignature(data["signature"].toString());
        }
    }
    else if(command == 10)
    {
        if(m_startStage.isEmpty() || m_startStage.first().first != LaunchStage::CHECK_PUBLIC_KEY)
        {
            return;
        }

        if(!checkStatus())
        {
            tryStopCreationMasterNode(12, "The public key of the certificate was not found.");
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
            saveCurrentRegistration();
            stageComplated();
            return;
        }
    }
    if(command == 11)
    {
        if(m_startStage.isEmpty() || m_startStage.first().first != LaunchStage::CHECK_PUBLIC_KEY)
        {
            return;
        }

        if(!checkStatus())
        {
            tryStopCreationMasterNode(13, "couldn't copy the file.");
            return;
        }

        if(data.contains("fileName") && data["fileName"].toString() == m_currantStartMaster["certName"].toString())
        {
            getHashCertificate(m_currantStartMaster["certName"].toString());
            return;
        }
    }
}

void DapModuleMasterNode::addedNode(const QVariant &rcvData)
{
    auto result = rcvData.toString();
    if(result == "successfully")
    {
        getInfoNode();
    }
    else
    {
        tryStopCreationMasterNode(14, "I couldn't add a node.");
    }
}

void DapModuleMasterNode::respondNetworkStatus(const QVariant &rcvData)
{
    if(m_isNetworkStatusRequest)
    {
        QJsonObject replyObj = rcvData.toJsonObject();
        if(!replyObj.contains("name") || !replyObj.contains("nodeAddress"))
        {
            tryStopCreationMasterNode( 2, "Other problems. Contact customer support.");
            qWarning() << "The data of the net info team has changed" << replyObj;
            return;
        }

        QString network = replyObj["name"].toString();
        if(network == m_currantStartMaster["network"].toString())
        {
            m_currantStartMaster.insert("nodeAddress", replyObj["nodeAddress"].toString());
            saveCurrentRegistration();
            m_isNetworkStatusRequest = false;
            getNodeLIst();
        }
    }
}

void DapModuleMasterNode::respondNodeListCommand(const QVariant &rcvData)
{
    if(m_isNodeListRequest)
    {

        auto replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
        QJsonObject replyObj = replyDoc.object();
        m_isNodeListRequest = false;
        if(replyObj.contains("error"))
        {
            auto error = replyObj["error"].toString();
            qInfo() << "The list of nodes has not been received. Message:" << error;
            tryStopCreationMasterNode(15, "The list of nodes has not been received.");
            return;
        }

        auto resultArr = replyObj["result"].toArray();
        auto addr = m_currantStartMaster["nodeAddress"].toString();
        for(const auto& itemValue: resultArr)
        {
            QJsonObject item = itemValue.toObject();
            if(item.contains("node address") && item["node address"].toString() == addr)
            {
                stageComplated();
                return;
            }
        }
        tryStopCreationMasterNode(16, "Your node was not found in the list.");
     }
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
    emit masterNodeChanged();
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

void DapModuleMasterNode::tryStopCreationMasterNode(int code, const QString& message)
{
    // The logic of stopping the node.
    /// errors
    /// 0 - There is no certificate name or signature.
    /// 1 - An empty value was specified for freezing m-tokens.
    /// 2 - Other problems. Contact customer support.
    /// 3 - No stake delegate hash found in the mempool.
    /// 4 - No stake delegate hash found in the queue.
    /// 5 - There are node configuration problems.
    /// 6 - The transaction may have failed.
    /// 7 - The value of the desired commission was not found.
    /// 8 - The transaction was not created.
    /// 9 - There was a problem with the detention of tokens, we need to make another attempt.
    /// 10 -
    /// 11 - Couldn't create a certificate
    /// 12 - The public key of the certificate was not found.
    /// 13 - couldn't copy the file.
    /// 14 - Other problems.
    /// 15 - The list of nodes has not been received.
    /// 16 - Your node was not found in the list.
    qDebug() << "[DapModuleMasterNode] The node registration operation was interrupted." << message;
}

void DapModuleMasterNode::workNodeChanged()
{
    if(m_startStage.isEmpty() || m_startStage.first().first != LaunchStage::RESTARTING_NODE)
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
        tryStopCreationMasterNode(8, "The transaction was not created.");
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
        saveCurrentRegistration();
    }

    if(!stakeHash.isEmpty() || !queueHash.isEmpty())
    {
        stageComplated();
    }
    else
    {
        qDebug() << "[DapModuleMasterNode] [pespondStakeDelegate]There was a problem with the detention of tokens, we need to make another attempt.";
        tryStopCreationMasterNode(9, "There was a problem with the detention of tokens, we need to make another attempt.");
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

    getItem("queueHash", queueHash);
    getItem("state", state);
    getItem("txHash", txHash);

    if(m_currantStartMaster.contains(QUEUE_HASH_KEY) && m_currantStartMaster[QUEUE_HASH_KEY].toString() != queueHash)
    {
        qDebug() << "[DapModuleMasterNode][respondCheckStakeDelegate]The response came from another request.";
        return;
    }

    if(state == "mempool")
    {
        if(!m_currantStartMaster.contains(STAKE_HASH_KEY) && !txHash.isEmpty())
        {
            m_currantStartMaster.insert(STAKE_HASH_KEY, txHash);
            saveCurrentRegistration();
        }
    }
    else if(state == "notFound")
    {
        if(!m_currantStartMaster.contains(STAKE_HASH_KEY))
        {
            qDebug() << "It looks like the transaction was rejected.";
            tryStopCreationMasterNode(10, "It looks like the transaction was rejected.");
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

void DapModuleMasterNode::setCertName(const QString& name)
{
    m_certName = name;
    emit certNameChanged();
}

void DapModuleMasterNode::setSignature(const QString& signature)
{
    m_signature = signature;
    emit signatureChanged();
}

bool DapModuleMasterNode::isSandingDataStage() const
{
    if(m_startStage.isEmpty())
    {
        return false;
    }
    return m_startStage.first().first == LaunchStage::SEND_FORM;
}

bool DapModuleMasterNode::isMasterNode() const
{
    if(m_currentNetwork.isEmpty())
    {
        return false;
    }
    if(!m_masterNodeInfo.contains(m_currentNetwork))
    {
        return false;
    }
    return m_masterNodeInfo[m_currentNetwork].isMaster;
}
