#include "DapChainDashboardService.h"

DapChainDashboardService::DapChainDashboardService() : DapRpcService(nullptr)
{
    // Log reader
    m_pDapChainLogHandler = new DapChainLogHandler(this);
    connect(m_pDapChainLogHandler, SIGNAL(onUpdateModel()), SLOT(clearLogModel()));
    connect(m_pDapChainLogHandler, SIGNAL(onChangedLog()), SLOT(changedLogModel()));
    m_pDapChainWalletHandler = new DapChainWalletHandler(this);
    connect(this, &DapChainDashboardService::onNewClientConnected, [=] {
        qDebug() << "New client";
    });

    m_pDapChainNodeHandler = new DapChainNodeNetworkHandler(this);

    m_pDapChainHistoryHandler = new DapChainHistoryHandler {this};
    QObject::connect(m_pDapChainHistoryHandler, &DapChainHistoryHandler::requsetWallets, this, &DapChainDashboardService::doRequestWallets);
    QObject::connect(m_pDapChainHistoryHandler, &DapChainHistoryHandler::changeHistory, this, &DapChainDashboardService::doSendNewHistory);

    m_pDapChainConsoleHandler = new DapChainConsoleHandler(this);

}

bool DapChainDashboardService::start()
{
    qInfo() << "DapChainDashboardService::start()";
    
    m_pSocketService = new DapUiSocketServer();
    m_pServer = new DapUiService();
    if(m_pServer->listen(DAP_BRAND)) 
    {
        connect(m_pServer, SIGNAL(onClientConnected()), SIGNAL(onNewClientConnected()));
        m_pServer->addService(this);
    }
    else
    {
        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
        qCritical() << m_pServer->errorString();
        return false;
    }
    return true;
}

/// Get node logs.
/// @param aiTimeStamp Timestamp start reading logging.
/// @param aiRowCount Number of lines displayed.
/// @return Logs node.
QStringList DapChainDashboardService::getNodeLogs(int aiTimeStamp, int aiRowCount)
{
    qInfo() << QString("getNodeLogs(%1, %2)").arg(aiTimeStamp).arg(aiRowCount);
    return m_pDapChainLogHandler->request();
}

QStringList DapChainDashboardService::addWallet(const QString &asWalletName)
{
    qInfo() << QString("addWallet(%1)").arg(asWalletName);
    return m_pDapChainWalletHandler->createWallet(asWalletName);
}

void DapChainDashboardService::removeWallet(const QString &asWalletName)
{
    qInfo() << QString("removeWallet(%1)").arg(asWalletName);
    return m_pDapChainWalletHandler->removeWallet(asWalletName);
}

QMap<QString, QVariant> DapChainDashboardService::getWallets()
{
    qInfo() << QString("getWallets()");

    return m_pDapChainWalletHandler->getWallets();
}

QStringList DapChainDashboardService::getWalletInfo(const QString &asWalletName)
{
//    qInfo() << QString("getWalletInfo(%1)").arg(asWalletName);
//    return m_pDapChainWalletHandler->getWalletInfo(asWalletName);
    return QStringList();
}

QVariant DapChainDashboardService::getNodeNetwork() const
{
    return m_pDapChainNodeHandler->getNodeNetwork();
}

void DapChainDashboardService::setNodeStatus(const bool aIsOnline)
{
    m_pDapChainNodeHandler->setNodeStatus(aIsOnline);
}

QVariant DapChainDashboardService::getHistory() const
{
    return m_pDapChainHistoryHandler->getHistory();
}

QString DapChainDashboardService::getQueryResult(const QString& aQuery) const
{
    return m_pDapChainConsoleHandler->getResult(aQuery);
}

void DapChainDashboardService::doRequestWallets()
{
    m_pDapChainHistoryHandler->onRequestNewHistory(m_pDapChainWalletHandler->getWallets());
}

void DapChainDashboardService::doSendNewHistory(const QVariant& aData)
{
    if(!aData.isValid()) return;
    QVariantList params = QVariantList() << aData;
    DapRpcMessage request = DapRpcMessage::createRequest("RPCClient.setNewHistory", QJsonArray::fromVariantList(params));
    m_pServer->notifyConnectedClients(request);
}

QString DapChainDashboardService::sendToken(const QString &asWalletName, const QString &asReceiverAddr, const QString &asToken, const QString &asAmount)
{
    qInfo() << QString("sendToken(%1;%2;%3;%4)").arg(asWalletName).arg(asReceiverAddr).arg(asToken).arg(asAmount);
    return m_pDapChainWalletHandler->sendToken(asWalletName, asReceiverAddr, asToken, asAmount);
}

void DapChainDashboardService::clearLogModel()
{
    qDebug() << "clearLogModel()";
    QJsonArray arguments;
    m_pServer->notifyConnectedClients("RPCClient.clearLogModel", arguments);
}

void DapChainDashboardService::changedLogModel()
{
    qDebug() << "changedLogModel()";
    QJsonArray arguments;
    m_pServer->notifyConnectedClients("RPCClient.processChangedLog", arguments);
}

/// Activate the main client window by double-clicking the application icon in the system tray.
/// @param reason Type of action on the icon in the system tray.
//void DapChainDashboardService::activateClient(const QSystemTrayIcon::ActivationReason& reason)
//{
//    qInfo() << "DapChainDashboardService::activateClient()";
//    switch (reason)
//    {
//        case QSystemTrayIcon::Trigger:
//            {
//                QJsonArray arguments;
//                arguments.append(true);
//                m_pServer->notifyConnectedClients("RPCClient.activateClient", arguments);
//            }
//            break;
//        default:
//            break;
//    }
//}

/// Shut down client.
void DapChainDashboardService::closeClient()
{
    qDebug() << "Close client";
    QJsonArray arguments;
    m_pServer->notifyConnectedClients("RPCClient.closeClient", arguments);
    // Signal-slot connection shutting down the service after closing the client
    connect(m_pServer, SIGNAL(onClientDisconnected()), qApp, SLOT(quit()));
}

/// System tray initialization.
//void DapChainDashboardService::initTray()
//{
//    QSystemTrayIcon *trayIconKelvinDashboard = new QSystemTrayIcon();
//    trayIconKelvinDashboard->setIcon(QIcon(":/Resources/Icons/icon.ico"));
//    trayIconKelvinDashboard->setToolTip("KelvinDashboard");
//    QMenu * menuKelvinDashboardService = new QMenu();
//    QAction * quitAction = new QAction("Выход");
//    menuKelvinDashboardService->addAction(quitAction);
//    trayIconKelvinDashboard->setContextMenu(menuKelvinDashboardService);
//    trayIconKelvinDashboard->show();
    
//    // If the "Exit" menu item is selected, then we shut down the service,
//    // and also send a command to shut down the client.
//    connect(quitAction, &QAction::triggered, this, [=]
//    {
//        closeClient();
//    });
    
//    // With a double click on the icon in the system tray,
//    // we send a command to the client to activate the main window
//    connect(trayIconKelvinDashboard, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
//            this, SLOT(activateClient(QSystemTrayIcon::ActivationReason)));
//}
