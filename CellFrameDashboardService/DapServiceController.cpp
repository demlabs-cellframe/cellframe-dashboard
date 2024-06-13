#include "DapServiceController.h"

#include "handlers/DapAbstractCommand.h"
#include "handlers/DapNetIdCommand.h"
#include "handlers/DapQuitApplicationCommand.h"
#include "handlers/DapActivateClientCommand.h"
#include "handlers/DapUpdateLogsCommand.h"
#include "handlers/DapAddWalletCommand.h"
#include "handlers/DapRemoveWalletCommand.h"
#include "handlers/DapGetListNetworksCommand.h"
#include "handlers/DapGetNetworkStatusCommand.h"
#include "handlers/DapNetworkGoToCommand.h"
#include "handlers/DapGetWalletInfoCommand.h"
#include "handlers/DapGetWalletsInfoCommand.h"
#include "handlers/DapGetWalletAddressesCommand.h"
#include "handlers/stackCommand/DapCreateTransactionCommandStack.h"
#include "handlers/stackCommand/DapSrvStakeDelegateCommandStack.h"
#include "handlers/stackCommand/DapTXCondCreateCommandStack.h"
#include "handlers/stackCommand/DapStakeLockHoldCommandStack.h"
#include "handlers/stackCommand/DapStakeLockTakeCommandStack.h"
#include "handlers/stackCommand/DapCreateJsonTransactionCommandStack.h"
#include "handlers/DapGetOnceWalletInfoCommand.h"
#include "handlers/DapExportLogCommand.h"
#include "handlers/DapGetWalletTokenInfoCommand.h"
#include "handlers/DapMempoolProcessCommand.h"
#include "handlers/DapGetWalletHistoryCommand.h"
#include "handlers/DapGetAllWalletHistoryCommand.h"
#include "handlers/DapRunCmdCommand.h"
#include "handlers/DapGetHistoryExecutedCmdCommand.h"
#include "handlers/DapSaveHistoryExecutedCmdCommand.h"
#include "handlers/DapCertificateManagerCommands.h"
#include "handlers/DapGetListOrdersCommand.h"
#include "handlers/DapGetNetworksStateCommand.h"
#include "handlers/DapNetworkSingleSyncCommand.h"
#include "handlers/DapGetListWalletsCommand.h"
#include "handlers/DapVersionController.h"
#include "handlers/DapRcvNotify.h"
#include "handlers/DapNodeConfigController.h"
#include "handlers/DapGetListTokensCommand.h"
#include "handlers/DapWebConnectRequest.h"
#include "handlers/DapWebBlockList.h"
#include "handlers/DapTokenEmissionCommand.h"
#include "handlers/DapTokenDeclCommand.h"
#include "handlers/DapGetXchangeTxList.h"
#include "handlers/stackCommand/DapXchangeOrderCreateStack.h"
#include "handlers/stackCommand/DapXchangeOrderRemoveStack.h"
#include "handlers/stackCommand/DapXchangeOrderPurchaseStack.h"
#include "handlers/DapGetXchangeOrdersList.h"
#include "handlers/DapGetXchangeTokenPair.h"
#include "handlers/DapGetXchangeTokenPriceAverage.h"
#include "handlers/DapGetXchangeTokenPriceHistory.h"
#include "handlers/DapDictionaryCommand.h"
#include "handlers/DapWalletActivateOrDeactivateCommand.h"
#include "handlers/DapNodeRestart.h"
#include "handlers/DapRemoveChainsOrGdbCommand.h"
#include "handlers/DapGetFeeCommand.h"
#include "handlers/DapCreatePassForWallet.h"
#include "handlers/DapCreateVPNOrder.h"
#include "handlers/DapCreateStakeOrder.h"
#include "handlers/MempoolCheckCommand.h"
#include "handlers/DapMempoolListCommand.h"
#include "handlers/DapTransactionListCommand.h"
#include "handlers/DapLedgerTxHashCommand.h"
#include "handlers/DapGetListKeysCommand.h"
#include "handlers/DapNodeDumpCommand.h"
#include "handlers/DapGetNodeIPCommand.h"
#include "handlers/DapGetNodeStatus.h"
#include "handlers/DapRemoveTransactionsQueueCommand.h"
#include "handlers/DapCheckTransactionsQueueCommand.h"
#include "handlers/DapAddNodeCommand.h"
#include "handlers/DapGetServiceLimitsCommand.h"
#include "handlers/DapServiceInitCommand.h"
#include "TransactionQueue/DapTransactionQueueController.h"

