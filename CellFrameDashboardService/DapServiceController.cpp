#include "DapServiceController.h"

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
    delete m_pToolTipWidget;
    delete menuSystemTrayIcon;
}

/// Start service: creating server and socket.
/// @return Returns true if the service starts successfully, otherwise false.
bool DapServiceController::start()
{
    qInfo() << "DapChainDashboardService::start()";
    
    m_pServer = new DapUiService(this);
    m_pServer->setSocketOptions(QLocalServer::WorldAccessOption);
    if(m_pServer->listen(DAP_BRAND)) 
    {
        connect(m_pServer, SIGNAL(onClientConnected()), SIGNAL(onNewClientConnected()));
        // Register command
        registerCommand();
        // Initialize system tray
        initSystemTrayIcon();
    }
    else
    {
        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
        qCritical() << m_pServer->errorString();
        return false;
    }
    return true;
}

/// Register command.
void DapServiceController::registerCommand()
{
    // Application shutdown team
    m_pServer->addService(new DapQuitApplicationCommand("DapQuitApplicationCommand", m_pServer));
    // GUI client activation command in case it is minimized/expanded
    m_pServer->addService(new DapActivateClientCommand("DapActivateClientCommand", m_pServer));
    // Log update command on the Logs tab
    m_pServer->addService(new DapUpdateLogsCommand("DapUpdateLogsCommand", m_pServer, LOG_FILE));
    // The team to create a new wallet on the Dashboard tab
    m_pServer->addService(new DapAddWalletCommand("DapAddWalletCommand", m_pServer));
    // The command to get a list of available wallets
    m_pServer->addService(new DapGetListWalletsCommand("DapGetListWalletsCommand", m_pServer, CLI_PATH));
    // The command to get a list of available networks
    m_pServer->addService(new DapGetListNetworksCommand("DapGetListNetworksCommand", m_pServer, CLI_PATH));
    // Saving the file with the logs
    m_pServer->addService(new DapExportLogCommand("DapExportLogCommand", m_pServer));

    m_pServer->addService(new DapGetWalletAddressesCommand("DapGetWalletAddressesCommand", m_pServer));

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
}

/// Initialize system tray.
void DapServiceController::initSystemTrayIcon()
{
    m_pToolTipWidget = new DapToolTipWidget();
    m_pSystemTrayIcon = new DapSystemTrayIcon(this);
    m_pSystemTrayIcon->setToolTipWidget(m_pToolTipWidget);
    m_pSystemTrayIcon->setIcon(QIcon(":/res/icons/icon.ico"));
    menuSystemTrayIcon = new QMenu();
    QAction * quitAction = new QAction("Quit", this);
    menuSystemTrayIcon->addAction(quitAction);
    m_pSystemTrayIcon->setContextMenu(menuSystemTrayIcon);
    m_pSystemTrayIcon->show();

    // If the "Quit" menu item is selected, then we shut down the service,
    // and also send a command to shut down the client.
    connect(quitAction, &QAction::triggered, this, [=]
    {
        DapQuitApplicationCommand * command = dynamic_cast<DapQuitApplicationCommand*>(m_pServer->findService("DapQuitApplicationCommand"));
        Q_ASSERT(command);
        command->notifyToClient();
    });

    // With a double click on the icon in the system tray,
    // we send a command to the client to activate the main window
    connect(m_pSystemTrayIcon, &DapSystemTrayIcon::activated, this, [=] (const QSystemTrayIcon::ActivationReason& reason)
    {
        Q_UNUSED(reason);
        DapActivateClientCommand * command = dynamic_cast<DapActivateClientCommand*>(m_pServer->findService("DapActivateClientCommand"));
        Q_ASSERT(command);
        command->notifyToClient();
    });

}
