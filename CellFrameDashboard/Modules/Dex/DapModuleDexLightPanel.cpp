#include "DapModuleDexLightPanel.h"
#include "DapDataManagerController.h"
#include <QJsonValue>

DapModuleDexLightPanel::DapModuleDexLightPanel(DapModulesController *parent)
    : DapModuleDex(parent)
    , m_tokensModel(new DapTokensModel())
    , m_tokenProxyModel(new TokensProxyModel())
    , m_regTokenPairsModel(new DapTokenPairModel())
{
    m_tokenProxyModel->setSourceModel(m_tokensModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelTokensList", m_tokenProxyModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelTokenPairRegular", m_regTokenPairsModel);
    m_proxyModel->setIsRegularType(isRegularTypePanel());
}

DapModuleDexLightPanel::~DapModuleDexLightPanel()
{
    delete m_tokensModel;
    delete m_tokenProxyModel;
    delete m_regTokenPairsModel;
}

void DapModuleDexLightPanel::updateTokenModels()
{
    DapModuleDex::updateTokenModels();
    updateRegularModels();
}

void DapModuleDexLightPanel::updateRegularModels()
{
    QList<DEX::InfoTokenPairLight> modelData;
    QString buyTokenName = m_currentPair.token2;
    QString sellTokenName = m_currentPair.token1;
    QString network = m_currentPair.network;
    QMap<QString, QString> tmpDataSell, tmpDataBuy;
    for(const auto& item: qAsConst(m_tokensPair))
    {
        if(item.network != network) continue;

        if(sellTokenName == item.token1)
        {
            tmpDataSell.insert(item.token2, item.rate);
        }
        else if(sellTokenName == item.token2)
        {
            tmpDataSell.insert(item.token1, invertValue(item.rate));
        }

        if(buyTokenName == item.token1)
        {
            tmpDataBuy.insert(item.token2, item.rate);
        }
        else if(buyTokenName == item.token2)
        {
            tmpDataBuy.insert(item.token1, invertValue(item.rate));
        }
    }
    tmpDataSell.insert(sellTokenName, "1.0");
    tmpDataBuy.insert(buyTokenName, "1.0");
    for(const auto& token: tmpDataSell.keys())
    {
        DEX::InfoTokenPairLight buyToken;
        buyToken.token = sellTokenName;
        buyToken.rate = tmpDataBuy[token];
        buyToken.displayText = token;
        buyToken.type = "buy";
        modelData.append(buyToken);
    }
    for(const auto& token: tmpDataBuy.keys())
    {
        DEX::InfoTokenPairLight sellToken;
        sellToken.token = buyTokenName;
        sellToken.rate = tmpDataSell[token];
        sellToken.displayText = token;
        sellToken.type = "sell";
        modelData.append(sellToken);
    }

    m_tokensModel->updateModel(std::move(modelData));

    DEX::InfoTokenPair firstPair;
    firstPair.token1  = m_currentPair.token1;
    firstPair.token2  = m_currentPair.token2;
    firstPair.rate    = m_currentPair.rate;
    firstPair.network = m_currentPair.network;
    firstPair.change  = m_currentPair.change;
    firstPair.displayText = firstPair.token1 + "/" + firstPair.token2;

    DEX::InfoTokenPair secondPair;
    secondPair.token1  = m_currentPair.token2;
    secondPair.token2  = m_currentPair.token1;
    secondPair.rate    = invertValue(m_currentPair.rate);
    secondPair.network = m_currentPair.network;
    secondPair.change  = m_currentPair.change;
    secondPair.displayText = secondPair.token1 + "/" + secondPair.token2;

    QList<DEX::InfoTokenPair> m_regularTokensPair;
    m_regularTokensPair.append(std::move(firstPair));
    m_regularTokensPair.append(std::move(secondPair));
    m_regTokenPairsModel->updateModel(m_regularTokensPair);
}

void DapModuleDexLightPanel::workersUpdate()
{
    DapModuleDex::workersUpdate();
    m_currentPair.displayText = m_currentPair.token1 + "/" + m_currentPair.token2;
    
    m_proxyModel->setCurrentTokenPair(m_currentPair.token1, m_currentPair.token2);
    updateRegularModels();
}

void DapModuleDexLightPanel::setCurrentTokenSell(const QString& token)
{
    if(m_currentPair.token1 == token)
    {
        return;
    }
    else if(m_currentPair.token2 == token)
    {
        m_currentPair.token2 = m_currentPair.token1;
        m_currentPair.token1 = token;
    }
    else
    {
        m_currentPair.token1 = token;
        setCurrentRateFromModel();
    }
    workersUpdate();
    emit currentTokenPairChanged();
}

void DapModuleDexLightPanel::setCurrentTokenBuy(const QString& token)
{
    if(m_currentPair.token2 == token)
    {
        return;
    }
    else if(m_currentPair.token1 == token)
    {
        m_currentPair.token1 = m_currentPair.token2;
        m_currentPair.token2 = token;
        m_currentPair.rate = invertValue(m_currentPair.rate);
    }
    else
    {
        m_currentPair.token2 = token;
        setCurrentRateFromModel();
    }
    workersUpdate();
    emit currentTokenPairChanged();
}

void DapModuleDexLightPanel::setTypeListToken(const QString& type)
{
    m_typeListToken = type;
    m_tokenProxyModel->setParmsModel(m_typeListToken);
}

