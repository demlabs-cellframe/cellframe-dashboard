#ifndef DapRPCTCPSERVER_H
#define DapRPCTCPSERVER_H

#include <QObject>
#include <QTcpSocket>
#include <QTcpServer>

#include "DapRpcSocket.h"
#include "DapRpcAbstractServer.h"

/**
 * @brief The DapRpcTCPServer class
 * TCP server class realize interface DapRpcAbstractServer
 * @see DapRpcAbstractServer
 * @see QTcpServer
 */
class DapRpcTCPServer : public QTcpServer, public DapRpcAbstractServer
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcTCPServer)
    /// Lookup's tcp sockets witj Rpc sockets
    QHash<QTcpSocket*, DapRpcSocket*> m_socketLookup;

protected:
    /// This virtual function is called by QTcpServer when a new connection is available
    /// @param aSocketDescriptor The socketDescriptor argument is the native socket
    /// descriptor for the accepted connection
    virtual void incomingConnection(qintptr aSocketDescriptor);

public:
    /// Standard constructor
    explicit DapRpcTCPServer(QObject *apParent = nullptr);
    /// Virtual destructor
    virtual ~DapRpcTCPServer();

    /// Tells the server to listen for incoming connections on address
    /// @param asAddress Address
    /// @param aPort Port. If port is 0, a port is chosen automatically
    /// @param If address is QHostAddress::Any, the server will listen on all network interfaces
    /// @return Returns true on success; otherwise returns false.
    /// @see isListening()
    virtual bool listen(const QString &asAddress = QString(), quint16 aPort = 0);
    /// Add new service
    /// @param apService New service
    /// @return If service add successfully return true. Otherwise return false
    DapRpcService * addService(DapRpcService *apService);
    /// Remove service
    /// @param apService Service for removing
    /// @return If service add successfully return true. Otherwise return false
    bool removeService(DapRpcService *apService);

signals:
    /// The signal is emitted when client was connected
    void onClientConnected();
    /// The signal is emitted when client was disconnected
    void onClientDisconnected();

protected slots:
    /// Calls when client disconnected
    void clientDisconnected();
    /// When receive message from client prepare message by type of message
    /// @param asMessage Message
    void messageProcessing(const DapRpcMessage &asMessage);

    // DapRpcAbstractServer interface
public slots:
    /// Notify connected clients. Send all message
    /// @param message Message to client
    DapRpcServiceReply* notifyConnectedClients(const DapRpcMessage &message);
    /// Notify connected clients. Send all message
    /// @param method Method which clients were notified
    /// @param params Parameters of message in JSON format
    void notifyConnectedClients(const QString &method, const QJsonArray &params);
};

#endif // DapRPCTCPSERVER_H
