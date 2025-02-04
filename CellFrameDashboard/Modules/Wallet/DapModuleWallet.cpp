#include "DapModuleWallet.h"

DapModuleWallet::DapModuleWallet(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_tokenModel(new DapTokensWalletModel())
    , m_walletModel(new DapListWalletsModel())
    , m_infoWallet (new DapInfoWalletModel())
    , m_walletHashManager(new WalletHashManager())
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletModelList", m_walletModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletModelInfo", m_infoWallet);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletTokensModel", m_tokenModel);

    auto* walletsManager = getWalletManager();
    auto* transtactionManager = getTransactionManager();

    connect(walletsManager, &DapWalletsManagerBase::walletListChanged, this, &DapModuleWallet::walletListChangedSlot);
    connect(walletsManager, &DapWalletsManagerBase::walletInfoChanged, this, &DapModuleWallet::walletInfoChangedSlot);
    connect(walletsManager, &DapWalletsManagerBase::currentWalletChanged, this, &DapModuleWallet::currentWalletChanged);

    connect(transtactionManager, &DapTransactionManager::sigDefatultTxReply, this, &DapModuleWallet::rcvDefatultTxReply);
    connect(s_serviceCtrl, &DapServiceController::walletRemoved, this, &DapModuleWallet::rcvRemoveWallet, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::transactionCreated, this, &DapModuleWallet::rcvCreateTx, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletCreated, this, &DapModuleWallet::rcvCreateWallet, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::passwordCreated, this, &DapModuleWallet::rcvPasswordCreated, Qt::QueuedConnection);

    m_walletHashManager->setContext(m_modulesCtrl->getAppEngine()->rootContext());
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletHashManager", m_walletHashManager);
}

DapModuleWallet::~DapModuleWallet()
{
    disconnect();

    delete m_walletHashManager;
    delete m_walletModel;
    delete m_tokenModel;
}

void DapModuleWallet::walletListChangedSlot()
{
    auto& walletsInfo = getWalletsInfo();
    m_walletModel->updateWallets(walletsInfo);
    int index = getIndexWallet(getCurrentWallet().second);
    if(!m_isFirstUpdate)
    {
        QString walletSaved = getSavedWallet();
        if(!walletsInfo.isEmpty())
        {
            if(!walletSaved.isEmpty())
            {
                int indexSave = getIndexWallet(walletSaved);
                setCurrentWallet(indexSave);
            }
            else
            {
                setCurrentWallet(0);
            }
        }
        else
        {
            setCurrentWallet(-1);
        }
        m_isFirstUpdate = true;
    }
    else if(walletsInfo.isEmpty())
    {
        setCurrentWallet(-1);
    }
    else if(index == -1)
    {
        setCurrentWallet(0);
    }
    else
    {
        setCurrentWallet(index);
    }

    emit listWalletChanged();
}

void DapModuleWallet::walletInfoChangedSlot(const QString& walletName, const QString& networkName)
{
    auto curWall = getCurrentWallet().second;
    if(getCurrentWallet().second != walletName)
    {
        return;
    }

    auto& walletsInfo = getWalletsInfo();
    if(walletsInfo.contains(getCurrentWallet().second))
    {
        m_infoWallet->updateModel(walletsInfo[getCurrentWallet().second].walletInfo);
        emit walletsModelChanged();
    }
}

const QMap<QString, CommonWallet::WalletInfo>& DapModuleWallet::getWalletsInfo() const
{
    auto* walletsManager = getWalletManager();
    return walletsManager->getWalletsInfo();
}

void DapModuleWallet::updateWalletList()
{
    getWalletManager()->updateWalletList();
}

void DapModuleWallet::updateWalletInfo()
{
    getWalletManager()->updateWalletInfo();
}

QString DapModuleWallet::getSavedWallet()
{
    QString walletName = m_modulesCtrl->getSettings()->value("walletName", "").toString();
    return walletName;
}

void DapModuleWallet::setCurrentWallet(int index)
{
    QPair<int,QString> newWallet;
    auto& walletsInfo = getWalletsInfo();
    if(index == -1 || walletsInfo.isEmpty())
    {
        newWallet = {-1, ""};
    }
    else if(walletsInfo.size() > index)
    {
        QStringList list = walletsInfo.keys();
        newWallet = {index, list[index]};
    }
    else
    {
        newWallet = {0, walletsInfo.first().walletName};
    }
    setNewCurrentWallet(std::move(newWallet));
}

void DapModuleWallet::setCurrentWallet(const QString& walletName)
{
    QPair<int,QString> newWallet;
    auto& walletsInfo = getWalletsInfo();
    if(walletsInfo.isEmpty())
    {
        newWallet = {-1, ""};
    }
    else if(walletName.isEmpty() || walletName.trimmed().isEmpty())
    {
        newWallet = {0, walletsInfo.first().walletName};
    }
    else if(walletsInfo.contains(walletName))
    {
        int index = getIndexWallet(walletName);
        newWallet = {index, walletName};
    }
    else
    {
        newWallet = {0, walletsInfo.first().walletName};
    }
    setNewCurrentWallet(std::move(newWallet));
}

