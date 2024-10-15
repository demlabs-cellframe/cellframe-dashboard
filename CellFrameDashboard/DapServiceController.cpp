#include "DapServiceController.h"

/// Standard constructor.
/// @param apParent Parent.
DapServiceController::DapServiceController(QObject *apParent)
    : QObject(apParent)
{
    m_reqularRequestsCtrl = new DapRegularRequestsController();

    DapConfigReader configReader;
    m_DapNotifyController = new DapNotifyController();
    notifySignalsAttach();

    m_sVersion = DAP_VERSION;

    m_bReadingChains = configReader.getItemBool("general", "reading_chains", false);
}

DapServiceController::~DapServiceController()
{

    for(QThread *thread : qAsConst(m_threadPool))
    {
        thread->quit();
        thread->wait();
        delete thread;
    }
    delete m_web3Controll;
    DapTransactionQueueController* controller = DapTransactionQueueController::getTransactionController();
    if(controller)
    {
        controller->deleteTransactionController();
    }
    //    for(DapRpcService *service : qAsConst(m_servicePool))
    //        service->deleteLater();

    m_threadPool.clear();
    //    m_servicePool.clear();

    //    DapTransactionQueueController* controller = DapTransactionQueueController::getTransactionController();
    //    if(controller)
    //    {
    //        controller->deleteTransactionController();
    //    }

    if(m_threadRegular)
    {
        m_threadRegular->quit();
        m_threadRegular->wait();
        delete m_threadRegular;
    }
}

/// Client controller initialization.
/// @param apDapServiceClient Network connection controller.
void DapServiceController::init()
{
    m_pServer = new DapUiService(this);

    m_threadRegular = new QThread();
    m_reqularRequestsCtrl->moveToThread(m_threadRegular);
    connect(m_threadRegular, &QThread::finished, m_reqularRequestsCtrl, &QObject::deleteLater);
    connect(m_threadRegular, &QThread::finished, m_threadRegular, &QObject::deleteLater);
    m_threadRegular->start();

    if(m_transceivers.isEmpty())
    {
        registerCommand();
    }

    initAdditionalParamrtrsService();
    m_reqularRequestsCtrl->start();

    m_web3Controll = new DapWebControllerForService(this);
    m_web3Controll->rcvFrontendConnectStatus(true);
    ////    m_versionController = new DapUpdateVersionController(this);
#ifdef Q_OS_ANDROID
    /*
    if (m_pServer->listen("127.0.0.1", 22150)) {
        qDebug() << "Listen for UI on 127.0.0.1: " << 22150;
        connect(m_pServer, &DapUiService::onClientConnected, &DapServiceController::onNewClientConnected);
        connect(m_pServer, &DapUiService::onClientDisconnected, &DapServiceController::onNewClientConnected);
    }*/
#else
    //    m_pServer->setSocketOptions(QLocalServer::WorldAccessOption);
    //    if(m_pServer->listen(DAP_BRAND))
    //    {
    //        connect(m_pServer, &DapUiService::onClientConnected, this,  &DapServiceController::onNewClientConnected);
    //        connect(m_pServer, &DapUiService::onClientDisconnected, this, &DapServiceController::onClientDisconnected);

    m_web3Controll->setCommandList(&m_transceivers);
    // Channel req\rep for web 3 API
    connect(this, &DapServiceController::webConnectRespond, m_web3Controll, &DapWebControll::rcvAccept);
    connect(m_web3Controll, &DapWebControllerForService::signalConnectRequest, this, &DapServiceController::rcvWebConenctRequest);
    //        // Regular request controller
    //
    //    }
#endif
    //    else
    //    {
    //        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
    //        qCritical() << m_pServer->errorString();
    //        return false;
    //    }

    qInfo() << "Service started";
    emit onServiceStarted();
}

/// Get company brand.
/// @return Brand сompany.
QString DapServiceController::getBrand() const
{
    return m_sBrand;
}

/// Get app version.
/// @return Application version.
QString DapServiceController::getVersion() const
{
    return m_sVersion;
}

QString DapServiceController::getCurrentNetwork() const
{
    return m_sCurrentNetwork;
}

