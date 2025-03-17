#include "DapModuleMasterNode.h"
#include <QJsonDocument>
#include <QJsonObject>
#include "../DapTypes/DapCoin.h"
#include "DapDataManagerController.h"
#include "CellframeNode.h"

Q_DECLARE_METATYPE(QList<int>)

DapModuleMasterNode::DapModuleMasterNode(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_stakeDelegate(new DapStakeDelegate(s_serviceCtrl))
    , m_modulesCtrl(parent)
    , m_srvStakeInvalidate(new DapSrvStakeInvalidateStage(s_serviceCtrl))
    , m_waitingPermission(new DapWaitingPermission(s_serviceCtrl))
    , m_updateConfig(new DapUpdateConfigStage(s_serviceCtrl))
    , m_nodeDelStage(new DapNodeDelStage(s_serviceCtrl))
{
    auto setStageCallback = [this](DapAbstractMasterNodeCommand* stage)
    {
        stage->setStageComplatedCallback([this](){ stageComplated(); });
        stage->setNewDataCallback([this](const QString& key, const QVariant& data){
            m_currentStartMaster.insert(key, data);
            saveCurrentRegistration();
        });
        stage->setStopCreationCallback([this](int code, const QString& message){ tryStopCreationMasterNode(code, message); });
    };
    setStageCallback(m_stakeDelegate);
    setStageCallback(m_srvStakeInvalidate);
    setStageCallback(m_waitingPermission);
    setStageCallback(m_updateConfig);
    setStageCallback(m_nodeDelStage);

    connect(m_modulesCtrl->getManagerController(), &DapDataManagerController::networkListChanged, this, &DapModuleMasterNode::networkListUpdateSlot);

    connect(s_serviceCtrl, &DapServiceController::certificateManagerOperationResult, this, &DapModuleMasterNode::respondCreateCertificate);
    connect(s_serviceCtrl, &DapServiceController::rcvAddNode, this, &DapModuleMasterNode::addedNode);
    connect(s_serviceCtrl, &DapServiceController::networkStatusReceived, this, &DapModuleMasterNode::respondNetworkStatus);
    connect(s_serviceCtrl, &DapServiceController::rcvNodeListCommand, this, &DapModuleMasterNode::respondNodeListCommand);
    connect(s_serviceCtrl, &DapServiceController::createdStakeOrder, this, &DapModuleMasterNode::respondCreatedStakeOrder);
    connect(s_serviceCtrl, &DapServiceController::moveWalletCommandReceived, this, &DapModuleMasterNode::respondMoveWalletCommand);

    connect(m_modulesCtrl, &DapModulesController::nodeWorkingChanged, this, &DapModuleMasterNode::workNodeChanged);

    // TODO: for cleare nodes
//    clearMasterNodeBase();
//    clearCurrentRegistration();
//    clearStageList();

    loadFullStagesList();
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
            addNetwork(item[MasterNode::NETWORK_KEY].toString());
        }
    }
    if(!m_currentStartMaster.isEmpty())
    {
        addNetwork(m_currentStartMaster[MasterNode::NETWORK_KEY].toString());
    }
    connect(m_modulesCtrl, &DapModulesController::initDone, [this] ()
        {
            updateStakeNode();
        });
}

void DapModuleMasterNode::updateStakeNode()
{
    if(m_updateStakeData)
    {
        return;
    }
    m_updateStakeData = new DapUpdateStakeData(s_serviceCtrl);
    setStageCallback(m_updateStakeData);
    connect(m_updateStakeData, &DapAbstractMasterNodeCommand::finished, this, [this]
    {
        delete m_updateStakeData;
        m_updateStakeData = nullptr;
        if(!m_masterNodes.isEmpty())
        {
            for(const auto& item: qAsConst(m_masterNodes))
            {
                addNetwork(item[MasterNode::NETWORK_KEY].toString());
            }
        }
    });
    m_updateStakeData->tryUpdateStakeData(m_masterNodes);
}

