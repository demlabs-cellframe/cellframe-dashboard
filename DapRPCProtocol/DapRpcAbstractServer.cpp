#include "DapRpcAbstractServer.h"

DapRpcAbstractServer::DapRpcAbstractServer()
{

}

DapRpcAbstractServer::~DapRpcAbstractServer()
{

}

int DapRpcAbstractServer::connectedClientCount() const
{
    return m_clients.size();
}

DapRpcServiceReply* DapRpcAbstractServer::notifyConnectedClients(const DapRpcMessage &message)
{
    DapRpcServiceReply * reply {nullptr};
    for (int i = 0; i < m_clients.size(); ++i)
        reply = m_clients[i]->sendMessage(message);
    return reply;
}

void DapRpcAbstractServer::notifyConnectedClients(const QString &method, const QJsonArray &params)
{
    DapRpcMessage notification =
        DapRpcMessage::createNotification(method, params);
    notifyConnectedClients(notification);
}
