#ifndef DAPCHAINWALLETMODEL_H
#define DAPCHAINWALLETMODEL_H

#include <QAbstractListModel>
#include "DapChainWallet.h"

class DapChainWalletModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(float walletBalance READ walletBalance NOTIFY walletBalanceChanged)

public:
    enum {
        WalletNameDisplayRole = Qt::UserRole,
        WalletAddressDisplayRole,
        WalletIconDisplayRole,
        WalletTokenListDisplayRole,
        TokenListByNetworkDisplayRole
    };

private:
    QString m_currentWallet;
    float m_walletBalance;
    QList<DapChainWalletPair> m_walletList;

public:
    explicit DapChainWalletModel(QObject *parent = nullptr);

    static DapChainWalletModel& instance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    float walletBalance(const QString& aAddress) const;

    QList<QObject*> tokeListByWallet(const QString& aWalletAddress, const QString& aNetwork = QString()) const;

    float walletBalance() const;

public slots:

    void setCurrentWallet(const QString& aWallet);

    void setWalletData(const QList<DapChainWalletPair>& aData);

    void appendWallet(const DapChainWalletData& aWallet);

    void appendToken(const QString& aWalletAddress, const DapChainWalletTokenData& aTokenData);

    void removeWallet(const QString& aWalletAddress);

    void removeWallet(const int aWalletIndex);

signals:
    void walletBalanceChanged(float walletBalance);
};

#endif // DAPCHAINWALLETMODEL_H
