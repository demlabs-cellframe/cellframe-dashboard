#include "DapChainDashboardService.h"

DapChainDashboardService::DapChainDashboardService() : DapRpcService(nullptr)
{
    connect(this, &DapChainDashboardService::onNewClientConnected, [=] {
        qDebug() << "New client";
    });
}

bool DapChainDashboardService::start()
{
    qInfo() << "DapChainDashboardService::start()";
    
    m_pSocketService = new DapUiSocketServer();
    m_pServer = new DapUiService();
    if(m_pServer->listen(DAP_BRAND)) 
    {
        connect(m_pServer, SIGNAL(onClientConnected()), SIGNAL(onNewClientConnected()));
        m_pServer->addService(this);
    }
    else
    {
        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
        return false;
    }
    return true;
}


/// Activate the main client window by double-clicking the application icon in the system tray.
/// @param reason Type of action on the icon in the system tray.
void DapChainDashboardService::activateClient(const QSystemTrayIcon::ActivationReason& reason)
{
    qInfo() << "DapChainDashboardService::activateClient()";
    switch (reason)
    {
        case QSystemTrayIcon::Trigger:
            {
                QJsonArray arguments;
                arguments.append(true);
                m_pServer->notifyConnectedClients("RPCClient.activateClient", arguments);
            }
            break;
        default:
            break;
    }
}

/// Shut down client.
void DapChainDashboardService::closeClient()
{
    qDebug() << "Close client";
    QJsonArray arguments;
    m_pServer->notifyConnectedClients("RPCClient.closeClient", arguments);
    // Signal-slot connection shutting down the service after closing the client
    connect(m_pServer, SIGNAL(onClientDisconnected()), qApp, SLOT(quit()));
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
    });
    
    // With a double click on the icon in the system tray, 
    // we send a command to the client to activate the main window
    connect(trayIconKelvinDashboard, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(activateClient(QSystemTrayIcon::ActivationReason)));
}
