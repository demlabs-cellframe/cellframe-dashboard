#ifndef DapRPCSERVICEPROVIDER_H
#define DapRPCSERVICEPROVIDER_H

#include <QScopedPointer>
#include <QObjectCleanupHandler>
#include <QHash>
#include <QMetaObject>
#include <QMetaClassInfo>
#include <QDebug>

#include "DapRpcService.h"

class DapRpcServiceProvider
{
    QHash<QByteArray, DapRpcService*> m_services;
    QObjectCleanupHandler m_cleanupHandler;

protected:
    DapRpcServiceProvider();
    void processMessage(DapRpcSocket *apSocket, const DapRpcMessage &aMessage);

public:
    virtual ~DapRpcServiceProvider();
    virtual bool addService(DapRpcService *apService);
    virtual bool removeService(DapRpcService *apService);
    QByteArray getServiceName(DapRpcService *apService);
};

#endif // DapRPCSERVICEPROVIDER_H
