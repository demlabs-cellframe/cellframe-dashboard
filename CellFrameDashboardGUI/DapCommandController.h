#ifndef DAPCOMMANDCONTROLLER_H
#define DAPCOMMANDCONTROLLER_H

#include <QObject>
#include <QIODevice>
#include <QVariantMap>
#include <QDebug>

#include "DapRpcSocket.h"
#include "DapRpcServiceProvider.h"
#include "DapRpcService.h"
#include "DapChainWallet.h"

/// Class command controller for service
class DapCommandController : public DapRpcService, public DapRpcServiceProvider
{
    Q_OBJECT
    Q_DISABLE_COPY(DapCommandController)
    Q_CLASSINFO("serviceName", "RPCClient")
    
    /// RPC socket.
    DapRpcSocket    * m_DAPRpcSocket {nullptr};

public:
    /// Overloaded constructor.
    /// @param apIODevice Data transfer device.
    /// @param apParent Parent.
    DapCommandController(QIODevice *apIODevice, QObject *apParent = nullptr);
    
private slots:
    /// Process incoming message.
    /// @param asMessage Incoming message.
    void messageProcessing(const DapRpcMessage &asMessage);
};

#endif // COMMANDCONTROLLER_H
