#ifndef DapRPCLOCALSERVER_H
#define DapRPCLOCALSERVER_H

#include <QObject>
#include <QLocalSocket>
#include <QLocalServer>

#include "DapRpcSocket.h"
#include "DapRpcService.h"
#include "DapRpcAbstractServer.h"

/**
 * @brief The DapRpcLocalServer class
 * Local RPC server. inheritance from DapRpcAbstractServer
 * @see DapRpcAbstractServer
 * @see QLocalServer
 */
class DapRpcLocalServer : public QLocalServer, public DapRpcAbstractServer
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcLocalServer)

    /// Hash map socket lookups. LocalSocket according to RPC socket
    QHash<QLocalSocket*, DapRpcSocket*> m_socketLookup;

protected:
    /// Call when new connection is available
    /// @param aSocketDescriptor SocketDescriptor is the native socket descriptor for the accepted connection
    virtual void incomingConnection(quintptr aSocketDescriptor);

public:
    /// Standard constructor
    explicit DapRpcLocalServer(QObject *apParent = nullptr);
    /// Virtual overrided descriptor
    virtual ~DapRpcLocalServer();

    /// Tells to server to listen incoming connections on address and port.
    /// @param asAddress Address
    /// @param aPort Port
    /// @return If Server is currently listening then it will return false.
    /// Otherwise return true.
    virtual bool listen(const QString &asAddress = QString(), quint16 aPort = 0);
    /// Add new service
    /// @param apService New service
    /// @return If service add successfully return true. Otherwise return false
    DapRpcService * addService(DapRpcService *apService);
    /// Remove service
    /// @param apService Service for removing
    /// @return If service add successfully return true. Otherwise return false
    bool removeService(DapRpcService *apService);


    DapRpcService* findService(const QString& asServiceName);
signals:
    /// The signal is emitted when client was connected
    void onClientConnected();
    /// The signal is emitted when client was disconnected
    void onClientDisconnected();

private slots:
    /// Calls when client disconnected
    void clientDisconnected();
    /// When receive message from client prepare message by type of message
    /// @param asMessage Message
    void messageProcessing(const DapRpcMessage &asMessage);

    // DapRpcAbstractServer interface
public slots:
    /// Notify connected clients. Send all message
    /// @param message Message to client
    DapRpcServiceReply * notifyConnectedClients(const DapRpcMessage &message);
    /// Notify connected clients. Send all message
    /// @param method Method which clients were notified
    /// @param params Parameters of message in JSON format
    void notifyConnectedClients(const QString &method, const QJsonArray &params);
};

#endif // DapRPCLOCALSERVER_H
