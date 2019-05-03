#include "DapRpcSocket.h"
#include "DapRpcServiceRequest.h"


DapRpcServiceRequest::DapRpcServiceRequest()
{
}

DapRpcServiceRequest::~DapRpcServiceRequest()
{
}

DapRpcServiceRequest::DapRpcServiceRequest(const DapRpcServiceRequest &aDapRpcServiceRequest)
{
    m_request = aDapRpcServiceRequest.m_request;
    m_socket = aDapRpcServiceRequest.m_socket;
}

DapRpcServiceRequest::DapRpcServiceRequest(const DapRpcMessage &aRequest,
                                               DapRpcSocket *apSocket)
{
    m_request = aRequest;
    m_socket = apSocket;
}

DapRpcServiceRequest &DapRpcServiceRequest::operator=(const DapRpcServiceRequest &other)
{
    m_request = other.m_request;
    m_socket = other.m_socket;
    return *this;
}

bool DapRpcServiceRequest::isValid() const
{
    return (m_request.isValid() && !m_socket.isNull());
}

DapRpcMessage DapRpcServiceRequest::request() const
{
    return m_request;
}

DapRpcSocket *DapRpcServiceRequest::socket() const
{
    return m_socket;
}

bool DapRpcServiceRequest::respond(QVariant aReturnValue)
{
    if (!m_socket) {
        qJsonRpcDebug() << "socket was closed";
        return false;
    }

    DapRpcMessage response =
        m_request.createResponse(DapRpcService::convertReturnValue(aReturnValue));
    return respond(response);
}

bool DapRpcServiceRequest::respond(const DapRpcMessage &aResponse)
{
    if (!m_socket) {
        qJsonRpcDebug() << "socket was closed";
        return false;
    }

    QMetaObject::invokeMethod(m_socket, "notify", Q_ARG(DapRpcMessage, aResponse));
    return true;
}