#ifdef Q_OS_WIN
#include "registry.h"
#define LOG_FILE    QString("%1/cellframe-node/var/log/cellframe-node.log").arg(regGetUsrPath())
#define CMD_HISTORY QString("%1/%2/data/cmd_history.txt").arg(regGetUsrPath()).arg(DAP_BRAND)
#endif

#ifdef Q_OS_MAC
#define LOG_FILE QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/log/cellframe-node.log").arg(getenv("USER"))
#define CMD_HISTORY QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/data/cmd_history.txt").arg(getenv("USER"))
#endif

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#include <QAndroidIntent>
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#endif

/// Standard constructor.
/// @param parent Parent.
DapServiceController::DapServiceController(QObject *parent)
    : QObject(parent)
    , m_reqularRequestsCtrl(new DapRegularRequestsController())
{
    connect(this, &DapServiceController::onNewClientConnected, [=] {
        qDebug() << "Frontend connected";
        m_watcher->frontendConnected();
        m_web3Controll->rcvFrontendConnectStatus(true);
    });

    connect(this, &DapServiceController::onClientDisconnected, [=] {
        qDebug() << "Frontend disconnected";
        m_web3Controll->rcvFrontendConnectStatus(false);
    });
}

/// Destructor.
DapServiceController::~DapServiceController()
{

    for(QThread *thread : qAsConst(m_threadPool))
    {
        thread->quit();
        thread->wait();
        delete thread;
    }

    for(DapRpcService *service : qAsConst(m_servicePool))
        service->deleteLater();

    m_threadPool.clear();
    m_servicePool.clear();

    DapTransactionQueueController* controller = DapTransactionQueueController::getTransactionController();
    if(controller)
    {
        controller->deleteTransactionController();
    }

    if(m_threadNotify)
    {
        m_threadNotify->quit();
        m_threadNotify->wait();
        delete m_threadNotify;
    }

    if(m_threadRegular)
    {
        m_threadRegular->quit();
        m_threadRegular->wait();
        delete m_threadRegular;
    }
}

/// Start service: creating server and socket.
/// @return Returns true if the service starts successfully, otherwise false.
bool DapServiceController::start()
{
    qInfo() << "DapChainDashboardService::start()";
    m_pServer = new DapUiService(this);

    m_threadNotify = new QThread();
    m_watcher = new DapNotificationWatcher();
    m_watcher->moveToThread(m_threadNotify);

    connect(m_threadNotify, &QThread::finished, m_watcher, &QObject::deleteLater);
    connect(m_threadNotify, &QThread::finished, m_threadNotify, &QObject::deleteLater);
    m_threadNotify->start();

    m_threadRegular = new QThread();
    m_reqularRequestsCtrl->moveToThread(m_threadRegular);
    connect(m_threadRegular, &QThread::finished, m_reqularRequestsCtrl, &QObject::deleteLater);
    connect(m_threadRegular, &QThread::finished, m_threadRegular, &QObject::deleteLater);
    m_threadRegular->start();

//    m_syncControll = new DapNetSyncController(watcher, this);
    m_web3Controll = new DapWebControllerForService(this);
//    m_versionController = new DapUpdateVersionController(this);
#ifdef Q_OS_ANDROID
    if (m_pServer->listen("127.0.0.1", 22150)) {
        qDebug() << "Listen for UI on 127.0.0.1: " << 22150;
        connect(m_pServer, &DapUiService::onClientConnected, &DapServiceController::onNewClientConnected);
        connect(m_pServer, &DapUiService::onClientDisconnected, &DapServiceController::onNewClientConnected);
        initServices();
    }
#else
    m_pServer->setSocketOptions(QLocalServer::WorldAccessOption);
    if(m_pServer->listen(DAP_BRAND)) 
    {
        connect(m_pServer, &DapUiService::onClientConnected, this,  &DapServiceController::onNewClientConnected);
        connect(m_pServer, &DapUiService::onClientDisconnected, this, &DapServiceController::onClientDisconnected);
        // Register command
        initServices();
        initAdditionalParamrtrsService();
        m_web3Controll->setCommandList(&m_servicePool);
        // Send data from notify socket to client
        connect(m_watcher, &DapNotificationWatcher::rcvNotify, this, &DapServiceController::sendNotifyDataToGui);
        connect(m_watcher, &DapNotificationWatcher::rcvNotify, m_web3Controll, &DapWebControll::rcvNodeStatus);
        // Channel req\rep for web 3 API
        DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_pServer->findService("DapWebConnectRequest"));
        connect(transceiver,    &DapAbstractCommand::clientResponded,  this, &DapServiceController::rcvReplyFromClient);
        connect(m_web3Controll, &DapWebControll::signalConnectRequest, this, &DapServiceController::sendConnectRequest);
        // Regular request controller
        m_reqularRequestsCtrl->start();
    }
