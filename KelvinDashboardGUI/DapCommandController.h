#ifndef DAPCOMMANDCONTROLLER_H
#define DAPCOMMANDCONTROLLER_H

#include <QObject>
#include <QIODevice>
#include <QVariantMap>
#include <QDebug>

#include "DapRpcSocket.h"
#include "DapRpcServiceProvider.h"
#include "DapRpcService.h"

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

    void sigWalletAdded(const QString& asWalletName, const QString& asWalletAddress);
    void onTokenSended(const QString& asAnswer);

    void sigWalletsReceived(const QMap<QString, QVariant>& aWallets);
    /// The signal is emitted when the main application window is activated.
    void onClientActivate(bool aIsActivated);
    
    void onClientClose();

    void sigWalletInfoChanged(const QString& asWalletName, const QString& asWalletAddress, const QStringList& aBalance, const QStringList& aTokens);
    
    void executeCommandChanged(const QString& result);
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

    void processAddWallet();
    void processSendToken();
    void processGetWallets();

    void processGetWalletInfo();
    
    void processExecuteCommand();
public slots:
    /// Show or hide GUI client by clicking on the tray icon.
    /// @param aIsActivated Accepts true - when requesting to 
    /// display a client, falso - when requesting to hide a client.
    void activateClient(bool aIsActivated);
    /// Shut down client.
    void closeClient();
    /// Get node logs.
    /// @param aiTimeStamp Timestamp start reading logging.
    /// @param aiRowCount Number of lines displayed.
    void getNodeLogs(int aiTimeStamp, int aiRowCount);

    void addWallet(const QString& asWalletName);
    void removeWallet(const QString& asWalletName);
    void sendToken(const QString &asSendWallet, const QString& asAddressReceiver, const QString& asToken, const QString& aAmount);

    void getWallets();

    void getWalletInfo(const QString& asWalletName);

    void executeCommand(const QString& command);
};

#endif // COMMANDCONTROLLER_H
