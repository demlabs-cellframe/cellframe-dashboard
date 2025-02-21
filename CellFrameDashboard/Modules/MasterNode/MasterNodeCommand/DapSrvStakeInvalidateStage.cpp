#include "DapSrvStakeInvalidateStage.h"
#include "../DapTypes/DapCoin.h"
#include "../DapMasterNodeKeys.h"

DapSrvStakeInvalidateStage::DapSrvStakeInvalidateStage(DapServiceController *serviceController)
    :DapAbstractMasterNodeCommand(serviceController)
    , m_checkStakeTimer(new QTimer())
{
    connect(m_serviceController, &DapServiceController::rcvSrvStakeInvalidate, this, &DapSrvStakeInvalidateStage::respondStakeInvalidate);
    connect(m_serviceController, &DapServiceController::rcvCheckQueueTransaction, this, &DapSrvStakeInvalidateStage::respondCheckStakeDelegate);
    connect(m_serviceController, &DapServiceController::rcvMempoolCheckCommand, this, &DapSrvStakeInvalidateStage::respondMempoolCheck);
    connect(m_checkStakeTimer, &QTimer::timeout, this, &DapSrvStakeInvalidateStage::checkStake);
}

void DapSrvStakeInvalidateStage::stakeInvalidate(const QVariantMap& masterNodeInfo)
{
    setMasterNodeInfo(masterNodeInfo);

    QString stakeValue = m_masterNodeInfo.value(MasterNode::STAKE_VALUE_KEY).toString();
    auto split = stakeValue.split('.');
    if(split.size() == 1)
    {
        if(split[0].isEmpty())
        {
            stakeValue = "0.0";
        }
        else
        {
            stakeValue = split[0] + ".0";
        }
    }
    else if(split.size() >= 1)
    {
        if(split[0].isEmpty() && !split[1].isEmpty())
        {
            stakeValue = "0." + split[1];
        }
        else if(split[1].isEmpty() && !split[0].isEmpty())
        {
            stakeValue = split[0] + ".0";
        }
        else if(stakeValue.isEmpty())
        {
            stopCreationMasterNode(1, "An empty value was specified for freezing m-tokens.");
            return;
        }
    }
    Dap::Coin value256 = stakeValue;
    QString valueDatoshi = value256.toDatoshiString();

    Dap::Coin fee256 = m_masterNodeInfo.value(MasterNode::STAKE_FEE_KEY).toString();
    QString feeDatoshi = fee256.toDatoshiString();
    m_serviceController->requestToService("DapSrvStakeInvalidate", QStringList() << m_masterNodeInfo.value(MasterNode::NETWORK_KEY).toString()
                                                                                 << m_masterNodeInfo.value(MasterNode::STAKE_HASH_KEY).toString()
                                                                                 << m_masterNodeInfo.value(MasterNode::WALLET_NAME_KEY).toString()
                                                                                 << feeDatoshi
                                                                                 << valueDatoshi
                                                                                 );
}

void DapSrvStakeInvalidateStage::checkStakeInvalidate(const QVariantMap& masterNodeInfo)
{
    setMasterNodeInfo(masterNodeInfo);
    checkStakeDelegate();
}

void DapSrvStakeInvalidateStage::checkStakeDelegate()
{
    checkStake();
    m_checkStakeTimer->start(TIME_OUT_CHECK_STAKE);
}

void DapSrvStakeInvalidateStage::checkStake()
{
    if(m_masterNodeInfo.contains(MasterNode::QUEUE_INVALIDATE_HASH_KEY))
    {
        m_serviceController->requestToService("DapCheckQueueTransactionCommand", QStringList()
                                              << m_masterNodeInfo.value(MasterNode::QUEUE_INVALIDATE_HASH_KEY).toString()
                                              << m_masterNodeInfo.value(MasterNode::WALLET_NAME_KEY).toString()
                                              << m_masterNodeInfo.value(MasterNode::NETWORK_KEY).toString());
    }
    else
    {
        stopCreationMasterNode(4, "No stake delegate hash found in the queue.");
    }
}

