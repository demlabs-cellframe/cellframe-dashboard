#include "DapModuleMasterNode.h"
#include <QJsonDocument>
#include <QJsonObject>
#include "../DapTypes/DapCoin.h"

Q_DECLARE_METATYPE(QList<int>)

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
    connect(s_serviceCtrl, &DapServiceController::moveWalletCommandReceived, this, &DapModuleMasterNode::respondMoveWalletCommand);

    connect(m_modulesCtrl, &DapModulesController::nodeWorkingChanged, this, &DapModuleMasterNode::workNodeChanged);
    connect(m_checkStakeTimer, &QTimer::timeout, this, &DapModuleMasterNode::checkStake);
    connect(m_listKeysTimer, &QTimer::timeout, this, &DapModuleMasterNode::getListKeys);

    // TODO: for cleare nodes
//    clearMasterNodeBase();
//    clearCurrentRegistration();
//    clearStageList();

    loadMasterNodeBase();
    loadStageList();
    loadCurrentRegistration();

    if(getIsRegistrationNode())
    {
        m_isNeedStartRegistration = true;
    }

    if(!m_masterNodes.isEmpty())
    {
        for(const auto& item: qAsConst(m_masterNodes))
        {
            addNetwork(item[NETWORK_KEY].toString());
        }
    }
    if(!m_currentStartMaster.isEmpty())
    {
        addNetwork(m_currentStartMaster[NETWORK_KEY].toString());
    }
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
    auto keys = m_masterNodeInfo.keys();
    for(const auto &net: qAsConst(keys))
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
    if(m_currentNetwork == networkName)
    {
        return;
    }
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

    if(!m_currentStartMaster.isEmpty())
    {
        return 1;
    }

    QString certName = value[CERT_NAME_KEY].toString();

    if(!certName.toLower().contains(QString(m_currentNetwork + '.').toLower()))
    {
        return 2;
    }
    certName.remove(QString(m_currentNetwork + '.'));
    certName = certName.trimmed();
    if(certName.isEmpty())
    {
        return 2;
    }

    bool isUploadCert = value[CERT_LOGIC_KEY].toString() == "uploadCertificate";
    if(isUploadCert)
    {
        if(m_certPath.isEmpty())
        {
            return 3;
        }
    }

    bool isExistCert = value[CERT_LOGIC_KEY].toString() == "existingCertificate";
    if(isExistCert)
    {
        m_certPath = value[CERT_PATH_KEY].toString();
    }

    m_currentStartMaster = value;
    if(isUploadCert)
    {
        m_currentStartMaster.insert(CERT_PATH_KEY, m_certPath);
    }

    // TODO: if you need to make a fake dashboard for testing.
    // createDemoNode();

    // return 0;

    m_errorStage = -1;
    m_errorCode = -1;
    m_startStage = PATTERN_STAGE;
    m_masterNodeInfo[m_currentNetwork].isRegNode = true;
    emit registrationNodeChanged();
    saveCurrentRegistration();
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

    switch(m_startStage.first().first)
    {
    case LaunchStage::CHECK_PUBLIC_KEY:
    {
        QString logic = m_currentStartMaster[CERT_LOGIC_KEY].toString();
        if(logic == "newCertificate")
        {
            createCertificate();
        }
        else if(logic == "newCertificate")
        {
            moveCertificate();
        }
        else if(logic == "existingCertificate")
        {
            tryGetInfoCertificate(m_currentStartMaster[CERT_PATH_KEY].toString(), "user");
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
    {
        if(m_currentStartMaster.contains(QUEUE_HASH_KEY))
        {
            tryCheckStakeDelegate();
        }
        else
        {
            stakeDelegate();
        }
    }
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
        return -1;
    }
    return static_cast<int>(m_startStage.first().first);
}

void DapModuleMasterNode::saveStageList()
{
    QVariantList stageList;
    QVariantList indexList;
    for (const auto &stage : qAsConst(m_startStage))
    {
        stageList.append(static_cast<int>(stage.first));
        indexList.append(static_cast<int>(stage.second));
    }
    m_modulesCtrl->getSettings()->setValue("startStageNode", QVariant::fromValue(stageList));
    m_modulesCtrl->getSettings()->setValue("startIndexNode", QVariant::fromValue(indexList));

    qDebug() << m_modulesCtrl->getSettings()->allKeys();
    qDebug() << m_modulesCtrl->getSettings()->value("startStageNode").value<QList<int>>();

    m_modulesCtrl->getSettings()->setValue("errorStageMasterNode", QVariant::fromValue(m_errorStage));
    m_modulesCtrl->getSettings()->setValue("errorMessageMasterNode", QVariant::fromValue(m_errorCode));
}

void DapModuleMasterNode::stageComplated()
{
    if(!m_startStage.isEmpty())
    {
        m_startStage.removeFirst();
        saveStageList();
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
    m_errorStage = m_modulesCtrl->getSettings()->value("errorStageMasterNode").value<int>();
    m_errorCode = m_modulesCtrl->getSettings()->value("errorMessageMasterNode").value<int>();

    QList<QPair<LaunchStage, int>> resultList;
    qDebug() << m_modulesCtrl->getSettings()->allKeys();
    qDebug() << m_modulesCtrl->getSettings()->value("startStageNode").value<QList<int>>();
    qDebug() << m_modulesCtrl->getSettings()->value("startIndexNode").value<QList<int>>();
    QVariantList stageList = m_modulesCtrl->getSettings()->value("startStageNode").toList();//value<QList<int>>();
    QVariantList indexList = m_modulesCtrl->getSettings()->value("startIndexNode").toList();// value<QList<int>>();
    if(stageList.size() != indexList.size())
    {
        return;
    }
    for (int i = 0; i < stageList.size(); i++)
    {
        resultList.append({static_cast<LaunchStage>(stageList[i].toInt()), indexList[i].toInt()});
    }

    m_startStage = resultList;
}

void DapModuleMasterNode::clearStageList()
{
    m_modulesCtrl->getSettings()->remove("startStageNode");
    m_modulesCtrl->getSettings()->remove("startIndexNode");
    m_modulesCtrl->getSettings()->remove("errorStageMasterNode");
}

void DapModuleMasterNode::saveCurrentRegistration()
{
    m_modulesCtrl->getSettings()->setValue("currentStartMaster", QVariant::fromValue(m_currentStartMaster));
}

void DapModuleMasterNode::loadCurrentRegistration()
{
    m_currentStartMaster = m_modulesCtrl->getSettings()->value("currentStartMaster").toMap();
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
    for (const QString& group : qAsConst(groups)) {
        settings->beginGroup(group);

        QVariantMap valueMap;
        QStringList keys = settings->allKeys();
        for (const QString& key : qAsConst(keys)) {
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
    if(!m_currentStartMaster.contains(CERT_NAME_KEY) || !m_currentStartMaster.contains(CERT_SIGN_KEY))
    {
        qWarning() << "[DapModuleMasterNode] There is no certificate name or signature.";
        tryStopCreationMasterNode(0, "There is no certificate name or signature.");
        return;
    }
    qInfo() << "[DapModuleMasterNode] [Creating a master node] A " << m_currentStartMaster[CERT_NAME_KEY].toString() << " certificate is being created";
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "2"
                                                                                   << m_currentStartMaster[CERT_NAME_KEY].toString()
                                                                                   << m_currentStartMaster[CERT_SIGN_KEY].toString()
                                                                                   << "public");
}

void DapModuleMasterNode::getHashCertificate(const QString& certName)
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "10" << certName);
}

void DapModuleMasterNode::addNode()
{
    s_serviceCtrl->requestToService("DapAddNodeCommand", QStringList() << m_currentStartMaster[NETWORK_KEY].toString());
}

void DapModuleMasterNode::stakeDelegate()
{
    QString stakeValue = m_currentStartMaster["stakeValue"].toString();
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

    Dap::Coin fee256 = m_currentStartMaster["stakeFee"].toString();
    QString feeDatoshi = fee256.toDatoshiString();
    s_serviceCtrl->requestToService("DapSrvStakeDelegateCommand", QStringList() << m_currentStartMaster[CERT_NAME_KEY].toString()
                                                                                << m_currentStartMaster[NETWORK_KEY].toString()
                                                                                << m_currentStartMaster[WALLET_NAME_KEY].toString()
                                                                                << valueDatoshi
                                                                                << feeDatoshi);
}

void DapModuleMasterNode::mempoolCheck()
{
    if(m_currentStartMaster.contains(STAKE_HASH_KEY))
    {
        s_serviceCtrl->requestToService("MempoolCheckCommand", QStringList() << m_currentStartMaster[NETWORK_KEY].toString()
                                                                             << m_currentStartMaster[STAKE_HASH_KEY].toString());
    }
    else
    {
        tryStopCreationMasterNode(3, "No stake delegate hash found in the mempool.");
    }
}

void DapModuleMasterNode::checkStake()
{
    if(m_currentStartMaster.contains(QUEUE_HASH_KEY))
    {
        s_serviceCtrl->requestToService("DapCheckQueueTransactionCommand", QStringList()
                                                                                << m_currentStartMaster[QUEUE_HASH_KEY].toString()
                                                                                << m_currentStartMaster[WALLET_NAME_KEY].toString()
                                                                                << m_currentStartMaster[NETWORK_KEY].toString());
    }
    else
    {
        tryStopCreationMasterNode(4, "No stake delegate hash found in the queue.");
    }
}

void DapModuleMasterNode::createStakeOrder()
{
    if(!m_currentStartMaster.contains(FEE_KEY))
    {
        tryStopCreationMasterNode(7, "The value of the desired commission was not found.");
        return;
    }
    Dap::Coin feeCoin(m_currentStartMaster[FEE_KEY].toString());
    QString feeDatoshi = feeCoin.toDatoshiString();
    s_serviceCtrl->requestToService("DapCreateStakeOrder", QStringList()
                                                           << m_currentStartMaster[NETWORK_KEY].toString()
                                                           << feeDatoshi
                                                           << m_currentStartMaster[CERT_NAME_KEY].toString());
}

void DapModuleMasterNode::createStakeOrderForMasterNode(const QString& fee, const QString& certName)
{
    Dap::Coin feeCoin(fee);
    QString feeDatoshi = feeCoin.toDatoshiString();
    s_serviceCtrl->requestToService("DapCreateStakeOrder", QStringList() << m_currentNetwork << feeDatoshi << certName << "from" << MASTER_NODE_KEY); // master_node - For identification FROM
}

void DapModuleMasterNode::getInfoNode()
{
    if(!m_isNetworkStatusRequest)
    {
        m_isNetworkStatusRequest = true;
        s_serviceCtrl->requestToService("DapGetNetworkStatusCommand", QStringList() << m_currentStartMaster[NETWORK_KEY].toString());
    }
}

void DapModuleMasterNode::getNodeLIst()
{
    if(!m_isNodeListRequest)
    {
        m_isNodeListRequest = true;
        s_serviceCtrl->requestToService("DapNodeListCommand", QStringList() << m_currentStartMaster[NETWORK_KEY].toString());
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

void DapModuleMasterNode::moveCertificate(const QString& path)
{
    if(path.isEmpty())
    {
        s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "11"
                                                                                       << m_currentStartMaster[CERT_NAME_KEY].toString()
                                                                                       << m_currentStartMaster[CERT_PATH_KEY].toString());
    }
    else
    {
        auto cert = parsePath(path);
        if(!cert.first.isEmpty() && !cert.second.isEmpty())
        {
            qDebug() << "[DapModuleMasterNode] [moveCertificate] We are trying to move the certificate.";
            m_certMovedKeyRequest = true;
            s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "11"
                                                                                           << cert.first
                                                                                           << cert.second);
        }
        else
        {
            qDebug() << "[DapModuleMasterNode] [moveCertificate] The path to the certificate is specified incorrectly.";
            emit certMovedSignal(0);
        }
    }
}

void DapModuleMasterNode::moveWallet(const QString& path)
{
    auto wallet = parsePath(path, false);
    if(!wallet.first.isEmpty() && !wallet.second.isEmpty())
    {
        qDebug() << "[DapModuleMasterNode] [moveWallet] We are trying to move the wallet.";
        m_walletMovedKeyRequest = true;
        s_serviceCtrl->requestToService("DapMoveWalletCommand", QStringList() << wallet.first
                                                                              << wallet.second);
    }
    else
    {
        qDebug() << "[DapModuleMasterNode] [moveWallet] The path to the wallet is specified incorrectly.";
        emit walletMovedSignal(0);
    }
}

void DapModuleMasterNode::dumpCertificate(const QString& type)
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "3" << m_certName << m_certPath
                                                                                   << "from" << "master_node"
                                                                                   << "type" << type);
}

