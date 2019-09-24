/****************************************************************************
**
** This file is part of the CellFrameDashboardService application.
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
#include "DapChainNodeNetworkHandler.h"
#include "DapChainHistoryHandler.h"

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
    /// Recipient wallet inforamtion
    DapChainWalletHandler   * m_pDapChainWalletHandler {nullptr};
    /// Recipient node network
    DapChainNodeNetworkHandler     * m_pDapChainNodeHandler {nullptr};
    /// Recipient history of transactions
    DapChainHistoryHandler* m_pDapChainHistoryHandler {nullptr};

public:
    /// Standard сonstructor.
    explicit DapChainDashboardService();
    
    bool start();
    
signals:
    /// The signal is emitted in case of successful connection of a new client.
    void onNewClientConnected();
    
public slots:
    void changedLogModel();
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
    /// Add new wallet
    QStringList addWallet(const QString &asWalletName);
    /// Remove wallet
    void removeWallet(const QString &asWalletName);
    /// Get wallet
    /// @return data for wallets
    QMap<QString, QVariant> getWallets();
    /// Get information of wallet such as balance, currencies
    /// @param number of wallet
    /// @return data for the wallet
    QStringList getWalletInfo(const QString &asWalletName);
    /// Create new transactio
    /// @param name of wallet
    /// @param address of a receiver
    /// @param name of token
    /// @param sum for transaction
    /// @return result of trasaction
    QString sendToken(const QString &asWalletName, const QString &asReceiverAddr, const QString &asToken, const QString &asAmount);
    /// Get node network
    /// @return QMap node network
    QVariant getNodeNetwork() const;
    /// Receive new status for node
    /// @param true if online
    void setNodeStatus(const bool aIsOnline);
    /// Get history
    /// @return QList data history
    QVariant getHistory() const;

private slots:
    void doRequestWallets();
    void doSendNewHistory(const QVariant& aData);
};

#endif // DAPCHAINDASHBOARDSERVICE_H
