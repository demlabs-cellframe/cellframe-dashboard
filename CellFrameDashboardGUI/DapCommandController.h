#ifndef DAPCOMMANDCONTROLLER_H
#define DAPCOMMANDCONTROLLER_H

#include <QObject>
#include <QIODevice>
#include <QVariantMap>
#include <QDebug>

#include "DapRpcSocket.h"
#include "DapRpcServiceProvider.h"
#include "DapRpcService.h"

/// Class command controller for service
class DapCommandController : public DapRpcService, public DapRpcServiceProvider
{
    Q_OBJECT
    Q_DISABLE_COPY(DapCommandController)
    Q_CLASSINFO("serviceName", "RPCClient")
    
    /// RPC socket.
    DapRpcSocket    * m_DAPRpcSocket {nullptr};
    
signals:
    /// The signal is emitted after receiving a response from the service about the command execution.
    void sigCommandResult(QJsonValue );
    /// The signal is emitted when node logs are received from the service.
    /// @param aNodeLogs List of node logs.
    void sigNodeLogsReceived(const QStringList& aNodeLogs);

    /// The signal is emitted when new wallet was added
    /// @param asWalletName Wallet's name
    /// @param asWalletAddress Wallet's address
    void sigWalletAdded(const QString& asWalletName, const QString& asWalletAddress);
    /// The signal is emitted when token was sent
    /// @param asAnswer Answer from service
    void onTokenSended(const QString& asAnswer);

    /// The signal is emitted when receive current wallets
    /// @param aWallets current wallets
    void sigWalletsReceived(const QMap<QString, QVariant>& aWallets);
    /// The signal is emitted when the main application window is activated.
    /// @param aIsActivated Accepts true - when requesting to
    /// display a client, falso - when requesting to hide a client.
    void onClientActivate(bool aIsActivated);
    /// The signal is emitted when the main application window closed
    void onClientClose();
    /// Signal for changing information of wallet
    /// @param asWalletName Wallet's name
    /// @param asWalletAddress Wallet's address
    void sigWalletInfoChanged(const QString& asWalletName, const QString& asWalletAddress, const QStringList& aBalance, const QStringList& aTokens);
    /// Signal for data network
    /// @param Data network
    void sendNodeNetwork(const QVariant& aData);
    /// Signal for sending status of node
    /// @param Status of node
    void sendNodeStatus(const QVariant& aData);
    /// The signal is emitted when execute command result was changed
    /// @param result Result of command
    void executeCommandChanged(const QString& result);
    /// The signal for changing logs
    void onChangeLogModel();
    /// Ths signal for sending new transaction history
    /// @param aData New transaction history
    void sendHistory(const QVariant& aData);
    /// The signal for response from service about command request
    /// @param Responce from service
    void responseConsole(const QString& aResponse);
    /// The signal about changing history of commands
    /// @param aHistory Changed history of commands
    void sigCmdHistory(const QString& aHistory);
    /// The signal for send network list
    /// @param List of networks
    void sendNetworkList(const QStringList& aList);

public:
    /// Overloaded constructor.
    /// @param apIODevice Data transfer device.
    /// @param apParent Parent.
    DapCommandController(QIODevice *apIODevice, QObject *apParent = nullptr);
    
private slots:
    /// Process incoming message.
    /// @param asMessage Incoming message.
    void messageProcessing(const DapRpcMessage &asMessage);
    /// Process the result of the command execution.
    void processCommandResult();
    /// Handling service response for receiving node logs.
    void processGetNodeLogs();
    /// Handling service response for add new wallet
    void processAddWallet();
    /// Handling service response for send token
    void processSendToken();
    /// Handling service response for get wallets
    void processGetWallets();
    /// Handling service response for get information about wallet
    void processGetWalletInfo();
    /// Handling service response for get node network
    void processGetNodeNetwork();
    /// Handling service response for get node status
    void processGetNodeStatus();
    /// Handling service response for execute command from service
    void processExecuteCommand();
    /// Handling service response for get history
    void processGetHistory();
    /// Handling service response for get list network and send to network model
    void processGetNetworkList();
    /// Handling service response for send new history operation to console model
    void processResponseConsole();
    /// Handling service response for changing history of commands
    void processGetCmdHistory();

public slots:
    /// Show or hide GUI client by clicking on the tray icon.
    /// @param aIsActivated Accepts true - when requesting to 
    /// display a client, falso - when requesting to hide a client.
    void activateClient(bool aIsActivated);
    /// Shut down client.
    void closeClient();
    /// Send signal for changing log model
    void processChangedLog();
    /// Add new wallet
    /// @param asWalletName Name of new wallet
    void addWallet(const QString& asWalletName);
    /// Remove wallet
    /// @param asWalletName Name of removing wallet
    void removeWallet(const QString& asWalletName);
    /// Send new token
    /// @param asSendWallet Sent wallet
    /// @param asAddressReceiver Address of receiver
    /// @param asToken Name of token
    /// @param aAmount sum for transaction
    void sendToken(const QString &asSendWallet, const QString& asAddressReceiver, const QString& asToken, const QString& aAmount);
    /// Get wallets
    void getWallets();
    /// Get information about wallet
    /// @param asWalletName Name of wallet
    void getWalletInfo(const QString& asWalletName);
    /// Get node network for explorer
    void getNodeNetwork();
    /// Request about new network list
    void getNetworkList();
    /// Set new status for node
    /// @param aIsOnline New status for node
    void setNodeStatus(const bool aIsOnline);
    /// Execute command
    /// @param command Command for executing
    void executeCommand(const QString& command);

    /// Get node logs.
    void getNodeLogs();

    /// Get transaction history
    void getHistory();
    /// Send to model new history
    /// @param aData New history transaction
    void setNewHistory(const QVariant& aData);
    /// Commands request
    /// @param aQueue Result for command
    void requestConsole(const QString& aQueue);
    /// Get command history
    void getCmdHistory();
    /// Change current network
    /// @param name of network which was selected
    void changeCurrentNetwork(const QString& aNetwork);
};

#endif // COMMANDCONTROLLER_H
