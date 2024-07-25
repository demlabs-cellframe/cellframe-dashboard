#include "DapModuleMasterNode.h"
#include <QJsonDocument>
#include <QJsonObject>
#include "../DapTypes/DapCoin.h"

DapModuleMasterNode::DapModuleMasterNode(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_checkStakeTimer(new QTimer())
    , m_listKeysTimer(new QTimer())
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
    connect(s_serviceCtrl, &DapServiceController::rcvGetListKeysCommand, this, &DapModuleMasterNode::respondListKeys);
    connect(s_serviceCtrl, &DapServiceController::createdStakeOrder, this, &DapModuleMasterNode::respondCreatedStakeOrder);

    connect(m_modulesCtrl, &DapModulesController::nodeWorkingChanged, this, &DapModuleMasterNode::workNodeChanged);
    connect(m_checkStakeTimer, &QTimer::timeout, this, &DapModuleMasterNode::checkStake);
    connect(m_listKeysTimer, &QTimer::timeout, this, &DapModuleMasterNode::getListKeys);

    loadMasterNodeBase();
//    loadStageList();
//    loadCurrentRegistration();
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

    QString certName = value[CERT_NAME_KEY].toString();

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

    bool isUploadCert = value[IS_UPLOAD_CERT_KEY].toBool();
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
        m_currantStartMaster.insert(CERT_PATH_KEY, m_certPath);
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
    if(m_startStage.isEmpty())
    {
        return;
    }

    switch(m_startStage.first().first)
    {
    case LaunchStage::CHECK_PUBLIC_KEY:
    {
        if(m_currantStartMaster[IS_UPLOAD_CERT_KEY].toBool())
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
        startWaitingPermission();
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
    if(!m_startStage.isEmpty())
    {
        m_startStage.removeFirst();
    }
    else
    {
        qWarning() << "Unexpectedly, the stage stack is empty";
        return;
    }

    createMasterNode();

    if(m_startStage.isEmpty())
    {
        finishRegistration();
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

void DapModuleMasterNode::clearStageList()
{
    m_modulesCtrl->getSettings()->remove("startStageNode");
    m_modulesCtrl->getSettings()->remove("startIndexNode");
}

void DapModuleMasterNode::saveCurrentRegistration()
{
    m_modulesCtrl->getSettings()->setValue("currentStartMaster", QVariant::fromValue(m_currantStartMaster));
}

void DapModuleMasterNode::loadCurrentRegistration()
{
    m_currantStartMaster = m_modulesCtrl->getSettings()->value("currentStartMaster").toMap();
}

void DapModuleMasterNode::clearCurrentRegistration()
{
    m_modulesCtrl->getSettings()->remove("currentStartMaster");
}

void DapModuleMasterNode::saveMasterNodeBase()
{
    auto* settings = m_modulesCtrl->getSettings();
    settings->beginGroup("masterNodes");

    for (auto it = m_masterNodes.constBegin(); it != m_masterNodes.constEnd(); ++it) {
        const QString& key = it.key();
        const QVariantMap& valueMap = it.value();

        settings->beginGroup(key);
        for (auto vIt = valueMap.constBegin(); vIt != valueMap.constEnd(); ++vIt) {
            settings->setValue(vIt.key(), vIt.value());
        }
        settings->endGroup();
    }

    settings->endGroup();
}

void DapModuleMasterNode::loadMasterNodeBase()
{
    QMap<QString, QVariantMap> nodes;
    auto* settings = m_modulesCtrl->getSettings();
    settings->beginGroup("masterNodes");

    QStringList groups = settings->childGroups();
    for (const QString& group : groups) {
        settings->beginGroup(group);

        QVariantMap valueMap;
        QStringList keys = settings->allKeys();
        for (const QString& key : keys) {
            valueMap.insert(key, settings->value(key));
        }

        nodes.insert(group, valueMap);
        settings->endGroup();
    }

    settings->endGroup();

    m_masterNodes = std::move(nodes);
}

void DapModuleMasterNode::clearMasterNodeBase()
{
    m_modulesCtrl->getSettings()->remove("masterNodes");
}

void DapModuleMasterNode::createCertificate()
{
    if(!m_currantStartMaster.contains(CERT_NAME_KEY) || !m_currantStartMaster.contains(CERT_SIGN_KEY))
    {
        qWarning() << "[DapModuleMasterNode] There is no certificate name or signature.";
        tryStopCreationMasterNode(0, "There is no certificate name or signature.");
        return;
    }
    qInfo() << "[DapModuleMasterNode] [Creating a master node] A " << m_currantStartMaster[CERT_NAME_KEY].toString() << " certificate is being created";
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "2"
                                                                                   << m_currantStartMaster[CERT_NAME_KEY].toString()
                                                                                   << m_currantStartMaster[CERT_SIGN_KEY].toString()
                                                                                   << "public");
}

void DapModuleMasterNode::getHashCertificate(const QString& certName)
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "10" << certName);
}

void DapModuleMasterNode::addNode()
{
    s_serviceCtrl->requestToService("DapAddNodeCommand", QStringList() << m_currantStartMaster[NETWORK_KEY].toString());
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
    s_serviceCtrl->requestToService("DapSrvStakeDelegateCommand", QStringList() << m_currantStartMaster[CERT_NAME_KEY].toString()
                                                                                << m_currantStartMaster[NETWORK_KEY].toString()
                                                                                << m_currantStartMaster[WALLET_NAME_KEY].toString()
                                                                                << valueDatoshi
                                                                                << feeDatoshi);
}

void DapModuleMasterNode::mempoolCheck()
{
    if(m_currantStartMaster.contains(STAKE_HASH_KEY))
    {
        s_serviceCtrl->requestToService("MempoolCheckCommand", QStringList() << m_currantStartMaster[NETWORK_KEY].toString()
                                                                             << m_currantStartMaster[STAKE_HASH_KEY].toString());
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
                                                                                << m_currantStartMaster[WALLET_NAME_KEY].toString()
                                                                                << m_currantStartMaster[NETWORK_KEY].toString());
    }
    else
    {
        tryStopCreationMasterNode(4, "No stake delegate hash found in the queue.");
    }
}

