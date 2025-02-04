#include "DapTransactionManager.h"

DapTransactionManager::DapTransactionManager(DapModulesController *moduleController)
    : DapAbstractDataManager(moduleController)
{
    connect(m_modulesController->getServiceController(), &DapServiceController::rcvTxCreated, this, &DapTransactionManager::rcvTxReply);
}

void DapTransactionManager::sendTx(QVariantMap txData)
{
    m_modulesController->sendRequestToService("DapCreateTxCommand", txData);
}

void DapTransactionManager::rcvTxReply(const QVariant &reply)
{
    if(reply.isNull() || reply.toMap().isEmpty())
    {
        qWarning()<<"Empty result tx create";
        return;
    }

    QVariantMap map = reply.toMap();

    QVariant data = map.value(Dap::CommandParamKeys::DATA_KEY);
    DapTransactionController::TxType type = (DapTransactionController::TxType)map.value(Dap::KeysParam::TYPE_TX).toInt();

    switch (type) {
    case DapTransactionController::TxType::DEFAULT:
    {
        emit sigDefatultTxReply(data);
        break;
    }
    case DapTransactionController::TxType::COND:
    {
        emit sigCondTxReply(data);
        break;
    }
    case DapTransactionController::TxType::STAKE_LOCK:
    {
        emit sigStakeLockTxReply(data);
        break;
    }
    case DapTransactionController::TxType::STAKE_TAKE:
    {
        emit sigStakeTakeTxReply(data);
        break;
    }
    case DapTransactionController::TxType::STAKE_DELEGATE:
    {
        emit sigStakeDelegateTxReply(data);
        break;
    }
    case DapTransactionController::TxType::STAKE_INVALIDATE:
    {
        emit sigStakeInvalidateTxReply(data);
        break;
    }
    case DapTransactionController::TxType::DEX_PURCHASE:
    {
        emit sigDexPurchaseTxReply(data);
        break;
    }
    case DapTransactionController::TxType::DEX_ORDER_CREATE:
    {
        emit sigDexOrderCreateTxReply(data);
        break;
    }
    case DapTransactionController::TxType::DEX_ORDER_REMOVE:
    {
        emit sigDexOrderRemoveTxReply(data);
        break;
    }
    case DapTransactionController::TxType::VOTE:
    {
        emit sigVoteTxReply(data);
        break;
    }
    case DapTransactionController::TxType::VOTING:
    {
        emit sigVotingTxReply(data);
        break;
    }
    case DapTransactionController::TxType::JSON:
    {
        emit sigJsonTxReply(data);
        break;
    }
    default:
        qWarning()<<"Unknown TX Type: " << type;
        break;
    }
}
