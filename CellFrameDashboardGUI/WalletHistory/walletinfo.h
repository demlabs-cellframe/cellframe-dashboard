#ifndef WALLETINFO_H
#define WALLETINFO_H

#include <QList>
#include <QString>

struct NetworkInfo
{
    QString network;
    QString chain;
    QString address;
};

struct WalletInfo
{
    QString name;

    QList <NetworkInfo> networkList;
};

#endif // WALLETINFO_H
