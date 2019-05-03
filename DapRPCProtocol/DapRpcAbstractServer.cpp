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

void DapRpcAbstractServer::notifyConnectedClients(const DapRpcMessage &message)
{
    for (int i = 0; i < m_clients.size(); ++i)
        m_clients[i]->sendMessage(message);
}

void DapRpcAbstractServer::notifyConnectedClients(const QString &method, const QJsonArray &params)
{
    DapRpcMessage notification =
        DapRpcMessage::createNotification(method, params);
    notifyConnectedClients(notification);
}
