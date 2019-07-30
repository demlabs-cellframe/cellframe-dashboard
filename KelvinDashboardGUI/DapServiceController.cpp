#include "DapServiceController.h"
#include "DapUiQmlWidgetModel.h"
#include "DapLogMessage.h"
#include "DapChainWallet.h"

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

    connect(m_pDapCommandController, SIGNAL(sigWalletAdded(QString, QString)), SLOT(processAddWallet(QString, QString)));

    connect(m_pDapCommandController, SIGNAL(sigWalletsReceived(QMap<QString,QVariant>)), SLOT(processGetWallets(QMap<QString,QVariant>)));

    connect(m_pDapCommandController, SIGNAL(sigWalletInfoChanged(QString,QString, QStringList, QStringList)), SLOT(processGetWalletInfo(QString,QString, QStringList, QStringList)));

    connect(m_pDapCommandController, SIGNAL(onTokenSended(QString)), SLOT(processSendToken(QString)));

    connect(m_pDapCommandController, SIGNAL(executeCommandChanged(QString)), SLOT(processExecuteCommandInfo(QString)));

    connect(m_pDapCommandController, SIGNAL(onLogModel()), SLOT(get()));

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

QString DapServiceController::getResult()
{
    return m_sResult;
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
    if(aNodeLogs.count() <= 0)
        return;
    int counter {0};
    QStringList list;
    int xx = DapLogModel::getInstance().rowCount();
    for(int x{0}; x <= aNodeLogs.size(); ++x)
    {
        if(counter == 4)
        {
            DapLogMessage message;
            message.setTimeStamp(list.at(0));
            message.setType(list.at(1));
            message.setFile(list.at(2));
            message.setMessage(list.at(3));
            DapLogModel::getInstance().append(message);
            list.clear();
            counter = 0;
            if(x != aNodeLogs.size())
                --x;
        }
        else
        {
            list.append(aNodeLogs[x]);
            ++counter;
        }
    }
    emit logCompleted();
}

void DapServiceController::get()
{
    clearLogModel();
    getNodeLogs();
}

/// Get node logs.
/// @param aiTimeStamp Timestamp start reading logging.
/// @param aiRowCount Number of lines displayed.
void DapServiceController::getNodeLogs() const
{
    qInfo() << QString("getNodeLogs()");
    m_pDapCommandController->getNodeLogs();
}

void DapServiceController::clearLogModel()
{
    DapLogModel::getInstance().clear();
    int z = DapLogModel::getInstance().rowCount();
    emit logCompleted();
}

void DapServiceController::addWallet(const QString &asWalletName)
{
    qInfo() << QString("addWallet(%1)").arg(asWalletName);
    m_pDapCommandController->addWallet(asWalletName);
}

void DapServiceController::removeWallet(int index, const QString &asWalletName)
{
    qInfo() << QString("removeWallet(%1)").arg(asWalletName);
    m_pDapCommandController->removeWallet(asWalletName.trimmed());
    DapChainWalletsModel::getInstance().remove(index);
}

void DapServiceController::sendToken(const QString &asSendWallet, const QString &asAddressReceiver, const QString &asToken, const QString &aAmount)
{
    qInfo() << QString("sendToken(%1, %2, %3, %4)").arg(asSendWallet).arg(asAddressReceiver).arg(asToken).arg(aAmount);
    m_pDapCommandController->sendToken(asSendWallet.trimmed(), asAddressReceiver.trimmed(), asToken.trimmed(), aAmount);
}

void DapServiceController::executeCommand(const QString& command)
{
    qInfo() << QString("executeCommand (%1)").arg(command);
    m_pDapCommandController->executeCommand(command);
}


void DapServiceController::getWalletInfo(const QString &asWalletName)
{
    qInfo() << QString("getWalletInfo(%1)").arg(asWalletName);
    m_pDapCommandController->getWalletInfo(asWalletName);
}

void DapServiceController::processAddWallet(const QString& asWalletName, const QString& asWalletAddress)
{
    qInfo() << QString("processAddWallet(%1, %2)").arg(asWalletName).arg(asWalletAddress);
    DapChainWallet wallet("", asWalletName, asWalletAddress);
    DapChainWalletsModel::getInstance().append(wallet);
}

void DapServiceController::processSendToken(const QString &asAnswer)
{
    qInfo() << QString("processSendToken(%1)").arg(asAnswer);
}

void DapServiceController::processGetWallets(const QMap<QString, QVariant> &aWallets)
{
    qInfo() << QString("processGetWallets()") << aWallets.size();
    for(QString w : aWallets.keys())
    {
        getWalletInfo(w);
    }
}

void DapServiceController::processGetWalletInfo(const QString &asWalletName, const QString &asWalletAddress, const QStringList& aBalance, const QStringList &aTokens)
{
    qInfo() << QString("processGetWalletInfo(%1, %2)").arg(asWalletName).arg(asWalletAddress);
    DapChainWallet wallet("", asWalletName, asWalletAddress, aBalance, aTokens);
    DapChainWalletsModel::getInstance().append(wallet);
    
    for (QString s : aBalance) {
        qDebug() << s;
    }
}

void DapServiceController::processExecuteCommandInfo(const QString &result)
{
    qInfo() << QString("processExecuteCommandInfo(%1)").arg(result);
    m_sResult = result;
    emit resultChanged();
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
