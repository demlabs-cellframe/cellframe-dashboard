#include "DapModuleDexLightPanel.h"

DapModuleDexLightPanel::DapModuleDexLightPanel(DapModulesController *parent)
    : DapModuleDex(parent)
    , m_tokensModel(new DapTokensModel())
    , m_tokenProxyModel(new TokensProxyModel())
{
    m_tokenProxyModel->setSourceModel(m_tokensModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelTokensList", m_tokenProxyModel);
}

DapModuleDexLightPanel::~DapModuleDexLightPanel()
{
    delete m_tokensModel;
    delete m_tokenProxyModel;
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
}

void DapModuleDexLightPanel::workersUpdate()
{
    DapModuleDex::workersUpdate();
    m_currentPair.displayText = m_currentPair.token1 + "/" + m_currentPair.token2;
    regularTokensUpdate();
    updateRegularModels();
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
}

bool DapModuleDexLightPanel::isRegularTypeMode()
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
