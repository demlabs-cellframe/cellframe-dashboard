#include "DapRpcTCPServer.h"

DapRpcTCPServer::DapRpcTCPServer(QObject *apParent)
    : QTcpServer(apParent)
{

}

DapRpcServiceReply *DapRpcTCPServer::notifyConnectedClients(const DapRpcMessage &message)
{
    DapRpcAbstractServer::notifyConnectedClients(message);
}

void DapRpcTCPServer::notifyConnectedClients(const QString &method, const QJsonArray &params)
{
    DapRpcAbstractServer::notifyConnectedClients(method, params);
}

DapRpcTCPServer::~DapRpcTCPServer()
{
    foreach (QTcpSocket *socket, m_socketLookup.keys()) {
        socket->flush();
        socket->deleteLater();
    }
    m_socketLookup.clear();

    foreach (DapRpcSocket *client, m_clients)
        client->deleteLater();
    m_clients.clear();
}

bool DapRpcTCPServer::listen(const QString &asAddress, quint16 aPort)
{
    return ((asAddress.isNull() || asAddress.isEmpty()) ?
                QTcpServer::listen(QHostAddress::Any, aPort) :
                QTcpServer::listen(QHostAddress(asAddress), aPort));
}

DapRpcService *DapRpcTCPServer::addService(DapRpcService *apService)
{
    if (!DapRpcServiceProvider::addService(apService))
        return nullptr;

    connect(apService, SIGNAL(notifyConnectedClients(DapRpcMessage)),
               this, SLOT(notifyConnectedClients(DapRpcMessage)));
    connect(apService, SIGNAL(notifyConnectedClients(QString,QJsonArray)),
               this, SLOT(notifyConnectedClients(QString,QJsonArray)));
    return apService;
}

bool DapRpcTCPServer::removeService(DapRpcService *apService)
{
    if (!DapRpcServiceProvider::removeService(apService))
        return false;

    disconnect(apService, SIGNAL(notifyConnectedClients(DapRpcMessage)),
                  this, SLOT(notifyConnectedClients(DapRpcMessage)));
    disconnect(apService, SIGNAL(notifyConnectedClients(QString,QJsonArray)),
                  this, SLOT(notifyConnectedClients(QString,QJsonArray)));
    return true;
}

void DapRpcTCPServer::clientDisconnected()
{
    QTcpSocket *tcpSocket = static_cast<QTcpSocket*>(sender());
    if (!tcpSocket) {
        qJsonRpcDebug() << "called with invalid socket";
        return;
    }

    if (m_socketLookup.contains(tcpSocket)) {
        DapRpcSocket *socket = m_socketLookup.take(tcpSocket);
        m_clients.removeAll(socket);
        socket->deleteLater();
    }

    tcpSocket->deleteLater();
    emit onClientDisconnected();
}

void DapRpcTCPServer::messageProcessing(const DapRpcMessage &asMessage)
{
    DapRpcSocket *socket = static_cast<DapRpcSocket*>(sender());
    if (!socket) {
        qJsonRpcDebug() << "called without service socket";
        return;
    }

    processMessage(socket, asMessage);
}

void DapRpcTCPServer::incomingConnection(qintptr aSocketDescriptor)
{
    QTcpSocket *tcpSocket = new QTcpSocket(this);
    if (!tcpSocket->setSocketDescriptor(aSocketDescriptor))
    {
        qJsonRpcDebug() << "can't set socket descriptor";
        tcpSocket->deleteLater();
        return;
    }

    QIODevice *device = qobject_cast<QIODevice*>(tcpSocket);
    DapRpcSocket *socket = new DapRpcSocket(device, this);
    connect(socket, SIGNAL(messageReceived(DapRpcMessage)),
              this, SLOT(_q_processMessage(DapRpcMessage)));
    m_clients.append(socket);
    connect(tcpSocket, SIGNAL(disconnected()), this, SLOT(_q_clientDisconnected()));
    m_socketLookup.insert(tcpSocket, socket);
    emit onClientConnected();
}