#endif
    else
    {
        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
        qCritical() << m_pServer->errorString();
        return false;
    }

    qInfo() << "Service started";
    emit onServiceStarted();
    return true;
}

void DapServiceController::sendNotifyDataToGui(QVariant data)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_pServer->findService("DapRcvNotify"));
    transceiver->notifyToClient(data);
}

void DapServiceController::sendConnectRequest(QString site, int index)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_pServer->findService("DapWebConnectRequest"));
    QJsonArray arr;
    arr.push_back(site);
    arr.push_back(index);
    QJsonDocument doc; doc.setArray(arr);
    transceiver->notifyToClient(doc.toVariant());
}

void DapServiceController::rcvReplyFromClient(QVariant result)
{
    QJsonDocument doc = QJsonDocument::fromJson(result.toString().toUtf8());
    QJsonArray arr = doc.array();
    m_web3Controll->rcvAccept(arr.at(0).toBool(), arr.at(1).toInt());
}

void DapServiceController::rcvBlockListFromClient(QVariant result)
{
    QJsonDocument doc = QJsonDocument::fromJson(result.toString().toUtf8());
    QJsonArray arr = doc.array();
    m_web3Controll->parseBlockList(arr.at(0).toString());
}

void DapServiceController::initServices()
{
    m_servicePool.append(new DapCertificateManagerCommands        ("DapCertificateManagerCommands"        , nullptr, CLI_PATH, TOOLS_PATH));
    m_servicePool.append(new DapActivateClientCommand             ("DapActivateClientCommand"             , nullptr));
    m_servicePool.append(new DapUpdateLogsCommand                 ("DapUpdateLogsCommand"                 , nullptr, LOG_FILE));
    m_servicePool.append(new DapAddWalletCommand                  ("DapAddWalletCommand"                  , nullptr));
    m_servicePool.append(new DapRemoveWalletCommand               ("DapRemoveWalletCommand"               , nullptr));
    m_servicePool.append(new DapGetWalletInfoCommand              ("DapGetWalletInfoCommand"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetWalletsInfoCommand             ("DapGetWalletsInfoCommand"             , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetListNetworksCommand            ("DapGetListNetworksCommand"            , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetNetworkStatusCommand           ("DapGetNetworkStatusCommand"           , nullptr, CLI_PATH));
    m_servicePool.append(new DapNetworkGoToCommand                ("DapNetworkGoToCommand"                , nullptr, CLI_PATH));
    m_servicePool.append(new DapExportLogCommand                  ("DapExportLogCommand"                  , nullptr));
    m_servicePool.append(new DapGetWalletAddressesCommand         ("DapGetWalletAddressesCommand"         , nullptr));
    m_servicePool.append(new DapGetListOrdersCommand              ("DapGetListOrdersCommand"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetNetworksStateCommand           ("DapGetNetworksStateCommand"           , nullptr, CLI_PATH));
    m_servicePool.append(new DapNetIdCommand                      ("DapNetIdCommand"                      , nullptr));
    m_servicePool.append(new DapNetworkSingleSyncCommand          ("DapNetworkSingleSyncCommand"          , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetWalletTokenInfoCommand         ("DapGetWalletTokenInfoCommand"         , nullptr));
    m_servicePool.append(new DapGetListWalletsCommand             ("DapGetListWalletsCommand"             , nullptr, CLI_PATH));
    m_servicePool.append(new DapCreateTransactionCommandStack     ("DapCreateTransactionCommand"          , nullptr, CLI_PATH));
    m_servicePool.append(new DapSrvStakeDelegateCommandStack      ("DapSrvStakeDelegateCommand"          , nullptr, CLI_PATH));
    m_servicePool.append(new DapTXCondCreateCommandStack          ("DapTXCondCreateCommand"               , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetOnceWalletInfoCommand          ("DapGetOnceWalletInfoCommand"          , nullptr, CLI_PATH));
    m_servicePool.append(new DapMempoolProcessCommand             ("DapMempoolProcessCommand"             , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetWalletHistoryCommand           ("DapGetWalletHistoryCommand"           , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetAllWalletHistoryCommand        ("DapGetAllWalletHistoryCommand"        , nullptr, CLI_PATH));
    m_servicePool.append(new DapRunCmdCommand                     ("DapRunCmdCommand"                     , nullptr, CLI_PATH, TOOLS_PATH));
    m_servicePool.append(new DapGetHistoryExecutedCmdCommand      ("DapGetHistoryExecutedCmdCommand"      , nullptr, CMD_HISTORY));
    m_servicePool.append(new DapSaveHistoryExecutedCmdCommand     ("DapSaveHistoryExecutedCmdCommand"     , nullptr, CMD_HISTORY));
    m_servicePool.append(new DapNodeConfigController              ("DapNodeConfigController"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetListTokensCommand              ("DapGetListTokensCommand"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapTokenEmissionCommand              ("DapTokenEmissionCommand"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapTokenDeclCommand                  ("DapTokenDeclCommand"                  , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeTxList                  ("DapGetXchangeTxList"                  , nullptr, CLI_PATH));
    m_servicePool.append(new DapXchangeOrderCreateStack           ("DapXchangeOrderCreate"                , nullptr, CLI_PATH));
    m_servicePool.append(new DapXchangeOrderRemoveStack           ("DapXchangeOrderRemove"                , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeOrdersList              ("DapGetXchangeOrdersList"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeTokenPair               ("DapGetXchangeTokenPair"               , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeTokenPriceAverage       ("DapGetXchangeTokenPriceAverage"       , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeTokenPriceHistory       ("DapGetXchangeTokenPriceHistory"       , nullptr, CLI_PATH));
    m_servicePool.append(new DapDictionaryCommand                 ("DapDictionaryCommand"                 , nullptr, CLI_PATH));
    m_servicePool.append(new DapXchangeOrderPurchaseStack         ("DapXchangeOrderPurchase"              , nullptr));
    m_servicePool.append(new DapWalletActivateOrDeactivateCommand ("DapWalletActivateOrDeactivateCommand" , nullptr, CLI_PATH));
    m_servicePool.append(new DapNodeRestart                       ("DapNodeRestart"                       , nullptr, CLI_PATH));
    m_servicePool.append(new DapRemoveChainsOrGdbCommand          ("DapRemoveChainsOrGdbCommand"          , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetFeeCommand                     ("DapGetFeeCommand"                     , nullptr, CLI_PATH));
    m_servicePool.append(new DapCreatePassForWallet               ("DapCreatePassForWallet"               , nullptr, CLI_PATH));
    m_servicePool.append(new DapCreateVPNOrder                    ("DapCreateVPNOrder"                    , nullptr));
    m_servicePool.append(new DapCreateStakeOrder                  ("DapCreateStakeOrder"                  , nullptr));
    m_servicePool.append(new MempoolCheckCommand                  ("MempoolCheckCommand"                  , nullptr));
    m_servicePool.append(new DapRemoveTransactionsQueueCommand    ("DapRemoveTransactionsQueueCommand"    , nullptr));
    m_servicePool.append(new DapCheckTransactionsQueueCommand     ("DapCheckTransactionsQueueCommand"     , nullptr));
    m_servicePool.append(new DapStakeLockHoldCommandStack         ("DapStakeLockHoldCommand"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapStakeLockTakeCommandStack         ("DapStakeLockTakeCommand"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapCreateJsonTransactionCommandStack ("DapCreateJsonTransactionCommand"      , nullptr, CLI_PATH));
    m_servicePool.append(new DapVersionController                 ("DapVersionController"                 , m_pServer));
    m_servicePool.append(new DapWebConnectRequest                 ("DapWebConnectRequest"                 , m_pServer));
    m_servicePool.append(new DapWebBlockList                      ("DapWebBlockList"                      , m_pServer));
    m_servicePool.append(new DapRcvNotify                         ("DapRcvNotify"                         , m_pServer));
    m_servicePool.append(new DapMempoolListCommand                ("DapMempoolListCommand"                , nullptr, CLI_PATH));
    m_servicePool.append(new DapTransactionListCommand            ("DapTransactionListCommand"            , nullptr, CLI_PATH));
    m_servicePool.append(new DapLedgerTxHashCommand               ("DapLedgerTxHashCommand"               , nullptr));
    m_servicePool.append(new DapGetListKeysCommand                ("DapGetListKeysCommand"                , nullptr));
    m_servicePool.append(new DapNodeDumpCommand                   ("DapNodeDumpCommand"                   , nullptr));
    m_servicePool.append(new DapGetNodeIPCommand                  ("DapGetNodeIPCommand"                  , nullptr));
    m_servicePool.append(new DapGetNodeStatus                     ("DapGetNodeStatus"                     , nullptr));
    m_servicePool.append(new DapAddNodeCommand                    ("DapAddNodeCommand"                    , nullptr));
    m_servicePool.append(new DapGetServiceLimitsCommand           ("DapGetServiceLimitsCommand"           , nullptr));
    m_servicePool.append(new DapQuitApplicationCommand            ("DapQuitApplicationCommand"            , m_pServer));
    m_servicePool.append(new DapServiceInitCommand                ("DapHistoryServiceInitCommand"         , m_pServer));
    m_servicePool.append(new DapServiceInitCommand                ("DapWalletServiceInitCommand"          , m_pServer));

    for(auto& service: qAsConst(m_servicePool))
    {
        if(m_onceThreadList.contains(service->getName()))
        {
            m_pServer->addService(service);
            continue;
        }
        QThread * thread = new QThread(m_pServer);
        service->moveToThread(thread);

        DapAbstractCommand * serviceCommand = dynamic_cast<DapAbstractCommand*>(service);
        if(serviceCommand->isNeedListNetworks())
        {
            connect(m_reqularRequestsCtrl, &DapRegularRequestsController::listNetworksUpdated, serviceCommand, &DapAbstractCommand::rcvListNetworks);

        }
        if(serviceCommand->isNeedListWallets())
        {
            connect(m_reqularRequestsCtrl, &DapRegularRequestsController::listWalletsUpdated, serviceCommand, &DapAbstractCommand::rcvListWallets);
        }

        connect(thread, &QThread::finished, m_pServer, &QObject::deleteLater);
        connect(thread, &QThread::finished, thread, &QObject::deleteLater);
        thread->start();

        m_threadPool.append(thread);
        m_pServer->addService(service);
    }
}

void DapServiceController::initAdditionalParamrtrsService()
{
    if(m_servicePool.isEmpty())
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
    for(auto& service: m_servicePool)
    {
        if(service->getName() == "MempoolCheckCommand")
        {
            DapAbstractCommand* command = dynamic_cast<DapAbstractCommand*>(service);
            connect(controller, &DapTransactionQueueController::toGetTransactionData, command, &DapAbstractCommand::toDataSignal);
            connect(command, &DapAbstractCommand::dataGetedSignal, controller, &DapTransactionQueueController::transactionDataReceived);
        }
        if(service->getName() == "DapGetOnceWalletInfoCommand")
        {
            DapAbstractCommand* command = dynamic_cast<DapAbstractCommand*>(service);
            connect(controller, &DapTransactionQueueController::toGetWalletInfo, command, &DapAbstractCommand::toDataSignal);
            connect(command, &DapAbstractCommand::dataGetedSignal, controller, &DapTransactionQueueController::walletInfoReceived);
        }
        if(service->getName() == "DapGetWalletsInfoCommand")
        {
            DapGetWalletsInfoCommand* command = dynamic_cast<DapGetWalletsInfoCommand*>(service);
            connect(controller, &DapTransactionQueueController::updateInfoForWallets, command, &DapGetWalletsInfoCommand::queueDataUpdate);
            connect(command, &DapGetWalletsInfoCommand::queuedUpdated,  this, &DapServiceController::sendUpdateWallets);
        }
        if(service->getName() == "DapGetWalletInfoCommand")
        {
            DapGetWalletInfoCommand* command = dynamic_cast<DapGetWalletInfoCommand*>(service);
            connect(controller, &DapTransactionQueueController::updateInfoForWallets, command, &DapGetWalletInfoCommand::queueDataUpdate);
        }
        if(service->getName() == "DapGetAllWalletHistoryCommand")
        {
            DapGetAllWalletHistoryCommand* command = dynamic_cast<DapGetAllWalletHistoryCommand*>(service);
            connect(controller, &DapTransactionQueueController::updateHistoryForWallet, command, &DapGetAllWalletHistoryCommand::queueDataUpdate);
            connect(command, &DapGetAllWalletHistoryCommand::queuedUpdated,  this, &DapServiceController::sendUpdateHistory);
        }
    }
}

void DapServiceController::sendUpdateHistory(const QVariant& data)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_pServer->findService("DapHistoryServiceInitCommand"));
    transceiver->notifyToClient(data);
}

void DapServiceController::sendUpdateWallets(const QVariant& data)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_pServer->findService("DapWalletServiceInitCommand"));
    transceiver->notifyToClient(data);
}