void DapModuleMasterNode::createStakeOrder()
{
    if(!m_currantStartMaster.contains(FEE_KEY))
    {
        tryStopCreationMasterNode(7, "The value of the desired commission was not found.");
        return;
    }
    Dap::Coin feeCoin(m_currantStartMaster[FEE_KEY].toString());
    QString feeDatoshi = feeCoin.toDatoshiString();
    s_serviceCtrl->requestToService("DapCreateStakeOrder", QStringList()
                                                           << m_currantStartMaster[NETWORK_KEY].toString()
                                                           << feeDatoshi
                                                           << m_currantStartMaster[CERT_NAME_KEY].toString());
}

void DapModuleMasterNode::getInfoNode()
{
    if(!m_isNetworkStatusRequest)
    {
        m_isNetworkStatusRequest = true;
        s_serviceCtrl->requestToService("DapGetNetworkStatusCommand", QStringList() << m_currantStartMaster[NETWORK_KEY].toString());
    }
}

void DapModuleMasterNode::getNodeLIst()
{
    if(!m_isNodeListRequest)
    {
        m_isNodeListRequest = true;
        s_serviceCtrl->requestToService("DapNodeListCommand", QStringList() << m_currantStartMaster[NETWORK_KEY].toString());
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
                                                                                   << m_currantStartMaster[CERT_NAME_KEY].toString()
                                                                                   << m_currantStartMaster[CERT_PATH_KEY].toString());
}

void DapModuleMasterNode::dumpCertificate()
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "3" << m_certName << m_certPath);
}

void DapModuleMasterNode::getListKeys()
{
    s_serviceCtrl->requestToService("DapGetListKeysCommand", QStringList() << m_currantStartMaster[NETWORK_KEY].toString());
}

void DapModuleMasterNode::startWaitingPermission()
{
    getListKeys();
    m_listKeysTimer->start(TIME_OUT_LIST_KEYS);
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
    worker->writeConfigValue(m_currantStartMaster[NETWORK_KEY].toString(), "esbocs", "blocks-sign-cert", m_currantStartMaster[CERT_NAME_KEY].toString());
    worker->writeConfigValue(m_currantStartMaster[NETWORK_KEY].toString(), "esbocs", "set_collect_fee", m_currantStartMaster[FEE_KEY].toString());
    worker->writeConfigValue(m_currantStartMaster[NETWORK_KEY].toString(), "esbocs", "fee_addr",  m_currantStartMaster[WALLET_ADDR_KEY].toString());
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

    if(m_currantStartMaster[STAKE_HASH_KEY].toString() != hash)
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

void DapModuleMasterNode::respondListKeys(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    QJsonObject result = replyObj["result"].toObject();

    if(!result.contains("keys"))
    {
        qWarning() << "[DapModuleMasterNode] Unexpected problem, key -keys- was not found.";
        tryStopCreationMasterNode(14, "Other problems.");
        return;
    }

    QString curPKey = m_currantStartMaster[CERT_HASH_KEY].toString();
    QString curNodeAddr = m_currantStartMaster[CERT_HASH_KEY].toString();
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
            qWarning() << "[DapModuleMasterNode] Unexpected problem, key -node addr- was not found.";
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
            qWarning() << "[DapModuleMasterNode] Unexpected problem, key -pKey hash- was not found.";
        }

        if(pKey == curPKey)
        {
            qInfo() << "-------The node has been added to the list.-----";
            stageComplated();
            return;
        }
    }

    qInfo() << QString("The node with address %1 and key %2 was not found in the list.").arg(curNodeAddr).arg(curPKey);
}

