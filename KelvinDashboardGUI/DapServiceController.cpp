#include "DapServiceController.h"
#include "DapUiQmlWidgetModel.h"
#include "DapLogMessage.h"

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

    connect(m_pDapCommandController, SIGNAL(sigWalletAdded(QString)), SLOT(processAddWallet(QString)));

    connect(m_pDapCommandController, SIGNAL(sigWalletsReceived(QMap<QString,QVariant>)), SLOT(processGetWallets(QMap<QString,QVariant>)));
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

void DapServiceController::getWallets() const
{
    qInfo() << QString("getNodeLogs()");
    m_pDapCommandController->getWallets();
}

/// Handling service response for receiving node logs.
/// @param aNodeLogs List of node logs.
void DapServiceController::processGetNodeLogs(const QStringList &aNodeLogs)
{
    for(QString s : aNodeLogs)
    {
        qDebug() << s;
        QStringList tempList = s.split(" ");
        DapLogMessage message;
        if(tempList.at(1) == "[INF]")
            message.setType(Type::Info);
        else if(tempList.at(1) == "[WRN]")
            message.setType(Type::Warning);
        else if(tempList.at(1) == "[DBG]")
            message.setType(Type::Debug);
        else if(tempList.at(1) == "[ERR]")
            message.setType(Type::Error);
        QString str = tempList.at(0);
        message.setTimeStamp(str.remove("[").remove("]"));
        QStringList tempList2 = tempList.at(2).split("\t");
        QString str2 = tempList2.at(0);
        message.setFile(str2.remove("[").remove("]"));
        QString str3 = s.split("\t").at(1);
        int pos = str3.indexOf('\n');
        message.setMessage(str3.remove(pos, str3.size()-pos));
        DapLogModel::getInstance().append(message);
    }
}

void DapServiceController::addWallet(const QString &asWalletName)
{
    qInfo() << QString("addWallet(%1)").arg(asWalletName);
    m_pDapCommandController->addWallet(asWalletName);
}

void DapServiceController::processAddWallet(const QString &asWalletAddress)
{
    qInfo() << QString("processAddWallet(%1)").arg(asWalletAddress);
    qDebug() << "Wallet address() " << asWalletAddress;
}

void DapServiceController::processGetWallets(const QMap<QString, QVariant> &aWallets)
{
    qInfo() << QString("processGetWallets()") << aWallets.size();
    for(QString wallet : aWallets.keys())
        qDebug() << "W" << wallet << " " << aWallets.value(wallet).toString();
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
