#include "DapTransaction.h"

DapTransaction::DapTransaction(QObject *parent) : QObject(parent)
{

}

DapTransaction& DapTransaction::instance()
{
    static DapTransaction instance;
    return instance;
}

void DapTransaction::createRequestTransaction(const QString& aFromWallet, const QString& aToAddress, const QString& aToken, const QString& aNetwork, const quint64 aValue)
{
    emit sendMempool(aFromWallet, aToAddress, aToken, aNetwork, aValue);
}

void DapTransaction::sendToken(const QString& aNetwork)
{
    emit sendTransaction(aNetwork);
}

void DapTransaction::receiveResult(const bool aSuccessful)
{
    emit sendResult(aSuccessful);
}