void DapModuleMasterNode::setStageCallback(DapAbstractMasterNodeCommand* stage)
{
    stage->setStageComplatedCallback([this](){ stageComplated(); });
    stage->setNewDataCallback([this](const QString& key, const QVariant& data){
        m_currentStartMaster.insert(key, data);
        saveCurrentRegistration();
    });
    stage->setStopCreationCallback([this](int code, const QString& message){ tryStopCreationMasterNode(code, message); });
    stage->setUpdateDataCallback([this](const QString& network, const QString& paramName, const QVariant& value){
        if(m_masterNodes.contains(network))
        {
            m_masterNodes[network][paramName] = value;
        }
    });
    stage->setSaveDataCallback([this]{
        saveMasterNodeBase();
    });
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

    QString certName = value[MasterNode::CERT_NAME_KEY].toString();

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

    bool isUploadCert = value[MasterNode::CERT_LOGIC_KEY].toString() == "uploadCertificate";
    if(isUploadCert)
    {
        if(m_certPath.isEmpty())
        {
            return 3;
        }
    }

    bool isExistCert = value[MasterNode::CERT_LOGIC_KEY].toString() == "existingCertificate";
    if(isExistCert)
    {
        m_certPath = value[MasterNode::CERT_PATH_KEY].toString();
    }

    m_currentStartMaster = value;
    if(isUploadCert)
    {
        m_currentStartMaster.insert(MasterNode::CERT_PATH_KEY, m_certPath);
    }

    // TODO: if you need to make a fake Wallet for testing.
    // createDemoNode();

    // return 0;

    m_errorStage = -1;
    m_errorCode = -1;
    m_startStage = PATTERN_STAGE;
    setFullStageList(m_startStage);
    saveFullStagesList();
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

    auto stage = m_startStage.first().first;
    qInfo() << "[Master node] Start stage: " << launchStageString(stage);

    switch(stage)
    {
    case LaunchStage::CHECK_PUBLIC_KEY:
    {
        QString logic = m_currentStartMaster[MasterNode::CERT_LOGIC_KEY].toString();
        if(logic == "newCertificate")
        {
            createCertificate();
        }
        else if(logic == "uploadCertificate")
        {
            moveCertificate();
        }
        else if(logic == "existingCertificate")
        {
            tryGetInfoCertificate(m_currentStartMaster[MasterNode::CERT_PATH_KEY].toString(), "user");
        }
    }
    break;
    case LaunchStage::UPDATE_CONFIG:
        m_updateConfig->updateConfigForRegistration(m_currentStartMaster);
        break;
    case LaunchStage::RESTARTING_NODE:
        tryRestartNode();
        break;
    case LaunchStage::ADDINNG_NODE_DATA:
        addNode();
        break;
    case LaunchStage::SENDING_STAKE:
    {
        if(m_currentStartMaster.contains(MasterNode::QUEUE_HASH_KEY))
        {
            m_stakeDelegate->tryCheckStakeDelegate(m_currentStartMaster);
        }
        else
        {
            m_stakeDelegate->stakeDelegate(m_currentStartMaster);
        }
    }
        break;
    case LaunchStage::SEND_FORM:
        m_waitingPermission->startWaitingPermission(m_currentStartMaster);
        break;
    case LaunchStage::ORDER_VALIDATOR:
        createStakeOrder();
        break;
    case LaunchStage::BACK_STAKE:
        m_srvStakeInvalidate->stakeInvalidate(m_currentStartMaster);
        break;
    case LaunchStage::ORDER_REMOVE:
        // createStakeOrder();
        break;
    case LaunchStage::BACK_CONFIG:
        m_updateConfig->updateConfigForCancel(m_currentStartMaster, m_masterNodes);
        break;
    case LaunchStage::NODE_REMOVE:
        m_nodeDelStage->tryDeleteNode(m_currentStartMaster);
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

    qDebug() << "[DapModuleMasterNode] save start stages" <<m_modulesCtrl->getSettings()->allKeys();
    qDebug() << "[DapModuleMasterNode] save start stages" <<m_modulesCtrl->getSettings()->value("startStageNode").value<QList<int>>();

    m_modulesCtrl->getSettings()->setValue("errorStageMasterNode", QVariant::fromValue(m_errorStage));
    m_modulesCtrl->getSettings()->setValue("errorMessageMasterNode", QVariant::fromValue(m_errorCode));
}

void DapModuleMasterNode::saveFullStagesList()
{
    QVariantList stageList;
    QVariantList indexList;
    for (const auto &stage : qAsConst(m_currentFullStages))
    {
        stageList.append(static_cast<int>(stage.first));
        indexList.append(static_cast<int>(stage.second));
    }
    m_modulesCtrl->getSettings()->setValue("currentFullStagesStageNode", QVariant::fromValue(stageList));
    m_modulesCtrl->getSettings()->setValue("currentFullStagesIndexNode", QVariant::fromValue(indexList));

    qDebug() << "[DapModuleMasterNode] save fullStages" << m_modulesCtrl->getSettings()->allKeys();
    qDebug() << "[DapModuleMasterNode] save fullStages" << m_modulesCtrl->getSettings()->value("currentFullStagesStageNode").value<QList<int>>();
}

void DapModuleMasterNode::loadFullStagesList()
{
    QList<QPair<LaunchStage, int>> resultList;
    qDebug() << "[DapModuleMasterNode] load fullStages" << m_modulesCtrl->getSettings()->value("currentFullStagesStageNode").value<QList<int>>();
    qDebug() << "[DapModuleMasterNode] load fullStages" << m_modulesCtrl->getSettings()->value("currentFullStagesIndexNode").value<QList<int>>();
    QVariantList stageList = m_modulesCtrl->getSettings()->value("currentFullStagesStageNode").toList();
    QVariantList indexList = m_modulesCtrl->getSettings()->value("currentFullStagesIndexNode").toList();
    if(stageList.size() != indexList.size())
    {
        return;
    }
    for (int i = 0; i < stageList.size(); i++)
    {
        resultList.append({static_cast<LaunchStage>(stageList[i].toInt()), indexList[i].toInt()});
    }

    setFullStageList(resultList);
}

void DapModuleMasterNode::clearFullStagesList()
{
    m_modulesCtrl->getSettings()->remove("currentFullStagesStageNode");
    m_modulesCtrl->getSettings()->remove("currentFullStagesIndexNode");
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
        if(m_currentStartMaster.contains(MasterNode::MASTER_NODE_TO_CENCEL_KEY))
        {
            cenceledRegistration();
        }
        else
        {
            finishRegistration();
            emit masterNodeCreated();
        }
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

    qDebug() << "[Master node] [loadStageList] stage size: " << resultList.size();
    if(resultList.size())
    {
        qDebug() << "[Master node] [loadStageList] first stage " << launchStageString(resultList.first().first);
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
    if(!m_masterNodes.isEmpty())
    {
        qDebug() << "[Master node] load master node. There are configured master nodes. Networks: " << m_masterNodes.keys();
    }
}

void DapModuleMasterNode::clearMasterNodeBase()
{
    m_modulesCtrl->getSettings()->remove("masterNodes");
}

void DapModuleMasterNode::createCertificate()
{
    if(!m_currentStartMaster.contains(MasterNode::CERT_NAME_KEY) || !m_currentStartMaster.contains(MasterNode::CERT_SIGN_KEY))
    {
        qWarning() << "[DapModuleMasterNode] There is no certificate name or signature.";
        tryStopCreationMasterNode(0, "There is no certificate name or signature.");
        return;
    }
    qInfo() << "[DapModuleMasterNode] [Creating a master node] A " << m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString() << " certificate is being created";
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "2"
                                                                                   << m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString()
                                                                                   << m_currentStartMaster[MasterNode::CERT_SIGN_KEY].toString()
                                                                                   << "public");
}

void DapModuleMasterNode::getHashCertificate(const QString& certName)
{
    s_serviceCtrl->requestToService("DapCertificateManagerCommands", QStringList() << "10" << certName);
}

void DapModuleMasterNode::addNode()
{
    s_serviceCtrl->requestToService("DapAddNodeCommand", QStringList() << m_currentStartMaster[MasterNode::NETWORK_KEY].toString());
}

void DapModuleMasterNode::createStakeOrder()
{
    if(!m_currentStartMaster.contains(MasterNode::FEE_KEY))
    {
        tryStopCreationMasterNode(7, "The value of the desired commission was not found.");
        return;
    }
    Dap::Coin feeCoin(m_currentStartMaster[MasterNode::FEE_KEY].toString());
    QString feeDatoshi = feeCoin.toDatoshiString();
    s_serviceCtrl->requestToService("DapCreateStakeOrder", QStringList()
                                                           << m_currentStartMaster[MasterNode::NETWORK_KEY].toString()
                                                           << feeDatoshi
                                                           << m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString());
}

void DapModuleMasterNode::createStakeOrderForMasterNode(const QString& fee, const QString& certName)
{
    Dap::Coin feeCoin(fee);
    QString feeDatoshi = feeCoin.toDatoshiString();
    s_serviceCtrl->requestToService("DapCreateStakeOrder", QStringList() << m_currentNetwork << feeDatoshi << certName << "from" << MasterNode::MASTER_NODE_KEY); // master_node - For identification FROM
}

void DapModuleMasterNode::getInfoNode()
{
    if(!m_isNetworkStatusRequest)
    {
        m_isNetworkStatusRequest = true;
        s_serviceCtrl->requestToService("DapGetNetworkStatusCommand", QStringList() << m_currentStartMaster[MasterNode::NETWORK_KEY].toString());
    }
}

void DapModuleMasterNode::getNodeLIst()
{
    if(!m_isNodeListRequest)
    {
        m_isNodeListRequest = true;
        s_serviceCtrl->requestToService("DapNodeListCommand", QStringList() << m_currentStartMaster[MasterNode::NETWORK_KEY].toString());
    }
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
                                                                                       << m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString()
                                                                                       << m_currentStartMaster[MasterNode::CERT_PATH_KEY].toString());
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

void DapModuleMasterNode::tryRestartNode()
{
    s_serviceCtrl->requestToService("DapNodeRestart", QStringList());
}

void DapModuleMasterNode::respondCreatedStakeOrder(const QVariant &rcvData)
{
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());

    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);
    if(document.isNull() || document.isEmpty())
    {
        return;
    }
    QJsonObject replyObj = document.object();
    bool fromMasterNode = replyObj.contains("from") && replyObj["from"].toString() == MasterNode::MASTER_NODE_KEY;

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
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());

    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);
    if(document.isNull() || document.isEmpty())
    {
        return;
    }
    QJsonObject replyObj = document.object();

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

        if(data.contains("completeBaseName") && data["completeBaseName"].toString() == m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString())
        {
            getHashCertificate(m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString());
            return;
        }
    }
    else if(command == 3)
    {
        bool isExistCert = false;
        if(m_currentStartMaster.contains(MasterNode::CERT_LOGIC_KEY))
        {
            isExistCert = m_currentStartMaster[MasterNode::CERT_LOGIC_KEY].toString() == "existingCertificate";
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
                m_currentStartMaster[MasterNode::CERT_SIGN_KEY] = data["signature"].toString();
                getHashCertificate(m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString());
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
            m_currentStartMaster.insert(MasterNode::CERT_HASH_KEY, hash);
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

        if(data.contains("fileName") && data["fileName"].toString() == m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString())
        {
            getHashCertificate(m_currentStartMaster[MasterNode::CERT_NAME_KEY].toString());
            return;
        }
    }
}

