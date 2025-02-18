#include "DapServiceController.h"

/// Standard constructor.
/// @param apParent Parent.
DapServiceController::DapServiceController(QObject *apParent)
    : QObject(apParent)
{
}

DapServiceController::~DapServiceController()
{
    disconnect();
    if(m_web3Controll) delete m_web3Controll;

    DapTransactionQueueController* controller = DapTransactionQueueController::getTransactionController();
    if(controller)
    {
        controller->deleteTransactionController();
    }
    for(auto* command: m_transceivers)
    {
        delete command;
    }
    m_transceivers.clear();
}

void DapServiceController::run()
{
    DapConfigReader configReader;

    m_bReadingChains = configReader.getItemBool("general", "reading_chains", false);

    if(m_transceivers.isEmpty())
    {
        registerCommand();
    }

    initAdditionalParamrtrsService();

    m_web3Controll = new DapWebControllerForService(this);
    m_web3Controll->rcvFrontendConnectStatus(true);
    m_web3Controll->setCommandList(&m_transceivers);

    QStringList webPathWallets = {Dap::UiSdkDefines::DataFolders::WALLETS_DIR, Dap::UiSdkDefines::DataFolders::WALLETS_MIGRATE_DIR};
    m_web3Controll->setPathWallets(webPathWallets);

    // Channel req\rep for web 3 API
    connect(this, &DapServiceController::webConnectRespond, m_web3Controll, &DapWebControll::rcvAccept);
    connect(m_web3Controll, &DapWebControllerForService::signalConnectRequest, this, &DapServiceController::rcvWebConenctRequest);

    qInfo() << "ServiceController started";
    emit onServiceStarted();

    DapTransactionQueueController* controller = DapTransactionQueueController::getTransactionController();
    if(!controller)
    {
        qWarning() << "DapTransactionQueueController have a problem";
        return;
    }
    controller->onInit();
    
}

void DapServiceController::setReadingChains(bool bReadingChains)
{
    m_bReadingChains = bReadingChains;
    emit readingChainsChanged(bReadingChains);
}

/// Disconnect all signals
void DapServiceController::disconnectAll()
{
    disconnect(this, 0, 0, 0);
}

void DapServiceController::requestToService(const QString &asServiceName, const QVariant &args)
{
    if(!m_transceivers.contains(asServiceName))
    {
        qWarning()<<QString("Command " + asServiceName + " was not found");
        return;
    }
    QtConcurrent::run([this, asServiceName, args]{
        DapAbstractCommand * transceiver = m_transceivers[asServiceName];
        if(!transceiver)
        {
            qWarning()<<QString("Transceiver " + asServiceName + " was not found");
            return;
        }
        transceiver->replyToClient(args);
    });
}

void DapServiceController::addService(const QString& name, const QString& signalName, DapAbstractCommand* commandService)
{
    if(m_transceivers.contains(name))
    {
        qWarning()<<QString("service with name " + name + " already exist");
        return;
    }

    connect(commandService, &DapAbstractCommand::dataGetedSignal, [signalName, this] (const QVariant& reply)
    {
        for (int idx = 0; idx < metaObject()->methodCount(); ++idx)
        {
            const QMetaMethod method = metaObject()->method(idx);
            if (method.methodType() == QMetaMethod::Signal && method.name() == signalName)
            {
                metaObject()->method(idx).invoke(this, Q_ARG(QVariant, reply));
            }
        }
    });

    qDebug() << "Init handler class: " << name;
    m_transceivers.insert(name, commandService);
}


template <typename ServiceType, typename... TArgs>
void DapServiceController::addServiceGeneric(const QString& name, const QString& signalName, TArgs... ctr_args)
{
    try {
        addService(name, signalName, new ServiceType(name, ctr_args...));
    }
    catch (std::runtime_error e) {
            qDebug() << "Can't instantinate command " << name << ": "<<e.what();
    }
}

