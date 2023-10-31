#include "DapServiceController.h"

#include "handlers/DapAbstractCommand.h"
#include "handlers/DapQuitApplicationCommand.h"
#include "handlers/DapActivateClientCommand.h"
#include "handlers/DapUpdateLogsCommand.h"
#include "handlers/DapAddWalletCommand.h"
#include "handlers/DapGetListNetworksCommand.h"
#include "handlers/DapGetNetworkStatusCommand.h"
#include "handlers/DapNetworkGoToCommand.h"
#include "handlers/DapGetWalletInfoCommand.h"
#include "handlers/DapGetWalletsInfoCommand.h"
#include "handlers/DapGetWalletAddressesCommand.h"
#include "handlers/DapExportLogCommand.h"
#include "handlers/DapGetWalletTokenInfoCommand.h"
#include "handlers/DapCreateTransactionCommandStack.h"
#include "handlers/DapGetOnceWalletInfoCommand.h"
#include "handlers/DapMempoolProcessCommand.h"
#include "handlers/DapGetWalletHistoryCommand.h"
#include "handlers/DapGetAllWalletHistoryCommand.h"
#include "handlers/DapRunCmdCommand.h"
#include "handlers/DapGetHistoryExecutedCmdCommand.h"
#include "handlers/DapSaveHistoryExecutedCmdCommand.h"
#include "handlers/DapCertificateManagerCommands.h"
#include "handlers/DapGetListOdersCommand.h"
#include "handlers/DapGetNetworksStateCommand.h"
#include "handlers/DapNetworkSingleSyncCommand.h"
#include "handlers/DapGetListWalletsCommand.h"
#include "handlers/DapVersionController.h"
#include "handlers/DapRcvNotify.h"
#include "handlers/DapNodeConfigController.h"
#include "handlers/DapGetListTokensCommand.h"
#include "handlers/DapWebConnectRequest.h"
#include "handlers/DapTokenEmissionCommand.h"
#include "handlers/DapTokenDeclCommand.h"
#include "handlers/DapGetXchangeTxList.h"
#include "handlers/DapXchangeOrderCreate.h"
#include "handlers/DapXchangeOrderPurchase.h"
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
#include "handlers/MempoolCheckCommand.h"
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
DapServiceController::DapServiceController(QObject *parent) : QObject(parent)
{
    connect(this, &DapServiceController::onNewClientConnected, [=] {
        qDebug() << "Frontend connected";
        watcher->frontendConnected();
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
        thread->deleteLater();

    for(DapRpcService *service : qAsConst(m_servicePool))
        service->deleteLater();

    m_threadPool.clear();
    m_servicePool.clear();
    DapTransactionQueueController* controller = DapTransactionQueueController::getTransactionController();
    if(controller)
    {
        controller->deleteTransactionController();
    }
}

/// Start service: creating server and socket.
/// @return Returns true if the service starts successfully, otherwise false.
bool DapServiceController::start()
{
    qInfo() << "DapChainDashboardService::start()";
    m_pServer = new DapUiService(this);
    watcher = new DapNotificationWatcher(this);
//    m_syncControll = new DapNetSyncController(watcher, this);
    m_web3Controll = new DapWebControll(this);
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
        // Send data from notify socket to client
        connect(watcher, &DapNotificationWatcher::rcvNotify, this, &DapServiceController::sendNotifyDataToGui);
        connect(watcher, &DapNotificationWatcher::rcvNotify, m_web3Controll, &DapWebControll::rcvNodeStatus);
        // Channel req\rep for web 3 API
        DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_pServer->findService("DapWebConnectRequest"));
        connect(transceiver,    &DapAbstractCommand::clientResponded,  this, &DapServiceController::rcvReplyFromClient);
        connect(m_web3Controll, &DapWebControll::signalConnectRequest, this, &DapServiceController::sendConnectRequest);
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

void DapServiceController::initServices()
{
    m_servicePool.append(new DapCertificateManagerCommands        ("DapCertificateManagerCommands"        , nullptr, CLI_PATH, TOOLS_PATH));
    m_servicePool.append(new DapActivateClientCommand             ("DapActivateClientCommand"             , nullptr));
    m_servicePool.append(new DapUpdateLogsCommand                 ("DapUpdateLogsCommand"                 , nullptr, LOG_FILE));
    m_servicePool.append(new DapAddWalletCommand                  ("DapAddWalletCommand"                  , nullptr));
    m_servicePool.append(new DapGetWalletInfoCommand              ("DapGetWalletInfoCommand"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetWalletsInfoCommand             ("DapGetWalletsInfoCommand"             , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetListNetworksCommand            ("DapGetListNetworksCommand"            , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetNetworkStatusCommand           ("DapGetNetworkStatusCommand"           , nullptr, CLI_PATH));
    m_servicePool.append(new DapNetworkGoToCommand                ("DapNetworkGoToCommand"                , nullptr, CLI_PATH));
    m_servicePool.append(new DapExportLogCommand                  ("DapExportLogCommand"                  , nullptr));
    m_servicePool.append(new DapGetWalletAddressesCommand         ("DapGetWalletAddressesCommand"         , nullptr));
    m_servicePool.append(new DapGetListOrdersCommand              ("DapGetListOrdersCommand"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetNetworksStateCommand           ("DapGetNetworksStateCommand"           , nullptr, CLI_PATH));
    m_servicePool.append(new DapNetworkSingleSyncCommand          ("DapNetworkSingleSyncCommand"          , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetWalletTokenInfoCommand         ("DapGetWalletTokenInfoCommand"         , nullptr));
    m_servicePool.append(new DapGetListWalletsCommand             ("DapGetListWalletsCommand"             , nullptr, CLI_PATH));
    m_servicePool.append(new DapCreateTransactionCommandStack     ("DapCreateTransactionCommand"          , nullptr, CLI_PATH));
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
    m_servicePool.append(new DapXchangeOrderCreate                ("DapXchangeOrderCreate"                , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeOrdersList              ("DapGetXchangeOrdersList"              , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeTokenPair               ("DapGetXchangeTokenPair"               , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeTokenPriceAverage       ("DapGetXchangeTokenPriceAverage"       , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetXchangeTokenPriceHistory       ("DapGetXchangeTokenPriceHistory"       , nullptr, CLI_PATH));
    m_servicePool.append(new DapDictionaryCommand                 ("DapDictionaryCommand"                 , nullptr, CLI_PATH));
    m_servicePool.append(new DapXchangeOrderPurchase              ("DapXchangeOrderPurchase"              , nullptr));
    m_servicePool.append(new DapWalletActivateOrDeactivateCommand ("DapWalletActivateOrDeactivateCommand" , nullptr, CLI_PATH));
    m_servicePool.append(new DapNodeRestart                       ("DapNodeRestart"                       , nullptr, CLI_PATH));
    m_servicePool.append(new DapRemoveChainsOrGdbCommand          ("DapRemoveChainsOrGdbCommand"          , nullptr, CLI_PATH));
    m_servicePool.append(new DapGetFeeCommand                     ("DapGetFeeCommand"                     , nullptr, CLI_PATH));
    m_servicePool.append(new DapCreatePassForWallet               ("DapCreatePassForWallet"               , nullptr, CLI_PATH));
    m_servicePool.append(new MempoolCheckCommand                  ("MempoolCheckCommand"                  , nullptr));

    for(auto service: qAsConst(m_servicePool))
    {
        QThread * thread = new QThread(m_pServer);
        service->moveToThread(thread);
        thread->start();

        m_threadPool.append(thread);
        m_pServer->addService(service);
    }

    //Need server parent for work.
    m_pServer->addService(new DapVersionController      ("DapVersionController"      , m_pServer));
    m_pServer->addService(new DapWebConnectRequest      ("DapWebConnectRequest"      , m_pServer));
    m_pServer->addService(new DapRcvNotify              ("DapRcvNotify"              , m_pServer));
    m_pServer->addService(new DapQuitApplicationCommand ("DapQuitApplicationCommand" , m_pServer));

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
    }
}
