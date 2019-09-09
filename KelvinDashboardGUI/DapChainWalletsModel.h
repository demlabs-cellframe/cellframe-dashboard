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

enum DapChainWalletRole {
        IconWalletRole = Qt::DisplayRole,
        NameWalletRole = Qt::UserRole,
        AddressWalletRole,
        BalanceWalletRole,
        TokensWalletRole,
        CountWalletRole
    };

/// Class model for wallets screen
class DapChainWalletsModel : public QAbstractListModel
{
    Q_OBJECT

    QList<DapChainWallet*>    m_dapChainWallets;

    DapChainWalletsModel(QObject* parent = nullptr);
public:
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapChainWalletsModel &getInstance();

    /// Overraid model's methods
    int rowCount(const QModelIndex & = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    /// Get data in a row
    Q_INVOKABLE QVariantMap get(int row) const;
    /// Add new wallet
    Q_INVOKABLE void append(const DapChainWallet &arWallet);
    Q_INVOKABLE void append(const QString& asIconPath, const QString &asName, const QString  &asAddress, const QStringList &aBalance, const QStringList &aTokens);
    /// Change data for wallet in a row
    Q_INVOKABLE void set(int row, const QString& asIconPath, const QString &asName, const QString  &asAddresss, const QStringList &aBalance, const QStringList &aTokens);
    /// Remove row with wallet
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
