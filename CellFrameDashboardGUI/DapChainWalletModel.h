#ifndef DAPCHAINWALLETMODEL_H
#define DAPCHAINWALLETMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include "DapChainWallet.h"

#define TITLE_ALL_WALLETS tr("all wallets")

class DapChainWalletModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QStringList wallets READ walletList NOTIFY walletListChanged)

public:
    enum {
        WalletNameDisplayRole = Qt::UserRole,
        WalletAddressDisplayRole,
        WalletIconDisplayRole,
        WalletTokenListDisplayRole,
        WalletListDisplayRole,
        NetworkDisplayRole,
    };

private:
    QStringList m_wallets;
    QList<DapChainWalletPair> m_walletList;


public:
    explicit DapChainWalletModel(QObject *parent = nullptr);

    static DapChainWalletModel& instance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE QStringList walletList() const;

    Q_INVOKABLE double walletBalance(const QString& aName) const;

    Q_INVOKABLE double walletBalance(const int aWalletIndex) const;

    Q_INVOKABLE QList<QObject*> tokeListByWallet(const QString& aWalletAddress, const QString& aNetwork = QString()) const;

    QList<QObject*> tokeListByIndex(const int aIndex) const;

public slots:

    void setWalletData(const QByteArray& aData);

    void appendWallet(const DapChainWalletData& aWallet);

    void appendToken(const QString& aWalletAddress, const DapChainWalletTokenData& aTokenData);

    void removeWallet(const QString& aWalletAddress);

    void removeWallet(const int aWalletIndex);

signals:
    void sigAppendWallet(QString name);
    void sigRemoveWallet(QString address);
    void walletListChanged(QStringList walletList);
};

#endif // DAPCHAINWALLETMODEL_H
