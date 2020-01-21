#ifndef DapRPCABSTRACTSERVER_H
#define DapRPCABSTRACTSERVER_H

#include <QList>
#include <QHostAddress>

#include "DapRpcSocket.h"
#include "DapRpcMessage.h"
#include "DapRpcServiceProvider.h"

/**
 * @brief The DapRpcAbstractServer class
 * Class of abstract RPC server. Include information about all clients
 * Server can send/receive message to/from client by RPC protocol
 */
class DapRpcAbstractServer : public DapRpcServiceProvider
{
protected:
    /// List of clients
    QList<DapRpcSocket*> m_clients;

public:
    /// Standard constructor
    DapRpcAbstractServer();
    /// Virtual destructor
    virtual ~DapRpcAbstractServer();
    /// Connected clients count
    /// @return Clients count
    virtual int connectedClientCount() const;
    /// Tells to server to listen incoming connections on address and port.
    /// @param asAddress Address
    /// @param aPort Port
    /// @return If Server is currently listening then it will return false.
    /// Otherwise return true.
    virtual bool listen(const QString &asAddress = QString(), quint16 aPort = 0) = 0;
// signals:
    /// The signal is emitted when client was connected
    virtual void onClientConnected() = 0;
    /// The signal is emitted when client was disconnected
    virtual void onClientDisconnected() = 0;

// public slots:
    /// Notify connected clients. Send all message
    /// @param message Message to client
    virtual DapRpcServiceReply *notifyConnectedClients(const DapRpcMessage &message);
    /// Notify connected clients. Send all message
    /// @param method Method which clients were notified
    /// @param params Parameters of message in JSON format
    virtual void notifyConnectedClients(const QString &method, const QJsonArray &params);


};

#endif // DapRPCABSTRACTSERVER_H