void DapModuleMasterNode::respondCreatedStakeOrder(const QVariant &rcvData)
{
    QJsonObject replyObj = rcvData.toJsonObject();

    if(!replyObj.contains("success"))
    {
        qWarning() << "[DapModuleMasterNode] [respondCreatedStakeOrder] Problems getting data from the team.";
        tryStopCreationMasterNode(14, "Problems getting data from the team.");
        return;
    }

    if(replyObj["success"].toBool())
    {
        qInfo() << "-------A commission payment order has been created.-----";
        stageComplated();
    }
    else
    {
        tryStopCreationMasterNode(10, "The commission payment order has not been created.");
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

        if(data.contains("completeBaseName") && data["completeBaseName"].toString() == m_currantStartMaster[CERT_NAME_KEY].toString())
        {
            getHashCertificate(m_currantStartMaster[CERT_NAME_KEY].toString());
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
            m_currantStartMaster.insert(CERT_HASH_KEY, hash);
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

        if(data.contains("fileName") && data["fileName"].toString() == m_currantStartMaster[CERT_NAME_KEY].toString())
        {
            getHashCertificate(m_currantStartMaster[CERT_NAME_KEY].toString());
            return;
        }
    }
}

void DapModuleMasterNode::addedNode(const QVariant &rcvData)
{
    auto result = rcvData.toString();
    if(result == "successfully")
    {
        qInfo() << "----The node has been added.-----";
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
        if(!replyObj.contains("name") || !replyObj.contains(NODE_ADDR_KEY))
        {
            tryStopCreationMasterNode( 2, "Other problems. Contact customer support.");
            qWarning() << "The data of the net info team has changed" << replyObj;
            return;
        }

        QString network = replyObj["name"].toString();
        if(network == m_currantStartMaster[NETWORK_KEY].toString())
        {
            qInfo() << "-----The address of the node was received.------";
            m_currantStartMaster.insert(NODE_ADDR_KEY, replyObj[NODE_ADDR_KEY].toString());
            saveCurrentRegistration();
            m_isNetworkStatusRequest = false;
            getNodeLIst();
            return;
        }
        qWarning() << "[DapModuleMasterNode] [respondNetworkStatus] An unexpected situation has occurred and the node address has not been received.";
        tryStopCreationMasterNode( 14, "Other problems.");
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
        auto addr = m_currantStartMaster[NODE_ADDR_KEY].toString();
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
    if(m_masterNodes.contains(net))
    {
        auto paramsNode = m_masterNodes[net];
        info.isMaster = true;
        info.publicKey = paramsNode[CERT_HASH_KEY].toString();
        info.nodeAddress = paramsNode[NODE_ADDR_KEY].toString();
        info.nodeIP = paramsNode[NODE_IP_KEY].toString();
        info.nodePort = paramsNode[PORT_KEY].toString();
        info.stakeAmount = paramsNode[STAKE_VALUE_KEY].toString() + " " + paramsNode[STAKE_TOKEN_KEY].toString();
        info.stakeHash = paramsNode[STAKE_HASH_KEY].toString();
        info.walletName = paramsNode[WALLET_NAME_KEY].toString();
        info.walletAddr = paramsNode[WALLET_ADDR_KEY].toString();

        info.validator.availabilityOrder = true;
        info.validator.nodePresence = true;
        info.validator.nodeWeight = "";
        info.validator.nodeStatus = "";
        info.validator.blocksSigned = "";
        info.validator.totalRewards = paramsNode[FEE_KEY].toString() + " " + paramsNode[FEE_TOKEN_KEY].toString();
        info.validator.networksBlocks = "";

    }
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
    /// 10 - The commission payment order has not been created.
    /// 11 - Couldn't create a certificate
    /// 12 - The public key of the certificate was not found.
    /// 13 - couldn't copy the file.
    /// 14 - Other problems.
    /// 15 - The list of nodes has not been received.
    /// 16 - Your node was not found in the list.
    qDebug() << "[DapModuleMasterNode] The node registration operation was interrupted. " << message;
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
    result.insert(NODE_ADDR_KEY, info.nodeAddress);
    result.insert("nodeIP", info.nodeIP);
    result.insert("nodePort", info.nodePort);
    result.insert("stakeAmount", info.stakeAmount);
    result.insert(STAKE_HASH_KEY, info.stakeHash);
    result.insert(WALLET_NAME_KEY, info.walletName);
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

void DapModuleMasterNode::finishRegistration()
{
    QString network = m_currantStartMaster[NETWORK_KEY].toString();
    if(m_masterNodes.contains(network))
    {
        qWarning() << "For some reason, you have already recorded a master node on this network. network: " << network;
        return;
    }
    m_masterNodes.insert(network, m_currantStartMaster);
    m_currantStartMaster.clear();

    clearCurrentRegistration();
    clearStageList();
}
