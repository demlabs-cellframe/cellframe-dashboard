#include "DapModuleWallet.h"
#include <QStringList>
#include "DapWalletsManagerBase.h"
#include "DapDataManagerController.h"
#include "../DapTypes/DapCoin.h"
#include "CommandKeys.h"
#include <QStringList>

DapModuleWallet::DapModuleWallet(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_tokenModel(new DapTokensWalletModel())
    , m_walletModel(new DapListWalletsModel())
    , m_infoWallet (new DapInfoWalletModel())
    , m_walletHashManager(new WalletHashManager())
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletModelList", m_walletModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletModelInfo", m_infoWallet);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletTokensModel", m_tokenModel);

    auto* walletsManager = getWalletManager();

    connect(walletsManager, &DapWalletsManagerBase::walletListChanged, this, &DapModuleWallet::walletListChangedSlot);
    connect(walletsManager, &DapWalletsManagerBase::walletInfoChanged, this, &DapModuleWallet::walletInfoChangedSlot);
    connect(walletsManager, &DapWalletsManagerBase::currentWalletChanged, this, &DapModuleWallet::currentWalletChanged);

    connect(m_modulesCtrl, &DapModulesController::initDone, [this] ()
    {
        m_walletHashManager->setContext(m_modulesCtrl->getAppEngine()->rootContext());
        m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletHashManager", m_walletHashManager);

        initConnect();
    });
}

DapModuleWallet::~DapModuleWallet()
{
    disconnect();

    delete m_walletHashManager;
    delete m_walletModel;
    delete m_tokenModel;
}

void DapModuleWallet::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::walletRemoved, this, &DapModuleWallet::rcvRemoveWallet, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::transactionCreated, this, &DapModuleWallet::rcvCreateTx, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletCreated, this, &DapModuleWallet::rcvCreateWallet, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory, Qt::QueuedConnection);
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
    if(DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::REMOTE)
    {
        s_serviceCtrl->requestToService("DapCreateTxCommand", args);
    }
    else
    {
        s_serviceCtrl->requestToService("DapCreateTransactionCommand", args);
    }
}

void DapModuleWallet::requestWalletTokenInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletTokenInfoCommand", args);
}

void DapModuleWallet::createWallet(QStringList args)
{
    s_serviceCtrl->requestToService("DapAddWalletCommand", args);
}

void DapModuleWallet::removeWallet(QStringList args)
{
    s_serviceCtrl->requestToService("DapRemoveWalletCommand", args);
}

void DapModuleWallet::createPassword(QStringList args)
{
    s_serviceCtrl->requestToService("DapCreatePassForWallet", args);
}

void DapModuleWallet::activateOrDeactivateWallet(const QString& walletName,
                                                 const QString& target, const QString& pass,
                                                 const QString& ttl)
{
    QStringList argList = QStringList() << walletName << target;
    if(!pass.isEmpty())
    {
        argList << pass;
    }
    if(!ttl.isEmpty())
    {
        argList << ttl;
    }
    s_serviceCtrl->requestToService("DapWalletActivateOrDeactivateCommand", argList);
}

void DapModuleWallet::rcvCreateTx(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    QJsonObject resultObj = replyObj["result"].toObject();

    emit sigTxCreate(resultObj);
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
                    if(tokenObject.contains("availableDatoshi"))
                    {
                        token.availableDatoshi = tokenObject["availableDatoshi"].toString();
                    }
                    if(tokenObject.contains("availableCoins"))
                    {
                        token.availableCoins = tokenObject["availableCoins"].toString();
                    }                    
                    networkInfo.networkInfo.append(token);
                }
            }

            wallet.walletInfo.insert(networkInfo.network, networkInfo);
        }
    }
    return wallet;
}

QVariantMap DapModuleWallet::getFee(QString network)
{
    QVariantMap mapResult;

    if(m_modulesCtrl->getManagerController()->isFeeEmpty())
    {
        mapResult.insert("error", (int)DAP_RCV_FEE_ERROR);
        mapResult.insert("fee_ticker","UNKNOWN");
        mapResult.insert("network_fee", "0.00");
        mapResult.insert("validator_fee", "0.05");
        return mapResult;
    }

    const CommonWallet::FeeInfo& fee = m_modulesCtrl->getManagerController()->getFee(network);
    mapResult.insert("error", (int)DAP_NO_ERROR);
    mapResult.insert("fee_ticker", fee.validatorFee.value("fee_ticker"));
    mapResult.insert("network_fee", fee.netFee.value("fee_coins"));
    mapResult.insert("validator_fee", fee.validatorFee.value("median_fee_coins"));

    return mapResult;
}

