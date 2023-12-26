#include "DapModuleWallet.h"
#include <QStringList>

DapModuleWallet::DapModuleWallet(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_walletHashManager(new WalletHashManager())
    , m_modulesCtrl(parent)
    , m_timerUpdateListWallets(new QTimer())
    , m_timerUpdateWallet(new QTimer())
    , m_timerFeeUpdateWallet(new QTimer())
    , m_walletModel(new DapListWalletsModel())
    , m_infoWallet (new DapInfoWalletModel())
    , m_DEXTokenModel(new DapTokensWalletModel())
    , m_tokenFilterModelDEX(new TokenProxyModel())
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletModelList", m_walletModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletModelInfo", m_infoWallet);
    m_tokenFilterModelDEX->setSourceModel(m_DEXTokenModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("dexTokenModel", m_tokenFilterModelDEX);


    updateListWallets();

    connect(m_timerUpdateListWallets, &QTimer::timeout, this, &DapModuleWallet::updateListWallets, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletsListReceived, this, &DapModuleWallet::walletsListReceived, Qt::QueuedConnection);
    m_timerUpdateListWallets->start(TIME_LIST_WALLET_UPDATE);
    
    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        m_walletHashManager->setContext(m_modulesCtrl->s_appEngine->rootContext());
        m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("walletHashManager", m_walletHashManager);

        initConnect();
        m_timerUpdateWallet->start(TIME_WALLET_UPDATE);
        tryUpdateFee();
    });
}

DapModuleWallet::~DapModuleWallet()
{
    disconnect(s_serviceCtrl, &DapServiceController::walletsReceived,          this, &DapModuleWallet::rcvWalletsInfo);
    disconnect(s_serviceCtrl, &DapServiceController::walletReceived,           this, &DapModuleWallet::rcvWalletInfo);
    disconnect(s_serviceCtrl, &DapServiceController::transactionCreated,       this, &DapModuleWallet::rcvCreateTx);
    disconnect(s_serviceCtrl, &DapServiceController::walletCreated,            this, &DapModuleWallet::rcvCreateWallet);
    disconnect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory);
    disconnect(s_serviceCtrl, &DapServiceController::walletRemoved,            this, &DapModuleWallet::rcvRemoveWallet);

    disconnect(m_timerUpdateWallet, &QTimer::timeout, this, &DapModuleWallet::slotUpdateWallet);

    delete m_timerUpdateListWallets;
    delete m_timerUpdateWallet;
    delete m_timerFeeUpdateWallet;
    delete m_walletHashManager;
    delete m_walletModel;
    delete m_DEXTokenModel;
    delete m_tokenFilterModelDEX;
}

void DapModuleWallet::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::rcvFee, this, &DapModuleWallet::rcvFee, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletsReceived, this, &DapModuleWallet::rcvWalletsInfo, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletReceived, this, &DapModuleWallet::rcvWalletInfo, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletRemoved, this, &DapModuleWallet::rcvRemoveWallet, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::transactionCreated, this, &DapModuleWallet::rcvCreateTx, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletCreated, this, &DapModuleWallet::rcvCreateWallet, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory, Qt::QueuedConnection);

    connect(m_timerFeeUpdateWallet, &QTimer::timeout, this, &DapModuleWallet::tryUpdateFee, Qt::QueuedConnection);
    connect(m_timerUpdateWallet, &QTimer::timeout, this, &DapModuleWallet::slotUpdateWallet, Qt::QueuedConnection);

    getWalletsInfo(QStringList()<<"true");
}


void DapModuleWallet::updateListWallets()
{
    m_modulesCtrl->updateListWallets();
}

void DapModuleWallet::walletsListReceived(const QVariant &rcvData)
{
    QJsonDocument doc = QJsonDocument::fromJson(rcvData.toByteArray());

    if(doc.array().isEmpty())
    {
        setCurrentWallet(-1);
    }

    if(m_walletListTest != doc.toJson())
    {
        m_walletListTest = doc.toJson();
        updateWalletInfo(doc);

        m_walletModel->updateWallets(m_walletsInfo);

        if(!m_firstDataLoad)
        {
            restoreIndex();
            m_firstDataLoad = true;
            m_modulesCtrl->tryStartModules();
        }
        int index = getIndexWallet(m_currentWallet.second);
        if(m_walletsInfo.isEmpty())
        {
            m_currentWallet = {-1, ""};
        }
        else if(index == -1)
        {
            m_currentWallet = {0, m_walletsInfo.firstKey()};
        }
        else
        {
            m_currentWallet = {index, m_currentWallet.second};
        }

        if(m_walletsInfo.contains(m_currentWallet.second))
        {
            m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);
            updateDexTokenModel();
        }
        emit listWalletChanged();
    }
}

