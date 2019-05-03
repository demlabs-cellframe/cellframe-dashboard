#ifndef DapRPCLOCALSERVER_H
#define DapRPCLOCALSERVER_H

#include <QObject>
#include <QLocalSocket>
#include <QLocalServer>

#include "DapRpcSocket.h"
#include "DapRpcService.h"
#include "DapRpcAbstractServer.h"

class DapRpcLocalServer : public QLocalServer, public DapRpcAbstractServer
{
    Q_OBJECT
    Q_DISABLE_COPY(DapRpcLocalServer)

    QHash<QLocalSocket*, DapRpcSocket*> m_socketLookup;

protected:
    virtual void incomingConnection(quintptr aSocketDescriptor);

public:
    explicit DapRpcLocalServer(QObject *apParent = nullptr);
    virtual ~DapRpcLocalServer();

    virtual bool listen(const QString &asAddress = QString(), quint16 aPort = 0);
    bool addService(DapRpcService *apService);
    bool removeService(DapRpcService *apService);

signals:
    void onClientConnected();
    void onClientDisconnected();

private slots:
    void clientDisconnected();
    void messageProcessing(const DapRpcMessage &asMessage);

    // DapRpcAbstractServer interface
public slots:
    void notifyConnectedClients(const DapRpcMessage &message);
    void notifyConnectedClients(const QString &method, const QJsonArray &params);
};

#endif // DapRPCLOCALSERVER_H