void DapModuleMasterNode::addedNode(const QVariant &rcvData)
{
    QJsonDocument document = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject resultObject = document.object();

    if(resultObject.contains(Dap::JsonKeys::RESULT_KEY))
    {
        QString result = resultObject.value(Dap::JsonKeys::RESULT_KEY).toString();
        if(result == "successfully")
        {
            qInfo() << "----The node has been added.-----";
            getInfoNode();
            return;
        }
    }
    tryStopCreationMasterNode(17, "I couldn't add a node.");
}

void DapModuleMasterNode::respondNetworkStatus(const QVariant &rcvData)
{
    if(m_isNetworkStatusRequest)
    {
        auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());

        QJsonDocument document = QJsonDocument::fromJson(byteArrayData);
        if(document.isNull() || document.isEmpty())
        {
            return;
        }
        QJsonObject replyObj = document.object();
        if(!replyObj.contains("name") || !replyObj.contains(MasterNode::NODE_ADDR_KEY))
        {
            tryStopCreationMasterNode( 2, "Other problems. Contact customer support.");
            qWarning() << "The data of the net info team has changed" << replyObj;
            return;
        }

        QString network = replyObj["name"].toString();
        if(network == m_currentStartMaster[MasterNode::NETWORK_KEY].toString())
        {
            qInfo() << "-----The address of the node was received.------";
            m_currentStartMaster.insert(MasterNode::NODE_ADDR_KEY, replyObj[MasterNode::NODE_ADDR_KEY].toString());
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
        auto addr = m_currentStartMaster[MasterNode::NODE_ADDR_KEY].toString();
        for(const auto& itemValue: qAsConst(resultArr))
        {
            QJsonObject item = itemValue.toObject();
            if(item.contains("node address") && item["node address"].toString() == addr)
            {
                m_currentStartMaster.insert(MasterNode::NODE_ADDED_KEY, true);
                stageComplated();
                return;
            }
        }
        tryStopCreationMasterNode(16, "Your node was not found in the list.");
     }
}

