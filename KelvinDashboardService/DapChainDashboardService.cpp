#include "DapChainDashboardService.h"

DapChainDashboardService::DapChainDashboardService(QObject *parent) : QObject(parent)
{
    // Creating a local server to establish connection with the GUI client and then connect to it.
    m_dapLocalServer = new DapLocalServer("Kelvin Client");
    m_dapLocalServer->connectWithClient();
    
    // Signal-slot connection that triggers the identification of a received command.
    connect(m_dapLocalServer, &DapLocalServer::commandRecieved, this, &DapChainDashboardService::identificationCommand);
    // Signal-slot connection, starts processing the user authorization command.
    connect(&m_dapChainDashboardAuth, &DapChainDashboardAuth::onCommandCompleted, m_dapLocalServer, &DapLocalServer::sendCommand);
}

/// Identification of the command received.
/// @param command Command received
/// @return Returns true if the command is identified, otherwise - false.
bool DapChainDashboardService::identificationCommand(const DapCommand &command)
{
    qDebug() << "Identification command: " << command.getTypeCommand();
    switch (command.getTypeCommand()) 
    {
    // User authorization
    case TypeDapCommand::Authorization:
        m_dapChainDashboardAuth.runCommand(command);
        return true;
    default:
        return false;
    }
}

/// Activate the main client window by double-clicking the application icon in the system tray.
/// @param reason Type of action on the icon in the system tray.
void DapChainDashboardService::clientActivated(const QSystemTrayIcon::ActivationReason& reason)
{
    qDebug() << "Client activated";
    switch (reason)
    {
        case QSystemTrayIcon::Trigger:
            {
                if(m_dapLocalServer->isClientExist())
                {
                    qDebug() << "Send command activated";
                    DapCommand *command = new DapCommand(TypeDapCommand::ActivateWindowClient, {true});
                    m_dapLocalServer->sendCommand(*command);
                }
            }
            break;
        default:
            break;
    }
}

/// Shut down client.
void DapChainDashboardService::closeClient()
{
    DapCommand *command = new DapCommand(TypeDapCommand::CloseClient, {true});
    m_dapLocalServer->sendCommand(*command);
}

/// System tray initialization.
void DapChainDashboardService::initTray()
{
    QSystemTrayIcon *trayIconKelvinDashboard = new QSystemTrayIcon();
    trayIconKelvinDashboard->setIcon(QIcon(":/Resources/Icons/icon.ico"));
    trayIconKelvinDashboard->setToolTip("KelvinDashboard");
    QMenu * menuKelvinDashboardService = new QMenu();
    QAction * quitAction = new QAction("Выход");
    menuKelvinDashboardService->addAction(quitAction);
    trayIconKelvinDashboard->setContextMenu(menuKelvinDashboardService);
    trayIconKelvinDashboard->show();
    
    // If the "Exit" menu item is selected, then we shut down the service, 
    // and also send a command to shut down the client.
    connect(quitAction, &QAction::triggered, this, [=]
    {
        closeClient();
        qApp->quit();
    });
    
    // With a double click on the icon in the system tray, 
    // we send a command to the client to activate the main window
    connect(trayIconKelvinDashboard, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(clientActivated(QSystemTrayIcon::ActivationReason)));
}