int DapModuleWallet::getIndexWallet(const QString& walletName) const
{
    auto& walletsInfo = getWalletsInfo();
    QStringList walletsList = walletsInfo.keys();
    int index = -1;
    for(int i = 0; i < walletsList.size(); i++)
    {
        if(walletName == walletsList[i])
        {
            index = i;
            break;
        }
    }
    return index;
}

void DapModuleWallet::setNewCurrentWallet(const QPair<int,QString> newWallet)
{
    if(getCurrentWallet().second == newWallet.second)
    {
        if(newWallet.first != getCurrentWallet().first)
        {
            auto currentWallet = getCurrentWallet();
            currentWallet.first = newWallet.first;
            setCurrentWallet(std::move(currentWallet));
        }
        return;
    }
    setCurrentWallet(newWallet);
    m_modulesCtrl->getSettings()->setValue("walletName", getCurrentWallet().second);
    if(!getCurrentWallet().second.isEmpty())
    {
        auto& walletsInfo = getWalletsInfo();
        if(walletsInfo.contains(getCurrentWallet().second))
        {
            m_infoWallet->updateModel(walletsInfo[getCurrentWallet().second].walletInfo);
        }
    }
    else
    {
        qDebug()<<"[DapModuleWallet::setNewCurrentWallet] m_infoWallet->set empty model";
        m_infoWallet->updateModel({});
    }
}

void DapModuleWallet::createTx(QVariant args)
{
    s_serviceCtrl->requestToService("DapCreateTransactionCommand", args);
}

void DapModuleWallet::requestWalletTokenInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletTokenInfoCommand", args);
}

void DapModuleWallet::createWallet(const QStringList& args)
{
    QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    QVariantMap request = {{Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade}
                          ,{Dap::KeysParam::WALLET_NAME, args[0]}
                          ,{Dap::KeysParam::SIGN, args[1]}
                          ,{Dap::KeysParam::HASH, args[2]}};
    if(args.size() == 4)
    {
        request.insert(Dap::KeysParam::WALLET_PASSWORD, args[3]);
    }

    s_serviceCtrl->requestToService("DapAddWalletCommand", request);
}

void DapModuleWallet::removeWallet(QStringList args)
{
    if(args.isEmpty())
    {
        return;
    }
    QVariantMap request;
    auto walletsInfo = getWalletManager()->getWalletsInfo();
    QVariantMap walletsList;
    for(const auto& wallet: args)
    {
        if(!walletsInfo.contains(wallet))
        {
            continue;
        }
        QString path = walletsInfo.value(wallet).path;
        if(!path.isEmpty())
        {
            path += "/";
        }
        walletsList.insert(wallet, path);
    }
    request.insert("walletList", walletsList);
    s_serviceCtrl->requestToService("DapRemoveWalletCommand", request);
}

void DapModuleWallet::createPassword(QStringList args)
{
    if(args.isEmpty() && args.size() != 2)
    {
        return;
    }
    QVariantMap request;
    auto walletsInfo = getWalletManager()->getWalletsInfo();
    request.insert(Dap::KeysParam::WALLET_NAME, args[0]);
    request.insert(Dap::KeysParam::WALLET_PASSWORD, args[1]);
    request.insert(Dap::KeysParam::WALLET_PATH, walletsInfo.value(args[0]).path);
    QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL
                           ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    request.insert(Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade);
    s_serviceCtrl->requestToService("DapCreatePassForWallet", request);
}

void DapModuleWallet::activateOrDeactivateWallet(const QString& walletName,
                                                 const QString& target, const QString& pass,
                                                 const QString& ttl)
{
    QVariantMap req;
    req.insert(Dap::CommandParamKeys::COMMAND_KEY, target);
    req.insert(Dap::KeysParam::WALLET_NAME, walletName);
    req.insert(Dap::JsonKeys::PASSWORD, pass);
    req.insert(Dap::JsonKeys::TTL, ttl);

    if(DapNodeMode::getNodeMode() == DapNodeMode::REMOTE)
    {
        QString walletPath = getWalletManager()->getWalletsInfo()[walletName].path;

        req.insert(Dap::KeysParam::WALLET_PATH, walletPath);
        req.insert(Dap::CommandParamKeys::NODE_MODE_KEY, Dap::NodeMode::REMOTE_MODE);
    }
    else
    {
        req.insert(Dap::CommandParamKeys::NODE_MODE_KEY, Dap::NodeMode::LOCAL_MODE);
    }

    s_serviceCtrl->requestToService("DapWalletActivateOrDeactivateCommand", req);
}

