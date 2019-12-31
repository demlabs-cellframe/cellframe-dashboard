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
void DapServiceController::requestToService(const QString &asServicename, const QVariant &arg1,
                                            const QVariant &arg2, const QVariant &arg3, const QVariant &arg4,
                                            const QVariant &arg5, const QVariant &arg6, const QVariant &arg7,
                                            const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
{
    DapAbstractCommand * transceiver = m_transceivers.find(asServicename).value();
    
    Q_ASSERT(transceiver);
    
    transceiver->requestToService(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
    connect(transceiver, SIGNAL(serviceResponded(QVariant)), SLOT(find(QVariant)));
}

/// Register command.
void DapServiceController::registerCommand()
{
     m_transceivers.insert("ADD", new DapAddWalletCommand("ADD", m_DAPRpcSocket, this));
}

/// Find the emitted signal.
/// @param aValue Transmitted parameter.
void DapServiceController::findEmittedSignal(const QVariant &aValue)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand *>(sender());
    
    Q_ASSERT(transceiver);
    
    QString nameSignal = QString("%1Responded").arg(transceiver->getName());
        
    for (int idx = 0; idx < metaObject()->methodCount(); ++idx) 
    {
        const QMetaMethod method = metaObject()->method(idx);
        if (method.methodType() == QMetaMethod::Signal && method.name() == nameSignal) 
        {
            metaObject()->method(idx).invoke(this, Q_ARG(QVariant, aValue));
        }
    }
}

/// Method that implements the singleton pattern for the qml layer.
/// @param engine QML application.
/// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
QObject *DapServiceController::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    
    return &getInstance();
}


