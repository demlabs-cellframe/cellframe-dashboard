#ifndef DapRPCSERVICEPROVIDER_H
#define DapRPCSERVICEPROVIDER_H

#include <QScopedPointer>
#include <QObjectCleanupHandler>
#include <QHash>
#include <QMetaObject>
#include <QMetaClassInfo>
#include <QDebug>

#include "DapRpcService.h"

/**
 * @brief The DapRpcServiceProvider class
 * Class provides to add/remove services and store them.
 */
class DapRpcServiceProvider
{
    /// Store pointers to service by the name
    QHash<QByteArray, DapRpcService*> m_services;
    /// Handle service to cleanup
    QObjectCleanupHandler m_cleanupHandler;

protected:
    /// Standard constructor
    DapRpcServiceProvider();
    /// Process message to send by socket interface
    /// @param apSocket Remote socket
    /// aMessage Rpc message
    void processMessage(DapRpcSocket *apSocket, const DapRpcMessage &aMessage);

public:
    /// Virtual destructor
    virtual ~DapRpcServiceProvider();
    /// Add new service
    /// @param apService New service
    /// @return True if service add successfullym false if not
    virtual DapRpcService *addService(DapRpcService *apService);
    /// Remove existing service
    /// @param apService Service to remove
    /// @return If service alreade removing or not existing return false, else return true
    virtual bool removeService(DapRpcService *apService);

    virtual DapRpcService *findService(const QString& asServiceName);
    /// Get service name
    /// @param apService Service
    /// @return Serilization name of service
    QByteArray getServiceName(DapRpcService *apService);
};

#endif // DapRPCSERVICEPROVIDER_H