void DapModuleMasterNode::getListKeys()
{
    s_serviceCtrl->requestToService("DapGetListKeysCommand", QStringList() << m_currentStartMaster[NETWORK_KEY].toString());
}

void DapModuleMasterNode::startWaitingPermission()
{
    getListKeys();
    m_listKeysTimer->start(TIME_OUT_LIST_KEYS);
}

bool DapModuleMasterNode::tryGetInfoCertificate(const QString& filePath, const QString& type)
{
    auto cert = parsePath(filePath);
    setCertName(cert.first);
    m_certPath = cert.second;
    dumpCertificate(type);
    return true;
}

void DapModuleMasterNode::clearCertificate()
{
    setCertName("-");
    setSignature("-");
}

void DapModuleMasterNode::tryUpdateNetworkConfig()
{
    auto& controller = DapConfigToolController::getInstance();
    controller.setConfigParam("cellframe-node", "mempool", "auto_proc", "true");
    controller.setConfigParam("cellframe-node", "server", "enabled", "true");
    controller.setConfigParam(m_currentStartMaster[NETWORK_KEY].toString(), "general", "node-role", "master");
    controller.setConfigParam(m_currentStartMaster[NETWORK_KEY].toString(), "esbocs", "collecting_level", m_currentStartMaster[STAKE_VALUE_KEY].toString());
    controller.setConfigParam(m_currentStartMaster[NETWORK_KEY].toString(), "esbocs", "fee_addr", m_currentStartMaster[WALLET_ADDR_KEY].toString());
    controller.setConfigParam(m_currentStartMaster[NETWORK_KEY].toString(), "esbocs", "blocks-sign-cert", m_currentStartMaster[CERT_NAME_KEY].toString());
    tryRestartNode();
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

    if(m_currentStartMaster[STAKE_HASH_KEY].toString() != hash)
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

    if(source == "chain" && (code == "DAP_LEDGER_TX_CHECK_OK" || code.contains("No error")))
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
    if(replyObj.contains("error"))
    {
        qWarning() << "[DapModuleMasterNode] [respondListKeys] Error message. " << replyObj["error"].toString();
        m_listKeysTimer->stop();
        tryStopCreationMasterNode(14, "[respondListKeys]" + replyObj["error"].toString());
        return;
    }
    if(replyObj["result"].isNull())
    {
        m_listKeysTimer->stop();
        tryStopCreationMasterNode(14, "[respondListKeys] The result is empty in the response.");
        return;
    }
    QJsonObject result = replyObj["result"].toObject();

    if(!result.contains("keys"))
    {
        qWarning() << "[DapModuleMasterNode] Unexpected problem, key -keys- was not found.";
        m_listKeysTimer->stop();
        tryStopCreationMasterNode(14, "Other problems.");
        return;
    }

    QString curPKey = m_currentStartMaster[CERT_HASH_KEY].toString();
    QString curNodeAddr = m_currentStartMaster[NODE_ADDR_KEY].toString();
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
            m_listKeysTimer->stop();
            stageComplated();
            return;
        }
    }

    qInfo() << QString("The node with address %1 and key %2 was not found in the list.").arg(curNodeAddr).arg(curPKey);
}

