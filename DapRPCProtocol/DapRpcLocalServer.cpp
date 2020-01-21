#include "DapRpcLocalServer.h"

DapRpcLocalServer::DapRpcLocalServer(QObject *apParent)
    : QLocalServer(apParent)
{
    this->setSocketOptions(QLocalServer::WorldAccessOption);
}

DapRpcLocalServer::~DapRpcLocalServer()
{
    foreach (QLocalSocket *socket, m_socketLookup.keys()) {
        socket->flush();
        socket->deleteLater();
    }
    m_socketLookup.clear();

    foreach (DapRpcSocket *client, m_clients)
        client->deleteLater();
    m_clients.clear();
}

bool DapRpcLocalServer::listen(const QString &asAddress, quint16 aPort)
{
    Q_UNUSED(aPort)

    return QLocalServer::listen(asAddress);
}

DapRpcService *DapRpcLocalServer::addService(DapRpcService *apService)
{
    if (!DapRpcServiceProvider::addService(apService))
        return nullptr;

    connect(apService, SIGNAL(notifyConnectedClients(DapRpcMessage)),
               this, SLOT(notifyConnectedClients(DapRpcMessage)));
    connect(apService, SIGNAL(notifyConnectedClients(QString,QJsonArray)),
               this, SLOT(notifyConnectedClients(QString,QJsonArray)));
    return apService;
}

bool DapRpcLocalServer::removeService(DapRpcService *apService)
{
    if (!DapRpcServiceProvider::removeService(apService))
        return false;

    disconnect(apService, SIGNAL(notifyConnectedClients(DapRpcMessage)),
                  this, SLOT(notifyConnectedClients(DapRpcMessage)));
    disconnect(apService, SIGNAL(notifyConnectedClients(QString,QJsonArray)),
                  this, SLOT(notifyConnectedClients(QString,QJsonArray)));
    return true;
}

DapRpcService *DapRpcLocalServer::findService(const QString &asServiceName)
{
    return DapRpcServiceProvider::findService(asServiceName);
}

void DapRpcLocalServer::clientDisconnected()
{
    QLocalSocket *localSocket = static_cast<QLocalSocket*>(sender());
    if (!localSocket) {
        qJsonRpcDebug() << "called with invalid socket";
        return;
    }
    if (m_socketLookup.contains(localSocket)) {
        DapRpcSocket *socket = m_socketLookup.take(localSocket);
        m_clients.removeAll(socket);
        socket->deleteLater();
    }

    localSocket->deleteLater();
    emit onClientDisconnected();
}

void DapRpcLocalServer::messageProcessing(const DapRpcMessage &asMessage)
{
    DapRpcSocket *socket = static_cast<DapRpcSocket*>(sender());
    if (!socket) {
        qJsonRpcDebug() << "called without service socket";
        return;
    }

    processMessage(socket, asMessage);
}

DapRpcServiceReply *DapRpcLocalServer::notifyConnectedClients(const DapRpcMessage &message)
{
    return DapRpcAbstractServer::notifyConnectedClients(message);
}

void DapRpcLocalServer::notifyConnectedClients(const QString &method, const QJsonArray &params)
{
    DapRpcAbstractServer::notifyConnectedClients(method, params);
}

void DapRpcLocalServer::incomingConnection(quintptr aSocketDescriptor)
{
    QLocalSocket *localSocket = new QLocalSocket(this);
    if (!localSocket->setSocketDescriptor(aSocketDescriptor)) {
        qJsonRpcDebug() << "nextPendingConnection is null";
        localSocket->deleteLater();
        return;
    }

    QIODevice *device = qobject_cast<QIODevice*>(localSocket);
    DapRpcSocket *socket = new DapRpcSocket(device, this);
    connect(socket, SIGNAL(messageReceived(DapRpcMessage)),
              this, SLOT(messageProcessing(DapRpcMessage)));
    m_clients.append(socket);
    connect(localSocket, SIGNAL(disconnected()), this, SLOT(clientDisconnected()));
    m_socketLookup.insert(localSocket, socket);
    emit onClientConnected();
}