void DapModuleWallet::restoreIndex()
{
    QString prevName = m_modulesCtrl->getSettings()->value("walletName", "").toString();

    if(!prevName.isEmpty())
    {
        setCurrentWallet(prevName);
        return;
    }

    setCurrentWallet(0);
}

void DapModuleWallet::updateWalletInfo(const QJsonDocument& document)
{
    QJsonArray walletArray = document.array();

    QStringList currentList;

    for(const QJsonValue value: walletArray)
    {
        QJsonObject tmpObject = value.toObject();
        if(tmpObject.contains("name") && tmpObject.contains("status"))
        {
            QString walletName = tmpObject["name"].toString();
            if(!walletName.isEmpty())
            {
                if(m_walletsInfo.contains(walletName))
                {
                    m_walletsInfo[walletName].status = tmpObject["status"].toString();
                }
                else
                {
                    if(!walletName.isEmpty())
                    {
                        CommonWallet::WalletInfo tmpWallet;
                        tmpWallet.walletName = walletName;
                        tmpWallet.status = tmpObject["status"].toString();
                        m_walletsInfo.insert(walletName, std::move(tmpWallet));
                    }
                }
                currentList.append(walletName);
            }
        }
    }

    QStringList tmpList = m_walletsInfo.keys();
    QStringList diffList;
    for(const QString& str: tmpList)
    {
        if(!currentList.contains(str))
        {
            diffList.append(str);
        }
    }

    for(const QString& str: diffList)
    {
        m_walletsInfo.remove(str);
    }
}

void DapModuleWallet::setCurrentWallet(int index)
{
    QPair<int,QString> newWallet;
    if(index == -1 || m_walletsInfo.isEmpty())
    {
        newWallet = {-1, ""};
    }
    else if(m_walletsInfo.size() > index)
    {
        QStringList list = m_walletsInfo.keys();
        newWallet = {index, list[index]};
    }
    else
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }

    if(newWallet.first != m_currentWallet.first)
    {
        setNewCurrentWallet(std::move(newWallet));
    }
}

void DapModuleWallet::setCurrentWallet(const QString& walletName)
{
     QPair<int,QString> newWallet;

    if(m_walletsInfo.isEmpty())
    {
        newWallet = {-1, ""};
    }
    else if(walletName.isEmpty() || walletName.trimmed().isEmpty())
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }
    else if(m_walletsInfo.contains(walletName))
    {
        int index = getIndexWallet(walletName);
        newWallet = {index, walletName};
    }
    else
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }

    if(newWallet.first != m_currentWallet.first)
    {
        setNewCurrentWallet(std::move(newWallet));
    }
}

int DapModuleWallet::getIndexWallet(const QString& walletName) const
{
    QStringList walletsList = m_walletsInfo.keys();
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
    m_currentWallet = newWallet;
    m_modulesCtrl->getSettings()->setValue("walletName", m_currentWallet.second);
    m_modulesCtrl->setCurrentWallet(m_currentWallet);
    if(!m_currentWallet.second.isEmpty())
    {
        m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);
        updateDexTokenModel();
    }
    else
    {
        m_infoWallet->updateModel({});
    }

    startUpdateCurrentWallet();
    emit currentWalletChanged();
    updateBalanceDEX();
}

void DapModuleWallet::timerUpdateFlag(bool flag)
{
    if(flag)
        m_timerUpdateWallet->start(TIME_WALLET_UPDATE);
    else
        m_timerUpdateWallet->stop();
}

void DapModuleWallet::getWalletsInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletsInfoCommand", args);
}

void DapModuleWallet::requestWalletInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletInfoCommand", args);
}

void DapModuleWallet::createTx(QStringList args)
{
    s_serviceCtrl->requestToService("DapCreateTransactionCommand", args);
}

void DapModuleWallet::requestWalletTokenInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletTokenInfoCommand", args);
}

void DapModuleWallet::createWallet(QStringList args)
{
    m_timerUpdateWallet->stop();
    s_serviceCtrl->requestToService("DapAddWalletCommand", args);
}

