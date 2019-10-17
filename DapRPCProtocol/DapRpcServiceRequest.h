#ifndef DapRPCSERVICEREQUEST_H
#define DapRPCSERVICEREQUEST_H

#include <QPointer>
#include <QMetaObject>
#include <QDebug>

#include "DapRpcMessage.h"

class DapRpcSocket;
/**
 * @brief The DapRpcServiceRequest class
 * Class provides to operate with request message by socket interface
 * @see DapRpcSocket
 */
class DapRpcServiceRequest
{
    /// Request message
    DapRpcMessage m_request;
    /// RPC socket
    QPointer<DapRpcSocket> m_socket;

public:
    /// Standard constructor
    DapRpcServiceRequest();
    /// Copy constructor
    DapRpcServiceRequest(const DapRpcServiceRequest &aDapRpcServiceRequest);
    /// Overloaded constructor
    /// @param aRequest Request message
    /// @param apSocket Pointer to RPC socket
    DapRpcServiceRequest(const DapRpcMessage &aRequest, DapRpcSocket *apSocket);
    /// Overloaded assignment operator
    /// @param aDapRpcServiceRequest Other DapRpcServiceRequest object
    /// @return Reference to this object
    DapRpcServiceRequest &operator=(const DapRpcServiceRequest &aDapRpcServiceRequest);
    /// Standard destructor
    ~DapRpcServiceRequest();

    /// Validation of request message
    /// @return If request message is valid or socket is not null return true.
    /// Otherwise return false
    bool isValid() const;
    /// Get request message
    /// @return Request message
    DapRpcMessage request() const;
    /// Get current socket
    /// @return Socket
    DapRpcSocket *socket() const;

    /// Create response to following respont by socket
    /// @param aReturnValue Return value from service
    /// @return False if socket is closed
    bool respond(QVariant aReturnValue);
    /// Send response to socket
    /// @param aResponse Response message
    /// @return False if socket is closed
    bool respond(const DapRpcMessage &aResponse);
};

#endif // DapRPCSERVICEREQUEST_H
