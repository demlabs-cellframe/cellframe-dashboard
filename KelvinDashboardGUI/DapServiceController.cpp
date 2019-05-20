#include "DapServiceController.h"
#include "DapUiQmlWidgetModel.h"
DapServiceController::DapServiceController(QObject *apParent) 
    : QObject(apParent)
{
    
}

/// Show or hide GUI client by clicking on the tray icon.
/// @param aIsActivated Accepts true - when requesting to 
/// display a client, falso - when requesting to hide a client.
void DapServiceController::activateClient(bool aIsActivated)
{
    if(aIsActivated)
        emit activateWindow();
}

/// Shut down client.
void DapServiceController::closeClient()
{
    qApp->quit();
}

/// Get company brand.
/// @return Brand сompany.
void DapServiceController::init(DapServiceClient *apDapServiceClient)
{
    m_pDapServiceClient = apDapServiceClient;
    
    // Creating rpc controller
    m_pDapCommandController = new DapCommandController(apDapServiceClient->getClientSocket(), this);
    
    // Signal-slot connection that implements the client display control when you click on the tray icon
    connect(m_pDapCommandController, SIGNAL(onClientActivate(bool)), SLOT(activateClient(bool)));
    // Signal-slot connection that implements the client display control when you click on the tray icon
    connect(m_pDapCommandController, SIGNAL(onClientClose()), SLOT(closeClient()));
    // Signal-slot connection for receiving node logs from the service
    connect(m_pDapCommandController, SIGNAL(sigNodeLogsReceived(QStringList)), SLOT(processGetNodeLogs(QStringList)));
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

/// Get node logs.
/// @param aiTimeStamp Timestamp start reading logging.
/// @param aiRowCount Number of lines displayed.
void DapServiceController::getNodeLogs(int aiTimeStamp, int aiRowCount) const
{
    qInfo() << QString("getNodeLogs(%1, %2)").arg(aiTimeStamp).arg(aiRowCount);
    m_pDapCommandController->getNodeLogs(aiTimeStamp, aiRowCount);
}

/// Handling service response for receiving node logs.
/// @param aNodeLogs List of node logs.
void DapServiceController::processGetNodeLogs(const QStringList &aNodeLogs)
{
    for(QString s : aNodeLogs)
        qDebug() << s;
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
