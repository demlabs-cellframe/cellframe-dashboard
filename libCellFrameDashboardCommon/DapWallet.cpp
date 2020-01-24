#include "DapWallet.h"

DapWallet::DapWallet(const QString &asName, QObject * parent)
    : QObject(parent), m_sName(asName)
{

}

DapWallet::DapWallet(const DapWallet &aToken)
    : QObject(parent()), m_sName(aToken.m_sName), m_aNetworks(aToken.m_aNetworks),
       m_aAddress(aToken.m_aAddress), m_aTokens(aToken.m_aTokens)
{

}

DapWallet &DapWallet::operator=(const DapWallet &aToken)
{
    QObject(parent());
    m_sName = aToken.m_sName;
    m_aNetworks = aToken.m_aNetworks;
    m_aAddress = aToken.m_aAddress;
    m_aTokens = aToken.m_aTokens;
    return (*this);
}

QString DapWallet::getName() const
{
    return m_sName;
}

void DapWallet::setName(const QString &sName)
{
    m_sName = sName;

    emit nameChanged(m_sName);
}

void DapWallet::addNetwork(const QString &asNetwork)
{
    m_aNetworks.append(asNetwork);
}

QList<QString> &DapWallet::getNetworks()
{
    return m_aNetworks;
}

void DapWallet::setAddress(const QString& aiAddress, const QString &asNetwork)
{
    m_aAddress.insert(asNetwork, aiAddress);
}

QString DapWallet::getAddress(const QString &asNetwork)
{
    return m_aAddress.find(asNetwork).value();
}

void DapWallet::addToken(DapWalletToken aToken)
{
    m_aTokens.append(aToken);
}

QList<DapWalletToken *> DapWallet::getTokens(const QString &asNetwork)
{
    QList<DapWalletToken *> tokens;
    auto begin = m_aTokens.begin();
    auto end = m_aTokens.end();
    for(;begin != end; ++begin)
    {
        if(begin->getNetwork() == asNetwork)
        {
            tokens.append(&(*begin));
        }
    }
    return tokens;
}

QObject* DapWallet::fromVariant(const QVariant &aWallet)
{
    DapWallet * wallet = new DapWallet();
    QByteArray data = QByteArray::fromStdString(aWallet.toString().toStdString());
    QDataStream in(&data, QIODevice::ReadOnly);
    in >> *wallet;
    return wallet;
}

QDataStream& operator << (QDataStream& aOut, const DapWallet& aWallet)
{
    aOut << aWallet.m_sName
         << aWallet.m_aNetworks
         << aWallet.m_aAddress
         << aWallet.m_aTokens;
    return aOut;
}

QDataStream& operator >> (QDataStream& aOut, DapWallet& aWallet)
{
    aOut >> aWallet.m_sName
         >> aWallet.m_aNetworks
         >> aWallet.m_aAddress
         >> aWallet.m_aTokens;
    return aOut;
}