void DapModuleWallet::rcvCreateTx(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    QJsonObject resultObj = replyObj["result"].toObject();

    emit sigTxCreate(resultObj);
}

void DapModuleWallet::rcvDefatultTxReply(const QVariant &rcvData)
{
    //TODO add queue processing

    QJsonObject rcvObj = QJsonDocument::fromJson(rcvData.toByteArray()).object();
    QJsonObject objResult = rcvObj["result"].toArray().first().toObject();

    QJsonObject reply;

    if(objResult.isEmpty() || rcvObj.contains("error"))
    {
        reply.insert("error", rcvObj["error"].toString());
        reply.insert("errorMessage", rcvObj["error"].toString());
    }
    else
    {
        reply.insert("toQueue", false);
        reply.insert("success", objResult["tx_create"].toBool());
        reply.insert("tx_hash", objResult["hash"].toString());
        reply.insert("message", "Transaction created.");
    }

    qDebug()<<reply;

    emit sigTxCreate(reply);
}

void DapModuleWallet::rcvCreateWallet(const QVariant &rcvData)
{
    updateWalletList();
    emit sigWalletCreate(rcvData);
}

void DapModuleWallet::rcvRemoveWallet(const QVariant &rcvData)
{
    emit sigWalletRemove(rcvData);
}

void DapModuleWallet::rcvHistory(const QVariant &rcvData)
{
    emit sigHistory(rcvData);
}

QVariantMap DapModuleWallet::approveTx(QVariantMap data)
{
    QString amount = data.value("amount").toString();
    amount = amount.contains(".")?
             amount.indexOf(".") == amount.length()-1 ? amount + "0": amount : amount + ".0";
    QVariantMap balanceInfo = getAvailableBalance(data);
    QString availBalance = balanceInfo.value("availBalance").toString();

    DapErrors err = (DapErrors)balanceInfo.value("error").toInt();

    if(err == DAP_NO_ERROR)
    {
        Dap::Coin availableBalance(availBalance);
        Dap::Coin amountValue(amount);
        QString result = (availableBalance - amountValue).toCoinsString();
        if(result.isEmpty() || result == "0" || result == "0.0" || result == "0.00")
            err = DAP_NOT_ENOUGHT_TOKENS;

        QVariantMap mapResult;
        mapResult.insert("error", (int)err);
        mapResult.insert("availBalance", availBalance);

        return mapResult;
    }

    return balanceInfo;
}