QVariantMap DapModuleWallet::getAvailableBalance(QVariantMap data)
{
    QVariantMap mapResult;

    if(m_modulesCtrl->getManagerController()->isFeeEmpty())
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

    const CommonWallet::FeeInfo& fee = m_modulesCtrl->getManagerController()->getFee(network);
    QString feeTicker  = fee.validatorFee.value("fee_ticker");

    QVariantMap balances = getBalanceInfo(walletName, network, feeTicker, sendTicker);
    if(balances.isEmpty())
    {
        mapResult.insert("error", (int)DAP_NO_TOKENS);
        mapResult.insert("availBalance", "0.00");
        return mapResult;
    }

    QString balancePayFee = balances.value("balancePayFeeCoins").toString();
    QString balanceDatoshi = balances.value("balanceSendDatoshi").toString();

    QVariant commission = mathWorker.sumCoins(fee.netFee.value("fee_datoshi"),
                                              fee.validatorFee.value("median_fee_datoshi"),
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

    MathWorker mathWorker;

    QString net           = data.value("network").toString();
    QString nativeToken   = m_modulesCtrl->getManagerController()->getFee(net).validatorFee.value("fee_ticker");
    QString feeDatoshi    = m_modulesCtrl->getManagerController()->getFee(net).validatorFee.value("median_fee_datoshi");
    QString fee           = m_modulesCtrl->getManagerController()->getFee(net).validatorFee.value("median_fee_coins");
    QString feeNet        = m_modulesCtrl->getManagerController()->getFee(net).netFee.value("fee_coins");
    QString feeNetDatoshi = m_modulesCtrl->getManagerController()->getFee(net).netFee.value("fee_datoshi");
    QString feeNetAddr    = m_modulesCtrl->getManagerController()->getFee(net).netFee.value("fee_addr");
    QString amount        = mathWorker.coinsToBalance(data.value("amount")).toString();

    if(DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::REMOTE)
    {
        QJsonObject txData;
        txData.insert(Dap::KeysParam::NETWORK_NAME,    net);
        txData.insert(Dap::KeysParam::FEE_DATOSHI,     feeDatoshi);
        txData.insert(Dap::KeysParam::FEE,             fee);
        txData.insert(Dap::KeysParam::FEE_NET,         feeNet);
        txData.insert(Dap::KeysParam::FEE_NET_DATOSHI, feeNetDatoshi);
        txData.insert(Dap::KeysParam::FEE_NET_ADDR,    feeNetAddr);
        txData.insert(Dap::KeysParam::AMOUNT_DATOSHI,  amount);
        txData.insert(Dap::KeysParam::TOKEN_NATIVE,    nativeToken);
        txData.insert(Dap::KeysParam::AMOUNT,          data.value("amount").toString());
        txData.insert(Dap::KeysParam::WALLET_NAME,     data.value("wallet_from").toString());
        txData.insert(Dap::KeysParam::WALLET_PATH,     data.value("wallet_from_path").toString());
        txData.insert(Dap::KeysParam::WALLET_PASSWORD, data.value("wallet_from_password").toString());
        txData.insert(Dap::KeysParam::ADDR_FROM,       data.value("wallet_from_addr").toString());
        txData.insert(Dap::KeysParam::ADDR_TO,         data.value("wallet_to").toString());
        txData.insert(Dap::KeysParam::TOKEN_TICKER,    data.value("send_ticker").toString());

        QJsonDocument docData(txData);

        QVariantMap mapData;
        mapData.insert(Dap::CommandParamKeys::NODE_MODE_KEY, Dap::NodeMode::REMOTE_MODE);
        mapData.insert(Dap::CommandParamKeys::COMMAND_KEY,   "DapCreateTxCommand");
        mapData.insert(Dap::CommandParamKeys::DATA_KEY,      docData.toJson());
        mapData.insert(Dap::KeysParam::TYPE_TX,              "Default");

        createTx(mapData);
    }
    else
    {
        QStringList listData;
        listData.append(net);
        listData.append(data.value("wallet_from").toString());
        listData.append(data.value("wallet_to").toString());
        listData.append(data.value("send_ticker").toString());
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

QVariantMap DapModuleWallet::getBalanceInfo(QString name, QString network, QString feeTicker, QString sendTicker)
{
    auto& walletsInfo = getWalletsInfo();
    if(!walletsInfo.contains(name))
    {
        qWarning()<< "Wallet is not found: " << name;
        return QVariantMap();
    }

    const CommonWallet::WalletInfo& wallet = walletsInfo[name];

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

QString DapModuleWallet::getTokenBalance(const QString& network, const QString& tokenName, const QString& walletName) const
{
    auto& walletsInfo = getWalletsInfo();
    QString name = walletName.isEmpty() ? getCurrentWallet().second : walletName;
    if(!walletsInfo.contains(name))
    {
        return QString("0.0");
    }
    const auto& info = walletsInfo[name];
    if(!info.walletInfo.contains(network))
    {
        return QString("0.0");
    }

    for(const auto& tokenInfo: info.walletInfo[network].networkInfo)
    {
        if(tokenInfo.ticker == tokenName)
        {
            return tokenInfo.value;
        }
    }
    return QString("0.0");
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

DapWalletsManagerBase* DapModuleWallet::getWalletManager() const
{
    Q_ASSERT_X(m_modulesCtrl, "DapModuleWallet", "ModuleController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController(), "DapModuleWallet", "ManagerController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController()->getWalletManager(), "DapModuleWallet", "WalletManager not found");
    return m_modulesCtrl->getManagerController()->getWalletManager();
}