void DapModuleMasterNode::respondCreatedStakeOrder(const QVariant &rcvData)
{
    QJsonObject replyObj = rcvData.toJsonObject();
    bool fromMasterNode = replyObj.contains("from") && replyObj["from"].toString() == MASTER_NODE_KEY;

    if(!replyObj.contains("success"))
    {
        qWarning() << "[DapModuleMasterNode] [respondCreatedStakeOrder] Problems getting data from the team.";
        if(fromMasterNode)
        {
            emit createdStakeOrder(false);
        }
        else
        {
            tryStopCreationMasterNode(14, "Problems getting data from the team.");
        }
        return;
    }

    if(replyObj["success"].toBool())
    {
        qInfo() << "-------A commission payment order has been created.-----";
        if(fromMasterNode)
        {
            emit createdStakeOrder(true);
        }
        else
        {
            stageComplated();
        }
    }
    else
    {
        if(fromMasterNode)
        {
            emit createdStakeOrder(false);
        }
        else
        {
            tryStopCreationMasterNode(10, "The commission payment order has not been created.");
        }
    }
}

void DapModuleMasterNode::respondCreateCertificate(const QVariant &rcvData)
{
    auto resultObject = QJsonDocument::fromJson(rcvData.toByteArray()).object();

    QJsonObject replyObj = resultObject["result"].toObject();

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

        if(data.contains("completeBaseName") && data["completeBaseName"].toString() == m_currentStartMaster[CERT_NAME_KEY].toString())
        {
            getHashCertificate(m_currentStartMaster[CERT_NAME_KEY].toString());
            return;
        }
    }
    else if(command == 3)
    {
        bool isExistCert = false;
        if(m_currentStartMaster.contains(CERT_LOGIC_KEY))
        {
            isExistCert = m_currentStartMaster[CERT_LOGIC_KEY].toString() == "existingCertificate";
        };

        QString name;
        if(data.contains("name"))
        {
            name = data["name"].toString();
        }
        if(!name.isEmpty() && name == m_certName && data.contains("signature"))
        {
            setSignature(data["signature"].toString());

            if(isExistCert)
            {
                m_currentStartMaster[CERT_SIGN_KEY] = data["signature"].toString();
                getHashCertificate(m_currentStartMaster[CERT_NAME_KEY].toString());
            }
        }
        else
        {
            if(isExistCert)
            {
                tryStopCreationMasterNode(0, "There is no certificate name or signature");
            }
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
            hash = hash.trimmed();
            m_currentStartMaster.insert(CERT_HASH_KEY, hash);
            saveCurrentRegistration();
            stageComplated();
            return;
        }
    }
    if(command == 11)
    {
        if(m_certMovedKeyRequest)
        {
            m_certMovedKeyRequest = false;
            emit certMovedSignal(checkStatus());
            return;
        }

        if(m_startStage.isEmpty() || m_startStage.first().first != LaunchStage::CHECK_PUBLIC_KEY)
        {
            return;
        }

        if(!checkStatus())
        {
            tryStopCreationMasterNode(13, "couldn't copy the file.");
            return;
        }

        if(data.contains("fileName") && data["fileName"].toString() == m_currentStartMaster[CERT_NAME_KEY].toString())
        {
            getHashCertificate(m_currentStartMaster[CERT_NAME_KEY].toString());
            return;
        }
    }
}

