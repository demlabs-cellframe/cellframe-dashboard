#include "DapChainWallet.h"

DapChainWallet::DapChainWallet(const QString &asIconPath, const QString &asName, const QString &asAddresss, QObject *parent)
    : QObject(parent), m_sIconPath(asIconPath), m_sName(asName), m_sAddress(asAddresss)
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
