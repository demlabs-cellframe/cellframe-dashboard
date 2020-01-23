#ifndef DAPWALLET_H
#define DAPWALLET_H

#include <QString>
#include <QList>

#include "DapWalletToken.h"

class DapWallet
{
    QString         m_name;
    QList<QString>  m_networks;
    QMap<QString, QString>   m_iAddress;
    QMultiMap<QString, DapWalletToken>   m_aTokens;

public:
    DapWallet(const QString& asName);

    void addNetwork(const QString& asNetwork);
    QList<QString>& getNetworks();
    void setAddress(const QString &aiAddress, const QString& asNetwork);
    QString getAddress(const QString& asNetwork);
    void addToken(const DapWalletToken& asName, const QString& asNetwork);
    QList<DapWalletToken*> getTokens(const QString& asNetwork);



};

#endif // DAPWALLET_H
