#include "DapWallet.h"

DapWallet::DapWallet(const QString &asName)
    : m_name(asName)
{

}

void DapWallet::addNetwork(const QString &asNetwork)
{
    m_networks.append(asNetwork);
}

QList<QString> &DapWallet::getNetworks()
{
    return m_networks;
}

void DapWallet::setAddress(const QString& aiAddress, const QString &asNetwork)
{
    m_iAddress.insert(asNetwork, aiAddress);
}

QString DapWallet::getAddress(const QString &asNetwork)
{
    return m_iAddress.find(asNetwork).value();
}

void DapWallet::addToken(const DapWalletToken &aToken, const QString &asNetwork)
{
    m_aTokens.insert(asNetwork, aToken);
}

QList<DapWalletToken *> DapWallet::getTokens(const QString &asNetwork)
{
    QList<DapWalletToken *> tokens;
    auto begin = m_aTokens.begin();
    auto end = m_aTokens.end();
    for(;begin != end; ++begin)
    {
        if(begin.key() == asNetwork)
        {
            tokens.append(&begin.value());
        }
    }
    return tokens;
}
