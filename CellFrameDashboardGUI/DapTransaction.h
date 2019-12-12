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
    void createRequestTransaction(const QString& aFromWallet, const QString& aToAddress, const QString& aToken, const QString& aNetwork, const quint64 aValue);
    void sendToken(const QString& aNetwork);
    void receiveResult(const bool aSuccessful);

signals:
    void sendResult(bool result);
    void sendMempool(const QString& fromWallet, const QString& toAddress, const QString& token, const QString& network, const quint64 value);
    void sendTransaction(const QString& network);
};

#endif // DAPTRANSACTION_H
