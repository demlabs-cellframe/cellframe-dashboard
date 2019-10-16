#ifndef DAPCHAINWALLETSMODEL_H
#define DAPCHAINWALLETSMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <QList>
#include <QQmlEngine>
#include <QJSEngine>
#include <QXmlStreamWriter>
#include <QXmlStreamReader>
#include <QXmlStreamAttribute>

#include <DapChainWallet.h>
/**
 * @brief The DapChainWalletRole enum
 *
 * These values are used in arguments to methods data and roleNames.
 * Main goal is return data from selected information about wallet
 */
enum DapChainWalletRole {
        /// Icon wallet
        IconWalletRole = Qt::DisplayRole,
        /// Name of wallet
        NameWalletRole = Qt::UserRole,
        /// Address of wallet
        AddressWalletRole,
        /// Balance
        BalanceWalletRole,
        /// Tokens name
        TokensWalletRole,
        /// Number of wallets
        CountWalletRole
    };

/// Class model for wallets screen
class DapChainWalletsModel : public QAbstractListModel
{
    Q_OBJECT
    /// Set of wallets
    QList<DapChainWallet*>    m_dapChainWallets;

    /// standard constructor
    DapChainWalletsModel(QObject* parent = nullptr);
public:
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapChainWalletsModel &getInstance();

    /// Overraid model's methods
    /// Get number of wallets
    /// @return Number of wallets
    int rowCount(const QModelIndex & = QModelIndex()) const;
    /// Information about selected wallet by index and which field needs
    /// @return Information about wallet
    /// @param index Index of wallet
    /// @param role Concrete fields about wallet
    /// @return Data about concrete field of wallet
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    /// Information about fields of wallet
    /// @return Set of fields wallet
    QHash<int, QByteArray> roleNames() const;

    /// Get data in a row
    /// @param row Row of wallet
    /// @return Information about wallet selected by row
    Q_INVOKABLE QVariantMap get(int row) const;
    /// Add new wallet
    /// @param arWallet new wallet
    Q_INVOKABLE void append(const DapChainWallet &arWallet);
    /// Add new wallet
    /// @param asIconPath Path icon
    /// @param asName Name of wallet
    /// @param asAddress Address of wallet
    /// @param aBalance Balance
    /// @param aTokens Tokens name
    Q_INVOKABLE void append(const QString& asIconPath, const QString &asName, const QString  &asAddress, const QStringList &aBalance, const QStringList &aTokens);
    /// Change data for wallet in a row
    /// @param row Row of wallet
    /// @param asName Name of wallet
    /// @param asAddress Address of wallet
    /// @param aBalance Balance
    /// @param aTokens Tokens name
    Q_INVOKABLE void set(int row, const QString& asIconPath, const QString &asName, const QString  &asAddresss, const QStringList &aBalance, const QStringList &aTokens);
    /// Remove row with wallet
    /// @param row Row of wallet
    Q_INVOKABLE void remove(int row);
    /// Clear screen
    Q_INVOKABLE void clear();

public slots:
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);

};

#endif // DAPCHAINWALLETSMODEL_H
