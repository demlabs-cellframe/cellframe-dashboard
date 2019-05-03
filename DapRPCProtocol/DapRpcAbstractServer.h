#ifndef DapRPCABSTRACTSERVER_H
#define DapRPCABSTRACTSERVER_H

#include <QList>
#include <QHostAddress>

#include "DapRpcSocket.h"
#include "DapRpcMessage.h"
#include "DapRpcServiceProvider.h"

class DapRpcAbstractServer : public DapRpcServiceProvider
{
protected:
    QList<DapRpcSocket*> m_clients;

public:
    DapRpcAbstractServer();

    virtual ~DapRpcAbstractServer();
    virtual int connectedClientCount() const;
    virtual bool listen(const QString &asAddress = QString(), quint16 aPort = 0) = 0;
// signals:
    virtual void onClientConnected() = 0;
    virtual void onClientDisconnected() = 0;

// public slots:
    virtual void notifyConnectedClients(const DapRpcMessage &message);
    virtual void notifyConnectedClients(const QString &method, const QJsonArray &params);
};

#endif // DapRPCABSTRACTSERVER_H
