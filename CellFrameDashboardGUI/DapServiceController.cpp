#include "DapServiceController.h"

#include <QThread>
#include "DapNetworkStr.h"

#include "dapconfigreader.h"
#include "NodePathManager.h"

/// Standard constructor.
/// @param apParent Parent.
DapServiceController::DapServiceController(QObject *apParent)
    : QObject(apParent)
{
    m_nodeCliPath =  NodePathManager::getInstance().nodePaths.nodePath_cli;
    m_nodeToolPath = NodePathManager::getInstance().nodePaths.nodePath_tool;

    m_reqularRequestsCtrl = new DapRegularRequestsController(m_nodeCliPath, m_nodeToolPath);

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

    //    for(DapRpcService *service : qAsConst(m_servicePool))
    //        service->deleteLater();

    m_threadPool.clear();
    //    m_servicePool.clear();

    //    DapTransactionQueueController* controller = DapTransactionQueueController::getTransactionController();
    //    if(controller)
    //    {
    //        controller->deleteTransactionController();
    //    }

    //    if(m_threadNotify)
    //    {
    //        m_threadNotify->quit();
    //        m_threadNotify->wait();
    //        delete m_threadNotify;
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
void DapServiceController::init(DapServiceClient *apDapServiceClient)
{
    m_pDapServiceClient = apDapServiceClient;
    m_pDapServiceClientMessage = new DapServiceClientMessage(nullptr);
    connect(m_pDapServiceClient,SIGNAL(sendMessageBox(QString)),m_pDapServiceClientMessage, SLOT(messageBox(QString)));
    // Socket initialization
    m_DAPRpcSocket = new DapRpcSocket(apDapServiceClient->getClientSocket(), this);
    m_pServer = new DapUiService(this);


    m_threadRegular = new QThread();
    m_reqularRequestsCtrl->moveToThread(m_threadRegular);
    connect(m_threadRegular, &QThread::finished, m_reqularRequestsCtrl, &QObject::deleteLater);
    connect(m_threadRegular, &QThread::finished, m_threadRegular, &QObject::deleteLater);
    m_threadRegular->start();

    registerCommand();
    m_reqularRequestsCtrl->start();


    //    m_threadNotify = new QThread();
    //    m_watcher = new DapNotificationWatcher();
    //    m_watcher->moveToThread(m_threadNotify);

    //    connect(m_threadNotify, &QThread::finished, m_watcher, &QObject::deleteLater);
    //    connect(m_threadNotify, &QThread::finished, m_threadNotify, &QObject::deleteLater);
    //    m_threadNotify->start();

    //    m_threadRegular = new QThread();
    //    m_reqularRequestsCtrl->moveToThread(m_threadRegular);
    //    connect(m_threadRegular, &QThread::finished, m_reqularRequestsCtrl, &QObject::deleteLater);
    //    connect(m_threadRegular, &QThread::finished, m_threadRegular, &QObject::deleteLater);
    //    m_threadRegular->start();

    //    m_web3Controll = new DapWebControllerForService(this);
    ////    m_versionController = new DapUpdateVersionController(this);
    //#ifdef Q_OS_ANDROID
    //    if (m_pServer->listen("127.0.0.1", 22150)) {
    //        qDebug() << "Listen for UI on 127.0.0.1: " << 22150;
    //        connect(m_pServer, &DapUiService::onClientConnected, &DapServiceController::onNewClientConnected);
    //        connect(m_pServer, &DapUiService::onClientDisconnected, &DapServiceController::onNewClientConnected);
    //        initServices();
    //    }
    //#else
    //    m_pServer->setSocketOptions(QLocalServer::WorldAccessOption);
    //    if(m_pServer->listen(DAP_BRAND))
    //    {
    //        connect(m_pServer, &DapUiService::onClientConnected, this,  &DapServiceController::onNewClientConnected);
    //        connect(m_pServer, &DapUiService::onClientDisconnected, this, &DapServiceController::onClientDisconnected);
    //        // Register command
    //        initServices();
    //        initAdditionalParamrtrsService();
    //        m_web3Controll->setCommandList(&m_servicePool);
    //        // Send data from notify socket to client
    //        connect(m_watcher, &DapNotificationWatcher::rcvNotify, this, &DapServiceController::sendNotifyDataToGui);
    //        connect(m_watcher, &DapNotificationWatcher::rcvNotify, m_web3Controll, &DapWebControll::rcvNodeStatus);
    //        // Channel req\rep for web 3 API
    //        DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_pServer->findService("DapWebConnectRequest"));
    //        connect(transceiver,    &DapAbstractCommand::clientResponded,  this, &DapServiceController::rcvReplyFromClient);
    //        connect(m_web3Controll, &DapWebControll::signalConnectRequest, this, &DapServiceController::sendConnectRequest);
    //        // Regular request controller
    //
    //    }
    //#endif
    //    else
    //    {
    //        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
    //        qCritical() << m_pServer->errorString();
    //        return false;
    //    }

    //    qInfo() << "Service started";
    //    emit onServiceStarted();
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

//     DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->findService(asServiceName));
// //    qDebug() << "DapServiceController::requestToService, asServiceName:"
// //             << asServiceName << arg1.toString() << arg2.toString()
// //             << arg3.toString() << arg4.toString() << arg5.toString()
// //             << "transceiver:" << transceiver;
//     Q_ASSERT(transceiver);
//     disconnect(transceiver, SIGNAL(serviceResponded(QVariant)), this, SLOT(findEmittedSignal(QVariant)));
//     connect(transceiver, SIGNAL(serviceResponded(QVariant)), SLOT(findEmittedSignal(QVariant)));
//     transceiver->requestToService(args);

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

    if(commandService->isNeedListNetworks())
    {
        connect(m_reqularRequestsCtrl, &DapRegularRequestsController::listNetworksUpdated, commandService, &DapAbstractCommand::rcvListNetworks);
    }

    if(commandService->isNeedListWallets())
    {
        connect(m_reqularRequestsCtrl, &DapRegularRequestsController::listWalletsUpdated, commandService, &DapAbstractCommand::rcvListWallets);
    }

    if(commandService->isNeedFee())
    {
        connect(m_reqularRequestsCtrl, &DapRegularRequestsController::feeUpdated, commandService, &DapAbstractCommand::rcvFee);
        connect(m_reqularRequestsCtrl, &DapRegularRequestsController::feeClear, commandService, &DapAbstractCommand::rcvFeeClear);
    }

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
    QThread * thread = new QThread(this);
//    auto service = m_pServer->addService(commandService);

    commandService->moveToThread(thread);
    thread->start();
    m_threadPool.append(thread);
    m_transceivers.insert(name, commandService);

}

/// Register command.
void DapServiceController::registerCommand()
{
    addService("DapCertificateManagerCommands",             "certificateManagerOperationResult",    new DapCertificateManagerCommands(DapCertificateCommands::serviceName(),            nullptr, m_nodeCliPath, m_nodeToolPath));
    addService("DapActivateClientCommand",                  "clientActivated",                      new DapActivateClientCommand("DapActivateClientCommand",                            nullptr, m_nodeCliPath));
    addService("DapUpdateLogsCommand",                      "logUpdated",                           new DapUpdateLogsCommand("DapUpdateLogsCommand",                                    nullptr, LOG_FILE));
    addService("DapAddWalletCommand",                       "walletCreated",                        new DapAddWalletCommand("DapAddWalletCommand",                                      nullptr, m_nodeCliPath));
    addService("DapRemoveWalletCommand",                    "walletRemoved",                        new DapRemoveWalletCommand("DapRemoveWalletCommand",                                nullptr, m_nodeCliPath));
    addService("DapGetWalletInfoCommand",                   "walletReceived",                       new DapGetWalletInfoCommand("DapGetWalletInfoCommand",                              nullptr, m_nodeCliPath));
    addService("DapExportLogCommand",                       "exportLogs",                           new DapExportLogCommand("DapExportLogCommand",                                      nullptr));
    addService("DapGetListNetworksCommand",                 "networksListReceived",                 new DapGetListNetworksCommand("DapGetListNetworksCommand",                          nullptr, m_nodeCliPath));
    addService("DapGetNetworkStatusCommand",                "networkStatusReceived",                new DapGetNetworkStatusCommand("DapGetNetworkStatusCommand",                        nullptr, m_nodeCliPath));
    addService("DapNetworkGoToCommand",                     "newTargetNetworkStateReceived",        new DapNetworkGoToCommand("DapNetworkGoToCommand",                                  nullptr, m_nodeCliPath));
    addService("DapGetListOrdersCommand",                   "ordersListReceived",                   new DapGetListOrdersCommand("DapGetListOrdersCommand",                              nullptr, m_nodeCliPath));
    addService("DapNetworkSingleSyncCommand",               "",                                     new DapNetworkSingleSyncCommand("DapNetworkSingleSyncCommand",                      nullptr, m_nodeCliPath));
    addService("DapGetWalletAddressesCommand",              "walletAddressesReceived",              new DapGetWalletAddressesCommand("DapGetWalletAddressesCommand",                    nullptr, m_nodeCliPath));
    addService("DapGetListWalletsCommand",                  "walletsListReceived",                  new DapGetListWalletsCommand("DapGetListWalletsCommand",                            nullptr, m_nodeCliPath));
    addService("DapGetWalletTokenInfoCommand",              "walletTokensReceived",                 new DapGetWalletTokenInfoCommand("DapGetWalletTokenInfoCommand",                    nullptr, m_nodeCliPath));
    addService("DapCreateTransactionCommand",               "transactionCreated",                   new DapCreateTransactionCommand("DapCreateTransactionCommand",                      nullptr, m_nodeCliPath));
    addService("DapSrvStakeDelegateCommand",                "srvStakeDelegateCreated",              new DapSrvStakeDelegateCommand("DapSrvStakeDelegateCommand",                        nullptr, m_nodeCliPath));
    addService("DapTXCondCreateCommand",                    "rcvTXCondCreateCommand",               new DapTXCondCreateCommand("DapTXCondCreateCommand",                                nullptr, m_nodeCliPath));
    addService("DapGetOnceWalletInfoCommand",               "rcvGetOnceWalletInfoCommand",          new DapGetOnceWalletInfoCommand("DapGetOnceWalletInfoCommand",                      nullptr, m_nodeCliPath));
    addService("DapMempoolProcessCommand",                  "mempoolProcessed",                     new DapMempoolProcessCommand("DapMempoolProcessCommand",                            nullptr, m_nodeCliPath));
    addService("DapGetWalletHistoryCommand",                "historyReceived",                      new DapGetWalletHistoryCommand("DapGetWalletHistoryCommand",                        nullptr, m_nodeCliPath));
    addService("DapGetAllWalletHistoryCommand",             "allWalletHistoryReceived",             new DapGetAllWalletHistoryCommand("DapGetAllWalletHistoryCommand",                  nullptr, m_nodeCliPath));
    addService("DapRunCmdCommand",                          "cmdRunned",                            new DapRunCmdCommand("DapRunCmdCommand",                                            nullptr, m_nodeCliPath, m_nodeToolPath));
    addService("DapGetHistoryExecutedCmdCommand",           "historyExecutedCmdReceived",           new DapGetHistoryExecutedCmdCommand("DapGetHistoryExecutedCmdCommand",              nullptr, CMD_HISTORY));
    addService("DapSaveHistoryExecutedCmdCommand",          "",                                     new DapSaveHistoryExecutedCmdCommand("DapSaveHistoryExecutedCmdCommand",            nullptr, CMD_HISTORY));
    addService("DapNodeRestart",                            "nodeRestart",                          new DapNodeRestart("DapNodeRestart",                                                nullptr, m_nodeCliPath));
    addService("DapNodeConfigController",                   "dapNodeConfigController",              new DapNodeConfigController("DapNodeConfigController",                              nullptr, m_nodeCliPath));
    addService("DapGetListTokensCommand",                   "tokensListReceived",                   new DapGetListTokensCommand("DapGetListTokensCommand",                              nullptr, m_nodeCliPath));
    addService("DapTokenEmissionCommand",                   "responseEmissionToken",                new DapTokenEmissionCommand("DapTokenEmissionCommand",                              nullptr, m_nodeCliPath));
    addService("DapTokenDeclCommand",                       "responseDeclToken",                    new DapTokenDeclCommand("DapTokenDeclCommand",                                      nullptr, m_nodeCliPath));
    addService("DapGetWalletsInfoCommand",                  "walletsReceived",                      new DapGetWalletsInfoCommand("DapGetWalletsInfoCommand",                            nullptr, m_nodeCliPath));
    addService("DapCreateVPNOrder",                         "createdVPNOrder",                      new DapCreateVPNOrder("DapCreateVPNOrder",                                          nullptr, m_nodeCliPath));
    addService("DapCreateStakeOrder",                       "createdStakeOrder",                    new DapCreateStakeOrder("DapCreateStakeOrder",                                      nullptr, m_nodeCliPath));
    addService("DapGetXchangeTokenPair",                    "rcvXchangeTokenPair",                  new DapGetXchangeTokenPair("DapGetXchangeTokenPair",                                nullptr, m_nodeCliPath));
    addService("DapGetXchangeTokenPriceAverage",            "rcvXchangeTokenPriceAverage",          new DapGetXchangeTokenPriceAverage("DapGetXchangeTokenPriceAverage",                nullptr, m_nodeCliPath));
    addService("DapGetXchangeTokenPriceHistory",            "rcvXchangeTokenPriceHistory",          new DapGetXchangeTokenPriceHistory("DapGetXchangeTokenPriceHistory",                nullptr, m_nodeCliPath));
    addService("DapGetXchangeTxList",                       "rcvXchangeTxList",                     new DapGetXchangeTxList("DapGetXchangeTxList",                                      nullptr, m_nodeCliPath));
    addService("DapXchangeOrderCreate",                     "rcvXchangeCreate",                     new DapXchangeOrderCreate("DapXchangeOrderCreate",                                  nullptr, m_nodeCliPath));
    addService("DapXchangeOrderRemove",                     "rcvXchangeRemove",                     new DapXchangeOrderRemove("DapXchangeOrderRemove",                                  nullptr, m_nodeCliPath));
    addService("DapGetXchangeOrdersList",                   "rcvXchangeOrderList",                  new DapGetXchangeOrdersList("DapGetXchangeOrdersList",                              nullptr, m_nodeCliPath));
    addService("DapDictionaryCommand",                      "rcvDictionary",                        new DapDictionaryCommand("DapDictionaryCommand",                                    nullptr, m_nodeCliPath));
    addService("DapXchangeOrderPurchase",                   "rcvXchangeOrderPurchase",              new DapXchangeOrderPurchase("DapXchangeOrderPurchase",                              nullptr, m_nodeCliPath));
    addService("DapWalletActivateOrDeactivateCommand",      "rcvActivateOrDeactivateReply",         new DapWalletActivateOrDeactivateCommand("DapWalletActivateOrDeactivateCommand",    nullptr, m_nodeCliPath));
    addService("DapRemoveChainsOrGdbCommand",               "rcvRemoveResult",                      new DapRemoveChainsOrGdbCommand("DapRemoveChainsOrGdbCommand",                      nullptr, m_nodeCliPath));
    addService("DapGetFeeCommand",                          "rcvFee",                               new DapGetFeeCommand("DapGetFeeCommand",                                            nullptr, m_nodeCliPath));
    addService("DapCreatePassForWallet",                    "passwordCreated",                      new DapCreatePassForWallet("DapCreatePassForWallet",                                nullptr, m_nodeCliPath));
    addService("DapRemoveTransactionsQueueCommand",         "transactionRemoved",                   new DapRemoveTransactionsQueueCommand("DapRemoveTransactionsQueueCommand",          nullptr, m_nodeCliPath));
    addService("DapCheckTransactionsQueueCommand",          "transactionInfoReceived",              new DapCheckTransactionsQueueCommand("DapCheckTransactionsQueueCommand",            nullptr, m_nodeCliPath));
    addService("DapGetListKeysCommand",                     "rcvGetListKeysCommand",                new DapGetListKeysCommand("DapGetListKeysCommand",                                  nullptr, m_nodeCliPath));
    addService("DapAddNodeCommand",                         "rcvAddNode",                           new DapAddNodeCommand("DapAddNodeCommand",                                          nullptr, m_nodeCliPath));
    addService("DapCheckQueueTransactionCommand",           "rcvCheckQueueTransaction",             new DapCheckQueueTransactionCommand("DapCheckQueueTransactionCommand",              nullptr, m_nodeCliPath));
    addService("MempoolCheckCommand",                       "rcvMempoolCheckCommand",               new MempoolCheckCommand("MempoolCheckCommand",                                      nullptr, m_nodeCliPath));
    addService("DapNodeListCommand",                        "rcvNodeListCommand",                   new DapNodeListCommand("DapNodeListCommand",                                        nullptr, m_nodeCliPath));
    addService("DapGetNetworksStateCommand",                "networkStatesListReceived",            new DapGetNetworksStateCommand("DapGetNetworksStateCommand",                        nullptr, m_nodeCliPath));
    addService("DapMoveWalletCommand",                      "moveWalletCommandReceived",            new DapMoveWalletCommand("DapMoveWalletCommand",                                    nullptr));
    addService("DapNetIdCommand",                           "rcvNetIdCommand",                      new DapNetIdCommand("DapNetIdCommand",                                              nullptr, m_nodeCliPath));
    addService("DapStakeLockHoldCommand",                   "rcvStakeLockHoldCommand",              new DapStakeLockHoldCommand("DapStakeLockHoldCommand",                              nullptr, m_nodeCliPath));
    addService("DapStakeLockTakeCommand",                   "rcvStakeLockTakeCommand",              new DapStakeLockTakeCommand("DapStakeLockTakeCommand",                              nullptr, m_nodeCliPath));
    addService("DapCreateJsonTransactionCommand",           "rcvCreateJsonTransactionCommand",      new DapCreateJsonTransactionCommand("DapCreateJsonTransactionCommand",              nullptr, m_nodeCliPath));
    addService("DapMempoolListCommand",                     "rcvMempoolListCommand",                new DapMempoolListCommand("DapMempoolListCommand",                                  nullptr, m_nodeCliPath));
    addService("DapTransactionListCommand",                 "rcvTransactionListCommand",            new DapTransactionListCommand("DapTransactionListCommand",                          nullptr, m_nodeCliPath));
    addService("DapLedgerTxHashCommand",                    "rcvLedgerTxHashCommand",               new DapLedgerTxHashCommand("DapLedgerTxHashCommand",                                nullptr, m_nodeCliPath));
    addService("DapNodeDumpCommand",                        "rcvNodeDumpCommand",                   new DapNodeDumpCommand("DapNodeDumpCommand",                                        nullptr, m_nodeCliPath));
    addService("DapGetNodeIPCommand",                       "rcvGetNodeIPCommand",                  new DapGetNodeIPCommand("DapGetNodeIPCommand",                                      nullptr, m_nodeCliPath));
    addService("DapGetNodeStatus",                          "rcvGetNodeStatus",                     new DapGetNodeStatus("DapGetNodeStatus",                                            nullptr, m_nodeCliPath));
    addService("DapGetServiceLimitsCommand",                "rcvGetServiceLimitsCommand",           new DapGetServiceLimitsCommand("DapGetServiceLimitsCommand",                        nullptr, m_nodeCliPath));
    addService("DapVoitingCreateCommand",                   "rcvVoitingCreateCommand",              new DapVoitingCreateCommand("DapVoitingCreateCommand",                              nullptr, m_nodeCliPath));
    addService("DapVoitingVoteCommand",                     "rcvVoitingVoteCommand",                new DapVoitingVoteCommand("DapVoitingVoteCommand",                                  nullptr, m_nodeCliPath));
    addService("DapVoitingListCommand",                     "rcvVoitingListCommand",                new DapVoitingListCommand("DapVoitingListCommand",                                  nullptr, m_nodeCliPath));
    addService("DapVoitingDumpCommand",                     "rcvVoitingDumpCommand",                new DapVoitingDumpCommand("DapVoitingDumpCommand",                                  nullptr, m_nodeCliPath));
    addService("DapQuitApplicationCommand",                 "",                                     new DapQuitApplicationCommand("DapQuitApplicationCommand",                          m_pServer));
    addService("DapRcvNotify",                              "dapRcvNotify",                         new DapRcvNotify("DapRcvNotify",                                                    m_pServer));
    addService("DapVersionController",                      "versionControllerResult",              new DapVersionController("DapVersionController",                                    m_pServer, m_nodeCliPath));
    addService("DapWebConnectRequest",                      "dapWebConnectRequest",                 new DapWebConnectRequest("DapWebConnectRequest",                                    m_pServer));
    addService("DapWebBlockList",                           "dapWebBlockList",                      new DapWebBlockList("DapWebBlockList",                                              m_pServer));
    addService("DapHistoryServiceInitCommand",              "historyServiceInitRcv",                new DapServiceInitCommand("DapHistoryServiceInitCommand",                           m_pServer));
    addService("DapWalletServiceInitCommand",               "walletsServiceInitRcv",                new DapServiceInitCommand("DapWalletServiceInitCommand",                            m_pServer));

    connect(this, &DapServiceController::networksListReceived, [=] (const QVariant& rcvData)
    {
        QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
        QJsonObject replyObj = replyDoc.object();
        QJsonArray array = replyObj["result"].toArray();

//        QByteArray  array = QByteArray::fromHex(networksList.toByteArray());
        QList<DapNetworkStr> tempNetworks;

//        QDataStream in(&array, QIODevice::ReadOnly);
//        in >> tempNetworks;

        QList<QObject*> networks;
        auto begin = tempNetworks.begin();
        auto end = tempNetworks.end();
        DapNetworkStr * network = nullptr;
        for(;begin != end; ++begin)
        {
            network = new DapNetworkStr(*begin);
            networks.append(network);
        }

        emit networksReceived(networks);
    });

    connect(this, &DapServiceController::dapRcvNotify, [=] (const QVariant& rcvData)
    {
        m_DapNotifyController->rcvData(rcvData);
    });

    connect(this, &DapServiceController::dapWebConnectRequest, [=] (const QVariant& rcvData)
    {
        qDebug()<<"Rcv web request " << rcvData;
    });

    connect(this, &DapServiceController::dapWebBlockList, [=] (const QVariant& rcvData)
            {
                qDebug() << "Rcv blocklist " << rcvData;
            });

    connect(this, &DapServiceController::tokensListReceived, [=] (const QVariant& tokensResult)
    {
        if(!tokensResult.isValid())
            return ;

//        emit signalTokensListReceived(tokensResult);

        if (tokensResult.toString() == "isEqual")
        {
            qDebug() << "tokensListReceived isEqual";
            emit signalTokensListReceived("isEqual");
        }
        else
        {
            emit signalTokensListReceived(tokensResult);
        }

/*        if(s_bufferTokensJson.isEmpty())
        {
            s_bufferTokensJson = tokensResult.toByteArray();
            emit signalTokensListReceived(tokensResult);
            return ;
        }else{
            if(!compareJson(s_bufferTokensJson, tokensResult))
            {
                s_bufferTokensJson = tokensResult.toByteArray();
                emit signalTokensListReceived(tokensResult);
                return ;
            }
            emit signalTokensListReceived("isEqual");
        }*/
    });
//    registerEmmitedSignal();
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

/// Find the emitted signal.
/// @param aValue Transmitted parameter.
void DapServiceController::findEmittedSignal(const QVariant &aValue)
{
//    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand *>(sender());
//    //qDebug() << "findEmittedSignal, transceiver:" << transceiver  << ", value:" << aValue;
//    Q_ASSERT(transceiver);
//    auto service = std::find_if(m_transceivers.begin(), m_transceivers.end(), [=] (const QPair<DapAbstractCommand*, QString>& it)
//    {
//        return it.first->getName() == transceiver->getName() ? true : false;
//    });

//    for (int idx = 0; idx < metaObject()->methodCount(); ++idx)
//    {
//        const QMetaMethod method = metaObject()->method(idx);
//        if (method.methodType() == QMetaMethod::Signal && method.name() == service->second)
//        {
//            metaObject()->method(idx).invoke(this, Q_ARG(QVariant, aValue));
//        }
//    }
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


/// Register a signal handler for notification results.
void DapServiceController::registerEmmitedSignal()
{
    foreach (auto command, m_transceivers)
    {
        connect(command, SIGNAL(clientNotifed(QVariant)), SLOT(findEmittedSignal(QVariant)));
    }
}

void DapServiceController::notifySignalsAttach()
{
    connect(m_DapNotifyController, SIGNAL(socketState(QString,int,int)), this, SLOT(slotStateSocket(QString,int,int)));
    connect(m_DapNotifyController, SIGNAL(netStates(QVariantMap)), this, SLOT(slotNetState(QVariantMap)));
    connect(m_DapNotifyController, SIGNAL(chainsLoadProgress(QVariantMap)), this, SLOT(slotChainsLoadProgress(QVariantMap)));
}

void DapServiceController::notifySignalsDetach()
{
    disconnect(m_DapNotifyController, SIGNAL(socketState(QString,int,int)), this, SLOT(slotStateSocket(QString,int,int)));
    disconnect(m_DapNotifyController, SIGNAL(netStates(QVariantMap)), this, SLOT(slotNetState(QVariantMap)));
    disconnect(m_DapNotifyController, SIGNAL(chainsLoadProgress(QVariantMap)), this, SLOT(slotChainsLoadProgress(QVariantMap)));
}



