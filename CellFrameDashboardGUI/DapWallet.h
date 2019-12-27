#ifndef DAPWALLET_H
#define DAPWALLET_H

#include <QObject>
#include <QString>
#include "DapChainWallet.h"
#include "DapChainConvertor.h"
#include "QDebug"

#define ALL_WALLETS tr("all wallets")

class DapWallet:public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList wallets READ walletList NOTIFY walletListChanged)
    Q_PROPERTY(QString walletBalance READ walletBalance NOTIFY walletBalanceChanged)

    QStringList m_wallets;
    QList<DapChainWalletPair> m_walletList;
public:
    DapWallet();

    static DapWallet& instance();

    //QString getBalance(QString wallet)const;

    QString walletBalance();
    void walletBalanceChanged();
    QStringList walletList();
    Q_INVOKABLE QString convertWalletBallance(const QString& aName = ALL_WALLETS) const;
    Q_INVOKABLE double walletBalance(const QString& aName) const;
   // double walletBalance(const int aWalletIndex) const;
//    QList<QObject*> tokeListByWallet(const QString& aWalletAddress, const QString& aNetwork) const;
//    QList<QObject*> tokeListByIndex(const int aIndex) const;
    void setWalletData(const QByteArray& aData);
//    void appendWallet(const DapChainWalletData& aWallet);
//    void removeWallet(const QString& aWalletAddress);

//    void removeWallet(const int aWalletIndex);
signals:
    void walletListChanged(QStringList);
};

#endif // DAPWALLET_H
