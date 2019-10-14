#ifndef DAPCHAINWALLETHANDLER_H
#define DAPCHAINWALLETHANDLER_H

#include <QObject>
#include <QProcess>
#include <QRegExp>
#include <QDebug>

/// Class provides operations at wallets
class DapChainWalletHandler : public QObject
{
    Q_OBJECT

private:
    /// Current network's name
    QString m_CurrentNetwork;

protected:
    /// Parse address of wallet from console command
    /// @param aWalletAddress Console command to create new wallet's address
    /// @return Address of wallet
    virtual QString parse(const QByteArray& aWalletAddress);

public:
    /// Standard constructor
    explicit DapChainWalletHandler(QObject *parent = nullptr);

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