void DapModuleMasterNode::networkListUpdateSlot()
{
    QMap<QString, bool> checkList;
    for(const auto &key: m_masterNodeInfo.keys())
    {
        checkList.insert(key, false);
        if(!m_currentStartMaster.isEmpty())
        {
            checkList.insert(m_currentStartMaster[MasterNode::NETWORK_KEY].toString(), false);
        }
    }

    QStringList netlist = m_modulesCtrl->getManagerController()->getNetworkList();
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
        info.publicKey = paramsNode[MasterNode::CERT_HASH_KEY].toString();
        info.nodeAddress = paramsNode[MasterNode::NODE_ADDR_KEY].toString();
        info.nodeIP = paramsNode[MasterNode::NODE_IP_KEY].toString();
        info.nodePort = paramsNode[MasterNode::PORT_KEY].toString();
        info.stakeAmount = paramsNode[MasterNode::STAKE_VALUE_KEY].toString() + " " + paramsNode[MasterNode::STAKE_TOKEN_KEY].toString();
        info.stakeHash = paramsNode[MasterNode::STAKE_HASH_KEY].toString();
        info.walletName = paramsNode[MasterNode::WALLET_NAME_KEY].toString();
        info.walletAddr = paramsNode[MasterNode::WALLET_ADDR_KEY].toString();
    }
    else if(!m_currentStartMaster.isEmpty())
    {
        if(m_currentStartMaster[MasterNode::NETWORK_KEY].toString() == net)
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
    
    /// 18 - I couldn't deleted a node.
    /// 19 - There was a problem with the return of tokens.
    /// 20 - No stake invalidate hash found in the mempool.
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

QVariantMap DapModuleMasterNode::masterNodeData() const
{
    MasterNodeInfo info = m_masterNodeInfo[m_currentNetwork];
    QVariantMap result;

    result.insert("publicKey", info.publicKey);
    result.insert(MasterNode::NODE_ADDR_KEY, info.nodeAddress);
    result.insert("nodeIP", info.nodeIP);
    result.insert("nodePort", info.nodePort);
    result.insert("stakeAmount", info.stakeAmount);
    result.insert(MasterNode::STAKE_HASH_KEY, info.stakeHash);
    result.insert(MasterNode::WALLET_NAME_KEY, info.walletName);
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
    QString network = m_currentStartMaster[MasterNode::NETWORK_KEY].toString();
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
    clearFullStagesList();
    networkListUpdateSlot();
    emit registrationNodeChanged();
    emit currentNetworkChanged();
    qInfo() << "Master Node created!!!!!!!!!!!";
}

void DapModuleMasterNode::cenceledRegistration()
{
    m_startStage.clear();
    m_stakeDelegate->cencelRegistration();
    m_waitingPermission->cencelRegistration();
    m_errorStage = -1;
    m_errorCode = -1;
    m_currentStartMaster.clear();
    clearStageList();
    clearCurrentRegistration();
    clearFullStagesList();
    emit errorCreation();
    emit registrationNodeChanged();
    emit registrationCenceled();
    qInfo() << "Master Node cenceled";
}

void DapModuleMasterNode::createDemoNode()
{
    m_currentStartMaster.insert(MasterNode::CERT_NAME_KEY, "0xB236424A551FDE2170ACACE905582B7772234C029C621A023EC04DC6C22B74C2");
    m_currentStartMaster.insert(MasterNode::STAKE_HASH_KEY, "0xF01C34E60F4BF387EBC07451F988BA07EB8EAAE9B184870A16BF495E53523764");
    m_currentStartMaster.insert(MasterNode::NODE_ADDR_KEY, "8343::1E4B::428B::101A");
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
    for(const auto& item: m_currentFullStages)
    {
        result.append(item.first);
    }
    return result;
}

bool DapModuleMasterNode::isUploadCertificate()
{
    if(m_currentStartMaster.contains(MasterNode::CERT_LOGIC_KEY))
    {
        return m_currentStartMaster[MasterNode::CERT_LOGIC_KEY].toString() == "uploadCertificate";
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

void DapModuleMasterNode::cencelRegistration()
{
    if(!m_currentStartMaster.contains(MasterNode::MASTER_NODE_TO_CENCEL_KEY))
    {
        if(!m_startStage.isEmpty())
        {
            qInfo() << "[MasterNode] Cancellation occurs at the stage:" << getStageString(m_startStage.first().first);
        }

        m_currentStartMaster.insert(MasterNode::MASTER_NODE_TO_CENCEL_KEY, true);
        emit isStartRegistrationChanged();
        QList<QPair<LaunchStage, int>> newStages;

        int count = 0;
        if(m_currentStartMaster.contains(MasterNode::ORDER_HASH_KEY))
        {
            newStages.append({LaunchStage::ORDER_REMOVE, count});
            count++;
        }
        if(m_currentStartMaster.contains(MasterNode::NODE_ADDED_KEY))
        {
            newStages.append({LaunchStage::NODE_REMOVE, count});
            count++;
        }

        auto stageIterator = std::find_if(m_startStage.begin(), m_startStage.end(), [](const QPair<LaunchStage, int>& value){
            return LaunchStage::UPDATE_CONFIG == value.first;
        });
        if(stageIterator == m_startStage.end())
        {
            newStages.append({LaunchStage::BACK_CONFIG, count});
            count++;
        }
        if(m_currentStartMaster.contains(MasterNode::STAKE_HASH_KEY))
        {
            newStages.append({LaunchStage::BACK_STAKE, count});
            count++;
        }
        if(!newStages.isEmpty())
        {
            newStages.append({LaunchStage::RESTARTING_NODE, count});
        }
        else
        {
            cenceledRegistration();
            return;
        }

        m_startStage.clear();
        m_startStage = newStages;
        setFullStageList(m_startStage);
        saveFullStagesList();

        m_errorStage = -1;
        m_errorCode = -1;
        emit registrationNodeChanged();
        saveCurrentRegistration();
        saveStageList();

        createMasterNode();
    }
    else
    {
        if(!m_startStage.isEmpty())
        {
            qInfo() << "[MasterNode] Ignoring occurs at the stage:" << getStageString(m_startStage.first().first);
        }
        qInfo() << "[MasterNode] Registration Information: " << m_currentStartMaster;
        stageComplated();
    }

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
    return getMasterNodeData(MasterNode::CERT_NAME_KEY);
}

void DapModuleMasterNode::setFullStageList(const QList<QPair<LaunchStage, int> > &stages)
{
    m_currentFullStages = stages;
    emit fullStageListUpdate();
}

QString DapModuleMasterNode::getStageString(LaunchStage stage) const
{
    QMetaEnum metaEnum = QMetaEnum::fromType<DapModuleMasterNode::LaunchStage>();
    return metaEnum.valueToKey(stage);
}

QString DapModuleMasterNode::launchStageString(LaunchStage value)
{
    const QMetaObject &metaObject = DapModuleMasterNode::staticMetaObject;
    int index = metaObject.indexOfEnumerator("LaunchStage");
    QMetaEnum metaEnum = metaObject.enumerator(index);
    return metaEnum.valueToKey(value);
}
