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

#include "DapRpcAbstractServer.h"
#include "DapRpcLocalServer.h"
#include "DapRpcTCPServer.h"
#include "DapRpcService.h"

#include <QLocalServer>
typedef class DapRpcLocalServer DapUiService;
typedef class QLocalServer DapUiSocketServer;

class DapChainDashboardService : public DapRpcService
{
    Q_OBJECT
    Q_CLASSINFO("serviceName", "RPCServer")
    DapUiService            * m_pServer {nullptr};
    DapUiSocketServer       * m_pSocketService {nullptr};
public:
    /// Standard сonstructor.
    explicit DapChainDashboardService();
    
    bool start();
    
signals:
    /// The signal is emitted in case of successful connection of a new client.
    void onNewClientConnected();
    
public slots:
    /// Activate the main client window by double-clicking the application icon in the system tray.
    /// @param reason Type of action on the icon in the system tray.
    void activateClient(const QSystemTrayIcon::ActivationReason& reason);
    /// Shut down client.
    void closeClient();
    /// System tray initialization.
    void initTray();
    
};

#endif // DAPCHAINDASHBOARDSERVICE_H
