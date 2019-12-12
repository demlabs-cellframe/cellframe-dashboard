#ifndef DAPCHAINTRANSACTION_H
#define DAPCHAINTRANSACTION_H

#include <QObject>
#include <QProcess>
#include <QDebug>

class DapChainTransaction : public QObject
{
    Q_OBJECT

public:
    explicit DapChainTransaction(QObject *parent = nullptr);

    /// Request for creation new transaction
    /// @param name of wallet
    /// @param address of a receiver
    /// @param name of token
    /// @param name of network
    /// @param sum for transaction
    /// @return result of trying to do transaction
    bool createTransaction(const QString& aFromWallet, const QString& aToAddress, const QString& aTokenName, const QString& aNetwork, const quint64 aValue) const;

    /// Taking everything from mempool
    /// @param network
    void takeFromMempool(const QString& aNetwork);
};

#endif // DAPCHAINTRANSACTION_H