void DapModuleWallet::removeWallet(QStringList args)
{
    m_timerUpdateWallet->stop();
    s_serviceCtrl->requestToService("DapRemoveWalletCommand", args);
}

void DapModuleWallet::createPassword(QStringList args)
{
    s_serviceCtrl->requestToService("DapCreatePassForWallet", args);
}

void DapModuleWallet::getTxHistory(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetAllWalletHistoryCommand", args);
}

void DapModuleWallet::rcvWalletsInfo(const QVariant &rcvData)
{
    updateWalletModel(rcvData, false);
}

void DapModuleWallet::rcvWalletInfo(const QVariant &rcvData)
{
    updateWalletModel(rcvData, true);
}

void DapModuleWallet::rcvCreateTx(const QVariant &rcvData)
{
    emit sigTxCreate(rcvData);
}

void DapModuleWallet::rcvCreateWallet(const QVariant &rcvData)
{
    m_modulesCtrl->updateListWallets();
    m_timerUpdateWallet->start(TIME_WALLET_UPDATE);
    emit sigWalletCreate(rcvData);
}

void DapModuleWallet::rcvRemoveWallet(const QVariant &rcvData)
{
    m_modulesCtrl->getWalletList();
    m_timerUpdateWallet->start(5000);
    emit sigWalletRemove(rcvData);
}

void DapModuleWallet::rcvHistory(const QVariant &rcvData)
{
    emit sigHistory(rcvData);
}

void DapModuleWallet::slotUpdateWallet()
{
    requestWalletInfo(QStringList() << getCurrentWalletName() <<"false");
}

void DapModuleWallet::updateWalletModel(QVariant data, bool isSingle)
{
    QByteArray byteArrayData = data.toByteArray();

    if(isSingle)
    {
        if(m_walletInfoTest != byteArrayData)
        {
            m_walletInfoTest = byteArrayData;
        }
        else
        {
            return;
        }
    }
    else
    {
        if(m_walletsInfoTest != byteArrayData)
        {
            m_walletsInfoTest = byteArrayData;
        }
        else
        {
            return;
        }
    }

    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);

    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    if(!isSingle)
    {
        QJsonArray walletArray = document.array();
        if(walletArray.isEmpty())
        {
            return;
        }

        for(const QJsonValue& walletValue: walletArray)
        {
            CommonWallet::WalletInfo tmpInfo = creatInfoObject(std::move(walletValue.toObject()));
            if(m_walletsInfo.contains(tmpInfo.walletName))
            {
                m_walletsInfo[tmpInfo.walletName] = std::move(tmpInfo);
            }
            else
            {
                if(!tmpInfo.walletName.isEmpty())
                {
                    m_walletsInfo.insert(tmpInfo.walletName, std::move(tmpInfo));
                }
            }
        }
        emit walletsModelChanged();
    }
    else
    {
        QJsonObject inObject = document.object();
        CommonWallet::WalletInfo tmpInfo = creatInfoObject(std::move(inObject));
        if(m_walletsInfo.contains(tmpInfo.walletName))
        {
            m_walletsInfo[tmpInfo.walletName] = std::move(tmpInfo);
        }
        else
        {
            if(!tmpInfo.walletName.isEmpty())
            {
                m_walletsInfo.insert(tmpInfo.walletName, std::move(tmpInfo));
            }
        }
        emit walletsModelChanged();
    }
    updateDexTokenModel();
    m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);
    m_walletModel->updateWallets(m_walletsInfo);
    emit walletsModelChanged();
    updateBalanceDEX();
}

void DapModuleWallet::updateDexTokenModel()
{
    QList<CommonWallet::WalletTokensInfo> tokenInfoConteiner;
    for(const auto& networkItem: m_walletsInfo[m_currentWallet.second].walletInfo)
    {
        tokenInfoConteiner.append(networkItem.networkInfo);
    }
    m_DEXTokenModel->updateAllToken(tokenInfoConteiner);
    m_tokenFilterModelDEX->updateCount();
}

