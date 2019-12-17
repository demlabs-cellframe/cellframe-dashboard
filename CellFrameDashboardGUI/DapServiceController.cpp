#include "DapServiceController.h"
#include "DapLogMessage.h"
#include "DapChainWallet.h"
#include "DapSettings.h"
#include <QRegularExpression>

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

    connect(m_pDapServiceClient, SIGNAL(sigDisconnected()), SLOT(clearLogModel()));
    connect(m_pDapServiceClient, SIGNAL(sigConnected()), SLOT(loadUserSettings()));
    
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

	connect(m_pDapCommandController, SIGNAL(sendNodeNetwork(QVariant)), this, SLOT(processGetNodeNetwork(QVariant)));
    connect(m_pDapCommandController, SIGNAL(onChangeLogModel()), SLOT(getNodeLogs()));

    connect(&DapChainNodeNetworkModel::getInstance(), SIGNAL(requestNodeNetwork()), this, SLOT(getNodeNetwork()));
    connect(&DapChainNodeNetworkModel::getInstance(), SIGNAL(requestNodeStatus(bool)), this, SLOT(setNodeStatus(bool)));

    connect(m_pDapCommandController, SIGNAL(sendHistory(QVariant)), this, SLOT(processGetHistory(QVariant)));

    connect(m_pDapCommandController, &DapCommandController::sendHistory, &DapScreenHistoryModel::getInstance(), &DapScreenHistoryModel::receiveNewData);

    connect(&DapConsoleModel::getInstance(), &DapConsoleModel::sendRequest, m_pDapCommandController, &DapCommandController::requestConsole);
    connect(m_pDapCommandController, &DapCommandController::responseConsole, &DapConsoleModel::getInstance(), &DapConsoleModel::receiveResponse);
    connect(m_pDapCommandController, &DapCommandController::sigCmdHistory, &DapConsoleModel::getInstance(), &DapConsoleModel::receiveCmdHistory);

    connect(m_pDapCommandController, &DapCommandController::sendNetworkList, &DapSettingsNetworkModel::getInstance(), &DapSettingsNetworkModel::setNetworkList);
    connect(&DapSettingsNetworkModel::getInstance(), &DapSettingsNetworkModel::currentNetworkChanged, m_pDapCommandController, &DapCommandController::changeCurrentNetwork);

    connect(m_pDapCommandController, &DapCommandController::sigWalletData, &DapChainWalletModel::instance(), &DapChainWalletModel::setWalletData);

    connect(m_pDapCommandController, &DapCommandController::sendResponseTransaction, this, &DapServiceController::resultMempool);
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

QString DapServiceController::getSettingFile() const
{
    return m_sSettingFile;
}

QString DapServiceController::getResult()
{
    return m_sResult;
}

void DapServiceController::getWallets() const
{
    qInfo() << QString("getWallets()");
    m_pDapCommandController->getWallets();
}

/// Handling service response for receiving node logs.
/// @param aNodeLogs List of node logs.
void DapServiceController::processGetNodeLogs(const QStringList &aNodeLogs)
{
    if(aNodeLogs.isEmpty())
        return;

    QRegularExpression re("(?<=])\\s");
    for (auto const & log : aNodeLogs)
    {
        const QStringList list = log.split(re);
        DapLogMessage logMessage;
        logMessage.setTimeStamp(list.at(0));
        logMessage.setType(list.at(1));
        logMessage.setFile(list.at(2));
        logMessage.setMessage(list.at(3));
        DapLogModel::getInstance().append(logMessage);
    }

    emit logCompleted();
}

/// Get node logs.
void DapServiceController::getNodeLogs() const
{
    qInfo() << QString("getNodeLogs()");
    m_pDapCommandController->getNodeLogs();
}

void DapServiceController::clearLogModel()
{
    DapLogModel::getInstance().clear();
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

void DapServiceController::getCmdHistory()
{
    m_pDapCommandController->getCmdHistory();
}

void DapServiceController::getHistory()
{
    m_pDapCommandController->getHistory();
}

void DapServiceController::getNodeNetwork()
{
    m_pDapCommandController->getNodeNetwork();
}

void DapServiceController::setNodeStatus(const bool aIsOnline)
{
    m_pDapCommandController->setNodeStatus(aIsOnline);
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
}

void DapServiceController::processExecuteCommandInfo(const QString &result)
{
    qInfo() << QString("processExecuteCommandInfo(%1)").arg(result);
    m_sResult = result;
    emit resultChanged();
}

void DapServiceController::processGetNodeNetwork(const QVariant& aData)
{
    DapChainNodeNetworkModel::getInstance().receiveNewNetwork(aData);
}

void DapServiceController::processGetHistory(const QVariant& aData)
{
    DapScreenHistoryModel::getInstance().receiveNewData(aData);
}

void DapServiceController::getNetworkList()
{
    m_pDapCommandController->getNetworkList();
}

void DapServiceController::loadUserSettings()
{
    const QString networkName = DapSettings::getInstance(m_sSettingFile)
            .getKeyValue("network").toString();
    qInfo() << "get settings name: " << networkName;
    int currentIndex = DapSettingsNetworkModel::getInstance().getCurrentIndex();
    qInfo() << "current index is " << currentIndex;
    DapSettingsNetworkModel::getInstance().setCurrentNetwork(networkName, ++currentIndex);
    qInfo() << "change Current Network: " << DapSettingsNetworkModel::getInstance().getCurrentNetwork();
    emit userSettingsLoaded();
}

void DapServiceController::saveUserSettings()
{
    DapSettings::getInstance().setFileName(m_sSettingFile);
    QJsonObject networkObject;
    networkObject["network"] = DapSettingsNetworkModel::getInstance().getCurrentNetwork();
    qInfo() << "Save to file: " << networkObject;
    DapSettings::getInstance().writeFile(QJsonDocument(networkObject));
    emit userSettingsSaved();
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

void DapServiceController::createTransaction(const QString& aFromWallet, const QString& aToAddress, const QString& aToken, const QString& aNetwork, const quint64 aValue)
{
    m_pDapCommandController->sendMempool(aFromWallet, aToAddress, aToken, aNetwork, aValue);
}

void DapServiceController::sendToken(const QString& aNetwork)
{
    m_pDapCommandController->takeFromMempool(aNetwork);
}

void DapServiceController::requestWalletData()
{
    m_pDapCommandController->requestWalletData();
}
