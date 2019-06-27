#include "DapChainWallet.h"

DapChainWallet::DapChainWallet(const QString &asIconPath, const QString &asName, const QString &asAddresss, const QStringList &aBalance, const QStringList &aTokens, QObject *parent)
    : QObject(parent), m_sIconPath(asIconPath), m_sName(asName), m_sAddress(asAddresss), m_balance(aBalance), m_tokens(aTokens)
{

}

DapChainWallet::DapChainWallet(const QString &asIconPath, const QString &asName, const QString &asAddresss, QObject *parent)
    : DapChainWallet(asIconPath, asName, asAddresss, QStringList(), QStringList(), parent)
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