/// Register command.
void DapServiceController::registerCommand()
{
    /*Wallet*/
    addServiceGeneric<DapAddWalletCommand,                  QObject*>("DapAddWalletCommand",                       "walletCreated",                         nullptr);
    addServiceGeneric<DapRemoveWalletCommand,               QObject*>("DapRemoveWalletCommand",                    "walletRemoved",                         nullptr);
    addServiceGeneric<DapGetWalletInfoCommand,              QObject*>("DapGetWalletInfoCommand",                   "walletReceived",                        nullptr);
    addServiceGeneric<DapGetListWalletsCommand,             QObject*>("DapGetListWalletsCommand",                  "walletsListReceived",                   nullptr);
    addServiceGeneric<DapMoveWalletCommand,                 QObject*>("DapMoveWalletCommand",                      "moveWalletCommandReceived",             nullptr);
    addServiceGeneric<DapCreatePassForWallet,               QObject*>("DapCreatePassForWallet",                    "passwordCreated",                       nullptr);
    addServiceGeneric<DapWalletActivateOrDeactivateCommand, QObject*>("DapWalletActivateOrDeactivateCommand",      "rcvActivateOrDeactivateReply",          nullptr);
    addServiceGeneric<DapGetWalletAddressCommand,           QObject*>("DapGetWalletAddressCommand",                "walletAddressReceived",                 nullptr);
//    addServiceGeneric<DapGetWalletTokenInfoCommand,         QObject*>("DapGetWalletTokenInfoCommand",              "walletTokensReceived",                  nullptr);
    addServiceGeneric<DapGetOnceWalletInfoCommand,          QObject*>("DapGetOnceWalletInfoCommand",               "rcvGetOnceWalletInfoCommand",           nullptr);

    /*Xchange*/
    addServiceGeneric<DapGetXchangeTxList,                  QObject*>("DapGetXchangeTxList",                       "rcvXchangeTxList",                      nullptr);
    addServiceGeneric<DapXchangeOrderCreateStack,           QObject*>("DapXchangeOrderCreate",                     "rcvXchangeCreate",                      nullptr);
    addServiceGeneric<DapXchangeOrderRemoveStack,           QObject*>("DapXchangeOrderRemove",                     "rcvXchangeRemove",                      nullptr);
    addServiceGeneric<DapXchangeOrderPurchaseStack,         QObject*>("DapXchangeOrderPurchase",                   "rcvXchangeOrderPurchase",               nullptr);
    addServiceGeneric<DapGetXchangeTokenPair,               QObject*>("DapGetXchangeTokenPair",                    "rcvXchangeTokenPair",                   nullptr);
    addServiceGeneric<DapGetXchangeTokenPriceAverage,       QObject*>("DapGetXchangeTokenPriceAverage",            "rcvXchangeTokenPriceAverage",           nullptr);
    addServiceGeneric<DapGetXchangeTokenPriceHistory,       QObject*>("DapGetXchangeTokenPriceHistory",            "rcvXchangeTokenPriceHistory",           nullptr);
    addServiceGeneric<DapGetXchangeOrdersList,              QObject*>("DapGetXchangeOrdersList",                   "rcvXchangeOrderList",                   nullptr);

    /*Voting*/
    addServiceGeneric<DapVoitingCreateCommandStack,         QObject*>("DapVoitingCreateCommand",                   "rcvVoitingCreateCommand",               nullptr);
    addServiceGeneric<DapVoitingVoteCommandStack,           QObject*>("DapVoitingVoteCommand",                     "rcvVoitingVoteCommand",                 nullptr);
    addServiceGeneric<DapVoitingListCommand,                QObject*>("DapVoitingListCommand",                     "rcvVoitingListCommand",                 nullptr);
    addServiceGeneric<DapVoitingDumpCommand,                QObject*>("DapVoitingDumpCommand",                     "rcvVoitingDumpCommand",                 nullptr);

    /*Stake*/
    addServiceGeneric<DapSrvStakeInvalidate,                QObject*>("DapSrvStakeInvalidate",                     "rcvSrvStakeInvalidate",                 nullptr);
    addServiceGeneric<DapSrvStakeRemove,                    QObject*>("DapSrvStakeRemove",                         "rcvSrvStakeRemove",                     nullptr);
    addServiceGeneric<DapSrvStakeDelegateCommandStack,      QObject*>("DapSrvStakeDelegateCommand",                "srvStakeDelegateCreated",               nullptr);
    addServiceGeneric<DapStakeLockHoldCommandStack,         QObject*>("DapStakeLockHoldCommand",                   "rcvStakeLockHoldCommand",               nullptr);
    addServiceGeneric<DapStakeLockTakeCommandStack,         QObject*>("DapStakeLockTakeCommand",                   "rcvStakeLockTakeCommand",               nullptr);
    addServiceGeneric<DapCreateStakeOrder,                  QObject*>("DapCreateStakeOrder",                       "createdStakeOrder",                     nullptr);

    /*Network*/
    addServiceGeneric<DapGetListNetworksCommand,            QObject*>("DapGetListNetworksCommand",                 "networksListReceived",                  nullptr);
    addServiceGeneric<DapGetNetworkStatusCommand,           QObject*>("DapGetNetworkStatusCommand",                "networkStatusReceived",                 nullptr);
    addServiceGeneric<DapNetworkGoToCommand,                QObject*>("DapNetworkGoToCommand",                     "newTargetNetworkStateReceived",         nullptr);
    addServiceGeneric<DapNetIdCommand,                      QObject*>("DapNetIdCommand",                           "rcvNetIdCommand",                       nullptr);
    addServiceGeneric<DapNetworkSingleSyncCommand,          QObject*>("DapNetworkSingleSyncCommand",               "",                                      nullptr);
    addServiceGeneric<DapGetNetworksStateCommand,           QObject*>("DapGetNetworksStateCommand",                "networkStatesListReceived",             nullptr);

    /*Transaction*/
    addServiceGeneric<DapCreateJsonTransactionCommandStack, QObject*>("DapCreateJsonTransactionCommand",           "rcvCreateJsonTransactionCommand",       nullptr);
    addServiceGeneric<DapTransactionListCommand,            QObject*>("DapTransactionListCommand",                 "rcvTransactionListCommand",             nullptr);
    addServiceGeneric<DapTransactionsInfoQueueCommand,      QObject*>("DapTransactionsInfoQueueCommand",           "rcvTransactionsInfoQueueCommand",       nullptr);
    addServiceGeneric<DapCheckQueueTransactionCommand,      QObject*>("DapCheckQueueTransactionCommand",           "rcvCheckQueueTransaction",              nullptr);
    addServiceGeneric<DapRemoveTransactionsQueueCommand,    QObject*>("DapRemoveTransactionsQueueCommand",         "transactionRemoved",                    nullptr);
    addServiceGeneric<DapCheckTransactionsQueueCommand,     QObject*>("DapCheckTransactionsQueueCommand",          "transactionInfoReceived",               nullptr);
    addServiceGeneric<DapCreateTransactionCommandStack,     QObject*>("DapCreateTransactionCommand",               "transactionCreated",                    nullptr);
    addServiceGeneric<DapTXCondCreateCommandStack,          QObject*>("DapTXCondCreateCommand",                    "rcvTXCondCreateCommand",                nullptr);
    addServiceGeneric<DapGetFeeCommand,                     QObject*>("DapGetFeeCommand",                          "rcvFee",                                nullptr);
    addServiceGeneric<DapCreateTxCommand,                   QObject*>("DapCreateTxCommand",                        "rcvTxCreated",                          nullptr);

    /*Node*/
    addServiceGeneric<DapNodeRestart,                       QObject*>("DapNodeRestart",                            "nodeRestart",                           nullptr);
    addServiceGeneric<DapAddNodeCommand,                    QObject*>("DapAddNodeCommand",                         "rcvAddNode",                            nullptr);
    addServiceGeneric<DapNodeListCommand,                   QObject*>("DapNodeListCommand",                        "rcvNodeListCommand",                    nullptr);
    addServiceGeneric<DapNodeDumpCommand,                   QObject*>("DapNodeDumpCommand",                        "rcvNodeDumpCommand",                    nullptr);
    addServiceGeneric<DapGetNodeIPCommand,                  QObject*>("DapGetNodeIPCommand",                       "rcvGetNodeIPCommand",                   nullptr);
    addServiceGeneric<DapGetNodeStatus,                     QObject*>("DapGetNodeStatus",                          "rcvGetNodeStatus",                      nullptr);
    addServiceGeneric<DapNodeDel,                           QObject*>("DapNodeDel",                                "rcvNodeDel",                            nullptr);
    addServiceGeneric<DapNodeConfigController,              QObject*>("DapNodeConfigController",                   "dapNodeConfigController",               nullptr);

    /*Mempool*/
    addServiceGeneric<MempoolCheckCommand,                  QObject*>("MempoolCheckCommand",                       "rcvMempoolCheckCommand",                nullptr);
    addServiceGeneric<DapMempoolListCommand,                QObject*>("DapMempoolListCommand",                     "rcvMempoolListCommand",                 nullptr);
    //    addServiceGeneric<DapMempoolProcessCommand,             QObject*>("DapMempoolProcessCommand",                  "mempoolProcessed",                      nullptr);

    /*Token*/
    addServiceGeneric<DapGetListTokensCommand,              QObject*>("DapGetListTokensCommand",                   "tokensListReceived",                    nullptr);
    addServiceGeneric<DapTokenEmissionCommand,              QObject*>("DapTokenEmissionCommand",                   "responseEmissionToken",                 nullptr);
    addServiceGeneric<DapTokenDeclCommand,                  QObject*>("DapTokenDeclCommand",                       "responseDeclToken",                     nullptr);

    /*Order*/
    addServiceGeneric<DapGetListOrdersCommand,              QObject*>("DapGetListOrdersCommand",                   "ordersListReceived",                    nullptr);
    addServiceGeneric<DapCreateVPNOrder,                    QObject*>("DapCreateVPNOrder",                         "createdVPNOrder",                       nullptr);

    /*Certificate*/
    addServiceGeneric<DapCertificateManagerCommands,        QObject*>("DapCertificateManagerCommands",             "certificateManagerOperationResult",     nullptr);

    /*History*/
    addServiceGeneric<DapGetWalletHistoryCommand,           QObject*>("DapGetWalletHistoryCommand",                "allWalletHistoryReceived",              nullptr);

    /*Other*/
    addServiceGeneric<DapExportLogCommand,                  QObject*>("DapExportLogCommand",                       "exportLogs",                            nullptr);
    addServiceGeneric<DapRunCmdCommand,                     QObject*>("DapRunCmdCommand",                          "cmdRunned",                             nullptr);
    addServiceGeneric<DapDictionaryCommand,                 QObject*>("DapDictionaryCommand",                      "rcvDictionary",                         nullptr);
    addServiceGeneric<DapRemoveChainsOrGdbCommand,          QObject*>("DapRemoveChainsOrGdbCommand",               "rcvRemoveResult",                       nullptr);
    addServiceGeneric<DapGetListKeysCommand,                QObject*>("DapGetListKeysCommand",                     "rcvGetListKeysCommand",                 nullptr);
    addServiceGeneric<DapLedgerTxHashCommand,               QObject*>("DapLedgerTxHashCommand",                    "rcvLedgerTxHashCommand",                nullptr);
    addServiceGeneric<DapGetServiceLimitsCommand,           QObject*>("DapGetServiceLimitsCommand",                "rcvGetServiceLimitsCommand",            nullptr);
    addServiceGeneric<DapQuitApplicationCommand,            QObject*>("DapQuitApplicationCommand",                 "",                                      nullptr);
    addServiceGeneric<DapVersionController,                 QObject*>("DapVersionController",                      "versionControllerResult",               nullptr);
    addServiceGeneric<DapWebConnectRequest,                 QObject*>("DapWebConnectRequest",                      "dapWebConnectRequest",                  nullptr);
    addServiceGeneric<DapWebBlockList,                      QObject*>("DapWebBlockList",                           "rcvWebBlockList",                       nullptr);
    addServiceGeneric<DapMigrateWalletsCommand,             QObject*>("DapMigrateWalletsCommand",                  "rcvMigrateWallets",                     nullptr);
    addServiceGeneric<DapUpdateLogsCommand,                 QObject *, QString> ("DapUpdateLogsCommand",                    "logUpdated",                   nullptr, Dap::UiSdkDefines::CellframeNode::LOG_FILE);
    addServiceGeneric<DapGetHistoryExecutedCmdCommand,      QObject *, QString> ("DapGetHistoryExecutedCmdCommand",         "historyExecutedCmdReceived",   nullptr, Dap::UiSdkDefines::DataFolders::CMD_HISTORY_USER);
    addServiceGeneric<DapSaveHistoryExecutedCmdCommand,     QObject *, QString> ("DapSaveHistoryExecutedCmdCommand",        "",                             nullptr, Dap::UiSdkDefines::DataFolders::CMD_HISTORY_USER);

    connect(this, &DapServiceController::tokensListReceived, [this] (const QVariant& tokensResult)
    {
        if(!tokensResult.isValid())
            return ;

//        emit signalTokensListReceived(tokensResult);

        QJsonDocument replyDoc = QJsonDocument::fromJson(tokensResult.toByteArray());
        QJsonObject replyObj = replyDoc.object();

        if(replyObj["result"].isArray())
        {
            QJsonArray resultArr = replyObj["result"].toArray();
            QJsonDocument resultDoc(resultArr);
            emit signalTokensListReceived(tokensResult);
        }
        else
        {
            qDebug() << "tokensListReceived isEqual";
            emit signalTokensListReceived("isEqual");
        }
    });
}

