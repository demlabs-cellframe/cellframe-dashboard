#include "DapWallet.h"

DapWallet::DapWallet(QObject * parent)
    : QObject(parent)
{

}

DapWallet::DapWallet(const DapWallet &aWallet)
    : m_sName(aWallet.m_sName), m_dBalance(aWallet.m_dBalance), m_sIcon(aWallet.m_sIcon), m_sAddress(aWallet.m_sAddress),
      m_aNetworks(aWallet.m_aNetworks), m_aAddresses(aWallet.m_aAddresses), m_aTokens(aWallet.m_aTokens)
{

}

DapWallet &DapWallet::operator=(const DapWallet &aWallet)
{
    m_sName = aWallet.m_sName;
    m_dBalance = aWallet.m_dBalance;
    m_sIcon = aWallet.m_sIcon;
    m_sAddress = aWallet.m_sAddress;
    m_aNetworks = aWallet.m_aNetworks;
    m_aAddresses = aWallet.m_aAddresses;
    m_aTokens = aWallet.m_aTokens;
    return (*this);
}

QString DapWallet::getName() const
{
    return m_sName;
}

void DapWallet::setName(const QString &asName)
{
    m_sName = asName;

    emit nameChanged(m_sName);
}

double DapWallet::getBalance() const
{
    return m_dBalance;
}

void DapWallet::setBalance(const double& adBalance)
{
    m_dBalance = adBalance;

    emit balanceChanged(m_dBalance);
}

QString DapWallet::getIcon() const
{
    return m_sIcon;
}

void DapWallet::setIcon(const QString &sIcon)
{
    m_sIcon = sIcon;

    emit iconChanged(m_sIcon);
}

void DapWallet::addNetwork(const QString &asNetwork)
{
    m_aNetworks.append(asNetwork);

    emit networkAdded(asNetwork);
    emit networksChanged(m_aNetworks);
}

QStringList DapWallet::getNetworks() const
{
    return m_aNetworks;
}

void DapWallet::setAddress(const QString &asNetwork)
{
    m_sAddress = m_aAddresses.find(asNetwork).value();

    emit addressChanged(m_sAddress);
}

QString DapWallet::getAddress() const
{
    return m_sAddress;
}

void DapWallet::addAddress(const QString& aiAddress, const QString &asNetwork)
{
    m_aAddresses.insert(asNetwork, aiAddress);
}

QString DapWallet::findAddress(const QString &asNetwork) const
{
    if(asNetwork.isNull() || asNetwork.isNull())
        return QString();

    QString s=m_aAddresses.find(asNetwork).value();
    return m_aAddresses.find(asNetwork) != m_aAddresses.end() ? m_aAddresses.find(asNetwork).value() : QString();
}

QMap<QString, QString> DapWallet::getAddresses() const
{
    return m_aAddresses;
}

void DapWallet::addToken(DapWalletToken *asToken)
{
    m_aTokens.append(asToken);

    emit tokenAdded(*asToken);

    QList<QObject*> tokens;
    auto begin = m_aTokens.begin();
    auto end = m_aTokens.end();
    for(;begin != end; ++begin)
    {
        tokens.append(*begin);
    }
    emit tokensChanged(tokens);
}

QList<DapWalletToken*> DapWallet::findTokens(const QString &asNetwork)
{
    QList<DapWalletToken*> tokens;
    auto begin = m_aTokens.begin();
    auto end = m_aTokens.end();
    for(;begin != end; ++begin)
    {
        if((*begin)->getNetwork() == asNetwork)
        {
            tokens.append(*begin);
        }
    }
    return tokens;
}

QList<QObject *> DapWallet::getTokens() const
{
    QList<QObject*> tokens;
    auto begin = m_aTokens.begin();
    auto end = m_aTokens.end();
    for(;begin != end; ++begin)
    {
        tokens.append(*begin);
    }
    return tokens;
}

DapWallet DapWallet::fromVariant(const QVariant &aWallet)
{
    DapWallet wallet;
    QByteArray data = QByteArray::fromStdString(aWallet.toString().toStdString());
    QDataStream in(&data, QIODevice::ReadOnly);
    in >> wallet;
    return wallet;
}

QDataStream& operator << (QDataStream& aOut, const DapWallet& aWallet)
{
    QList<DapWalletToken> tokens;
    for(int x{0}; x < aWallet.m_aTokens.size(); ++x)
    {
        tokens.append(*aWallet.m_aTokens.at(x));
    }

     aOut   << aWallet.m_sName
            << aWallet.m_dBalance
            << aWallet.m_sIcon
            << aWallet.m_sAddress
            << aWallet.m_aNetworks
            << aWallet.m_aAddresses
            << tokens;

    return aOut;
}

QDataStream& operator >> (QDataStream& aIn, DapWallet& aWallet)
{
    QList<DapWalletToken> tokens;

        aIn >> aWallet.m_sName;
        aIn.setFloatingPointPrecision(QDataStream::DoublePrecision);
        aIn >> aWallet.m_dBalance
            >> aWallet.m_sIcon
            >> aWallet.m_sAddress
            >> aWallet.m_aNetworks
            >> aWallet.m_aAddresses
            >> tokens;


    auto begin = tokens.begin();
    auto end = tokens.end();
    for(;begin != end; ++begin)
        aWallet.addToken(new DapWalletToken(*begin));
    return aIn;
}

bool operator ==(const DapWallet &aWalletFirst, const DapWallet &aWalletSecond)
{
    return aWalletFirst.m_sName == aWalletSecond.m_sName;
}
