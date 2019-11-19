#ifndef DAPCHAINWALLETMODEL_H
#define DAPCHAINWALLETMODEL_H

#include <QAbstractListModel>
#include <QDebug>
#include "DapChainWallet.h"

class DapChainWalletModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(double walletBalance READ walletBalance NOTIFY walletBalanceChanged)
    Q_PROPERTY(QList<QObject*> tokenList READ tokenList NOTIFY tokenListChanged)

public:
    enum {
        WalletNameDisplayRole = Qt::UserRole,
        WalletAddressDisplayRole,
        WalletIconDisplayRole,
        WalletTokenListDisplayRole,
        NetworkDisplayRole,
    };

private:
    QString m_currentWallet;
    double m_walletBalance;
    QList<DapChainWalletPair> m_walletList;
    QList<QObject*> m_tokenList;

public:
    explicit DapChainWalletModel(QObject *parent = nullptr);

    static DapChainWalletModel& instance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    QHash<int, QByteArray> roleNames() const override;

    double walletBalance(const QString& aAddress) const;

    Q_INVOKABLE double walletBalance(const int aWalletIndex) const;

    Q_INVOKABLE QList<QObject*> tokeListByWallet(const QString& aWalletAddress, const QString& aNetwork = QString()) const;

    double walletBalance() const;

    QList<QObject*> tokenList() const;

public slots:

    Q_INVOKABLE void setCurrentWallet(const QString& aWalletAddress);

    Q_INVOKABLE void setCurrentWallet(const int aWalletIndex);

    void setWalletData(const QByteArray& aData);

    void appendWallet(const DapChainWalletData& aWallet);

    void appendToken(const QString& aWalletAddress, const DapChainWalletTokenData& aTokenData);

    void removeWallet(const QString& aWalletAddress);

    void removeWallet(const int aWalletIndex);

signals:
    void walletBalanceChanged(double walletBalance);
    void sigAppendWallet(QString name);
    void sigRemoveWallet(QString address);
    void tokenListChanged(QList<QObject*> tokenList);
};

#endif // DAPCHAINWALLETMODEL_H
