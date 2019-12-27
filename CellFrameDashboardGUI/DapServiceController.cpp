#include "DapServiceController.h"

DapServiceController::DapServiceController(QObject *apParent)
    : QObject(apParent)
{
    
}

/// Get company brand.
/// @return Brand сompany.
void DapServiceController::init(DapServiceClient *apDapServiceClient)
{
    m_pDapServiceClient = apDapServiceClient;
    
    // Creating rpc controller
    m_pDapCommandController = new DapCommandController(apDapServiceClient->getClientSocket(), this);
    
}

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

/// Method that implements the singleton pattern for the qml layer.
/// @param engine QML application.
/// @param scriptEngine The QJSEngine class provides an environment for evaluating JavaScript code.
QObject *DapServiceController::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    
    return &getInstance();
}
