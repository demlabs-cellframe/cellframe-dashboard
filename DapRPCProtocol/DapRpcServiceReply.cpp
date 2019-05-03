#include "DapRpcServiceReply.h"

DapRpcServiceReply::DapRpcServiceReply(QObject *apParent)
    : QObject(apParent)
{
}

DapRpcServiceReply::~DapRpcServiceReply()
{

}

void DapRpcServiceReply::setRequest(const DapRpcMessage &aRequest)
{
    m_request = aRequest;
}

void DapRpcServiceReply::setResponse(const DapRpcMessage &aResponse)
{
    m_response = aResponse;
}

DapRpcMessage DapRpcServiceReply::request() const
{
    return m_request;
}

DapRpcMessage DapRpcServiceReply::response() const
{
    return m_response;
}
