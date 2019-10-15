#ifndef DapRPCSERVICEREPLY_H
#define DapRPCSERVICEREPLY_H

#include <QObject>
#include <QNetworkReply>

#include "DapRpcMessage.h"

/**
 * @brief The DapRpcServiceReply class
 * Class provides service reply from sender.
 * Class has methods to operate with response and request
 */
class DapRpcServiceReply : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcServiceReply)
    /// Request message
    DapRpcMessage m_request;
    /// Response message
    DapRpcMessage m_response;

public:
    /// Standard constructor
    explicit DapRpcServiceReply(QObject *apParent = nullptr);
    /// Virtual destructor
    virtual ~DapRpcServiceReply();

    /// Get request message
    /// @return Request message
    DapRpcMessage request() const;
    /// Get response message
    /// @return Response message
    DapRpcMessage response() const;

    /// Set request message
    /// @param aRequest New request message
    void setRequest(const DapRpcMessage &aRequest);
    /// Set response message
    /// @param aResponse Responce message
    void setResponse(const DapRpcMessage &aResponse);

signals:
    /// The signal is emitted when reply finished
    void finished();
};

#endif // DapRPCSERVICEREPLY_H