CommonWallet::WalletInfo DapModuleWallet::creatInfoObject(const QJsonObject& walletObject)
{
    CommonWallet::WalletInfo wallet;

    if(walletObject.contains("name"))
    {
        wallet.walletName = walletObject["name"].toString();
    }
    else
    {
        qWarning() << "[creatInfoObject] No wallet name";
        return CommonWallet::WalletInfo();
    }

    if(walletObject.contains("status"))
    {
        wallet.status = walletObject["status"].toString();
    }
    wallet.isLoad = true;
    if(walletObject.contains("networks"))
    {
        for(const QJsonValue& networkValue: walletObject["networks"].toArray())
        {
            QJsonObject networkObject = networkValue.toObject();
            CommonWallet::WalletNetworkInfo networkInfo;

            if(networkObject.contains("address"))
            {
                networkInfo.address = networkObject["address"].toString();
            }
            else
            {
                qWarning() << "The wallet address is missing on the network or the input data has changed";
                continue;
            }

            if(networkObject.contains("name"))
            {
                networkInfo.network = networkObject["name"].toString();
            }
            else
            {
                qWarning() << "The network name is missing or the input data has changed";
                continue;
            }

            if(networkObject.contains("tokens"))
            {
                for(const QJsonValue& tokenValue: networkObject["tokens"].toArray())
                {
                    QJsonObject tokenObject = tokenValue.toObject();
                    CommonWallet::WalletTokensInfo token;
                    token.network = networkInfo.network;
                    if(tokenObject.contains("coins"))
                    {
                        token.value = tokenObject["coins"].toString();
                    }
                    if(tokenObject.contains("datoshi"))
                    {
                        token.datoshi = tokenObject["datoshi"].toString();
                    }
                    if(tokenObject.contains("name"))
                    {
                        token.ticker = tokenObject["name"].toString();
                        token.tokenName = tokenObject["name"].toString();
                    }

                    networkInfo.networkInfo.append(token);
                }
            }

            wallet.walletInfo.insert(networkInfo.network, networkInfo);
        }
    }
    return wallet;
}

void DapModuleWallet::startUpdateCurrentWallet()
{
    qDebug() << "New current wallet - " << m_currentWallet.second;

    if(!m_walletsInfo.contains(m_currentWallet.second))
    {
        qWarning() << "The wallet that you have now switched to does not exist";
        return;
    }

    emit walletsModelChanged();
    requestWalletInfo(QStringList() << m_currentWallet.second << "true");
}

void DapModuleWallet::tryUpdateFee()
{
    s_serviceCtrl->requestToService("DapGetFeeCommand",QStringList()<<QString("all"));
}

void DapModuleWallet::getComission(QString network)
{
    s_serviceCtrl->requestToService("DapGetFeeCommand",QStringList()<<QString(network));
}

void DapModuleWallet::rcvFee(const QVariant &rcvData)
{
    auto feeDoc = QJsonDocument::fromJson(rcvData.toByteArray());

    QJsonObject feeObject = feeDoc.object();
    if(feeObject.isEmpty())
    {
        qDebug() << "[DapModuleWallet] The list of networks is empty";
        return;
    }

    for(const auto& networkName: feeObject.keys())
    {
        QJsonObject networkObj = feeObject[networkName].toObject();
        CommonWallet::FeeInfo tmpFeeInfo;
        if(!networkObj.contains("network_fee"))
        {
            qDebug() << "[DapModuleWallet] There is no information on the network commission";
        }
        else
        {
            QJsonObject netFeeObject = networkObj["network_fee"].toObject();
            QStringList netFeeKeys = netFeeObject.keys();
            for(const QString& itemName: netFeeKeys)
            {
                tmpFeeInfo.netFee.insert(itemName, netFeeObject[itemName].toString());
            }
        }

        if(!networkObj.contains("validator_fee"))
        {
            qDebug() << "[DapModuleWallet] There is no information on the validator commission";
        }
        else
        {
            QJsonObject netValidatorObject = networkObj["validator_fee"].toObject();
            QStringList validatorKeys = netValidatorObject.keys();
            for(const QString& itemName: validatorKeys)
            {
                tmpFeeInfo.validatorFee.insert(itemName, netValidatorObject[itemName].toString());
            }
        }
        m_feeInfo.insert(networkName, std::move(tmpFeeInfo));
    }
    emit feeInfoUpdated();
}

