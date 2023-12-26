#include "DapModuleDex.h"
#include <QJsonObject>
#include <QQmlContext>

DapModuleDex::DapModuleDex(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_tokenPairsModel(new DapTokenPairModel())
    , m_ordersModel(new DapOrderHistoryModel())
    , m_proxyModel(new OrdersHistoryProxyModel())
    , m_tokenPairsProxyModel(new TokenPairsProxyModel())
    , m_netListModel(new DapStringListModel())
    , m_rightPairListModel(new DapStringListModel())
    , m_stockDataWorker(new StockDataWorker(m_modulesCtrl->s_appEngine->rootContext(), this))
    , m_allTakenPairsUpdateTimer(new QTimer)
    , m_curentTokenPairUpdateTimer(new QTimer)
    , m_ordersHistoryUpdateTimer(new QTimer)
    , m_ordersHistoryCash(new QByteArray)
{
    m_tokenPairsProxyModel->setSourceModel(m_tokenPairsModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelTokenPair", m_tokenPairsProxyModel);
    m_proxyModel->setSourceModel(m_ordersModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("ordersModel", m_proxyModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("dexNetModel", m_netListModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("dexRightPairModel", m_rightPairListModel);

    m_proxyModel->setIsHashCallback([this](const QString& hash) -> bool
    {
        QString walletName = m_modulesCtrl->getCurrentWalletName();
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
    delete m_ordersHistoryCash;
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
    connect(m_modulesCtrl, &DapModulesController::initDone, this, &DapModuleDex::startInitData);
    connect(m_allTakenPairsUpdateTimer, &QTimer::timeout, this, &DapModuleDex::requestTokenPairs);
    connect(m_curentTokenPairUpdateTimer, &QTimer::timeout, this, &DapModuleDex::requestCurrentTokenPairs);
    connect(m_ordersHistoryUpdateTimer, &QTimer::timeout, this, &DapModuleDex::requestHistoryOrders);
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
    requestTXList();
}

void DapModuleDex::respondTokenPairs(const QVariant &rcvData)
{
    m_isSandDapGetXchangeTokenPair = false;
    QJsonDocument document = QJsonDocument::fromJson(rcvData.toByteArray());
    if(document.isObject())
    {
        return;
    }
    QJsonArray tokenPairsArray = document.array();
    if(tokenPairsArray.isEmpty())
    {
        return;
    }
    m_tokensPair.clear();
    QStringList netList = {"All"};

    for(const QJsonValue& value: tokenPairsArray)
    {
        DEX::InfoTokenPair tmpPair;
        QJsonObject pairObject = value.toObject();
        tmpPair.token1  = pairObject["token1"].toString();
        tmpPair.token2  = pairObject["token2"].toString();
        tmpPair.rate    = pairObject["rate"].toString();
        tmpPair.network = pairObject["network"].toString();
        tmpPair.change  = pairObject["change"].toString();
        tmpPair.displayText = tmpPair.token1 + "/" + tmpPair.token2;

        if(!netList.contains(tmpPair.network))
        {
            netList.append(tmpPair.network);
        }

        m_tokensPair.append(std::move(tmpPair));
    }
    m_netListModel->setStringList(std::move(netList));
    m_tokenPairsModel->updateModel(m_tokensPair);

    if(m_currentPair.displayText.isEmpty() && !m_tokensPair.isEmpty())
    {
        setCurrentTokenPair(m_tokensPair.first().displayText, m_tokensPair.first().network);
    }
}

void DapModuleDex::respondCurrentTokenPairs(const QVariant &rcvData)
{
    m_isSandXchangeTokenPriceAverage = false;
    QJsonDocument document = QJsonDocument::fromJson(rcvData.toByteArray());
    if(!document.isObject())
    {
        return;
    }
    QJsonObject tokenPairObject = document.object();
    if(tokenPairObject.isEmpty())
    {
        return;
    }
    if(!tokenPairObject.contains("token1") ||
        !tokenPairObject.contains("token2") ||
        !tokenPairObject.contains("network") ||
        !tokenPairObject.contains("rate"))
    {
        qWarning() << "[respondCurrentTokenPairs] there have been changes in the response of the DapGetXchangeTokenPriceAverage command.";
        return;
    }
    QString pairName = tokenPairObject["token1"].toString() + "/" + tokenPairObject["token2"].toString();

    if(m_currentPair.displayText == pairName)
    {
        m_currentPair.rate = tokenPairObject["rate"].toString();
        m_currentPair.rate_double = m_currentPair.rate.toDouble();

        m_stockDataWorker->getCandleChartWorker()->setNewPrice(m_currentPair.rate);
        emit currentTokenPairInfoChanged();
    }
}

void DapModuleDex::respondTokenPairsHistory(const QVariant &rcvData)
{
    QJsonDocument document = QJsonDocument::fromJson(rcvData.toByteArray());
    if(!document.isObject())
    {
        return;
    }
    QJsonObject tokenHistoryObject = document.object();
    if(tokenHistoryObject.isEmpty())
    {
        return;
    }
    if(!tokenHistoryObject.contains("history") || !tokenHistoryObject.contains("token1")
        ||!tokenHistoryObject.contains("token2") ||!tokenHistoryObject.contains("network"))
    {
        qWarning() << "[respondHistoryTokenPairs] The signature of the story has probably changed";
        return;
    }
    if(m_currentPair.network != tokenHistoryObject["network"].toString()
            || m_currentPair.token1 != tokenHistoryObject["token1"].toString()
            || m_currentPair.token2 != tokenHistoryObject["token2"].toString())
    {
        qDebug() << "[respondHistoryTokenPairs] The current pair has changed. The story is rejected";
        return;
    }
    m_stockDataWorker->getCandleChartWorker()->setTokenPriceHistory(tokenHistoryObject["history"].toArray());
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
        m_txListCash = &data;
    }

    QJsonDocument document = QJsonDocument::fromJson(data);
    if(!document.isObject())
    {
        return;
    }

    QJsonObject object = document.object();
    QString walletName = object["walletName"].toString();
    QJsonArray list = object["orderList"].toArray();
    QHash<QString, DEX::TXList> result;
    for(const auto& item: list)
    {
        QJsonObject itemObject = item.toObject();
        QString type = itemObject["type"].toString();

        if(type == "proposed")
        {
            DEX::TXList newItem;
            newItem.type = type;
            newItem.status = itemObject["status"].toString();
            QString hash = itemObject["hash"].toString();
            if(!hash.isEmpty())
            {
                result.insert(hash,std::move(newItem));
            }

        }
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
    QByteArray data = rcvData.toByteArray();
    if(data == m_ordersHistoryCash)
    {
        return;
    }
    m_ordersHistoryCash = &data;
    //TODO: For optimization, it will be necessary to remove unnecessary models.
    setOrdersHistory(data);
    m_stockDataWorker->getOrderBookWorker()->setBookModel(std::move(data));

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
            tmpData.sellToken = order["sell_token"].toString();
            tmpData.buyToken = order["buy_token"].toString();
            tmpData.network = order["network"].toString();
            tmpData.amountDatoshi = order["amount_datoshi"].toString();
            tmpData.rate = order["rate"].toString();
            tmpData.time = order["created"].toString();
            tmpData.unixTime = order["created_unix"].toString();
            tmpData.filled = order["filled"].toString();
            tmpData.status = order["status"].toString();
            tmpData.side = tmpData.buyToken == m_currentPair.token1 ? "Buy" : "Sell";

            {
                QString tmpPair = tmpData.buyToken + "/" + tmpData.sellToken;
                if(!listPairs.contains(tmpPair))
                {
                    listPairs.append(std::move(tmpPair));
                }
            }

            m_ordersHistory.append(std::move(tmpData));
        }
    }
    m_rightPairListModel->setStringList(std::move(listPairs));

    std::sort(m_ordersHistory.begin(), m_ordersHistory.end(), [](const DEX::Order& left, const DEX::Order& right){
        return left.unixTime.toLongLong() > right.unixTime.toLongLong();
    });

    m_ordersModel->updateModel(m_ordersHistory);
    emit orderHistoryChanged();
}

QString DapModuleDex::invertValue(const QString& value)
{

}

void DapModuleDex::setCurrentTokenPair(const QString& namePair, const QString& network)
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
            return;
        }
    }

    m_stockDataWorker->getOrderBookWorker()->setTokenPair(m_currentPair, "");
    requestHistoryTokenPairs();
    m_stockDataWorker->getCandleChartWorker()->setTokenPriceHistory(QJsonArray());
    emit currentTokenPairChanged();
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
        m_isSandDapGetXchangeTokenPair = true;
        m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeTokenPair", QStringList() << "full_info" << "update");
    }
}

void DapModuleDex::requestCurrentTokenPairs()
{
    if(isCurrentPair())
    {
        if(!m_isSandXchangeTokenPriceAverage)
        {
            m_isSandXchangeTokenPriceAverage = true;
            m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeTokenPriceAverage",
                                                         QStringList() << m_currentPair.network << m_currentPair.token1 << m_currentPair.token2);
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
        m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeTokenPriceHistory",
                                                         QStringList() << m_currentPair.network << m_currentPair.token1 << m_currentPair.token2);
    }
    else
    {
        qWarning() << "The request cannot be executed, there is no data";
    }
}

void DapModuleDex::requestHistoryOrders()
{
    m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeOrdersList", QStringList()<< m_currentPair.token1 << m_currentPair.token2);
}

void DapModuleDex::requestTXList(const QString& timeFrom, const QString& timeTo)
{
    m_modulesCtrl->getServiceController()->requestToService("DapGetXchangeTxList", QStringList() << m_modulesCtrl->getCurrentWalletName() << timeFrom << timeTo);
}

