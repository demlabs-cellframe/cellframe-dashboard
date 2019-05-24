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
        AddressWalletRole
    };

class DapChainWalletsModel : public QAbstractListModel
{
    Q_OBJECT

    QList<DapChainWallet*>    m_dapChainWallets;

    DapChainWalletsModel(QObject* parent = nullptr);
public:
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapChainWalletsModel &getInstance();

    int rowCount(const QModelIndex & = QModelIndex()) const;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const;
    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QVariantMap get(int row) const;
    Q_INVOKABLE void append(const DapChainWallet &arWallet);
    Q_INVOKABLE void append(const QString& asIconPath, const QString &asName, const QString  &asAddress);
    Q_INVOKABLE void set(int row, const QString& asIconPath, const QString &asName, const QString  &asAddresss);
    Q_INVOKABLE void remove(int row);
    Q_INVOKABLE void clear();

public slots:
    /// Method that implements the singleton pattern for the qml layer.
    /// @param engine QML application.
    /// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
    static QObject *singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine);

};

#endif // DAPCHAINWALLETSMODEL_H