QVariantMap DapModuleWallet::getFee(QString network)
{
    QVariantMap mapResult;

    if(m_feeInfo.isEmpty())
    {
        mapResult.insert("error", (int)DAP_RCV_FEE_ERROR);
        mapResult.insert("fee_ticker","UNKNOWN");
        mapResult.insert("network_fee", "0.00");
        mapResult.insert("validator_fee", "0.00");
        return mapResult;
    }
    CommonWallet::FeeInfo& fee = m_feeInfo[network];
    mapResult.insert("error", (int)DAP_NO_ERROR);
    mapResult.insert("fee_ticker", fee.validatorFee["fee_ticker"]);
    mapResult.insert("network_fee", fee.netFee["fee_coins"]);
    mapResult.insert("validator_fee", fee.validatorFee["median_fee_coins"]);

    return mapResult;
}

QVariantMap DapModuleWallet::getAvailableBalance(QVariantMap data)
{
    QVariantMap mapResult;

    if(m_feeInfo.isEmpty())
    {
        mapResult.insert("error", (int)DAP_RCV_FEE_ERROR);
        mapResult.insert("availBalance", "0.00");
        return mapResult;
    }

    DapErrors err{DAP_NO_ERROR};
    QVariant availBalance{"0.00"};

    MathWorker mathWorker;
    StringWorker stringWorker;

    QString walletName = data.value("wallet_name").toString();
    QString network    = data.value("network").toString();
    QString sendTicker = data.value("send_ticker").toString();

    CommonWallet::FeeInfo& fee    = m_feeInfo[network];
    QString feeTicker  = fee.validatorFee["fee_ticker"];

    QVariantMap balances = getBalanceInfo(walletName, network, feeTicker, sendTicker);
    if(balances.isEmpty())
    {
        mapResult.insert("error", (int)DAP_NO_TOKENS);
        mapResult.insert("availBalance", "0.00");
        return mapResult;
    }

    QString balancePayFee = balances.value("balancePayFeeCoins").toString();
    QString balanceDatoshi = balances.value("balanceSendDatoshi").toString();

    QVariant commission = mathWorker.sumCoins(fee.netFee["fee_datoshi"],
                                              fee.validatorFee["median_fee_datoshi"],
                                              false);

    if(!stringWorker.testAmount(balancePayFee, commission.toString()))
    {
        mapResult.insert("error", (int)DAP_NOT_ENOUGHT_TOKENS_FOR_PAY_FEE);
        mapResult.insert("availBalance", balancePayFee);
        mapResult.insert("feeSum", commission.toString());

        return mapResult;
    }
    else
    {
        QVariant comissionDatoshi = mathWorker.coinsToBalance(commission);
        if(sendTicker == feeTicker)
            availBalance = mathWorker.subCoins(balanceDatoshi, comissionDatoshi, true);
        else
            availBalance = balanceDatoshi;
    }

    mapResult.insert("error", err);
    mapResult.insert("availBalance", availBalance);

    return mapResult;
}

QVariant DapModuleWallet::calculatePrecentAmount(QVariantMap data)
{
    MathWorker mathWorker;
    int percent = data.value("percent").toInt();
    QVariantMap balanceInfo = getAvailableBalance(data);

    if(balanceInfo.value("error").toInt() == (int)DAP_NO_ERROR)
    {
        QVariant availBalance = balanceInfo.value("availBalance");

        QVariant resAmount;

        switch (percent) {
        case 25:
            resAmount = mathWorker.divDatoshi(availBalance, "4", false); break;
        case 50:
            resAmount = mathWorker.divDatoshi(availBalance, "2", false); break;
        case 75:
        {
            QVariant val1 = mathWorker.divDatoshi(availBalance, "2", true);
            QVariant val2 = mathWorker.divDatoshi(availBalance, "4", true);
            resAmount = mathWorker.sumCoins(val1,val2,false);
            break;
        }
        case 100:
            resAmount = mathWorker.divDatoshi(availBalance, "1", false); break;
        default:
            break;
        }

        return resAmount;
    }

    return "0.00";
}