void DapModuleDexLightPanel::setTypePanel(const QString& type)
{
    m_typePanel = type;

    if(!isRegularTypePanel())
    {
        for(const auto& item: qAsConst(m_tokensPair))
        {
            if(item.network == m_currentPair.network)
            {
                if(item.token1 == m_currentPair.token2 && item.token2 == m_currentPair.token1)
                {
                    setCurrentTokenPair(item.displayText, m_currentPair.network);
                    break;
                }
            }
        }
    }

    m_proxyModel->setIsRegularType(isRegularTypePanel());
    emit typePanelChanged();
}

bool DapModuleDexLightPanel::isRegularTypePanel()
{
    return m_typePanel == "regular";
}

void DapModuleDexLightPanel::setOrderType(const QString &type)
{
    m_orderType = type;
    emit orderTypeChanged();
}

void DapModuleDexLightPanel::setSellValueField(const QString& value)
{
    m_sellValueField = value;
    emit sellValueFieldChanged();
}

void DapModuleDexLightPanel::setIsSwapTokens(bool value)
{
    m_isSwapTokens = value;
    emit isSwapTokensChanged();
}

void DapModuleDexLightPanel::swapTokens()
{
    setIsSwapTokens(true);
    QString tmpToken = m_currentPair.token1;
    m_currentPair.token1 = m_currentPair.token2;
    m_currentPair.token2 = tmpToken;
    m_currentPair.rate = invertValue(m_currentPair.rate);
    workersUpdate();
    emit currentTokenPairChanged();
}

void DapModuleDexLightPanel::setNetworkFilterText(const QString &network)
{
    if(network == m_currentPair.network)
    {
        return;
    }

    if(isRegularTypePanel())
    {
        if(network.isEmpty())
        {
            return;
        }
        for(const auto& item: qAsConst(m_tokensPair))
        {
            if(item.network == network)
            {
                setCurrentTokenPair(item.displayText, network);
                break;
            }
        }
    }
    else
    {
        DapModuleDex::setNetworkFilterText(network);
    }
}

bool DapModuleDexLightPanel::setCurrentTokenPairVariable(const QString& namePair, const QString &network)
{
    if(!isRegularTypePanel()) return DapModuleDex::setCurrentTokenPairVariable(namePair, network);

    if(namePair.isEmpty() || network.isEmpty())
    {
        m_currentPair = DEX::InfoTokenPair();
    }
    else
    {
        if(m_currentPair.displayText.isEmpty()
            || m_currentPair.displayText  == "/") return DapModuleDex::setCurrentTokenPairVariable(namePair, network);

        if(m_currentPair.network != network)
        {
            return DapModuleDex::setCurrentTokenPairVariable(namePair, network);
        }
        auto listPair = namePair.split("/");
        if(m_currentPair.token1 == listPair[1] && m_currentPair.token2 == listPair[0])
        {
            QString tmpToken = m_currentPair.token1;
            m_currentPair.token1 = m_currentPair.token2;
            m_currentPair.token2 = tmpToken;
            m_currentPair.rate = invertValue(m_currentPair.rate);
            m_currentPair.network = network;
        }
        else
        {
            return DapModuleDex::setCurrentTokenPairVariable(namePair, network);
        }
    }
    return true;
}

QString DapModuleDexLightPanel::tryCreateOrderRegular(const QString& price, const QString& amount, const QString& fee)
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
        QString tokenSell = m_currentPair.token1;
        QString tokenBuy = m_currentPair.token2;
        QString walletName = m_modulesCtrl->getManagerController()->getCurrentWallet().second;
        QString amountOrder = checkValue(amount);
        QString feeOrder = checkValue(fee);
        QString priceOrder = checkValue(price);

        auto& model = m_ordersModel->getListModel();


        auto suitableOrder = std::find_if(model.begin(), model.end(), [&](const DapOrderHistoryModel::Item& item){
            if(item.status == "CLOSED")
            {
                return false;
            }
            if(item.tokenSellOrigin != tokenBuy || item.tokenBuyOrigin != tokenSell || item.network != m_currentPair.network)
            {
                return false;
            }
            if(item.rateOrigin != priceOrder)
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

QString DapModuleDexLightPanel::getDeltaRatePercent(const QString& rateValue)
{
    auto testRateList = rateValue.split('.');
    if(testRateList.size() != 2) return "0.0";
    if(testRateList[0].isEmpty()) return "0.0";
    if(testRateList[1].isEmpty()) return "0.0";
    if(m_currentPair.rate.isEmpty() || m_currentPair.rate == "0.0")
        return "0.0";

    Dap::Coin currentRate = m_currentPair.rate.isEmpty() ? QString("0.0") : m_currentPair.rate;
    Dap::Coin rate = rateValue;
    Dap::Coin hundred = QString("100.0");
    Dap::Coin twenty = QString("20.0");
    QString percent = "+0.0";

    auto getRealPercent = [](const QString& value) ->QString
    {
        auto list = value.split('.');
        return QString("%1").arg(list[0]);
    };

    if(rate > currentRate)
    {
        Dap::Coin delta = rate - currentRate;

        Dap::Coin percentCoin = currentRate.toCoinsString() == "0.0" ? hundred : (delta / currentRate) * hundred;
        auto str = percentCoin.toCoinsString();
        if(percentCoin > twenty)
        {
            percent = "-" + getRealPercent(percentCoin.toCoinsString());
        }
    }
    else
    {
        Dap::Coin delta = currentRate - rate;
        Dap::Coin percentCoin = delta / currentRate;
        percentCoin = percentCoin * hundred;
        auto str = percentCoin.toCoinsString();
        if(percentCoin > twenty)
        {
            percent = "+" + getRealPercent(percentCoin.toCoinsString());
        }
    }
    return percent;
}