void DapServiceController::tryRemoveTransactions(const QVariant& transactions)
{
    QList<QStringList> list;
    QVariantList lists = transactions.toList();
    for (const QVariant& listVariant : lists) {
        QStringList strList = listVariant.toStringList();
        list.append(strList);
    }
    QVariantList variantList;
    for (const QStringList& strList : list) {
        QVariant variant = QVariant::fromValue(strList);
        variantList.append(variant);
    }

    QVariant finalVariant = QVariant::fromValue(variantList);
    this->requestToService("DapRemoveTransactionsQueueCommand", finalVariant);
}

void DapServiceController::initAdditionalParamrtrsService()
{
    if(m_transceivers.isEmpty())
    {
        qWarning() << "An error occurred while initializing the service";
    }
    DapTransactionQueueController* controller = DapTransactionQueueController::getTransactionController();
    if(!controller)
    {
        qWarning() << "DapTransactionQueueController have a problem";
        return;
    }

    // connect(this, &DapServiceController::onServiceStarted, controller, &DapTransactionQueueController::onInit);

    if(m_transceivers.contains("MempoolCheckCommand"))
    {
        MempoolCheckCommand* command = dynamic_cast<MempoolCheckCommand*>(m_transceivers["MempoolCheckCommand"]);
        connect(controller, &DapTransactionQueueController::toGetTransactionData, command, &DapAbstractCommand::toDataSignal);
        connect(command, &DapAbstractCommand::dataGetedSignal, controller, &DapTransactionQueueController::transactionDataReceived);
    }
    if(m_transceivers.contains("DapGetOnceWalletInfoCommand"))
    {
        DapGetOnceWalletInfoCommand* command = dynamic_cast<DapGetOnceWalletInfoCommand*>(m_transceivers["DapGetOnceWalletInfoCommand"]);
        connect(controller, &DapTransactionQueueController::toGetWalletInfo, command, &DapAbstractCommand::toDataSignal);
        connect(command, &DapAbstractCommand::dataGetedSignal, controller, &DapTransactionQueueController::walletInfoReceived);
    }
    if(m_transceivers.contains("DapGetWalletInfoCommand"))
    {
        DapGetWalletInfoCommand* command = dynamic_cast<DapGetWalletInfoCommand*>(m_transceivers["DapGetWalletInfoCommand"]);
        connect(controller, &DapTransactionQueueController::updateInfoForWallets, command, &DapGetWalletInfoCommand::queueDataUpdate);
    }
    if(m_transceivers.contains("DapGetWalletHistoryCommand"))
    {
        DapGetWalletHistoryCommand* command = dynamic_cast<DapGetWalletHistoryCommand*>(m_transceivers["DapGetWalletHistoryCommand"]);
        connect(controller, &DapTransactionQueueController::updateHistoryForWallet, command, &DapGetWalletHistoryCommand::queueDataUpdate);
        connect(controller, &DapTransactionQueueController::newTransactionAdded, command, &DapGetWalletHistoryCommand::transactionFromQueudAdded);
        connect(command, &DapGetWalletHistoryCommand::queuedUpdated,  this, &DapServiceController::queueUpdated);
        connect(command, &DapGetWalletHistoryCommand::transactionMoved,  controller, &DapTransactionQueueController::updateInfoTransaction);
    }
}
