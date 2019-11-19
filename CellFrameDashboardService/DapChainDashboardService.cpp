#include "DapChainDashboardService.h"

#include "DapSettings.h"

DapChainDashboardService::DapChainDashboardService() : DapRpcService(nullptr)
{
    // Log reader
    m_pDapChainLogHandler = new DapChainLogHandler(this);
    connect(m_pDapChainLogHandler, SIGNAL(onChangedLog()), SLOT(changedLogModel()));
    connect(this, &DapChainDashboardService::onNewClientConnected, [=] {
        qDebug() << "Frontend connected";
    });


    m_pDapChainNodeHandler = new DapChainNodeNetworkHandler(this);

    m_pDapChainHistoryHandler = new DapChainHistoryHandler(this);
    QObject::connect(m_pDapChainHistoryHandler, &DapChainHistoryHandler::requsetWallets, this, &DapChainDashboardService::doRequestWallets);
    QObject::connect(m_pDapChainHistoryHandler, &DapChainHistoryHandler::changeHistory, this, &DapChainDashboardService::doSendNewHistory);

    m_pDapChainNetworkHandler = new DapChainNetworkHandler(this);

    m_pDapChainConsoleHandler = new DapChainConsoleHandler(this);

    m_pDapChainWalletHandler = new DapChainWalletHandler(this);
    QObject::connect(m_pDapChainWalletHandler, &DapChainWalletHandler::walletDataChanged, this, &DapChainDashboardService::doSendNewWalletData);
    m_pDapChainWalletHandler->setNetworkList(m_pDapChainNetworkHandler->getNetworkList());

}

bool DapChainDashboardService::start()
{
    qInfo() << "DapChainDashboardService::start()";
    
    m_pServer = new DapUiService();
    m_pServer->setSocketOptions(QLocalServer::WorldAccessOption	);
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
    qInfo() << QString("getWalletInfo(%1)").arg(asWalletName);
    return m_pDapChainWalletHandler->getWalletInfo(asWalletName);
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

QString DapChainDashboardService::getCmdHistory() const
{
    return m_pDapChainConsoleHandler->getHistory();
}

QStringList DapChainDashboardService::getNetworkList() const
{
    return m_pDapChainNetworkHandler->getNetworkList();
}

void DapChainDashboardService::changeCurrentNetwork(const QString& aNetwork)
{
    m_pDapChainHistoryHandler->setCurrentNetwork(aNetwork);
    m_pDapChainNodeHandler->setCurrentNetwork(aNetwork);
    m_pDapChainWalletHandler->setCurrentNetwork(aNetwork);
}

void DapChainDashboardService::doRequestWallets()
{
    QMap<QString, QVariant> wallets = m_pDapChainWalletHandler->getWallets();
    m_pDapChainHistoryHandler->onRequestNewHistory(wallets);
    /// TODO: for future
//    QVariantList params = QVariantList() << wallets;
//    DapRpcMessage request = DapRpcMessage::createRequest("RPCClient.setNewWallets", QJsonArray::fromVariantList(params));
//    m_pServer->notifyConnectedClients(request);
}

void DapChainDashboardService::doSendNewHistory(const QVariant& aData)
{
    if(!aData.isValid()) return;
    QVariantList params = QVariantList() << aData;
    DapRpcMessage request = DapRpcMessage::createRequest("RPCClient.setNewHistory", QJsonArray::fromVariantList(params));
    m_pServer->notifyConnectedClients(request);
}

void DapChainDashboardService::doSendNewWalletData(const QByteArray& aData)
{
    if(aData.isEmpty()) return;
    QVariantList params = QVariantList() << aData.toHex();
    DapRpcMessage request = DapRpcMessage::createRequest("RPCClient.setNewWalletData", QJsonArray::fromVariantList(params));
    m_pServer->notifyConnectedClients(request);
}

QString DapChainDashboardService::sendToken(const QString &asWalletName, const QString &asReceiverAddr, const QString &asToken, const QString &asAmount)
{
    qInfo() << QString("sendToken(%1;%2;%3;%4)").arg(asWalletName).arg(asReceiverAddr).arg(asToken).arg(asAmount);
    return m_pDapChainWalletHandler->sendToken(asWalletName, asReceiverAddr, asToken, asAmount);
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
//    QSystemTrayIcon *trayIconCellFrameDashboard = new QSystemTrayIcon();
//    trayIconCellFrameDashboard->setIcon(QIcon(":/Resources/Icons/icon.ico"));
//    trayIconCellFrameDashboard->setToolTip("CellFrameDashboard");
//    QMenu * menuCellFrameDashboardService = new QMenu();
//    QAction * quitAction = new QAction("Выход");
//    menuCellFrameDashboardService->addAction(quitAction);
//    trayIconCellFrameDashboard->setContextMenu(menuCellFrameDashboardService);
//    trayIconCellFrameDashboard->show();
    
//    // If the "Exit" menu item is selected, then we shut down the service,
//    // and also send a command to shut down the client.
//    connect(quitAction, &QAction::triggered, this, [=]
//    {
//        closeClient();
//    });
    
//    // With a double click on the icon in the system tray,
//    // we send a command to the client to activate the main window
//    connect(trayIconCellFrameDashboard, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
//            this, SLOT(activateClient(QSystemTrayIcon::ActivationReason)));
//}

bool DapChainDashboardService::appendWallet(const QString& aWalletName) const
{
    return m_pDapChainWalletHandler->appendWallet(aWalletName);
}

QByteArray DapChainDashboardService::walletData() const
{
    return m_pDapChainWalletHandler->walletData();
}
