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
#include "DapChainNetworkHandler.h"
#include "DapChainConsoleHandler.h"

#include <QLocalServer>
typedef class DapRpcLocalServer DapUiService;

/**
 * @brief The DapChainDashboardService class
 * Service class which provide handle operations with dashboard.
 * Class is server which works clients. Protocol to communacate with client is RPC.
 * Work with serves start from public methos start().
 * Class consist of follow handlers:
 * @see DapChainLogHandler
 * @see DapChainWalletHandler
 * @see DapChainNodeNetworkHandler
 * @see DapChainHistoryHandler
 * @see DapChainConsoleHandler
 * @see DapChainNetworkHandler
 */
class DapChainDashboardService : public DapRpcService
{
    Q_OBJECT
    Q_CLASSINFO("serviceName", "RPCServer")
    /// Service core.
    DapUiService            * m_pServer {nullptr};
    /// Recipient logs information
    DapChainLogHandler            * m_pDapChainLogHandler {nullptr};
    /// Recipient wallet information
    DapChainWalletHandler   * m_pDapChainWalletHandler {nullptr};
    /// Recipient node network
    DapChainNodeNetworkHandler     * m_pDapChainNodeHandler {nullptr};
    /// Recipient history of transactions
    DapChainHistoryHandler* m_pDapChainHistoryHandler {nullptr};
    /// Recipient history of commands
    DapChainConsoleHandler* m_pDapChainConsoleHandler {nullptr};
    /// Recipient network's name
    DapChainNetworkHandler* m_pDapChainNetworkHandler {nullptr};

public:
    /// Standard сonstructor.
    explicit DapChainDashboardService();
    /// Start service: creating server and socket
    bool start();
    
signals:
    /// The signal is emitted in case of successful connection of a new client.
    void onNewClientConnected();
    // TODO get structure Settings which has method fill from jsonDocument
    /// The signal is emitted in case of need to save setting
    void onSaveSetting();
    
public slots:
    /// Change log model
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
    /// Get network list
    /// @return Network list
    QStringList getNetworkList() const;
    /// Change current network
    /// @param name of network whcih was selected
    void changeCurrentNetwork(const QString& aNetwork);
    /// Get result for command
    /// @param command
    /// @return result
    QString getQueryResult(const QString& aQuery) const;
    /// Get history of commands
    /// @return history of last 50 commands
    QString getCmdHistory() const;

    bool appendWallet(const QString& aWalletName) const;

    QByteArray walletData() const;

private slots:
    /// Request new history request by handle wallet's name
    void doRequestWallets();
    /// Send new history transaction to client
    /// @param New history transaction
    void doSendNewHistory(const QVariant& aData);

    void doSendNewWalletData(const QByteArray& aData);
};

#endif // DAPCHAINDASHBOARDSERVICE_H
