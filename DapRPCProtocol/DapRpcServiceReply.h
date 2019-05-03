#ifndef DapRPCSERVICEREPLY_H
#define DapRPCSERVICEREPLY_H

#include <QObject>
#include <QNetworkReply>

#include "DapRpcMessage.h"

class DapRpcServiceReply : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcServiceReply)
    DapRpcMessage m_request;
    DapRpcMessage m_response;

public:
    explicit DapRpcServiceReply(QObject *apParent = nullptr);
    virtual ~DapRpcServiceReply();

    DapRpcMessage request() const;
    DapRpcMessage response() const;

    void setRequest(const DapRpcMessage &aRequest);
    void setResponse(const DapRpcMessage &aResponse);

signals:
    void finished();
};

#endif // DapRPCSERVICEREPLY_H
