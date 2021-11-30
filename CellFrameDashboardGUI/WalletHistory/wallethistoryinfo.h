#ifndef WALLETHISTORYINFO_H
#define WALLETHISTORYINFO_H

#include <QGuiApplication>

struct WalletHistoryInfo
{
    Q_GADGET

    Q_PROPERTY(QString wallet MEMBER wallet)
    Q_PROPERTY(QString network MEMBER network)
    Q_PROPERTY(QString token MEMBER token)
    Q_PROPERTY(QString txStatus MEMBER txStatus)
    Q_PROPERTY(double txAmount MEMBER txAmount)
    Q_PROPERTY(QString date MEMBER date)
    Q_PROPERTY(qint64 secsSinceEpoch MEMBER secsSinceEpoch)

public:
    QString wallet;
    QString network;
    QString token;
    QString txStatus;
    double txAmount;
    QString date;
    qint64 secsSinceEpoch;

    WalletHistoryInfo(
        const QString& wallet = "",
        const QString& network = "",
        const QString& tokenName = "",
        const QString& tokenStatus = "",
        double tokenBalance = 0.0,
        const QString& date = "",
        qint64 secsSinceEpoch = 0)
    {
        this->wallet = wallet;
        this->network = network;
        this->token = tokenName;
        this->txStatus = tokenStatus;
        this->txAmount = tokenBalance;
        this->date = date;
        this->secsSinceEpoch = secsSinceEpoch;
    }
};

Q_DECLARE_METATYPE(WalletHistoryInfo)

#endif // WALLETHISTORYINFO_H
