#ifndef DAPCHAINWALLETHANDLER_H
#define DAPCHAINWALLETHANDLER_H

#include <QObject>
#include <QProcess>
#include <QRegExp>
#include <QDebug>
#include <QTimer>
#include "DapChainWallet.h"

/// Class provides operations at wallets
class DapChainWalletHandler : public QObject
{
    Q_OBJECT

private:
    QStringList m_networkList;
    QList<QPair<DapChainWalletData, QList<DapChainWalletTokenData>>> m_walletList;
    QTimer* m_timeout;

public:
    /// Standard constructor
    explicit DapChainWalletHandler(QObject *parent = nullptr);

    bool appendWallet(const QString& aWalletName);

    bool createTransaction(const QString& aFromAddress, const QString& aToAddress, const QString& aTokenName, const QString& aNetwork, const quint64 aValue) const;

    QByteArray walletData() const;

private slots:

    void onReadWallet();

public slots:

    void setNetworkList(const QStringList& aNetworkList);

signals:

    void walletDataChanged(QByteArray data);






private:
    /// Current network's name
    QString m_CurrentNetwork;

protected:
    /// Parse address of wallet from console command
    /// @param aWalletAddress Console command to create new wallet's address
    /// @return Address of wallet
    virtual QString parse(const QByteArray& aWalletAddress);

signals:

public slots:
    /// Create new wallet
    /// @param name of wallet
    /// @return result
    QStringList createWallet(const QString& asNameWallet);
    /// Remove wallet
    /// @param name of wallet
    void removeWallet(const QString& asNameWallet);
    /// Get list of wallets
    /// @return QMap of available wallets, where the key is name of wallet
    /// and the value is number of wallet
    QMap<QString, QVariant> getWallets();
    /// Get details about wallet
    /// @param name of wallet
    /// @return list with balances and tokens
    QStringList getWalletInfo(const QString& asNameWallet);
    /// Create new token
    /// @param name of wallet where is needed to send
    /// @param andress of wallet which will receive
    /// @param token name
    /// @param sum for sending
    /// @return result
    QString sendToken(const QString &asSendWallet, const QString& asAddressReceiver, const QString& asToken, const QString& aAmount);
    /// Set current network
    /// @param name of network
    void setCurrentNetwork(const QString& aNetwork);
};

#endif // DAPCHAINWALLETHANDLER_H