void DapSrvStakeInvalidateStage::respondCheckStakeDelegate(const QVariant &rcvData)
{
    if(m_masterNodeInfo.isEmpty())
    {
        return;
    }

    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    if(!replyObj.contains("result"))
    {
        qWarning() << "[DapModuleMasterNode] Error in the data";
        return;
    }
    auto resultObject = replyObj["result"].toObject();
    QString txHash, queueHash, state;
    auto getItem = [&resultObject](const QString& name, QString& buff)
    {
        if(!resultObject.contains(name))
        {
            qWarning() << QString("[respondCheckStakeDelegate]The \"%1\" element was not found.").arg(name);
            buff = "";
            return;
        }
        buff = resultObject[name].toString();
    };

    getItem("queueHash", queueHash);
    getItem("state", state);
    getItem("txHash", txHash);

    if(m_masterNodeInfo.contains(MasterNode::QUEUE_INVALIDATE_HASH_KEY) && m_masterNodeInfo[MasterNode::QUEUE_INVALIDATE_HASH_KEY].toString() != queueHash)
    {
        qDebug() << "[DapStakeDelegate][respondCheckStakeDelegate]The response came from another request.";
        return;
    }

    if(state == "mempool")
    {
        if(!m_masterNodeInfo.contains(MasterNode::STAKE_INVALIDATE_HASH_KEY) && !txHash.isEmpty())
        {
            addDataMasterNodeInfo(MasterNode::STAKE_INVALIDATE_HASH_KEY, txHash);
        }
    }
    else if(state == "notFound")
    {
        m_checkStakeTimer->stop();
        if(!m_masterNodeInfo.contains(MasterNode::STAKE_INVALIDATE_HASH_KEY))
        {
            qDebug() << "It looks like the transaction was rejected.";
            stopCreationMasterNode(10, "It looks like the transaction was rejected.");
        }
        else
        {
            qInfo() << "We are looking for information about the transaction. By hash: " << m_masterNodeInfo[MasterNode::STAKE_INVALIDATE_HASH_KEY].toString();
            mempoolCheck();
        }
    }
}

void DapSrvStakeInvalidateStage::mempoolCheck()
{
    if(m_masterNodeInfo.contains(MasterNode::STAKE_INVALIDATE_HASH_KEY))
    {
        QString nodeMade = Dap::NodeMode::LOCAL_MODE;
        QVariantMap request = {{Dap::KeysParam::NODE_MODE_KEY, nodeMade}
                               ,{Dap::KeysParam::NETWORK_NAME, m_masterNodeInfo.value(MasterNode::NETWORK_KEY).toString()}
                               ,{Dap::KeysParam::TX_HASH, m_masterNodeInfo.value(MasterNode::STAKE_INVALIDATE_HASH_KEY).toString()}};

        m_serviceController->requestToService("MempoolCheckCommand", request);
    }
    else
    {
        stopCreationMasterNode(20, "No stake invalidate hash found in the mempool.");
    }
}

void DapSrvStakeInvalidateStage::respondMempoolCheck(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    QJsonObject result = replyObj["result"].toObject();

    if(!result.contains("hash") || !result.contains("net"))
    {
        qWarning() << "[DapModuleMasterNode] Incorrect data.";
        return;
    }
    QString hash = result["hash"].toString();

    if(m_masterNodeInfo.value(MasterNode::STAKE_INVALIDATE_HASH_KEY).toString() != hash)
    {
        return;
    }
    m_checkStakeTimer->stop();
    QString code;
    if(result.contains("atom"))
    {
        QJsonObject atom = result["atom"].toObject();
        if(!atom.contains("ledger_response_code"))
        {
            return;
        }

        code = atom["ledger_response_code"].toString();
    }

    QString source;
    if(result.contains("source"))
    {
        source = result["source"].toString();
    }

    if(source == "chain" && (code == "DAP_LEDGER_TX_CHECK_OK" || code.contains("No error")))
    {
        stageComplated();
        m_masterNodeInfo.clear();
    }
    else
    {
        qDebug() << "[DapModuleMasterNode] The transaction is in the mempool";
        stopCreationMasterNode(6, "The transaction may have failed.");
    }
}

void DapSrvStakeInvalidateStage::respondStakeInvalidate(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();

    if(replyObj.contains("error"))
    {
        auto error = replyObj["error"].toString();
        qInfo() << "The transaction was not created. Message:" << error;
        stopCreationMasterNode(8, "The transaction was not created.");
        return;
    }

    QJsonObject resultObj = replyObj["result"].toObject();

    QString stakeHash, queueHash;
    if(resultObj.contains("tx_hash"))
    {
        stakeHash = resultObj["tx_hash"].toString();
        addDataMasterNodeInfo(MasterNode::STAKE_INVALIDATE_HASH_KEY, stakeHash);
    }
    if(resultObj.contains("idQueue"))
    {
        queueHash = resultObj["idQueue"].toString();
        addDataMasterNodeInfo(MasterNode::QUEUE_INVALIDATE_HASH_KEY, queueHash);
    }

    if(!stakeHash.isEmpty() || !queueHash.isEmpty())
    {
        checkStakeDelegate();
        //        stageComplated();
    }
    else
    {
        qDebug() << "[DapStakeDelegate] [pespondStakeDelegate]There was a problem with the detention of tokens, we need to make another attempt.";
        stopCreationMasterNode(19, "There was a problem with the return of tokens.");
    }
}

void DapSrvStakeInvalidateStage::cencelRegistration()
{
    m_checkStakeTimer->stop();
    DapAbstractMasterNodeCommand::cencelRegistration();
}