QVariantMap DapModuleWallet::approveTx(QVariantMap data)
{
    StringWorker stringWorker;
    MathWorker mathWorker;

    QString amount = data.value("amount").toString();
    QVariantMap balanceInfo = getAvailableBalance(data);
    QVariant availBalanceDatoshi = balanceInfo.value("availBalance");
    QString availBalance = mathWorker.balanceToCoins(availBalanceDatoshi).toString();

    DapErrors err = (DapErrors)balanceInfo.value("error").toInt();

    if(err == DAP_NO_ERROR)
    {
        if(!stringWorker.testAmount(availBalance, amount))
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
    MathWorker mathWorker;
    QString net = data.value("network").toString();
    QString feeDatoshi = m_feeInfo[net].validatorFee["median_fee_datoshi"];
    QString amount = mathWorker.coinsToBalance(data.value("amount")).toString();

    QStringList listData;
    listData.append(net);
    listData.append(data.value("wallet_from").toString());
    listData.append(data.value("wallet_to").toString());
    listData.append(data.value("send_ticker").toString());
    listData.append(amount);
    listData.append(feeDatoshi);

    createTx(listData);
}

QString DapModuleWallet::isCreateOrder(const QString& network, const QString& amount, const QString& tokenName)
{
    const auto& infoWallet = m_walletsInfo[m_currentWallet.second];
    if(!infoWallet.walletInfo.contains(network))
    {
        return "Error, network not found";
    }
    const auto& infoNetwork = infoWallet.walletInfo[network];

    const auto& feeInfo = m_feeInfo[network];

//    uint256_t arg1_256 = dap_uint256_scan_uninteger(arg1.toString().toStdString().data());
//    uint256_t arg2_256 = dap_uint256_scan_uninteger(arg2.toString().toStdString().data());
//    uint256_t accum = {};

//    SUM_256_256(arg1_256, arg2_256, &accum);
}

QVariantMap DapModuleWallet::getBalanceInfo(QString name, QString network, QString feeTicker, QString sendTicker)
{
    if(!m_walletsInfo.contains(name))
    {
        qWarning()<< "Wallet is not found: " << name;
        return QVariantMap();
    }

    const CommonWallet::WalletInfo& wallet = m_walletsInfo[name];

    if(!wallet.walletInfo.contains(network))
    {
        qWarning()<< "Network is not found: " << network << " in " << name;
        return QVariantMap();
    }

    const CommonWallet::WalletNetworkInfo& tokens = wallet.walletInfo[network];


    QString balancePayFeeDatoshi = "", balancePayFeeCoins = "";
    QString balanceDatoshi = "", balanceCoins = "";
    for(const auto& item: tokens.networkInfo)
    {
        if(item.tokenName == feeTicker)
        {
            balancePayFeeDatoshi = item.datoshi;
            balancePayFeeCoins   = item.value;
        }
        if(item.tokenName == sendTicker)
        {
            balanceDatoshi = item.datoshi;
            balanceCoins   = item.value;
        }
    }

    if(balancePayFeeDatoshi.isEmpty() || balancePayFeeCoins.isEmpty() ||
        balanceDatoshi.isEmpty()       || balanceCoins.isEmpty()       ||
        tokens.networkInfo.isEmpty())
    {
        qWarning()<< "No tokens"       << "\n"                  <<
            "network: "                << network               <<
            "feeToken: "               << feeTicker             <<
            "sendToken: "              << sendTicker            <<
            "walletName: "             << name                  <<
            "balancePayFeeDatoshi: "   << balancePayFeeDatoshi  <<
            "balancePayFeeCoins: "     << balancePayFeeCoins    <<
            "balanceDatoshi: "         << balanceDatoshi        <<
            "balanceCoins: "           << balanceCoins;
        return QVariantMap();
    }

    QVariantMap mapResult;
    mapResult.insert("balancePayFeeDatoshi", balancePayFeeDatoshi);
    mapResult.insert("balancePayFeeCoins"  , balancePayFeeCoins);
    mapResult.insert("balanceSendDatoshi"  , balanceDatoshi);
    mapResult.insert("balanceSendCoins"    , balanceCoins);

    return mapResult;
}

void DapModuleWallet::setCurrentTokenDEX(const QString& token)
{
    m_currentTokenDEX = token;
    updateBalanceDEX();
}

QString DapModuleWallet::getBalanceDEX(const QString& tokenName) const
{
    auto& data = m_DEXTokenModel->getData();
    for(auto& item: data)
    {
        if((item.network == m_tokenFilterModelDEX->getCurrentNetwork()
             || m_tokenFilterModelDEX->getCurrentNetwork().isEmpty()))
        {
            if((tokenName.isEmpty() && m_currentTokenDEX == item.tokenName)
                || (!tokenName.isEmpty() && tokenName == item.tokenName))
            {
                return item.value;
            }
        }
    }
    return tokenName.isEmpty() ? "" : "0.0";
}

void DapModuleWallet::updateBalanceDEX()
{
    emit currantBalanceDEXChanged();
}