void DapServiceController::setCurrentNetwork(const QString &sCurrentNetwork)
{
    m_sCurrentNetwork = sCurrentNetwork;

    emit currentNetworkChanged(m_sCurrentNetwork);
}

int DapServiceController::getIndexCurrentNetwork() const
{
    return m_iIndexCurrentNetwork;
}

void DapServiceController::setIndexCurrentNetwork(int iIndexCurrentNetwork)
{
    m_iIndexCurrentNetwork = iIndexCurrentNetwork;

    emit indexCurrentNetworkChanged(m_iIndexCurrentNetwork);
}

bool DapServiceController::getReadingChains() const
{
    return m_bReadingChains;
}

void DapServiceController::setReadingChains(bool bReadingChains)
{
    m_bReadingChains = bReadingChains;

    emit readingChainsChanged(bReadingChains);
}

void DapServiceController::requestWalletList()
{
    this->requestToService("DapGetWalletsInfoCommand", QStringList() << "true");
}

/*void DapServiceController::requestWalletInfo(const QString &a_walletName, const QStringList &a_networks)
{
    this->requestToService("DapGetWalletInfoCommand", a_walletName, a_networks);
}*/

void DapServiceController::requestNetworkStatus(QString a_networkName)
{
    this->requestToService("DapGetNetworkStatusCommand", QStringList() << a_networkName);
}

void DapServiceController::changeNetworkStateToOffline(QString a_networkName)
{
    this->requestToService("DapGetNetworkStatusCommand", QStringList() << a_networkName << "offline");
}

void DapServiceController::changeNetworkStateToOnline(QString a_networkName)
{
    this->requestToService("DapNetworkGoToCommand", QStringList() << a_networkName << "online");
}

void DapServiceController::requestOrdersList()
{
    this->requestToService("DapGetListOrdersCommand");
}

void DapServiceController::requestNetworksList()
{
    this->requestToService("DapGetListNetworksCommand");
}

int DapServiceController::getAutoOnlineValue()
{
    DapConfigReader reader;
    bool res = reader.getItemBool("general", "auto_online", false);
    if (res)
        return 2;
    else return 0;
}


/// Get an instance of a class.
/// @return Instance of a class.
DapServiceController &DapServiceController::getInstance()
{
    static DapServiceController instance;
    return instance;
}

/// Disconnect all signals
void DapServiceController::disconnectAll()
{
    disconnect(this, 0, 0, 0);
}

/// Send request to service.
/// @details In this case, a request is sent to the service to which it is obliged to respond. Expect an answer.
/// @param asServiceName Service name.
/// @param arg1...arg10 Parametrs.
void DapServiceController::requestToService(const QString &asServiceName, const QVariant &args)
{
    Q_ASSERT_X(m_transceivers.contains(asServiceName), QString("Command " + asServiceName + " was not found").toStdString().c_str(), 0);

    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_transceivers[asServiceName]);
    Q_ASSERT(transceiver);
    emit transceiver->toDataSignal(args);
}

/// Notify service.
/// @details In this case, only a notification is sent to the service, the answer should not be expected.
/// @param asServiceName Service name.
/// @param arg1...arg10 Parametrs.
void DapServiceController::notifyService(const QString &asServiceName, const QVariant &args)
{
    qDebug() << "DapServiceController::notifyService" << asServiceName << args;
//    Q_ASSERT_X(m_transceivers.contains(asServiceName), QString("Command " + asServiceName + " was not found").toStdString().c_str(), 0);
//    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_transceivers[asServiceName]);

//    Q_ASSERT(transceiver);

//    transceiver->notifyToService(args);
}