void DapModuleWallet::sendTx(QVariantMap data)
{

    //TODO: for test
    //    QVariantMap testData;
    //    testData.insert("network",              "Backbone");
    //    testData.insert("amount",               "1.0");
    //    testData.insert("send_ticker",          "KEL");
    //    testData.insert("wallet_from",          "myWallet");
    //    testData.insert("wallet_from_password", "");
    //    testData.insert("wallet_from_path",     "/opt/cellframe-dashboard/data/wallets/myWallet.dwallet");
    //    testData.insert("wallet_from_addr",     "Rj7J7MiX2bWy8sNyXKzkzfA45trMW5g1vMF2PfmJA6vM5dSJ97T9yip3dbniDx8SqJ7gNW2e1CPQmXGxdHx1a2rnTVeRyd21oNjKDMit");
    //    testData.insert("wallet_to",            "Rj7J7MiX2bWy8sNyY55eNdUgNwp5AEERxW5N8mVKybe7RzxcvtYyA5duV6tC33DunPSatKe6YDhRPF32VzDsQWVrCbtGgiBUDAbpmhJM");

    //    sendTx(testData);

    QString net           = data.value("network").toString();
    QString walletName    = data.value("wallet_from").toString();
    QString addrTo        = data.value("wallet_to").toString();
    QString amount        = data.value("amount").toString();
    QString sendTicker    = data.value("send_ticker").toString();

    QString nativeToken   = m_modulesCtrl->getManagerController()->getFee(net).validatorFee.value("fee_ticker");
    QString feeDatoshi    = m_modulesCtrl->getManagerController()->getFee(net).validatorFee.value("median_fee_datoshi");
    QString fee           = m_modulesCtrl->getManagerController()->getFee(net).validatorFee.value("median_fee_coins");
    QString feeNet        = m_modulesCtrl->getManagerController()->getFee(net).netFee.value("fee_coins");
    QString feeNetDatoshi = m_modulesCtrl->getManagerController()->getFee(net).netFee.value("fee_datoshi");
    QString feeNetAddr    = m_modulesCtrl->getManagerController()->getFee(net).netFee.value("fee_addr");

    MathWorker mathWorker;
    amount = mathWorker.balanceToCoins(mathWorker.coinsToBalance(amount)).toString();

    if(DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::REMOTE)
    {
        QString walletPath     = getWalletManager()->getWalletsInfo()[walletName].path + "/" + walletName + ".dwallet";
        QString walletPassword = ""; //don't use
        QString walletAddress  = getWalletManager()->getWalletsInfo()[walletName].walletInfo[net].address;

        QJsonObject txData;
        txData.insert(Dap::KeysParam::NETWORK_NAME,    net);
        txData.insert(Dap::KeysParam::FEE_DATOSHI,     feeDatoshi);
        txData.insert(Dap::KeysParam::FEE,             fee);
        txData.insert(Dap::KeysParam::FEE_NET,         feeNet);
        txData.insert(Dap::KeysParam::FEE_NET_DATOSHI, feeNetDatoshi);
        txData.insert(Dap::KeysParam::FEE_NET_ADDR,    feeNetAddr);
        txData.insert(Dap::KeysParam::AMOUNT_DATOSHI,  amount);
        txData.insert(Dap::KeysParam::TOKEN_NATIVE,    nativeToken);
        txData.insert(Dap::KeysParam::AMOUNT,          amount);
        txData.insert(Dap::KeysParam::WALLET_NAME,     walletName);
        txData.insert(Dap::KeysParam::WALLET_PATH,     walletPath);
        txData.insert(Dap::KeysParam::WALLET_PASSWORD, walletPassword);//don't use
        txData.insert(Dap::KeysParam::ADDR_FROM,       walletAddress);
        txData.insert(Dap::KeysParam::ADDR_TO,         addrTo);
        txData.insert(Dap::KeysParam::TOKEN_TICKER,    sendTicker);

        QJsonDocument docData(txData);

        QVariantMap mapData;
        mapData.insert(Dap::CommandParamKeys::NODE_MODE_KEY, Dap::NodeMode::REMOTE_MODE);
        mapData.insert(Dap::CommandParamKeys::COMMAND_KEY,   "DapCreateTxCommand");
        mapData.insert(Dap::CommandParamKeys::DATA_KEY,      docData.toJson());
        mapData.insert(Dap::KeysParam::TYPE_TX,              "Default");

        getTransactionManager()->sendTx(mapData);
    }
    else
    {
        QStringList listData;
        listData.append(net);
        listData.append(walletName);
        listData.append(addrTo);
        listData.append(sendTicker);
        listData.append(amount);
        listData.append(feeDatoshi);

        createTx(listData);
    }
}

void DapModuleWallet::setWalletTokenModel(const QString& network)
{
    auto model = m_infoWallet->getModel(network);

    m_tokenModel->setDataFromOtherModel(model->getData());

    emit tokenModelChanged();
}

QString DapModuleWallet::getAddressWallet(const QString &network, const QString& walletName) const
{
    auto& walletsInfo = getWalletsInfo();
    QString name = walletName.isEmpty() ? getCurrentWallet().second : walletName;
    if(!walletsInfo.contains(name))
    {
        return QString();
    }
    const auto& info = walletsInfo[name];
    if(!info.walletInfo.contains(network))
    {
        return QString();
    }
    return info.walletInfo[network].address;
}

QString DapModuleWallet::getCurrentWalletName() const
{
    return getCurrentWallet().second;
}

int DapModuleWallet::getCurrentIndex() const
{
    return getCurrentWallet().first;
}

const QPair<int,QString>& DapModuleWallet::getCurrentWallet() const
{
    auto* walletsManager = getWalletManager();
    return walletsManager->getCurrentWallet();
}

void DapModuleWallet::setCurrentWallet(const QPair<int,QString>& wallet)
{
    auto* walletsManager = getWalletManager();
    walletsManager->setCurrentWallet(wallet);
}

bool DapModuleWallet::isConteinListWallets(const QString& walletName)
{
    return getWalletManager()->getWalletsInfo().contains(walletName);
}

DapWalletsManagerBase* DapModuleWallet::getWalletManager() const
{
    Q_ASSERT_X(m_modulesCtrl, "DapModuleWallet", "ModuleController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController(), "DapModuleWallet", "ManagerController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController()->getWalletManager(), "DapModuleWallet", "WalletManager not found");
    return m_modulesCtrl->getManagerController()->getWalletManager();
}

DapTransactionManager *DapModuleWallet::getTransactionManager() const
{
    Q_ASSERT_X(m_modulesCtrl, "DapModuleWallet", "ModuleController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController(), "DapModuleWallet", "ManagerController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController()->getTransactionManager(), "DapModuleWallet", "TransactionManager not found");
    return m_modulesCtrl->getManagerController()->getTransactionManager();
}

void DapModuleWallet::rcvPasswordCreated(const QVariant &rcvData)
{
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());

    QString result = byteArrayData.constData();
    emit passwordCreated(result);
}
