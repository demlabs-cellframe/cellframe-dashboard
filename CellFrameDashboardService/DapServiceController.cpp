#include "DapServiceController.h"
#ifdef Q_OS_WIN
#include "registry.h"
#define LOG_FILE    QString("%1/cellframe-node/var/log/cellframe-node.log").arg(regGetUsrPath())
#define CMD_HISTORY QString("%1/%2/data/cmd_history.txt").arg(regGetUsrPath()).arg(DAP_BRAND)
#endif

#ifdef Q_OS_MAC
#define LOG_FILE QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/log/cellframe-node.log").arg(getenv("USER"))
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
    });
}

/// Destructor.
DapServiceController::~DapServiceController()
{

}

/// Start service: creating server and socket.
/// @return Returns true if the service starts successfully, otherwise false.
bool DapServiceController::start()
{
    qInfo() << "DapChainDashboardService::start()";
    m_pServer = new DapUiService(this);
#ifdef Q_OS_ANDROID
    if (m_pServer->listen("127.0.0.1", 22150)) {
        qDebug() << "Listen for UI on 127.0.0.1: " << 22150;
        connect(m_pServer, SIGNAL(onClientConnected()), SIGNAL(onNewClientConnected()));
        registerCommand();
    }
#else
    m_pServer->setSocketOptions(QLocalServer::WorldAccessOption);
    if(m_pServer->listen(DAP_BRAND)) 
    {
        connect(m_pServer, SIGNAL(onClientConnected()), SIGNAL(onNewClientConnected()));
        // Register command
        registerCommand();
        watcher = new DapNotificationWatcher(this);
        connect(watcher, SIGNAL(rcvNotify(QVariant)), this, SLOT(sendNotifyDataToGui(QVariant)));
    }
#endif
    else
    {
        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
        qCritical() << m_pServer->errorString();
        return false;
    }
    return true;
}

void DapServiceController::sendNotifyDataToGui(QVariant data)
{
    qDebug()<< data;
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_pServer->findService("DapRcvNotify"));
    transceiver->notifyToClient(data);
}

/// Register command.
void DapServiceController::registerCommand()
{
    //all certificates commands for module certificate in
    m_pServer->addService(new DapCertificateManagerCommands("DapCertificateManagerCommands", m_pServer, CLI_PATH, TOOLS_PATH));

    // Application shutdown team
    m_pServer->addService(new DapQuitApplicationCommand("DapQuitApplicationCommand", m_pServer));
    // GUI client activation command in case it is minimized/expanded
    m_pServer->addService(new DapActivateClientCommand("DapActivateClientCommand", m_pServer));
    // Log update command on the Logs tab
    m_pServer->addService(new DapUpdateLogsCommand("DapUpdateLogsCommand", m_pServer, LOG_FILE));
    // The team to create a new wallet on the Dashboard tab
    m_pServer->addService(new DapAddWalletCommand("DapAddWalletCommand", m_pServer));
    // Team to get information about wallet
    m_pServer->addService(new DapGetWalletInfoCommand("DapGetWalletInfoCommand", m_pServer, CLI_PATH));
    // Team to get information on all available wallets
    m_pServer->addService(new DapGetWalletsInfoCommand("DapGetWalletsInfoCommand", m_pServer, CLI_PATH));
    // The command to get a list of available networks
    m_pServer->addService(new DapGetListNetworksCommand("DapGetListNetworksCommand", m_pServer, CLI_PATH));
    // The command to get a network status
    m_pServer->addService(new DapGetNetworkStatusCommand("DapGetNetworkStatusCommand", m_pServer, CLI_PATH));
    // The command to get a network status
    m_pServer->addService(new DapNetworkGoToCommand("DapNetworkGoToCommand", m_pServer, CLI_PATH));
    // Saving the file with the logs
    m_pServer->addService(new DapExportLogCommand("DapExportLogCommand", m_pServer));

    m_pServer->addService(new DapGetWalletAddressesCommand("DapGetWalletAddressesCommand", m_pServer));

    // The command to get a list of available orders
    m_pServer->addService(new DapGetListOrdersCommand("DapGetListOrdersCommand", m_pServer, CLI_PATH));

    m_pServer->addService(new DapGetListNetworksCommand("DapGetListNetworksCommand", m_pServer, CLI_PATH));

    m_pServer->addService(new DapGetNetworksStateCommand("DapGetNetworksStateCommand", m_pServer, CLI_PATH));

    m_pServer->addService(new DapNetworkSingleSyncCommand("DapNetworkSingleSyncCommand", m_pServer, CLI_PATH));

    m_pServer->addService(new DapGetWalletTokenInfoCommand("DapGetWalletTokenInfoCommand", m_pServer));
    // Creating a token transfer transaction between wallets
    m_pServer->addService(new DapCreateTransactionCommand("DapCreateTransactionCommand", m_pServer, CLI_PATH));
    // Transaction confirmation
    m_pServer->addService(new DapMempoolProcessCommand("DapMempoolProcessCommand", m_pServer, CLI_PATH));

    m_pServer->addService(new DapGetWalletHistoryCommand("DapGetWalletHistoryCommand", m_pServer, CLI_PATH));
    // Run cli command
    m_pServer->addService(new DapRunCmdCommand("DapRunCmdCommand", m_pServer, CLI_PATH));
    // Get history of commands executed by cli handler
    m_pServer->addService(new DapGetHistoryExecutedCmdCommand("DapGetHistoryExecutedCmdCommand", m_pServer, CMD_HISTORY));
    // Save cmd command in file
    m_pServer->addService(new DapSaveHistoryExecutedCmdCommand("DapSaveHistoryExecutedCmdCommand", m_pServer, CMD_HISTORY));

    m_pServer->addService(new DapRcvNotify("DapRcvNotify", m_pServer));
}
