#ifndef DAPWALLETMODEL_H
#define DAPWALLETMODEL_H

#include <QObject>
#include <QAbstractListModel>
#include <algorithm>
#include <QList>

#include "DapWallet.h"

class DapWalletModel : public QAbstractListModel
{
    Q_OBJECT

    QList<DapWallet>    m_aWallets;

    explicit DapWalletModel(QObject *parent = nullptr);

public:
    Q_PROPERTY(QStringList WalletList READ getWalletList NOTIFY walletListChanged)

    enum DapWalletRole
    {
        NameDisplayRole = Qt::UserRole,
        AddressDisplayRole,
        BalanceDisplayRole,
        IconDisplayRole,
        NetworksDisplayRole,
        TokensDisplayRole,
        WalletsDisplayRole
    };
    Q_ENUM(DapWalletRole)

    static DapWalletModel& getInstance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    QList<QObject*> getTokens(const int aIndex) const;

    QStringList getWalletList() const;

signals:
    void walletListChanged(const QStringList& aWalletList);

public slots:

    Q_INVOKABLE void appendWallet(const DapWallet& aWallet);
    Q_INVOKABLE void appendToken(const QString& asWalletAddress, DapWalletToken* aToken);
    Q_INVOKABLE void removeWallet(const QString& asWalletAddress);
    Q_INVOKABLE void removeWallet(const int aWalletIndex);
};

#endif // DAPWALLETMODEL_H