void DapServiceController::addService(const QString& name, const QString& signalName, DapAbstractCommand* commandService)
{
    Q_ASSERT_X(!m_transceivers.contains(name), QString("service with name " + name + " already exist").toStdString().c_str(), 0);
    commandService->setRegularController(m_reqularRequestsCtrl);

    connect(commandService, &DapAbstractCommand::dataGetedSignal, [signalName, this] (const QVariant reply)
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

    if(!m_onceThreadList.contains(name))
    {
        QThread * thread = new QThread(this);

        commandService->moveToThread(thread);
        thread->start();
        m_threadPool.append(thread);
    }
    qDebug() << "add command " << name;
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
    addServiceGeneric<DapCreateTransactionCommandStack,     QObject*>("DapCreateTransactionCommand",               "transactionCreated",                    nullptr);
    addServiceGeneric<DapSrvStakeDelegateCommandStack,      QObject*>("DapSrvStakeDelegateCommand",                "srvStakeDelegateCreated",               nullptr);
    addServiceGeneric<DapTXCondCreateCommandStack,          QObject*>("DapTXCondCreateCommand",                    "rcvTXCondCreateCommand",                nullptr);
    addServiceGeneric<DapXchangeOrderCreateStack,           QObject*>("DapXchangeOrderCreate",                     "rcvXchangeCreate",                      nullptr);
    addServiceGeneric<DapXchangeOrderRemoveStack,           QObject*>("DapXchangeOrderRemove",                     "rcvXchangeRemove",                      nullptr);
    addServiceGeneric<DapXchangeOrderPurchaseStack,         QObject*>("DapXchangeOrderPurchase",                   "rcvXchangeOrderPurchase",               nullptr);
    addServiceGeneric<DapStakeLockHoldCommandStack,         QObject*>("DapStakeLockHoldCommand",                   "rcvStakeLockHoldCommand",               nullptr);
    addServiceGeneric<DapStakeLockTakeCommandStack,         QObject*>("DapStakeLockTakeCommand",                   "rcvStakeLockTakeCommand",               nullptr);
    addServiceGeneric<DapCreateJsonTransactionCommandStack, QObject*>("DapCreateJsonTransactionCommand",           "rcvCreateJsonTransactionCommand",       nullptr);
    addServiceGeneric<DapVoitingCreateCommandStack,         QObject*>("DapVoitingCreateCommand",                   "rcvVoitingCreateCommand",               nullptr);
    addServiceGeneric<DapVoitingVoteCommandStack,           QObject*>("DapVoitingVoteCommand",                     "rcvVoitingVoteCommand",                 nullptr);

    addServiceGeneric<DapCertificateManagerCommands,        QObject*>("DapCertificateManagerCommands",             "certificateManagerOperationResult",     nullptr);
    addServiceGeneric<DapActivateClientCommand,             QObject*>("DapActivateClientCommand",                  "clientActivated",                       nullptr);
    addServiceGeneric<DapAddWalletCommand,                  QObject*>("DapAddWalletCommand",                       "walletCreated",                         nullptr);
    addServiceGeneric<DapRemoveWalletCommand,               QObject*>("DapRemoveWalletCommand",                    "walletRemoved",                         nullptr);
    addServiceGeneric<DapGetWalletInfoCommand,              QObject*>("DapGetWalletInfoCommand",                   "walletReceived",                        nullptr);
    addServiceGeneric<DapExportLogCommand,                  QObject*>("DapExportLogCommand",                       "exportLogs",                            nullptr);
    addServiceGeneric<DapGetListNetworksCommand,            QObject*>("DapGetListNetworksCommand",                 "networksListReceived",                  nullptr);
    addServiceGeneric<DapGetNetworkStatusCommand,           QObject*>("DapGetNetworkStatusCommand",                "networkStatusReceived",                 nullptr);
    addServiceGeneric<DapNetworkGoToCommand,                QObject*>("DapNetworkGoToCommand",                     "newTargetNetworkStateReceived",         nullptr);
    addServiceGeneric<DapGetListOrdersCommand,              QObject*>("DapGetListOrdersCommand",                   "ordersListReceived",                    nullptr);
    addServiceGeneric<DapNetworkSingleSyncCommand,          QObject*>("DapNetworkSingleSyncCommand",               "",                                      nullptr);
    addServiceGeneric<DapGetWalletAddressesCommand,         QObject*>("DapGetWalletAddressesCommand",              "walletAddressesReceived",               nullptr);
    addServiceGeneric<DapGetListWalletsCommand,             QObject*>("DapGetListWalletsCommand",                  "walletsListReceived",                   nullptr);
    addServiceGeneric<DapGetWalletTokenInfoCommand,         QObject*>("DapGetWalletTokenInfoCommand",              "walletTokensReceived",                  nullptr);
    addServiceGeneric<DapGetOnceWalletInfoCommand,          QObject*>("DapGetOnceWalletInfoCommand",               "rcvGetOnceWalletInfoCommand",           nullptr);
    addServiceGeneric<DapMempoolProcessCommand,             QObject*>("DapMempoolProcessCommand",                  "mempoolProcessed",                      nullptr);
    addServiceGeneric<DapGetAllWalletHistoryCommand,        QObject*>("DapGetAllWalletHistoryCommand",             "allWalletHistoryReceived",              nullptr);
    addServiceGeneric<DapRunCmdCommand,                     QObject*>("DapRunCmdCommand",                          "cmdRunned",                             nullptr);
    addServiceGeneric<DapNodeRestart,                       QObject*>("DapNodeRestart",                            "nodeRestart",                           nullptr);
    addServiceGeneric<DapNodeConfigController,              QObject*>("DapNodeConfigController",                   "dapNodeConfigController",               nullptr);
    addServiceGeneric<DapGetListTokensCommand,              QObject*>("DapGetListTokensCommand",                   "tokensListReceived",                    nullptr);
    addServiceGeneric<DapTokenEmissionCommand,              QObject*>("DapTokenEmissionCommand",                   "responseEmissionToken",                 nullptr);
    addServiceGeneric<DapTokenDeclCommand,                  QObject*>("DapTokenDeclCommand",                       "responseDeclToken",                     nullptr);
    addServiceGeneric<DapGetWalletsInfoCommand,             QObject*>("DapGetWalletsInfoCommand",                  "walletsReceived",                       nullptr);
    addServiceGeneric<DapCreateVPNOrder,                    QObject*>("DapCreateVPNOrder",                         "createdVPNOrder",                       nullptr);
    addServiceGeneric<DapCreateStakeOrder,                  QObject*>("DapCreateStakeOrder",                       "createdStakeOrder",                     nullptr);
    addServiceGeneric<DapGetXchangeTokenPair,               QObject*>("DapGetXchangeTokenPair",                    "rcvXchangeTokenPair",                   nullptr);
    addServiceGeneric<DapGetXchangeTokenPriceAverage,       QObject*>("DapGetXchangeTokenPriceAverage",            "rcvXchangeTokenPriceAverage",           nullptr);
    addServiceGeneric<DapGetXchangeTokenPriceHistory,       QObject*>("DapGetXchangeTokenPriceHistory",            "rcvXchangeTokenPriceHistory",           nullptr);
    addServiceGeneric<DapGetXchangeTxList,                  QObject*>("DapGetXchangeTxList",                       "rcvXchangeTxList",                      nullptr);
    addServiceGeneric<DapGetXchangeOrdersList,              QObject*>("DapGetXchangeOrdersList",                   "rcvXchangeOrderList",                   nullptr);
    addServiceGeneric<DapDictionaryCommand,                 QObject*>("DapDictionaryCommand",                      "rcvDictionary",                         nullptr);
    addServiceGeneric<DapWalletActivateOrDeactivateCommand, QObject*>("DapWalletActivateOrDeactivateCommand",      "rcvActivateOrDeactivateReply",          nullptr);
    addServiceGeneric<DapRemoveChainsOrGdbCommand,          QObject*>("DapRemoveChainsOrGdbCommand",               "rcvRemoveResult",                       nullptr);
    addServiceGeneric<DapGetFeeCommand,                     QObject*>("DapGetFeeCommand",                          "rcvFee",                                nullptr);
    addServiceGeneric<DapCreatePassForWallet,               QObject*>("DapCreatePassForWallet",                    "passwordCreated",                       nullptr);
    addServiceGeneric<DapRemoveTransactionsQueueCommand,    QObject*>("DapRemoveTransactionsQueueCommand",         "transactionRemoved",                    nullptr);
    addServiceGeneric<DapCheckTransactionsQueueCommand,     QObject*>("DapCheckTransactionsQueueCommand",          "transactionInfoReceived",               nullptr);
    addServiceGeneric<DapGetListKeysCommand,                QObject*>("DapGetListKeysCommand",                     "rcvGetListKeysCommand",                 nullptr);
    addServiceGeneric<DapAddNodeCommand,                    QObject*>("DapAddNodeCommand",                         "rcvAddNode",                            nullptr);
    addServiceGeneric<DapCheckQueueTransactionCommand,      QObject*>("DapCheckQueueTransactionCommand",           "rcvCheckQueueTransaction",              nullptr);
    addServiceGeneric<MempoolCheckCommand,                  QObject*>("MempoolCheckCommand",                       "rcvMempoolCheckCommand",                nullptr);
    addServiceGeneric<DapNodeListCommand,                   QObject*>("DapNodeListCommand",                        "rcvNodeListCommand",                    nullptr);
    addServiceGeneric<DapGetNetworksStateCommand,           QObject*>("DapGetNetworksStateCommand",                "networkStatesListReceived",             nullptr);
    addServiceGeneric<DapMoveWalletCommand,                 QObject*>("DapMoveWalletCommand",                      "moveWalletCommandReceived",             nullptr);
    addServiceGeneric<DapNetIdCommand,                      QObject*>("DapNetIdCommand",                           "rcvNetIdCommand",                       nullptr);
    addServiceGeneric<DapMempoolListCommand,                QObject*>("DapMempoolListCommand",                     "rcvMempoolListCommand",                 nullptr);
    addServiceGeneric<DapTransactionListCommand,            QObject*>("DapTransactionListCommand",                 "rcvTransactionListCommand",             nullptr);
    addServiceGeneric<DapLedgerTxHashCommand,               QObject*>("DapLedgerTxHashCommand",                    "rcvLedgerTxHashCommand",                nullptr);
    addServiceGeneric<DapNodeDumpCommand,                   QObject*>("DapNodeDumpCommand",                        "rcvNodeDumpCommand",                    nullptr);
    addServiceGeneric<DapGetNodeIPCommand,                  QObject*>("DapGetNodeIPCommand",                       "rcvGetNodeIPCommand",                   nullptr);
    addServiceGeneric<DapGetNodeStatus,                     QObject*>("DapGetNodeStatus",                          "rcvGetNodeStatus",                      nullptr);
    addServiceGeneric<DapGetServiceLimitsCommand,           QObject*>("DapGetServiceLimitsCommand",                "rcvGetServiceLimitsCommand",            nullptr);
    addServiceGeneric<DapVoitingListCommand,                QObject*>("DapVoitingListCommand",                     "rcvVoitingListCommand",                 nullptr);
    addServiceGeneric<DapVoitingDumpCommand,                QObject*>("DapVoitingDumpCommand",                     "rcvVoitingDumpCommand",                 nullptr);
    addServiceGeneric<DapQuitApplicationCommand,            QObject*>("DapQuitApplicationCommand",                 "",                                      m_pServer);
    addServiceGeneric<DapVersionController,                 QObject*>("DapVersionController",                      "versionControllerResult",               m_pServer);
    addServiceGeneric<DapWebConnectRequest,                 QObject*>("DapWebConnectRequest",                      "dapWebConnectRequest",                  m_pServer);
    addServiceGeneric<DapServiceInitCommand,                QObject*>("DapHistoryServiceInitCommand",                        "historyServiceInitRcv",       m_pServer);
    addServiceGeneric<DapServiceInitCommand,                QObject*>("DapWalletServiceInitCommand",                         "walletsServiceInitRcv",       m_pServer);
    addServiceGeneric<DapTransactionsInfoQueueCommand,      QObject*>("DapTransactionsInfoQueueCommand",           "rcvTransactionsInfoQueueCommand",       nullptr);
    addServiceGeneric<DapUpdateLogsCommand, QObject *, QString>    ("DapUpdateLogsCommand",                      "logUpdated",                            nullptr, LOG_FILE);
    addServiceGeneric<DapGetHistoryExecutedCmdCommand, QObject *, QString>  ("DapGetHistoryExecutedCmdCommand",           "historyExecutedCmdReceived",   nullptr, CMD_HISTORY);
    addServiceGeneric<DapSaveHistoryExecutedCmdCommand, QObject *, QString> ("DapSaveHistoryExecutedCmdCommand",          "",                             nullptr, CMD_HISTORY);
    
    connect(this, &DapServiceController::tokensListReceived, [=] (const QVariant& tokensResult)
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

bool DapServiceController::compareJson(QByteArray buff, QVariant data)
{
    json_object *obj = json_object_new_string(data.toByteArray());
    json_object *obj2 = json_object_new_string(buff);

    if(json_object_equal(obj, obj2))
    {
        json_object_put(obj);
        json_object_put(obj2);
        return true;
    }
    json_object_put(obj);
    json_object_put(obj2);

    return false;
}

void DapServiceController::notifySignalsAttach()
{
    connect(m_DapNotifyController, &DapNotifyController::socketState, this, [=] (const bool &status, const bool &isFirstSignal)
    {
        emit signalStateSocket(status, isFirstSignal);
    });

    connect(m_DapNotifyController, &DapNotifyController::netStates, this, [=] (const QVariantMap &netStates)
    {
        emit signalNetState(netStates);
    });

    connect(m_DapNotifyController, &DapNotifyController::chainsLoadProgress, this, [=] (const QVariantMap &progress)
    {
        emit signalChainsLoadProgress(progress);
    });
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

    connect(this, &DapServiceController::onServiceStarted, controller, &DapTransactionQueueController::onInit);

    if(m_transceivers.contains("MempoolCheckCommand"))
    {
        DapAbstractCommand* command = dynamic_cast<DapAbstractCommand*>(m_transceivers["MempoolCheckCommand"]);
        connect(controller, &DapTransactionQueueController::toGetTransactionData, command, &DapAbstractCommand::toDataSignal);
        connect(command, &DapAbstractCommand::dataGetedSignal, controller, &DapTransactionQueueController::transactionDataReceived);
    }
    if(m_transceivers.contains("DapGetOnceWalletInfoCommand"))
    {
        DapAbstractCommand* command = dynamic_cast<DapAbstractCommand*>(m_transceivers["DapGetOnceWalletInfoCommand"]);
        connect(controller, &DapTransactionQueueController::toGetWalletInfo, command, &DapAbstractCommand::toDataSignal);
        connect(command, &DapAbstractCommand::dataGetedSignal, controller, &DapTransactionQueueController::walletInfoReceived);
    }
    if(m_transceivers.contains("DapGetWalletsInfoCommand"))
    {
        DapGetWalletsInfoCommand* command = dynamic_cast<DapGetWalletsInfoCommand*>(m_transceivers["DapGetWalletsInfoCommand"]);
        connect(controller, &DapTransactionQueueController::updateInfoForWallets, command, &DapGetWalletsInfoCommand::queueDataUpdate);
        connect(command, &DapGetWalletsInfoCommand::queuedUpdated,  this, &DapServiceController::sendUpdateWallets);
    }
    if(m_transceivers.contains("DapGetWalletInfoCommand"))
    {
        DapGetWalletInfoCommand* command = dynamic_cast<DapGetWalletInfoCommand*>(m_transceivers["DapGetWalletInfoCommand"]);
        connect(controller, &DapTransactionQueueController::updateInfoForWallets, command, &DapGetWalletInfoCommand::queueDataUpdate);
    }
    if(m_transceivers.contains("DapGetAllWalletHistoryCommand"))
    {
        DapGetAllWalletHistoryCommand* command = dynamic_cast<DapGetAllWalletHistoryCommand*>(m_transceivers["DapGetAllWalletHistoryCommand"]);
        connect(controller, &DapTransactionQueueController::updateHistoryForWallet, command, &DapGetAllWalletHistoryCommand::queueDataUpdate);
        connect(controller, &DapTransactionQueueController::newTransactionAdded, command, &DapGetAllWalletHistoryCommand::transactionFromQueudAdded);
        connect(command, &DapGetAllWalletHistoryCommand::queuedUpdated,  this, &DapServiceController::sendUpdateHistory);
        connect(command, &DapGetAllWalletHistoryCommand::transactionMoved,  controller, &DapTransactionQueueController::updateInfoTransaction);
    }
}

void DapServiceController::sendUpdateHistory(const QVariant& data)
{
    emit historyServiceInitRcv(data);
}

void DapServiceController::sendUpdateWallets(const QVariant& data)
{
    emit walletsServiceInitRcv(data);
}
