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

void DapRegularTokenType::setSellNetwork(const QString& value)
{
    m_sellNetwork = value;
    emit sellNetworkChanged();
}

void DapRegularTokenType::setBuyNetwork(const QString& value)
{
    m_buyNetwork = value;
    emit buyNetworkChanged();
}

void DapRegularTokenType::currentPairChanged(const DEX::InfoTokenPair& pair)
{

}
