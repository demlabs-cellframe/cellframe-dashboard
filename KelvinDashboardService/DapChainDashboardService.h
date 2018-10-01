/****************************************************************************
**
** This file is part of the KelvinDashboardService application.
** 
** The class implements the main application object CalvinDashboardService. 
** It involves the implementation of the interaction of all the components 
** of the service components. For example, identification of commands, 
** control of the authorization mechanism, management of an GUI client, etc.
**
****************************************************************************/

#ifndef DAPCHAINDASHBOARDSERVICE_H
#define DAPCHAINDASHBOARDSERVICE_H

#include <QObject>
#include <QSystemTrayIcon>
#include <QMenu>
#include <QAction>
#include <QApplication>

#include "DapLocalServer.h"
#include "DapChainDashboardAuth.h"

class DapChainDashboardService : public QObject
{
    Q_OBJECT
    
    /// The object responsible for authorization of the user in the application.
    DapChainDashboardAuth   m_dapChainDashboardAuth;
    /// Local server for establishing connection with GUI client.
    DapLocalServer          *m_dapLocalServer;
public:
    /// Standard сonstructor.
    explicit DapChainDashboardService(QObject *parent = nullptr);
    
public slots:
    /// Identification of the command received.
    /// @param command Command received.
    /// @return Returns true if the command is identified, otherwise - false.
    bool identificationCommand(const DapCommand &command);
    /// Activate the main client window by double-clicking the application icon in the system tray.
    /// @param reason Type of action on the icon in the system tray.
    void clientActivated(const QSystemTrayIcon::ActivationReason& reason);
    /// Shut down client.
    void closeClient();
    /// System tray initialization.
    void initTray();
    
};

#endif // DAPCHAINDASHBOARDSERVICE_H
