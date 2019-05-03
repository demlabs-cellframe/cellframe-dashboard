#ifndef DapRPCTCPSERVER_H
#define DapRPCTCPSERVER_H

#include <QObject>
#include <QTcpSocket>
#include <QTcpServer>

#include "DapRpcSocket.h"
#include "DapRpcAbstractServer.h"

class DapRpcTCPServer : public QTcpServer, public DapRpcAbstractServer
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcTCPServer)

    QHash<QTcpSocket*, DapRpcSocket*> m_socketLookup;

protected:
    virtual void incomingConnection(qintptr aSocketDescriptor);

public:
    explicit DapRpcTCPServer(QObject *apParent = nullptr);
    virtual ~DapRpcTCPServer();

    virtual bool listen(const QString &asAddress = QString(), quint16 aPort = 0);

    bool addService(DapRpcService *apService);
    bool removeService(DapRpcService *apService);

signals:
    void onClientConnected();
    void onClientDisconnected();

protected slots:
    void clientDisconnected();
    void messageProcessing(const DapRpcMessage &asMessage);

    // DapRpcAbstractServer interface
public slots:
    void notifyConnectedClients(const DapRpcMessage &message);
    void notifyConnectedClients(const QString &method, const QJsonArray &params);
};

#endif // DapRPCTCPSERVER_H
