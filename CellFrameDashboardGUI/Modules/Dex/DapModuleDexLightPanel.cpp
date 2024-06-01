#include "DapModuleDexLightPanel.h"

#include <QJsonValue>

DapModuleDexLightPanel::DapModuleDexLightPanel(DapModulesController *parent)
    : DapModuleDex(parent)
    , m_tokensModel(new DapTokensModel())
    , m_tokenProxyModel(new TokensProxyModel())
    , m_regTokenPairsModel(new DapTokenPairModel())
{
    m_tokenProxyModel->setSourceModel(m_tokensModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelTokensList", m_tokenProxyModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelTokenPairRegular", m_regTokenPairsModel);
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
    for(const auto& item: m_tokensPair)
    {
        if(item.network != network) continue;

        if(sellTokenName == item.token1)
        {
            tmpDataSell.insert(item.token2, invertValue(item.rate));
        }
        else if(sellTokenName == item.token2)
        {
            tmpDataSell.insert(item.token1, item.rate);
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
        buyToken.rate = tmpDataSell[token];
        buyToken.displayText = token;
        buyToken.type = "buy";
        modelData.append(buyToken);
    }
    for(const auto& token: tmpDataBuy.keys())
    {
        DEX::InfoTokenPairLight sellToken;
        sellToken.token = buyTokenName;
        sellToken.rate = tmpDataBuy[token];
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
    regularTokensUpdate();
    updateRegularModels();
    m_proxyModel->setCurrentTokenPair(m_currentPair.token1, m_currentPair.token2);
}

void DapModuleDexLightPanel::regularTokensUpdate()
{

}

void DapModuleDexLightPanel::setLightCurrentTokenPair(const DEX::InfoTokenPair& pair)
{

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
    DapModuleDex::setNetworkFilterText(network);

    if(isRegularTypePanel() && !network.isEmpty())
    {
        for(const auto& item: m_tokensPair)
        {
            if(item.network == network)
            {
                setCurrentTokenPair(item.displayText, network);
            }
        }
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

        auto listPair = namePair.split("/");
        if(m_currentPair.token1 != listPair[0])
        {
            setIsSwapTokens(true);
            QString tmpToken = m_currentPair.token1;
            m_currentPair.token1 = m_currentPair.token2;
            m_currentPair.token2 = tmpToken;
            m_currentPair.rate = invertValue(m_currentPair.rate);
        }
        else
        {
            return DapModuleDex::setCurrentTokenPairVariable(namePair, network);
        }
    }
    return true;
}
