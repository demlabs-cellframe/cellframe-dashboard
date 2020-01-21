#include "DapServiceController.h"

DapServiceController::DapServiceController(QObject *apParent)
    : QObject(apParent)
{

}

/// Client controller initialization.
/// @param apDapServiceClient Network connection controller.
void DapServiceController::init(DapServiceClient *apDapServiceClient)
{
    m_pDapServiceClient = apDapServiceClient;
    // Socket initialization
    m_DAPRpcSocket = new DapRpcSocket(apDapServiceClient->getClientSocket(), this);
    // Register command.
    registerCommand();
}

/// Get company brand.
/// @return Brand сompany.
QString DapServiceController::getBrand() const
{
    return m_sBrand;
}

/// Get app version.
/// @return Application version.
QString DapServiceController::getVersion() const
{
    return m_sVersion;
}

/// Get an instance of a class.
/// @return Instance of a class.
DapServiceController &DapServiceController::getInstance()
{
    static DapServiceController instance;
    return instance;
}

/// Send request to service.
/// @param arg1...arg10 Parametrs.
void DapServiceController::requestToService(const QString &asServiceName, const QVariant &arg1,
                                            const QVariant &arg2, const QVariant &arg3, const QVariant &arg4,
                                            const QVariant &arg5, const QVariant &arg6, const QVariant &arg7,
                                            const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->findService(asServiceName));
    Q_ASSERT(transceiver);
    connect(transceiver, SIGNAL(serviceResponded(QVariant)), SLOT(findEmittedSignal(QVariant)));
    transceiver->requestToService(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
}

void DapServiceController::notifyService(const QString &asServiceName, const QVariant &arg1,
                                         const QVariant &arg2, const QVariant &arg3, const QVariant &arg4,
                                         const QVariant &arg5, const QVariant &arg6, const QVariant &arg7,
                                         const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->findService(asServiceName));

    Q_ASSERT(transceiver);

    transceiver->notifyToService(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
}

/// Register command.
void DapServiceController::registerCommand()
{
     m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapQuitApplicationCommand("DapQuitApplicationCommand", m_DAPRpcSocket))), QString()));
     m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapActivateClientCommand("DapActivateClientCommand", m_DAPRpcSocket))), QString("clientActivated")));
     m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapUpdateLogsCommand("DapUpdateLogsCommand", m_DAPRpcSocket))), QString("logUpdated")));

     registerEmmitedSignal();
}

/// Find the emitted signal.
/// @param aValue Transmitted parameter.
void DapServiceController::findEmittedSignal(const QVariant &aValue)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand *>(sender());
    
    Q_ASSERT(transceiver);
    auto service = std::find_if(m_transceivers.begin(), m_transceivers.end(), [=] (const QPair<DapAbstractCommand*, QString>& it) 
    {
        return it.first->getName() == transceiver->getName() ? true : false;
    });
        
    for (int idx = 0; idx < metaObject()->methodCount(); ++idx) 
    {
        const QMetaMethod method = metaObject()->method(idx);
        if (method.methodType() == QMetaMethod::Signal && method.name() == service->second)
        {
            metaObject()->method(idx).invoke(this, Q_ARG(QVariant, aValue));
        }
    }
}

void DapServiceController::registerEmmitedSignal()
{
    foreach (auto command, m_transceivers)
    {
        connect(command.first, SIGNAL(clientNotifed(QVariant)), SLOT(findEmittedSignal(QVariant)));
    }
}




