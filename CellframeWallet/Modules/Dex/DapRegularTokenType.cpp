#include "DapRegularTokenType.h"

DapRegularTokenType::DapRegularTokenType(QList<DEX::InfoTokenPair> &pairsInfo, QObject *parent)
    : QObject{parent}
    , m_tokensPair(pairsInfo)
{

}

void DapRegularTokenType::setSellToken(const QString& value)
{
    m_sellToken = value;
    emit sellTokenChanged();
}

void DapRegularTokenType::setBuyToken(const QString& value)
{
    m_buyToken = value;
    emit buyTokenChanged();
}

void DapRegularTokenType::setNetwork(const QString& value)
{
    m_network = value;
    emit networkChanged();
}

void DapRegularTokenType::setBuyTokenCount(const QString& value)
{
    m_buyTokenCount = value;
    emit buyTokenCountChanged();
}

void DapRegularTokenType::setSellTokenCount(const QString& value)
{
    m_sellTokenCount = value;
    emit sellTokenCountChanged();
}

void DapRegularTokenType::currentPairChanged(const DEX::InfoTokenPair& pair)
{

}
