#include "DapWalletToken.h"

DapWalletToken::DapWalletToken(const QString &asName, QObject *parent)
    : QObject(parent), m_sName(asName)
{
    
}

DapWalletToken::DapWalletToken(const DapWalletToken &aToken)
    : QObject(aToken.parent()), m_sName(aToken.m_sName), m_dBalance(aToken.m_dBalance),
      m_iEmission(aToken.m_iEmission), m_sNetwork(aToken.m_sNetwork)
{

}

DapWalletToken &DapWalletToken::operator=(const DapWalletToken &aToken)
{
    m_sName = aToken.m_sName;
    m_dBalance = aToken.m_dBalance;
    m_iEmission = aToken.m_iEmission;
    m_sNetwork = aToken.m_sNetwork;
    return (*this);
}

bool DapWalletToken::operator==(const DapWalletToken &aToken) const
{
    return m_sName == aToken.m_sName
         && m_dBalance == aToken.m_dBalance
         && m_iEmission == aToken.m_iEmission
         && m_sNetwork == aToken.m_sNetwork;
}

QString DapWalletToken::getName() const
{
    return m_sName;
}

void DapWalletToken::setName(const QString &sName)
{
    m_sName = sName;

    emit nameChanged(m_sName);
}

double DapWalletToken::getBalance() const
{
    return m_dBalance;
}

void DapWalletToken::setBalance(double dBalance)
{
    m_dBalance = dBalance;

    emit balanceChanged(m_dBalance);
}

quint64 DapWalletToken::getEmission() const
{
    return m_iEmission;
}

void DapWalletToken::setEmission(const quint64 &iEmission)
{
    m_iEmission = iEmission;

    emit emissionChanged(m_iEmission);
}

QString DapWalletToken::getNetwork() const
{
    return m_sNetwork;
}

void DapWalletToken::setNetwork(const QString &sNetwork)
{
    m_sNetwork = sNetwork;

    emit networkChanged(m_sNetwork);
}

QString DapWalletToken::getIcon() const
{
    return m_sIcon;
}

void DapWalletToken::setIcon(const QString &sIcon)
{
    m_sIcon = sIcon;

    emit iconChanged(m_sIcon);
}

QDataStream& operator << (QDataStream& aOut, const DapWalletToken& aToken)
{
    aOut << aToken.m_sName
         << aToken.m_dBalance
         << aToken.m_iEmission
         << aToken.m_sNetwork;
    return aOut;
}

QDataStream& operator >> (QDataStream& aOut, DapWalletToken& aToken)
{
    aOut >> aToken.m_sName;
    aOut.setFloatingPointPrecision(QDataStream::DoublePrecision);
    aOut >> aToken.m_dBalance;
    aOut.setFloatingPointPrecision(QDataStream::SinglePrecision);
    aOut >> aToken.m_iEmission
         >> aToken.m_sNetwork;
    return aOut;
}


