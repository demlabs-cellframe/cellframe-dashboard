#include "DapChainTransaction.h"

DapChainTransaction::DapChainTransaction(QObject *parent) : QObject(parent)
{

}

bool DapChainTransaction::createTransaction(const QString& aFromWallet, const QString& aToAddress, const QString& aTokenName, const QString& aNetwork, const quint64 aValue) const
{
    QProcess processCreate;
    processCreate.start(QString("%1 tx_create -net %2 -chain gdb -from_wallet %3 -to_addr %4 -token %5 -value %6")
                  .arg(CLI_PATH)
                  .arg(aNetwork)
                  .arg(aFromWallet)
                  .arg(aToAddress)
                  .arg(aTokenName)
                  .arg(QString::number(aValue)));
    processCreate.waitForFinished(-1);
    QByteArray result = processCreate.readAll();

    QRegExp rx("transfer=(\\w+)");
    rx.indexIn(result, 0);

    if(rx.cap(1) == "Ok")
    {
        return true;
    }

    return false;
}

void DapChainTransaction::takeFromMempool(const QString& aNetwork)
{
    QProcess processMempool;
    processMempool.start(QString("%1 mempool_proc -net " + aNetwork +" -chain gdb").arg(CLI_PATH));
    processMempool.waitForFinished(-1);
    processMempool.readAll();
}
