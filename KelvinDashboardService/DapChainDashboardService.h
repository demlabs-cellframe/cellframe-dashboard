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
//#include <QSystemTrayIcon>
//#include <QMenu>
//#include <QAction>
#include <QCoreApplication>

#include "DapRpcAbstractServer.h"
#include "DapRpcLocalServer.h"
#include "DapRpcTCPServer.h"
#include "DapRpcService.h"

#include "DapChainLogHandler.h"
#include "DapChainWalletHandler.h"

#include <QLocalServer>
typedef class DapRpcLocalServer DapUiService;
typedef class QLocalServer DapUiSocketServer;

class DapChainDashboardService : public DapRpcService
{
    Q_OBJECT
    Q_CLASSINFO("serviceName", "RPCServer")
    /// Service core.
    DapUiService            * m_pServer {nullptr};
    /// Socket of client connection with the service.
    DapUiSocketServer       * m_pSocketService {nullptr};
    /// Log reader.
    DapChainLogHandler            * m_pDapChainLogHandler {nullptr};

    DapChainWalletHandler   * m_pDapChainWalletHandler {nullptr};
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
//    void activateClient(const QSystemTrayIcon::ActivationReason& reason);
    /// Shut down client.
    void closeClient();
    /// System tray initialization.
    //void initTray();
    /// Get node logs.
    /// @param aiTimeStamp Timestamp start reading logging.
    /// @param aiRowCount Number of lines displayed.
    /// @return Logs node.
    QStringList getNodeLogs(int aiTimeStamp, int aiRowCount);

    QStringList addWallet(const QString &asWalletName);
    
    void removeWallet(const QString &asWalletName);

    QMap<QString, QVariant> getWallets();

    QStringList getWalletInfo(const QString &asWalletName);

    QString sendToken(const QString &asWalletName, const QString &asReceiverAddr, const QString &asToken, const QString &asAmount);
    
};

#endif // DAPCHAINDASHBOARDSERVICE_H
