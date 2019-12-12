#ifndef DAPTRANSACTION_H
#define DAPTRANSACTION_H

#include <QObject>

class DapTransaction : public QObject
{
    Q_OBJECT

public:
    explicit DapTransaction(QObject *parent = nullptr);
    static DapTransaction& instance();

public slots:
    /// Request for creation new transaction
    /// @param name of wallet
    /// @param address of a receiver
    /// @param name of token
    /// @param name of network
    /// @param sum for transaction
    void createRequestTransaction(const QString& aFromWallet, const QString& aToAddress, const QString& aToken, const QString& aNetwork, const quint64 aValue);
    /// Taking everything from mempool
    /// @param network
    void sendToken(const QString& aNetwork);
    /// Recevie result of putting to mempool
    /// @param successful or not
    void receiveResult(const bool aSuccessful);

signals:
    void sendResult(bool result);
    void sendMempool(const QString& fromWallet, const QString& toAddress, const QString& token, const QString& network, const quint64 value);
    void sendTransaction(const QString& network);
};

#endif // DAPTRANSACTION_H
