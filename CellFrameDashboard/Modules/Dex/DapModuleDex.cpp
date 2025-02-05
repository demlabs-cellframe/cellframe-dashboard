#include "DapModuleDex.h"
#include <QJsonObject>
#include <QQmlContext>
#include <QRegularExpression>
#include "../DapTypes/DapCoin.h"
#include "DapDataManagerController.h"

DapModuleDex::DapModuleDex(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_tokenPairsModel(new DapTokenPairModel())
    , m_ordersModel(new DapOrderHistoryModel())
    , m_proxyModel(new OrdersHistoryProxyModel())
    , m_tokenPairsProxyModel(new TokenPairsProxyModel())
    , m_netListModel(new DapStringListModel())
    , m_rightPairListModel(new DapStringListModel())
    , m_stockDataWorker(new StockDataWorker(m_modulesCtrl->getAppEngine()->rootContext(), this))
    , m_DEXTokenModel(new DapTokensWalletModel())
    , m_tokenFilterModelDEX(new TokenProxyModel())
    , m_allTakenPairsUpdateTimer(new QTimer())
    , m_curentTokenPairUpdateTimer(new QTimer())
    , m_ordersHistoryUpdateTimer(new QTimer())
{
    m_tokenPairsProxyModel->setSourceModel(m_tokenPairsModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelTokenPair", m_tokenPairsProxyModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("ordersModelNonFilter", m_ordersModel);
    m_proxyModel->setSourceModel(m_ordersModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("ordersModel", m_proxyModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("dexNetModel", m_netListModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("dexRightPairModel", m_rightPairListModel);
    m_tokenFilterModelDEX->setSourceModel(m_DEXTokenModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("dexTokenModel", m_tokenFilterModelDEX);


    m_proxyModel->setIsHashCallback([this](const QString& hash) -> bool
    {
        QString walletName = m_modulesCtrl->getManagerController()->getCurrentWallet().second;
        if(!m_txListsforWallet.contains(walletName))
        {
            return false;
        }

        if(m_txListsforWallet[walletName].contains(hash))
        {
            return true;
        }

        return false;
    });
    onInit();
}

DapModuleDex::~DapModuleDex()
{
    delete m_tokenPairsModel;
    delete m_ordersModel;
    delete m_proxyModel;
    delete m_netListModel;
    delete m_stockDataWorker;
    delete m_allTakenPairsUpdateTimer;
    delete m_curentTokenPairUpdateTimer;
    delete m_ordersHistoryUpdateTimer;
}

void DapModuleDex::slotUpdateData()
{
    //TODO:reset and update data
}

void DapModuleDex::onInit()
{
    const auto* service = m_modulesCtrl->getServiceController();
    if(service)
    {
        connect(service, &DapServiceController::rcvXchangeTokenPair, this, &DapModuleDex::respondTokenPairs, Qt::QueuedConnection);
        connect(service, &DapServiceController::rcvXchangeTokenPriceAverage, this, &DapModuleDex::respondCurrentTokenPairs, Qt::QueuedConnection);
        connect(service, &DapServiceController::rcvXchangeTokenPriceHistory, this, &DapModuleDex::respondTokenPairsHistory, Qt::QueuedConnection);
        connect(service, &DapServiceController::rcvXchangeOrderList, this, &DapModuleDex::respondOrdersHistory, Qt::QueuedConnection);
        connect(service, &DapServiceController::rcvXchangeTxList, this, &DapModuleDex::respondTxList, Qt::QueuedConnection);
    }

    auto* walletsManager = getWalletManager();

    connect(walletsManager, &DapWalletsManagerBase::walletInfoChanged, this, &DapModuleDex::walletInfoChangedSlot);
    connect(walletsManager, &DapWalletsManagerBase::currentWalletChanged, this, &DapModuleDex::currentWalletChangedSlot);

    // connect(m_modulesCtrl, &DapModulesController::initDone, this, &DapModuleDex::startInitData);
    connect(m_allTakenPairsUpdateTimer, &QTimer::timeout, this, &DapModuleDex::requestTokenPairs);
    connect(m_ordersHistoryUpdateTimer, &QTimer::timeout, this, &DapModuleDex::requestTXList);
    connect(m_curentTokenPairUpdateTimer, &QTimer::timeout, this, &DapModuleDex::requestCurrentTokenPairs);
    connect(m_ordersHistoryUpdateTimer, &QTimer::timeout, this, &DapModuleDex::requestHistoryOrders);
    connect(this, &DapModuleDex::txListChanged, m_proxyModel, &OrdersHistoryProxyModel::tryUpdateFilter);
    connect(this, &DapAbstractModule::statusProcessingChanged, [this]
    {
        if(m_statusProcessing)
        {
            m_allTakenPairsUpdateTimer->start(ALL_TOKEN_UPDATE_TIMEOUT);
            m_ordersHistoryUpdateTimer->start(ORDERS_HISTORY_UPDATE_TIMEOUT);
            m_curentTokenPairUpdateTimer->start(CURRENT_TOKEN_UPDATE_TIMEOUT);
        }
        else
        {
            m_allTakenPairsUpdateTimer->stop();
            m_ordersHistoryUpdateTimer->stop();
            m_curentTokenPairUpdateTimer->stop();
        }
    });
}

void DapModuleDex::currentWalletChangedSlot()
{
    updateBalance();
    updateDexTokenModel();
}

void DapModuleDex::walletInfoChangedSlot(const QString &walletName, const QString &networkName)
{
    Q_UNUSED(walletName)
    if(networkName == m_currentNetwork)
    {
        updateBalance();
    }
    updateDexTokenModel();
}

bool DapModuleDex::isCurrentPair()
{
    if(m_currentPair.displayText.isEmpty() || m_currentPair.network.isEmpty())
    {
        return false;
    }
    return true;
}

void DapModuleDex::startInitData()
{
    requestTokenPairs();
}

void DapModuleDex::respondTokenPairs(const QVariant &rcvData)
{
    m_isSandDapGetXchangeTokenPair = false;
    QByteArray rcvResult = convertJsonResult(rcvData.toByteArray());
    if(m_tokenPairsCash != rcvResult)
    {
        m_tokenPairsCash = rcvResult;
    }
    else
    {
        return;
    }

    QJsonArray tokenPairsArray = QJsonDocument::fromJson(rcvResult).array();
    if(tokenPairsArray.isEmpty())
    {
        return;
    }

    bool isFirstUpdate = m_tokensPair.isEmpty();

    m_tokensPair.clear();
    QStringList netList = {};

    for(const QJsonValue& value: tokenPairsArray)
    {
        DEX::InfoTokenPair tmpPair;
        QJsonObject pairObject = value.toObject();

        tmpPair.token1  = pairObject[Dap::KeysParam::TOKEN_1].toString();
        tmpPair.token2  = pairObject[Dap::KeysParam::TOKEN_2].toString();
        tmpPair.rate    = "-";
        tmpPair.network = pairObject["network"].toString();
        tmpPair.displayText = tmpPair.token1 + "/" + tmpPair.token2;

        if(tmpPair.token1 == "BUSD"     ||
           tmpPair.token2 == "BUSD"     ||
           tmpPair.token1.contains("m") ||
           tmpPair.token2.contains("m"))
        {
            continue;
        }

        if(!netList.contains(tmpPair.network))
        {
            netList.append(tmpPair.network);
        }

        m_tokensPair.append(std::move(tmpPair));
    }
    m_netListModel->setStringList(std::move(netList));
    if(m_currentPair.displayText.isEmpty() && !m_tokensPair.isEmpty())
    {
        setCurrentTokenPair(m_tokensPair.first().displayText, m_tokensPair.first().network);
    }
    updateTokenModels();

    if(!m_ordersHistoryCash.isEmpty() && isFirstUpdate)
    {
        setOrdersHistory(m_ordersHistoryCash);
    }

    if(isFirstUpdate)
        DapModuleDex::setNetworkFilterText(netList.first());

    emit dexNetListChanged();
}

void DapModuleDex::updateTokenModels()
{
    m_tokenPairsModel->updateModel(m_tokensPair);
}

void DapModuleDex::respondCurrentTokenPairs(const QVariant &rcvData)
{
    m_isSandXchangeTokenPriceAverage = false;
    auto resultObject = QJsonDocument::fromJson(rcvData.toByteArray()).object();

    QJsonObject tokenPairObject = resultObject["result"].toObject();
    if(tokenPairObject.isEmpty())
    {
        return;
    }
    if(!tokenPairObject.contains(Dap::KeysParam::TOKEN_1) ||
        !tokenPairObject.contains(Dap::KeysParam::TOKEN_2) ||
        !tokenPairObject.contains("network") ||
        !tokenPairObject.contains("rate"))
    {
        qWarning() << "[respondCurrentTokenPairs] there have been changes in the response of the DapGetXchangeTokenPriceAverage command.";
        return;
    }
    QString pairName = tokenPairObject[Dap::KeysParam::TOKEN_1].toString() + "/" + tokenPairObject[Dap::KeysParam::TOKEN_2].toString();

    if(m_currentPair.displayText == pairName)
    {
        m_currentPair.rate = tokenPairObject["rate"].toString();
        m_currentPair.rate_double = m_currentPair.rate.toDouble();
        QString time = tokenPairObject["time"].toString();

        m_stockDataWorker->getCandleChartWorker()->respondCurrentTokenPairs({{time, m_currentPair.rate}});
        m_currentPair.isDataReady = true;
        currentRateFirstTimeSlot();
        emit isReadyDataPairChanged();
        emit currentTokenPairInfoChanged();
    }
}

void DapModuleDex::respondTokenPairsHistory(const QVariant &rcvData)
{
    auto resultObject = QJsonDocument::fromJson(rcvData.toByteArray()).object();
    QJsonObject tokenHistoryObject = resultObject["result"].toObject();
    if(tokenHistoryObject.isEmpty())
    {
        return;
    }
    if(!tokenHistoryObject.contains("history") || !tokenHistoryObject.contains(Dap::KeysParam::TOKEN_1)
        ||!tokenHistoryObject.contains(Dap::KeysParam::TOKEN_2) ||!tokenHistoryObject.contains("network"))
    {
        qWarning() << "[respondHistoryTokenPairs] The signature of the story has probably changed";
        return;
    }
    if(m_currentPair.network != tokenHistoryObject["network"].toString()
            || m_currentPair.token1 != tokenHistoryObject[Dap::KeysParam::TOKEN_1].toString()
            || m_currentPair.token2 != tokenHistoryObject[Dap::KeysParam::TOKEN_2].toString())
    {
        qDebug() << "[respondHistoryTokenPairs] The current pair has changed. The story is rejected";
        return;
    }
    m_stockDataWorker->getCandleChartWorker()->respondTokenPairsHistory(tokenHistoryObject["history"].toArray());
}

void DapModuleDex::respondTxList(const QVariant &rcvData)
{
    QByteArray data = rcvData.toByteArray();
    if(data == m_txListCash)
    {
        return;
    }
    else
    {
        m_txListCash = data;
    }

    auto resultObject = QJsonDocument::fromJson(data).object();

    QJsonObject object = resultObject["result"].toObject();
    QString walletName = object["walletName"].toString();
    QJsonArray list = object["orderList"].toArray();
    QSet<QString> result;
    for(const auto& item: list)
    {
        QJsonObject itemObject = item.toObject();
        QString hash = itemObject["hash"].toString();
        result.insert(hash);
    }
    if(m_txListsforWallet.contains(walletName))
    {
        m_txListsforWallet[walletName].clear();
    }
    m_txListsforWallet.insert(walletName, result);
    emit txListChanged();
}

void DapModuleDex::respondOrdersHistory(const QVariant &rcvData)
{
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());
    if(byteArrayData == m_ordersHistoryCash)
    {
        return;
    }
    m_ordersHistoryCash = byteArrayData;
    //TODO: For optimization, it will be necessary to remove unnecessary models.
    setOrdersHistory(byteArrayData);
    m_stockDataWorker->getOrderBookWorker()->setCurrentRate(m_currentPair.rate);
    m_stockDataWorker->getOrderBookWorker()->setBookModel(std::move(byteArrayData));

}

void DapModuleDex::setOrdersHistory(const QByteArray& data)
{
    QJsonDocument document = QJsonDocument::fromJson(data);
    if(!document.isObject())
    {
        return;
    }
    m_ordersHistory.clear();
    auto object = document.object();
    auto keys = object.keys();
    QStringList listPairs = {"All pairs"};
    for(const auto& netName: keys)
    {
        for(const auto& orderValue: object[netName].toArray())
        {
            auto order = orderValue.toObject();
            DEX::Order tmpData;
            tmpData.amount = order["amount"].toString();
            tmpData.hash = order["order_hash"].toString();

            tmpData.amountDatoshi = order["amount_datoshi"].toString();

            tmpData.time = order["created"].toString();
            tmpData.unixTime = order["created_unix"].toString();
            tmpData.filled = order["filled"].toString();
            tmpData.status = order["status"].toString();

            QString sellToken = order["sell_token"].toString();
            QString buyToken = order["buy_token"].toString();
            QString network = order["network"].toString();
            QString amountToken = order["amount_token"].toString();
            QString rate = order["rate"].toString();
            tmpData.sellTokenOrigin = sellToken;
            tmpData.buyTokenOrigin = buyToken;
            tmpData.rateOrigin = rate;

            tmpData.network = network;

            tmpData.sellToken = sellToken;
            tmpData.buyToken = buyToken;
            if(isPair(buyToken, sellToken, network) == DapModuleDex::PairFoundResultType::IS_MIRROR_PAIR)
            {
                tmpData.rate = invertValue(rate);
                tmpData.side = "Sell";
            }
            else
            {
                listPairs.append(tmpData.buyToken + "/" + tmpData.sellToken);
                tmpData.rate = rate;
                tmpData.side = "Buy";
            }


            m_ordersHistory.append(std::move(tmpData));
        }
    }
    m_rightPairListModel->setStringList(std::move(listPairs));

    std::sort(m_ordersHistory.begin(), m_ordersHistory.end(), [](const DEX::Order& left, const DEX::Order& right){
        Dap::Coin first = left.rate;
        Dap::Coin second = right.rate;
        return first > second;
    });

    m_ordersModel->updateModel(m_ordersHistory);
    emit orderHistoryChanged();
}

DapModuleDex::PairFoundResultType DapModuleDex::isPair(const QString& token1, const QString& token2, const QString& network)
{
    if(m_tokensPair.isEmpty())
    {
        return DapModuleDex::PairFoundResultType::BASE_IS_EMPTY;
    }

    for(const auto& pair: qAsConst(m_tokensPair))
    {
        if(pair.network != network)
        {
            continue;
        }
        if(pair.token1 == token1 && pair.token2 == token2)
        {
            return DapModuleDex::PairFoundResultType::IS_PAIR;
        }
        if(pair.token1 == token2 && pair.token2 == token1)
        {
            return DapModuleDex::PairFoundResultType::IS_MIRROR_PAIR;
        }
    }

    qDebug() << QString("isPair() The pair %1 is not found").arg(token1 + "/" + token2);
    return DapModuleDex::PairFoundResultType::NO_PAIR;
}

QString DapModuleDex::invertValue()
{
    if(m_currantPriceForCreate.isEmpty() || m_currantPriceForCreate == "0.0" || m_currantPriceForCreate == "0")
    {
        return "0.0";
    }
    if(!m_currantPriceForCreate.contains('.'))
    {
        m_currantPriceForCreate.append(".0");
    }

    Dap::Coin one = QString("1.0");
    Dap::Coin price = m_currantPriceForCreate;
    QString result = (one/price).toCoinsString();
    return result;
}

QString DapModuleDex::invertValue(const QString& price)
{
    if(price.isEmpty() || price == "0.0" || price == "0")
    {
        return "0.0";
    }
    QString resPrice(price);
    if(!price.contains('.'))
    {
        resPrice.append(".0");
    }
    else
    {
        auto list = price.split(".");
        if(list[0].isEmpty())
        {
            resPrice = "0." + list[1];
        }
        else if(list[1].isEmpty())
        {
            resPrice = list[0] + ".0";
        }
    }

    Dap::Coin oneVal = QString("1.0");
    Dap::Coin priceVal = resPrice;
    return roundCoins((oneVal/priceVal).toCoinsString());
}

QString DapModuleDex::roundCoins(const QString& str)
{
    QString result;

    auto match = QRegularExpression(R"((\d+\.\d*?)0{3,}\d{1,17}$)").match(str);
    if(match.hasMatch())
    {
        result = match.captured(1);
    }

    if(result.isEmpty() )
    {
        auto match9 = QRegularExpression(R"(\.(9*(9|8){1}){2,17}$)").match(str);
        if(match9.hasMatch())
        {
            auto list = str.split('.');
            qint64 val = list[0].toInt();
            val++;
            result = QString::number(val) + ".0";
            return result;
        }
    }

    if(result.isEmpty() || result == "0.")
    {
        return str;
    }

    if(result[result.size()-1] == '.')
    {
        result.append('0');
        return result;
    }
    return result;
}

QString DapModuleDex::multCoins(const QString& a, const QString& b)
{
    if(a.isEmpty() || a == "0.0" || a == "0")
    {
        return "0.0";
    }
    QString resA(a);
    if(!resA.contains('.'))
    {
        resA.append(".0");
    }
    else if(resA[resA.size()-1] == '.')
    {
        resA.append("0");
    }

    if(b.isEmpty() || b == "0.0" || b == "0")
    {
        return "0.0";
    }
    QString resB(b);
    if(!resB.contains('.'))
    {
        resB.append(".0");
    }
    else if(resB[resB.size()-1] == '.')
    {
        resB.append("0");
    }

    Dap::Coin oneVal = resA;
    Dap::Coin twoVal = resB;
    return roundCoins((oneVal * twoVal).toCoinsString());
}

QString DapModuleDex::divCoins(const QString& a, const QString& b)
{
    if(a.isEmpty() || a == "0.0" || a == "0")
    {
        return "0.0";
    }
    QString resA(a);
    if(!resA.contains('.'))
    {
        resA.append(".0");
    }
    else if(resA[resA.size()-1] == '.')
    {
        resA.append("0");
    }

    if(b.isEmpty() || b == "0.0" || b == "0")
    {
        return "0.0";
    }

    QString resB(b);
    if(!resB.contains('.'))
    {
        resB.append(".0");
    }
    else if(resB[resB.size()-1] == '.')
    {
        resB.append("0");
    }
    Dap::Coin oneVal = resA;
    Dap::Coin twoVal = resB;
    return roundCoins((oneVal / twoVal).toCoinsString());
}

QString DapModuleDex::minusCoins(const QString& a, const QString& b)
{
    if(a.isEmpty() || a == "0.0" || a == "0")
    {
        return "0.0";
    }
    QString resA(a);
    if(!resA.contains('.'))
    {
        resA.append(".0");
    }
    else if(resA[resA.size()-1] == '.')
    {
        resA.append("0");
    }

    if(b.isEmpty() || b == "0.0" || b == "0")
    {
        return a;
    }
    QString resB(b);
    if(!resB.contains('.'))
    {
        resB.append(".0");
    }
    else if(resB[resB.size()-1] == '.')
    {
        resB.append("0");
    }
    Dap::Coin oneVal = resA;
    Dap::Coin twoVal = resB;
    return roundCoins((oneVal - twoVal).toCoinsString());
}

int DapModuleDex::diffNumber(const QString& a, const QString& b)
{
    // 2 - bigger
    // 1 - equally
    // 0 - less
    if(a.isEmpty() || a == "0.0" || a == "0")
    {
        return 0;
    }
    QString resA(a);
    if(!resA.contains('.'))
    {
        resA.append(".0");
    }
    else if(resA[resA.size()-1] == '.')
    {
        resA.append("0");
    }

    if(b.isEmpty() || b == "0.0" || b == "0")
    {
        return 0;
    }
    QString resB(b);
    if(!resB.contains('.'))
    {
        resB.append(".0");
    }
    else if(resB[resB.size()-1] == '.')
    {
        resB.append("0");
    }

    Dap::Coin oneVal = resA;
    Dap::Coin twoVal = resB;
    if(oneVal > twoVal) return 2;
    else if(oneVal == twoVal) return 1;
    else return 0;
}

QString DapModuleDex::tryCreateOrder(bool isSell, const QString& price, const QString& amount, const QString& fee)
{
    auto checkValue = [](const QString& str) -> QString
    {
        if(str.isEmpty())
        {
            return str;
        }
        QString result = str;
        if(!str.contains('.'))
        {
            result.append(".0");
        }
        return result;
    };

    if(m_ordersModel)
    {
        QString tokenSell = isSell ? m_currentPair.token1 : m_currentPair.token2;
        QString tokenBuy = !isSell ? m_currentPair.token1 : m_currentPair.token2;
        QString walletName = m_modulesCtrl->getManagerController()->getCurrentWallet().second;
        QString amountOrder = checkValue(amount);
        QString feeOrder = checkValue(fee);
        if(feeOrder == "0.0")
        {
            qWarning() << "[DapModuleDex] The validator's commission is zero. Valur: " << fee;
            feeOrder = "0.05";
        }
        QString priceOrder = checkValue(price);

        auto& model = m_ordersModel->getListModel();


        auto suitableOrder = std::find_if(model.begin(), model.end(), [&](const DapOrderHistoryModel::Item& item){
            if(item.status == "CLOSED")
            {
                return false;
            }
            if(item.tokenSell != tokenBuy || item.tokenBuy != tokenSell || item.network != m_currentPair.network)
            {
                return false;
            }
            if(item.price != priceOrder)
            {
                return false;
            }

            Dap::Coin itemDatoshi= item.amount;
            Dap::Coin currantDatoshi= amountOrder;
            if(itemDatoshi >= currantDatoshi)
            {
                qInfo() << "HASH: " << item.hash;
                return true;
            }

            return false;
        });

        Dap::Coin amount256 = amountOrder;
        QString amountDatoshi = amount256.toDatoshiString();
        Dap::Coin feeInt = feeOrder;
        QString feeDatoshi = feeInt.toDatoshiString();
        if(isSell)
        {
            priceOrder = invertValue(priceOrder);
        }

        if(suitableOrder == model.end())
        {
            requestOrderCreate(QStringList() << m_currentPair.network << tokenSell << tokenBuy
                                             << walletName << amountDatoshi << priceOrder << feeDatoshi);
        }
        else
        {
            requestOrderPurchase(QStringList() << suitableOrder->hash << m_currentPair.network
                                               << walletName << amountDatoshi << feeDatoshi << tokenSell);
        }

    }
    return "OK";
}

QString DapModuleDex::tryExecuteOrder(const QString& hash, const QString& amount, const QString& fee, const QString& tokenName )
{
    if(hash.isEmpty() || amount.isEmpty() || fee.isEmpty())
    {
        return "There is not enough data";
    }

    auto checkValue = [](const QString& str) -> QString
    {
        if(str.isEmpty())
        {
            return str;
        }
        QString result = str;
        if(!str.contains('.'))
        {
            result.append(".0");
        }
        return result;
    };

    QString walletName = m_modulesCtrl->getManagerController()->getCurrentWallet().second;
    QString amountOrder = checkValue(amount);
    QString feeOrder = checkValue(fee);

    Dap::Coin feeInt = feeOrder;
    QString feeDatoshi = feeInt.toDatoshiString();

    Dap::Coin amount256 = amountOrder;
    QString amountDatoshi = amount256.toDatoshiString();

    requestOrderPurchase(QStringList() << hash << m_currentPair.network
                                       << walletName << amountDatoshi << feeDatoshi << tokenName);

    return "OK";
}

void DapModuleDex::setNetworkFilterText(const QString &network)
{
    if(!network.isEmpty())
    {
        m_networkFilter = network;
        m_tokenPairsProxyModel->setNetworkFilter(network);
        emit networkFilterChanged(m_networkFilter);
    }
}

void DapModuleDex::setStepChart(const int &index)
{
    m_stepChartIndex = index;
    emit stepChartChanged(m_stepChartIndex);
}

void DapModuleDex::setCurrentTokenPair(const QString& namePair, const QString& network)
{
    m_currentPair.reset();
    emit isReadyDataPairChanged();
    emit currentTokenPairInfoChanged();

    if(!setCurrentTokenPairVariable(namePair, network)) return;

    workersUpdate();
    emit currentTokenPairChanged();
}

bool DapModuleDex::setCurrentTokenPairVariable(const QString& namePair, const QString &network)
{
    if(namePair.isEmpty())
    {
        m_currentPair = DEX::InfoTokenPair();
    }
    else
    {
        auto tmpPair = std::find_if(m_tokensPair.begin(), m_tokensPair.end(), [namePair, network](const DEX::InfoTokenPair item)
                                    {
                                        return namePair == item.displayText && network == item.network;
                                    });

        if(tmpPair != m_tokensPair.end())
        {
            m_currentPair = *tmpPair ;
        }
        else
        {
            qWarning() << "Not found pair: " << namePair;
            return false;
        }
    }
    return true;
}

void DapModuleDex::workersUpdate()
{
    m_stockDataWorker->getOrderBookWorker()->setTokenPair(m_currentPair);
    m_stockDataWorker->getOrderBookWorker()->setCurrentRate(m_currentPair.rate);
    m_stockDataWorker->getOrderBookWorker()->setBookModel(m_ordersHistoryCash);
    requestHistoryTokenPairs();
    m_stockDataWorker->getCandleChartWorker()->respondTokenPairsHistory(QJsonArray());
    m_proxyModel->setPairAndNetworkOrderFilter(m_currentPair.displayText, m_currentPair.network);
}

void DapModuleDex::setStatusProcessing(bool status)
{
    if(status)
    {
        requestHistoryTokenPairs();
        requestTokenPairs();
        requestCurrentTokenPairs();
        requestHistoryOrders();
        m_allTakenPairsUpdateTimer->start(ALL_TOKEN_UPDATE_TIMEOUT);
        m_curentTokenPairUpdateTimer->start(CURRENT_TOKEN_UPDATE_TIMEOUT);
        m_ordersHistoryUpdateTimer->start(ORDERS_HISTORY_UPDATE_TIMEOUT);
    }
    else
    {
        m_allTakenPairsUpdateTimer->stop();
        m_curentTokenPairUpdateTimer->stop();
        m_ordersHistoryUpdateTimer->stop();
    }

    DapAbstractModule::setStatusProcessing(status);
}

void DapModuleDex::requestTokenPairs()
{
    if(!m_isSandDapGetXchangeTokenPair)
    {
        auto& walletInfo = getWalletManager()->getWalletsInfo().value(getWalletManager()->getCurrentWallet().second);
        QStringList netList = walletInfo.walletInfo.keys();

        QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
        QVariantMap request = {
             {Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade}
            ,{Dap::KeysParam::NETWORK_LIST, netList}
        };

        m_isSandDapGetXchangeTokenPair = true;
        m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeTokenPair", request);
    }
}

void DapModuleDex::requestCurrentTokenPairs()
{
    if(isCurrentPair())
    {
        if(!m_isSandXchangeTokenPriceAverage)
        {
            QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
            QVariantMap request = {
                {Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade}
                ,{Dap::KeysParam::NETWORK_NAME, m_currentPair.network}
                ,{Dap::KeysParam::TOKEN_1, m_currentPair.token1}
                ,{Dap::KeysParam::TOKEN_2, m_currentPair.token2}
            };

            m_isSandXchangeTokenPriceAverage = true;
            m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeTokenPriceAverage", request);
        }
    }
    else
    {
        qWarning() << "The request cannot be executed, there is no data";
    }
}

void DapModuleDex::tokenPairModelCountChanged(int count)
{
    if(count == 0)
    {
        setCurrentTokenPair("", "");
    }
    else
    {
        auto itemsList = m_tokenPairsProxyModel->getCurrantList();

        if(itemsList.isEmpty())
        {
            setCurrentTokenPair("", "");
            return;
        }

        for(auto& item: itemsList)
        {
            if(item.first == m_currentPair.displayText && item.second == m_currentPair.network)
            {
                return;
            }
        }
        setCurrentTokenPair(itemsList[0].first, itemsList[0].second);
    }
}

void DapModuleDex::requestHistoryTokenPairs()
{
    if(isCurrentPair())
    {
        QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
        QVariantMap request = {
            {Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade}
            ,{Dap::KeysParam::NETWORK_NAME, m_currentPair.network}
            ,{Dap::KeysParam::TOKEN_1, m_currentPair.token1}
            ,{Dap::KeysParam::TOKEN_2, m_currentPair.token2}
        };
        m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeTokenPriceHistory", request);
    }
    else
    {
        qWarning() << "The request cannot be executed, there is no data";
    }
}

bool DapModuleDex::isValidValue(const QString& value)
{
    return value.contains(REGULAR_VALID_VALUE);
}

void DapModuleDex::requestHistoryOrders()
{
    auto& walletInfo = getWalletManager()->getWalletsInfo().value(getWalletManager()->getCurrentWallet().second);
    QStringList netList = walletInfo.walletInfo.keys();
    QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    QVariantMap request = {
        {Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade}
        ,{Dap::KeysParam::NETWORK_LIST, netList}
    };
    m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeOrdersList", request);
}

void DapModuleDex::requestTXList()
{
    auto& walletInfo = getWalletManager()->getWalletsInfo().value(getWalletManager()->getCurrentWallet().second);
    auto netList = walletInfo.walletInfo.keys();
    QVariantMap networkAddresses;
    for(const auto& net: netList)
    {
        QString address = walletInfo.walletInfo[net].address;
        if(!address.isEmpty())
        {
            networkAddresses.insert(net, address);
        }
    }
    if(networkAddresses.isEmpty())
    {
        qDebug() << "[DapModuleDex] No networks or wallet addresses were found.";
        return;
    }
    QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    QVariantMap request = {
                             {Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade}
                            ,{Dap::KeysParam::WALLET_ADDRESSES, networkAddresses}
                            ,{Dap::KeysParam::WALLET_NAME, getWalletManager()->getCurrentWallet().second}
                            };
    m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeTxList", request);
}

void DapModuleDex::requestOrderPurchase(const QStringList& params)
{
    m_modulesCtrl->getServiceController()->requestToService("DapXchangeOrderPurchase", params);
}

void DapModuleDex::requestOrderCreate(const QStringList& params)
{
    m_modulesCtrl->getServiceController()->requestToService("DapXchangeOrderCreate", params);
}

void DapModuleDex::requestOrderDelete(const QString& network, const QString& hash, const QString& fee, const QString& tokenName, const QString& amount)
{
    Dap::Coin feeInt = fee;
    QString feeDatoshi = feeInt.toDatoshiString();
    m_modulesCtrl->getServiceController()->requestToService("DapXchangeOrderRemove",
                                            QStringList() << network << hash <<
                                            m_modulesCtrl->getManagerController()->getCurrentWallet().second << feeDatoshi << tokenName << amount);
}

void DapModuleDex::currentRateFirstTimeSlot()
{
    for(auto& item: m_tokensPair)
    {
        if(item.token1 != m_currentPair.token1 || item.token2 != m_currentPair.token2)
        {
            continue;
        }

        if(item.rate == "-")
        {
            emit currentRateFirstTime();
        }
        item.rate = m_currentPair.rate;
        item.rate_double = m_currentPair.rate_double;
        return;
    }
}

void DapModuleDex::setCurrentRateFromModel()
{
    for(auto& item: m_tokensPair)
    {
        if(item.token1 != m_currentPair.token1 || item.token2 != m_currentPair.token2)
        {
            continue;
        }
        m_currentPair.rate = item.rate;
        m_currentPair.rate_double = item.rate_double;
    }
}

void DapModuleDex::updateBalance()
{
    emit currantBalanceChanged();
}

const QPair<int,QString>& DapModuleDex::getCurrentWallet() const
{
    auto* walletsManager = getWalletManager();
    return walletsManager->getCurrentWallet();
}

DapWalletsManagerBase* DapModuleDex::getWalletManager() const
{
    Q_ASSERT_X(m_modulesCtrl, "DapModuleWallet", "ModuleController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController(), "DapModuleWallet", "ManagerController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController()->getWalletManager(), "DapModuleWallet", "WalletManager not found");
    return m_modulesCtrl->getManagerController()->getWalletManager();
}

QString DapModuleDex::getBalance(const QString& tokenName) const
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

void DapModuleDex::setCurrentToken(const QString& token)
{
    m_currentTokenDEX = token;
    updateBalance();
}

QVariantMap DapModuleDex::isCreateOrder(const QString& network, const QString& amount, const QString& tokenName)
{
    /// result message
    /// 0 - OK
    /// 1 - Error, network not found
    /// 2 - Error. It is not possible to pay the Internet fee
    /// 3 - Error. It is not possible to pay the Validate fee
    /// 4 - Error. It is not possible to pay
    ///

    auto resultMap = [&](int number, const QString& message = "",  const QString& firstValue = "", const QString& secondValue = "") -> QVariantMap
    {
        QVariantMap mapResult;
        mapResult.insert("code", number);
        mapResult.insert("firstValue", firstValue);
        mapResult.insert("secondValue", secondValue);
        mapResult.insert("message", message);

        return mapResult;
    };

    auto checkValue = [](const QString& str) -> QString
    {
        if(str.isEmpty())
        {
            return str;
        }
        QString result = str;
        if(!str.contains('.'))
        {
            result.append(".0");
        }
        return result;
    };

    QString normalAmount = checkValue(amount);

    const auto& infoWallet = getWalletManager()->getWalletsInfo().value(getCurrentWallet().second);
    if(!infoWallet.walletInfo.contains(network))
    {
        return resultMap(1, tr("Error, network not found"));
    }
    const auto& infoNetwork = infoWallet.walletInfo[network];

    auto getCoins = [&infoNetwork](const QString& ticker) -> QString
    {
        auto itemIt = std::find_if(infoNetwork.networkInfo.begin(), infoNetwork.networkInfo.end(), [&ticker](const CommonWallet::WalletTokensInfo& item){
            return item.ticker == ticker;
        });

        return itemIt != infoNetwork.networkInfo.end() ? itemIt->value : QString();
    };

    const auto& feeInfo = m_modulesCtrl->getManagerController()->getFee(network);

    QString netFeeTicker;
    QString netFee;
    if(feeInfo.netFee.contains("fee_ticker") && feeInfo.netFee.contains("fee_coins"))
    {
        netFeeTicker = feeInfo.netFee["fee_ticker"];
        netFee = feeInfo.netFee["fee_coins"];
    }

    Dap::Coin result = normalAmount;


    if(!netFee.isEmpty() && netFee != "0.0")
    {
        Dap::Coin net = netFee;
        if(netFeeTicker == tokenName)
        {
            result = net + result;
        }
        else
        {
            QString netValue = getCoins(netFeeTicker);
            if(!netValue.isEmpty())
            {
                Dap::Coin value = netValue;
                if(value < net)
                {
                    return resultMap(2, tr("Error. It is not possible to pay the Internet fee"), value.toCoinsString(), net.toCoinsString());
                }
            }
        }
    }

    QString valFeeTicker;
    QString valFee;
    if(feeInfo.validatorFee.contains("fee_ticker") && feeInfo.validatorFee.contains("median_fee_coins"))
    {
        valFeeTicker = feeInfo.validatorFee["fee_ticker"];
        valFee = feeInfo.validatorFee["median_fee_coins"];
    }

    if(!valFee.isEmpty() && valFee != "0.0")
    {
        Dap::Coin fee = valFee;

        if(valFeeTicker == tokenName)
        {
            result = fee + result;
        }
        else
        {
            QString netValue = getCoins(valFeeTicker);
            if(!netValue.isEmpty())
            {
                Dap::Coin value = netValue;
                if(value < fee)
                {
                    return resultMap(3, tr("Error. It is not possible to pay the Validate fee"), value.toCoinsString(), fee.toCoinsString());
                }
            }
        }
    }

    QString currentValue = getCoins(tokenName);

    Dap::Coin value = currentValue;

    qDebug() << "value = " << value.toCoinsString() << " result = " << result.toCoinsString();
    if(value < result)
    {
        return resultMap(4, tr("Error. It is not possible to pay"), value.toCoinsString(), result.toCoinsString());
    }

    return resultMap(0, "OK");
}

void DapModuleDex::updateDexTokenModel()
{
    QList<CommonWallet::WalletTokensInfo> tokenInfoConteiner;
    auto& walletsInfo = getWalletManager()->getWalletsInfo();
    if(walletsInfo.contains(getCurrentWallet().second))
    {
        for(const auto& networkItem: walletsInfo[getCurrentWallet().second].walletInfo)
        {
            tokenInfoConteiner.append(networkItem.networkInfo);
        }
    }

    m_DEXTokenModel->updateAllToken(tokenInfoConteiner);
    m_tokenFilterModelDEX->updateCount();
}
