#ifndef DapRPCSERVICEREQUEST_H
#define DapRPCSERVICEREQUEST_H

#include <QPointer>
#include <QMetaObject>
#include <QDebug>

#include "DapRpcMessage.h"

class DapRpcSocket;
class DapRpcServiceRequest
{
    DapRpcMessage m_request;
    QPointer<DapRpcSocket> m_socket;

public:
    DapRpcServiceRequest();
    DapRpcServiceRequest(const DapRpcServiceRequest &aDapRpcServiceRequest);
    DapRpcServiceRequest(const DapRpcMessage &aRequest, DapRpcSocket *apSocket);
    DapRpcServiceRequest &operator=(const DapRpcServiceRequest &aDapRpcServiceRequest);
    ~DapRpcServiceRequest();

    bool isValid() const;
    DapRpcMessage request() const;
    DapRpcSocket *socket() const;

    bool respond(const DapRpcMessage &aResponse);
    bool respond(QVariant aReturnValue);
};

#endif // DapRPCSERVICEREQUEST_H
