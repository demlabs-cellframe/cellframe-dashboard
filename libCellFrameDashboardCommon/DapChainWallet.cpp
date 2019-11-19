#include "DapChainWallet.h"

DapChainWalletTokenItem::DapChainWalletTokenItem(const QString& aWalletAddress, QObject* parent) :
    QObject(parent),
    m_wallet(aWalletAddress)
{

}

DapChainWalletTokenItem::DapChainWalletTokenItem(const QString& aWalletAddress, const DapChainWalletTokenData& aData, QObject* parent) :
    QObject(parent)/*
    m_wallet(aWalletAddress),
    m_name(aData.Name),
    m_balance(aData.Balance),
    m_emission(aData.Emission)*/
{
    m_wallet = aWalletAddress;
    m_name = aData.Name;
    m_balance = aData.Balance;
    m_emission = aData.Emission;
}

QString DapChainWalletTokenItem::name() const
{
    return m_name;
}

double DapChainWalletTokenItem::balance() const
{
    return m_balance;
}

quint64 DapChainWalletTokenItem::emission() const
{
    return m_emission;
}

QString DapChainWalletTokenItem::wallet() const
{
    return m_wallet;
}

void DapChainWalletTokenItem::setName(const QString& aName)
{
    if (m_name == aName) return;
    m_name = aName;
    emit nameChanged(aName);
}

void DapChainWalletTokenItem::setBalance(const double aBalance)
{
    qWarning("Floating point comparison needs context sanity check");
    if (qFuzzyCompare(m_balance, aBalance))
        return;

    m_balance = aBalance;
    emit balanceChanged(m_balance);
}

void DapChainWalletTokenItem::setEmission(const quint64 aEmission)
{
    if (m_emission == aEmission)
        return;

    m_emission = aEmission;
    emit emissionChanged(m_emission);
}

void DapChainWalletTokenItem::setData(const DapChainWalletTokenData& aData)
{
    setName(aData.Name);
    setBalance(aData.Balance);
    setEmission(aData.Emission);
}





























DapChainWallet::DapChainWallet(const QString &asIconPath, const QString &asName, const QString &asAddress, const QStringList &aBalance, const QStringList &aTokens, QObject *parent)
    : QObject(parent), m_sIconPath(asIconPath), m_sName(asName), m_sAddress(asAddress), m_balance(aBalance), m_tokens(aTokens)
{

}

DapChainWallet::DapChainWallet(const QString &asIconPath, const QString &asName, const QString &asAddress, QObject *parent)
    : DapChainWallet(asIconPath, asName, asAddress, QStringList(), QStringList(), parent)
{

}

QString DapChainWallet::getIconPath() const
{
    return m_sIconPath;
}

void DapChainWallet::setIconPath(const QString &asIconPath)
{
    m_sIconPath = asIconPath;

    emit iconPathChanged(m_sIconPath);
}

QString DapChainWallet::getName() const
{
    return m_sName;
}

void DapChainWallet::setName(const QString &asName)
{
    m_sName = asName;

    emit nameChanged(m_sName);
}

QString DapChainWallet::getAddress() const
{
    return m_sAddress;
}

void DapChainWallet::setAddress(const QString &asAddress)
{
    m_sAddress = asAddress;

    emit addressChanged(m_sAddress);
}

QStringList DapChainWallet::getBalance() const
{
    return m_balance;
}

void DapChainWallet::setBalance(const QStringList &aBalance)
{
    m_balance = aBalance;

    emit balanceChanged(m_balance);
}

QStringList DapChainWallet::getTokens() const
{
    return m_tokens;
}

void DapChainWallet::setTokens(const QStringList &aTokens)
{
    m_tokens = aTokens;
    
    emit tokensChanged(m_tokens);
}

int DapChainWallet::getCount() const
{
    return m_tokens.count();
}


