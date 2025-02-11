#ifndef DAPTRANSACTIONMANAGER_H
#define DAPTRANSACTIONMANAGER_H

#include <QObject>

#include <DapAbstractDataManager.h>
#include "node_globals/NodeGlobals.h"
#include "Modules/DapModulesController.h"

#include "handlers/Transactions/DapTransactionController.h";


class DapTransactionManager : public DapAbstractDataManager
{
    Q_OBJECT
public:
    explicit DapTransactionManager(DapModulesController *parent = nullptr);

    void sendTx(QVariantMap txData);

private slots:
    void rcvTxReply(const QVariant& reply);

signals:
    void sigDefatultTxReply(const QVariant& reply);
    void sigCondTxReply(const QVariant& reply);
    void sigStakeLockTxReply(const QVariant& reply);
    void sigStakeTakeTxReply(const QVariant& reply);
    void sigStakeDelegateTxReply(const QVariant& reply);
    void sigStakeInvalidateTxReply(const QVariant& reply);
    void sigDexPurchaseTxReply(const QVariant& reply);
    void sigDexOrderCreateTxReply(const QVariant& reply);
    void sigDexOrderRemoveTxReply(const QVariant& reply);
    void sigVoteTxReply(const QVariant& reply);
    void sigVotingTxReply(const QVariant& reply);
    void sigJsonTxReply(const QVariant& reply);
};

#endif // DAPTRANSACTIONMANAGER_H
