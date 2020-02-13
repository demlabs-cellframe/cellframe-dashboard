#include "DapWalletHistoryEvent.h"

DapWalletHistoryEvent::DapWalletHistoryEvent(QObject *parent) : QObject(parent)
{
    
}

DapWalletHistoryEvent::DapWalletHistoryEvent(const DapWalletHistoryEvent &aHistoryEvent)
    : QObject(aHistoryEvent.parent()),m_sWallet(aHistoryEvent.m_sWallet), m_sName(aHistoryEvent.m_sName), m_sStatus(aHistoryEvent.m_sStatus),
      m_dAmount(aHistoryEvent.m_dAmount), m_sDate(aHistoryEvent.m_sDate)
{

}

DapWalletHistoryEvent &DapWalletHistoryEvent::operator=(const DapWalletHistoryEvent &aHistoryEvent)
{
    m_sWallet = aHistoryEvent.m_sWallet;
    m_sName = aHistoryEvent.m_sName;
    m_sStatus = aHistoryEvent.m_sStatus;
    m_dAmount = aHistoryEvent.m_dAmount;
    m_sDate = aHistoryEvent.m_sDate;
    return (*this);
}

bool DapWalletHistoryEvent::operator==(const DapWalletHistoryEvent &aHistoryEvent) const
{
    return (m_sWallet == aHistoryEvent.m_sWallet)
            && (m_sName == aHistoryEvent.m_sName)
            && (m_sStatus == aHistoryEvent.m_sStatus)
            && (m_dAmount == aHistoryEvent.m_dAmount)
            && (m_sDate == aHistoryEvent.m_sDate);
}

QString DapWalletHistoryEvent::getWallet() const
{
    return m_sWallet;
}

void DapWalletHistoryEvent::setWallet(const QString &sWallet)
{
    m_sWallet = sWallet;

    emit walletChanged(m_sWallet);
}

QString DapWalletHistoryEvent::getName() const
{
    return m_sName;
}

void DapWalletHistoryEvent::setName(const QString &sName)
{
    m_sName = sName;

    emit nameChanged(m_sName);
}

double DapWalletHistoryEvent::getAmount() const
{
    return m_dAmount;
}

void DapWalletHistoryEvent::setAmount(double dAmount)
{
    m_dAmount = dAmount;

    emit amountChanged(m_dAmount);
}

QString DapWalletHistoryEvent::getStatus() const
{
    return m_sStatus;
}

void DapWalletHistoryEvent::setStatus(const QString &sStatus)
{
    m_sStatus = sStatus;

    emit statusChanged(m_sStatus);
}

QString DapWalletHistoryEvent::getDate() const
{
    return m_sDate;
}

void DapWalletHistoryEvent::setDate(const QString &sDate)
{
    m_sDate = sDate;

    emit dateChanged(m_sDate);
}

QDataStream& operator << (QDataStream& aOut, const DapWalletHistoryEvent& aHistoryEvent)
{
    aOut << aHistoryEvent.m_sWallet
         << aHistoryEvent.m_sName
         << aHistoryEvent.m_dAmount
         << aHistoryEvent.m_sStatus
         << aHistoryEvent.m_sDate;
    return aOut;
}

QDataStream& operator >> (QDataStream& aOut, DapWalletHistoryEvent& aHistoryEvent)
{
    aOut >> aHistoryEvent.m_sWallet
         >> aHistoryEvent.m_sName;
    aOut.setFloatingPointPrecision(QDataStream::DoublePrecision);
    aOut >> aHistoryEvent.m_dAmount;
    aOut >> aHistoryEvent.m_sStatus
         >> aHistoryEvent.m_sDate;
    return aOut;
}
