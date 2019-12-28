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
    ///This variable contains a list of wallets.
    QStringList m_wallets;
    ///This variable contains a list of wallets and data structures for calculating the balance state for each wallet.
    QList<DapChainWalletPair> m_walletList;
public:
    DapWallet();
    ///Defines a static instance of a class.
    static DapWallet& instance();
    ///For _PROPERTY returns a list of wallets for the combobox
    QStringList walletList();
    ///Calculates the balance for the current wallet or for all wallets.
    Q_INVOKABLE double walletBalance(const QString& aName) const;
    ///Loads the entire wallet structure into class variables.
    /// @param Data from a node
    void setWalletData(const QByteArray& aData);

signals:
    ///This signal is triggered when the number of wallets changes.
    /// @param changed List
    void walletListChanged(QStringList);
};

#endif // DAPWALLET_H