void DapModuleMasterNode::addedNode(const QVariant &rcvData)
{
    auto result = rcvData.toString();
    if(result.contains("successfully"))
    {
        qInfo() << "----The node has been added.-----";
        getInfoNode();
    }
    else
    {
        tryStopCreationMasterNode(17, "I couldn't add a node.");
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
        if(network == m_currentStartMaster[NETWORK_KEY].toString())
        {
            qInfo() << "-----The address of the node was received.------";
            m_currentStartMaster.insert(NODE_ADDR_KEY, replyObj[NODE_ADDR_KEY].toString());
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
        auto addr = m_currentStartMaster[NODE_ADDR_KEY].toString();
        for(const auto& itemValue: qAsConst(resultArr))
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
    for(const auto &key: m_masterNodeInfo.keys())
    {
        checkList.insert(key, false);
        if(!m_currentStartMaster.isEmpty())
        {
            checkList.insert(m_currentStartMaster[NETWORK_KEY].toString(), false);
        }
    }

    QStringList netlist = m_modulesCtrl->getNetworkList();
    for(const auto &net: netlist)
    {
        if(checkList.contains(net))
        {
            checkList[net] = true;
            if(!m_masterNodeInfo[net].isMaster && m_masterNodes.contains(net))
            {
                addNetwork(net);
            }
        }
        else
        {
            addNetwork(net);
        }
    }

    for(const auto &key: checkList.keys(false))
    {
        if(!m_masterNodeInfo[key].isMaster && !m_masterNodeInfo[key].isRegNode) m_masterNodeInfo.remove(key);
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

//        info.validator.availabilityOrder = true;
//        info.validator.nodePresence = true;
//        info.validator.nodeWeight = "";
//        info.validator.nodeStatus = "";
//        info.validator.blocksSigned = "";
//        info.validator.totalRewards = paramsNode[FEE_KEY].toString() + " " + paramsNode[FEE_TOKEN_KEY].toString();
//        info.validator.networksBlocks = "";

    }
    else if(!m_currentStartMaster.isEmpty())
    {
        if(m_currentStartMaster[NETWORK_KEY].toString() == net)
        {
            info.isRegNode = true;
        }
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
    /// 17 - I couldn't add a node.
    qDebug() << "[DapModuleMasterNode] The node registration operation was interrupted. " << message;

    if(!m_startStage.isEmpty())
    {
        m_errorStage = m_startStage.first().second;
        m_errorCode = code;
        saveStageList();

        emit errorCreation(code);
    }
}

void DapModuleMasterNode::workNodeChanged()
{
    if(m_startStage.isEmpty())
    {
        return;
    }

    bool isNodeWork = m_modulesCtrl->isNodeWorking();

    if(isNodeWork && m_startStage.first().first == LaunchStage::RESTARTING_NODE)
    {
        stageComplated();
    }
    else if(isNodeWork && m_errorStage == -1 &&
               m_isNeedStartRegistration && m_startStage.first().first != LaunchStage::RESTARTING_NODE)
    {
        m_isNeedStartRegistration = false;
        createMasterNode();
    }
}

void DapModuleMasterNode::respondMoveWalletCommand(const QVariant &rcvData)
{
    if(m_walletMovedKeyRequest)
    {
        m_walletMovedKeyRequest = false;
        QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
        QJsonObject replyObj = replyDoc.object();

        if(replyObj.contains("error"))
        {
            emit walletMovedSignal(0);
            qInfo() << "There were problems when transferring the wallet.";
        }
        else if(replyObj.contains("result"))
        {
            emit walletMovedSignal(1);
            qInfo() << "It was possible to transfer the wallet.";
        }
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
        m_currentStartMaster.insert(STAKE_HASH_KEY, stakeHash);
    }
    if(resultObj.contains("idQueue"))
    {
        queueHash = resultObj["idQueue"].toString();
        m_currentStartMaster.insert(QUEUE_HASH_KEY, queueHash);
        saveCurrentRegistration();
    }

    if(!stakeHash.isEmpty() || !queueHash.isEmpty())
    {
        tryCheckStakeDelegate();
//        stageComplated();
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

    if(m_currentStartMaster.contains(QUEUE_HASH_KEY) && m_currentStartMaster[QUEUE_HASH_KEY].toString() != queueHash)
    {
        qDebug() << "[DapModuleMasterNode][respondCheckStakeDelegate]The response came from another request.";
        return;
    }

    if(state == "mempool")
    {
        if(!m_currentStartMaster.contains(STAKE_HASH_KEY) && !txHash.isEmpty())
        {
            m_currentStartMaster.insert(STAKE_HASH_KEY, txHash);
            saveCurrentRegistration();
        }
    }
    else if(state == "notFound")
    {
        if(!m_currentStartMaster.contains(STAKE_HASH_KEY))
        {
            qDebug() << "It looks like the transaction was rejected.";
            m_checkStakeTimer->stop();
            tryStopCreationMasterNode(10, "It looks like the transaction was rejected.");
        }
        else
        {
            m_checkStakeTimer->stop();
            qInfo() << "We are looking for information about the transaction. By hash: " << m_currentStartMaster[STAKE_HASH_KEY].toString();
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

QString DapModuleMasterNode::getMasterNodeDataByNetwork(const QString& network, const QString& key)
{
    if(m_masterNodes.contains(network))
    {
        if(m_masterNodes[network].contains(key))
        {
            return m_masterNodes[network][key].toString();
        }
    }
    return {};
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
    QString network = m_currentStartMaster[NETWORK_KEY].toString();
    if(m_masterNodes.contains(network))
    {
        qWarning() << "For some reason, you have already recorded a master node on this network. network: " << network;
        return;
    }
    m_masterNodes.insert(network, m_currentStartMaster);
    m_currentStartMaster.clear();

    saveMasterNodeBase();

    clearCurrentRegistration();
    clearStageList();
    networkListUpdateSlot();
    emit registrationNodeChanged();
    emit currentNetworkChanged();
    qInfo() << "Master Node created!!!!!!!!!!!";
}

void DapModuleMasterNode::createDemoNode()
{
    m_currentStartMaster.insert(CERT_NAME_KEY, "0xB236424A551FDE2170ACACE905582B7772234C029C621A023EC04DC6C22B74C2");
    m_currentStartMaster.insert(STAKE_HASH_KEY, "0xF01C34E60F4BF387EBC07451F988BA07EB8EAAE9B184870A16BF495E53523764");
    m_currentStartMaster.insert(NODE_ADDR_KEY, "8343::1E4B::428B::101A");
    finishRegistration();
}

QString DapModuleMasterNode::getMasterNodeData(const QString& key)
{
    if(m_masterNodes.contains(m_currentNetwork))
    {
        if(m_masterNodes[m_currentNetwork].contains(key))
        {
            return m_masterNodes[m_currentNetwork][key].toString();
        }
        qDebug() << QString("[DapModuleMasterNode][getNodeData] Key %1 was not found. Network: ").arg(key).arg(m_currentNetwork);
        return QString();
    }
    qDebug() << QString("[DapModuleMasterNode][getNodeData] Network %1 is not registered").arg(m_currentNetwork);
    return QString();
}

QPair<QString, QString> DapModuleMasterNode::parsePath(const QString& filePath, bool isCert)
{
    qDebug() << "[DapModuleMasterNode] Selected file: " << filePath;

    QString tmpFilePath = filePath;
    tmpFilePath.remove("file://");
    QRegularExpression regular;
    if(isCert)
    {
        regular = QRegularExpression(R"(\/([a-zA-Z0-9.-_][^\/]+).dcert)");
    }
    else
    {
        regular = QRegularExpression(R"(\/([a-zA-Z0-9.-_][^\/]+).dwallet)");
    }
    QRegularExpressionMatch match = regular.match(tmpFilePath);
    if (!match.hasMatch())
    {
        qDebug() << "[DapModuleMasterNode] unidentified file path";
        return {};
    }
    QString name = match.captured(1);
    return {name, tmpFilePath};
}

QList<int> DapModuleMasterNode::getFullStepsLoader() const
{
    QList<int> result;
    for(const auto& item: PATTERN_STAGE)
    {
        result.append(item.first);
    }
    return result;
}

bool DapModuleMasterNode::isUploadCertificate()
{
    if(m_currentStartMaster.contains(CERT_LOGIC_KEY))
    {
        return m_currentStartMaster[CERT_LOGIC_KEY].toString() == "uploadCertificate";
    }
    return false;
}

int DapModuleMasterNode::getCurrentStage()
{
    if(m_startStage.isEmpty())
    {
        return 0;
    }
    return static_cast<int>(m_startStage.first().second);
}

void DapModuleMasterNode::stopAndClearRegistration()
{
    m_checkStakeTimer->stop();
    m_errorStage = -1;
    m_errorCode = -1;
    emit errorCreation();
    m_startStage.clear();
    m_currentStartMaster.clear();
    clearStageList();
    clearCurrentRegistration();
    emit registrationNodeChanged();
}

void DapModuleMasterNode::continueRegistrationNode()
{
    m_errorStage = -1;
    m_errorCode = -1;
    emit errorCreation();
    createMasterNode();
}

QVariant DapModuleMasterNode::getDataRegistration(const QString& nameData) const
{
    if(m_currentStartMaster.contains(nameData))
    {
        return m_currentStartMaster[nameData];
    }
    return QVariant();
}


QString DapModuleMasterNode::getMasterNodeCertName()
{
    return getMasterNodeData(CERT_NAME_KEY);
}
