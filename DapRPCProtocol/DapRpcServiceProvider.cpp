#include "DapRpcServiceProvider.h"
#include "DapRpcSocket.h"

DapRpcServiceProvider::DapRpcServiceProvider()
{
}

DapRpcServiceProvider::~DapRpcServiceProvider()
{
}

QByteArray DapRpcServiceProvider::getServiceName(DapRpcService *apService)
{
    const QMetaObject *mo = apService->metaObject();
    for (int i = 0; i < mo->classInfoCount(); i++)
    {
        const QMetaClassInfo mci = mo->classInfo(i);
        if (mci.name() == QLatin1String("serviceName"))
            return mci.value();
    }

    return QByteArray(mo->className()).toLower();
}

DapRpcService * DapRpcServiceProvider::addService(DapRpcService *apService)
{
    QByteArray serviceName = apService->getName().toUtf8();
    if (serviceName.isEmpty()) {
        qJsonRpcDebug() << "service added without serviceName classinfo, aborting";
        return nullptr;
    }

    if (m_services.contains(serviceName)) {
        qJsonRpcDebug() << "service with name " << serviceName << " already exist";
        return nullptr;
    }

    apService->cacheInvokableInfo();
    m_services.insert(serviceName, apService);
    if (!apService->parent())
        m_cleanupHandler.add(apService);
    return apService;
}

bool DapRpcServiceProvider::removeService(DapRpcService *apService)
{
    QByteArray serviceName = getServiceName(apService);
    if (!m_services.contains(serviceName)) {
        qJsonRpcDebug() << "can not find service with name " << serviceName;
        return false;
    }

    m_cleanupHandler.remove(m_services.value(serviceName));
    m_services.remove(serviceName);
    return true;
}

DapRpcService* DapRpcServiceProvider::findService(const QString &asServiceName)
{
    if (!m_services.contains(QByteArray::fromStdString(asServiceName.toStdString())))
    {
        qJsonRpcDebug() << "can not find service with name " << asServiceName;
        return nullptr;
    }
    return m_services.value(QByteArray::fromStdString(asServiceName.toStdString()));
}

void DapRpcServiceProvider::processMessage(DapRpcSocket *apSocket, const DapRpcMessage &aMessage)
{
    switch (aMessage.type()) {
        case DapRpcMessage::Request:
        case DapRpcMessage::Notification: {
            QByteArray serviceName = aMessage.method().section(".", 0, -2).toLatin1();
            bool b = m_services.contains(serviceName);
            if (serviceName.isEmpty() || !m_services.contains(serviceName))
            {
                if (aMessage.type() == DapRpcMessage::Request)
                {
                    DapRpcMessage error =
                        aMessage.createErrorResponse(DapErrorCode::MethodNotFound,
                            QString("service '%1' not found").arg(serviceName.constData()));
                    apSocket->notify(error);
                }
            } else {
                DapRpcService *service = m_services.value(serviceName);
                service->setCurrentRequest(DapRpcServiceRequest(aMessage, apSocket));
                if (aMessage.type() == DapRpcMessage::Request)
                    QObject::connect(service, SIGNAL(result(DapRpcMessage)),
                                      apSocket, SLOT(notify(DapRpcMessage)), Qt::UniqueConnection);
                DapRpcMessage response = service->dispatch(aMessage);
                if (response.isValid())
                    apSocket->notify(response);
            }
        }
        break;

        case DapRpcMessage::Response:
            break;

        default: {
            DapRpcMessage error =
                aMessage.createErrorResponse(DapErrorCode::InvalidRequest, QString("invalid request"));
            apSocket->notify(error);
            break;
        }
    }
}
