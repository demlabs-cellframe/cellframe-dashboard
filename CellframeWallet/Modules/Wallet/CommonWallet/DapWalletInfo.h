#ifndef DAPWALLETINFO_H
#define DAPWALLETINFO_H

#include <QMap>
#include <QList>
#include <QString>

namespace CommonWallet
{
    struct WalletTokensInfo
    {
        QString tokenName = QString();
        QString value = QString();
        QString datoshi = QString();
        QString ticker = QString();
        QString network = QString();
        QString availableDatoshi = QString();
        QString availableCoins = QString();
    };

    struct WalletNetworkInfo
    {
        QString network = QString();
        QString address = QString();
        // tokenName  info
        QList<WalletTokensInfo> networkInfo;
    };

    struct WalletInfo
    {
        QString walletName = QString();
        QString status = QString();
        QString path = QString();
        bool isMigrate = false;
        bool isLoad = false;
        // networkName info
        QMap<QString, WalletNetworkInfo> walletInfo;
    };

    struct FeeInfo
    {
        QMap<QString, QString> netFee;
        QMap<QString, QString> validatorFee;
    };
}
#endif // DAPWALLETINFO_H
