#include "DapServiceController.h"

#include "DapNetworkStr.h"

#include "dapconfigreader.h"

//#define SERVICE_IMITATOR

/// Standard constructor.
/// @param apParent Parent.
DapServiceController::DapServiceController(QObject *apParent)
    : QObject(apParent),
      imitator(new ServiceImitator(this))
{
    DapConfigReader configReader;
    m_DapNotifyController = new DapNotifyController();
    notifySignalsAttach();

    m_sVersion = DAP_VERSION;

    m_bReadingChains = configReader.getItemBool("general", "reading_chains", false);
}

/// Client controller initialization.
/// @param apDapServiceClient Network connection controller.
void DapServiceController::init(DapServiceClient *apDapServiceClient)
{
    m_pDapServiceClient = apDapServiceClient;
    m_pDapServiceClientMessage = new DapServiceClientMessage(nullptr);
    connect(m_pDapServiceClient,SIGNAL(sendMessageBox(QString)),m_pDapServiceClientMessage, SLOT(messageBox(QString)));
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

QString DapServiceController::getCurrentNetwork() const
{
    return m_sCurrentNetwork;
}

void DapServiceController::setCurrentNetwork(const QString &sCurrentNetwork)
{
    m_sCurrentNetwork = sCurrentNetwork;

    emit currentNetworkChanged(m_sCurrentNetwork);
}

int DapServiceController::getIndexCurrentNetwork() const
{
    return m_iIndexCurrentNetwork;
}

void DapServiceController::setIndexCurrentNetwork(int iIndexCurrentNetwork)
{
    m_iIndexCurrentNetwork = iIndexCurrentNetwork;

    emit indexCurrentNetworkChanged(m_iIndexCurrentNetwork);
}

bool DapServiceController::getReadingChains() const
{
    return m_bReadingChains;
}

void DapServiceController::setReadingChains(bool bReadingChains)
{
    m_bReadingChains = bReadingChains;

    emit readingChainsChanged(bReadingChains);
}

void DapServiceController::requestWalletList()
{
    this->requestToService("DapGetWalletsInfoCommand", 1);
}

/*void DapServiceController::requestWalletInfo(const QString &a_walletName, const QStringList &a_networks)
{
    this->requestToService("DapGetWalletInfoCommand", a_walletName, a_networks);
}*/

void DapServiceController::requestNetworkStatus(QString a_networkName)
{
    this->requestToService("DapGetNetworkStatusCommand", a_networkName);
}

void DapServiceController::changeNetworkStateToOffline(QString a_networkName)
{
    this->requestToService("DapGetNetworkStatusCommand", a_networkName, "offline");
}

void DapServiceController::changeNetworkStateToOnline(QString a_networkName)
{
    this->requestToService("DapNetworkGoToCommand", a_networkName, "online");
}

void DapServiceController::requestOrdersList()
{
    this->requestToService("DapGetListOrdersCommand");
}

void DapServiceController::requestNetworksList()
{
    this->requestToService("DapGetListNetworksCommand");
}

int DapServiceController::getAutoOnlineValue()
{
    DapConfigReader reader;
    bool res = reader.getItemBool("general", "auto_online", false);
    if (res)
        return 2;
    else return 0;
}


/// Get an instance of a class.
/// @return Instance of a class.
DapServiceController &DapServiceController::getInstance()
{
    static DapServiceController instance;
    return instance;
}

/// Disconnect all signals
void DapServiceController::disconnectAll()
{
    disconnect(this, 0, 0, 0);
}

/// Send request to service.
/// @details In this case, a request is sent to the service to which it is obliged to respond. Expect an answer.
/// @param asServiceName Service name.
/// @param arg1...arg10 Parametrs.
void DapServiceController::requestToService(const QString &asServiceName, const QVariant &arg1,
                                            const QVariant &arg2, const QVariant &arg3, const QVariant &arg4,
                                            const QVariant &arg5, const QVariant &arg6, const QVariant &arg7,
                                            const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
{

    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->findService(asServiceName));
//    qDebug() << "DapServiceController::requestToService, asServiceName:"
//             << asServiceName << arg1.toString() << arg2.toString()
//             << arg3.toString() << arg4.toString() << arg5.toString()
//             << "transceiver:" << transceiver;
    Q_ASSERT(transceiver);
    disconnect(transceiver, SIGNAL(serviceResponded(QVariant)), this, SLOT(findEmittedSignal(QVariant)));
    connect(transceiver, SIGNAL(serviceResponded(QVariant)), SLOT(findEmittedSignal(QVariant)));
    transceiver->requestToService(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

#ifdef SERVICE_IMITATOR
    imitator->requestToService(asServiceName, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
#endif
}

/// Notify service.
/// @details In this case, only a notification is sent to the service, the answer should not be expected.
/// @param asServiceName Service name.
/// @param arg1...arg10 Parametrs.
void DapServiceController::notifyService(const QString &asServiceName, const QVariant &arg1,
                                         const QVariant &arg2, const QVariant &arg3, const QVariant &arg4,
                                         const QVariant &arg5, const QVariant &arg6, const QVariant &arg7,
                                         const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
{
    qDebug() << "DapServiceController::notifyService" << asServiceName << arg1 << arg2 << arg3 << arg4 << arg5;
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->findService(asServiceName));

    Q_ASSERT(transceiver);

    transceiver->notifyToService(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
}

/// Register command.
void DapServiceController::registerCommand()
{

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(
                                    new DapCertificateManagerCommands(DapCertificateCommands::serviceName(), m_DAPRpcSocket)))
                                    , QString("certificateManagerOperationResult")));

    // Application shutdown team
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapQuitApplicationCommand("DapQuitApplicationCommand", m_DAPRpcSocket))), QString()));
    // GUI client activation command in case it is minimized/expanded
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapActivateClientCommand("DapActivateClientCommand", m_DAPRpcSocket))), QString("clientActivated")));
    // Log update command on the Logs tab
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapUpdateLogsCommand("DapUpdateLogsCommand", m_DAPRpcSocket))), QString("logUpdated")));
    // The team to create a new wallet on the Dashboard tab
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapAddWalletCommand("DapAddWalletCommand", m_DAPRpcSocket))), QString("walletCreated")));
    // The command to get an wallet info
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletInfoCommand("DapGetWalletInfoCommand", m_DAPRpcSocket))), QString("walletReceived")));
    // The command to get a list of available wallets
    // Command to save data from the Logs tab
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapExportLogCommand("DapExportLogCommand",m_DAPRpcSocket))), QString("exportLogs")));
    // The command to get a list of available networks
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListNetworksCommand("DapGetListNetworksCommand", m_DAPRpcSocket))), QString("networksListReceived")));
    // The command to get a network status
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetNetworkStatusCommand("DapGetNetworkStatusCommand", m_DAPRpcSocket))), QString("networkStatusReceived")));
    // The command to change network state
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapNetworkGoToCommand("DapNetworkGoToCommand", m_DAPRpcSocket))), QString("newTargetNetworkStateReceived")));

    // The command to get a list of available orders
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListOrdersCommand("DapGetListOrdersCommand", m_DAPRpcSocket))), QString("ordersListReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetNetworksStateCommand("DapGetNetworksStateCommand", m_DAPRpcSocket))), QString("networkStatesListReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapNetworkSingleSyncCommand("DapNetworkSingleSyncCommand", m_DAPRpcSocket))), QString()));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletAddressesCommand("DapGetWalletAddressesCommand", m_DAPRpcSocket))), QString("walletAddressesReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListWalletsCommand("DapGetListWalletsCommand",m_DAPRpcSocket))), QString("walletsListReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletTokenInfoCommand("DapGetWalletTokenInfoCommand", m_DAPRpcSocket))), QString("walletTokensReceived")));
    // Creating a token transfer transaction between wallets
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCreateTransactionCommand("DapCreateTransactionCommand",m_DAPRpcSocket))), QString("transactionCreated")));
    // Transaction confirmation
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapMempoolProcessCommand("DapMempoolProcessCommand",m_DAPRpcSocket))), QString("mempoolProcessed")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletHistoryCommand("DapGetWalletHistoryCommand",m_DAPRpcSocket))), QString("historyReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetAllWalletHistoryCommand("DapGetAllWalletHistoryCommand",m_DAPRpcSocket))), QString("allWalletHistoryReceived")));
    // Run cli command
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapRunCmdCommand("DapRunCmdCommand",m_DAPRpcSocket))), QString("cmdRunned")));
    // Get history of commands executed by cli handler
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetHistoryExecutedCmdCommand("DapGetHistoryExecutedCmdCommand",m_DAPRpcSocket))), QString("historyExecutedCmdReceived")));
    // Save cmd command in file
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapSaveHistoryExecutedCmdCommand("DapSaveHistoryExecutedCmdCommand",m_DAPRpcSocket))), QString()));


    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapRcvNotify("DapRcvNotify",m_DAPRpcSocket))), QString("dapRcvNotify")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapNodeConfigController("DapNodeConfigController",m_DAPRpcSocket))), QString("dapNodeConfigController")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListTokensCommand("DapGetListTokensCommand",m_DAPRpcSocket))), QString("tokensListReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapTokenEmissionCommand("DapTokenEmissionCommand",m_DAPRpcSocket))), QString("responseEmissionToken")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapTokenDeclCommand("DapTokenDeclCommand",m_DAPRpcSocket))), QString("responseDeclToken")));


#ifdef SERVICE_IMITATOR
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletsInfoCommand("DapGetWalletsInfoCommand", m_DAPRpcSocket))), QString("walletsReceived1")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapVersionController("DapVersionController",m_DAPRpcSocket))), QString("versionControllerResult1")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTxList("DapGetXchangeTxList",m_DAPRpcSocket))), QString("rcvXchangeTxList1")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapXchangeOrderCreate("DapXchangeOrderCreate",m_DAPRpcSocket))), QString("rcvXchangeCreate1")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeOrdersList("DapGetXchangeOrdersList",m_DAPRpcSocket))), QString("rcvXchangeOrderList1")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPair("DapGetXchangeTokenPair",m_DAPRpcSocket))), QString("rcvXchangeTokenPair1")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPriceAverage("DapGetXchangeTokenPriceAverage",m_DAPRpcSocket))), QString("rcvXchangeTokenPriceAverage1")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPriceHistory("DapGetXchangeTokenPriceHistory",m_DAPRpcSocket))), QString("rcvXchangeTokenPriceHistory1")));
#else
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletsInfoCommand("DapGetWalletsInfoCommand", m_DAPRpcSocket))), QString("walletsReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapVersionController("DapVersionController",m_DAPRpcSocket))), QString("versionControllerResult")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTxList("DapGetXchangeTxList",m_DAPRpcSocket))), QString("rcvXchangeTxList")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapXchangeOrderCreate("DapXchangeOrderCreate",m_DAPRpcSocket))), QString("rcvXchangeCreate")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeOrdersList("DapGetXchangeOrdersList",m_DAPRpcSocket))), QString("rcvXchangeOrderList")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPair("DapGetXchangeTokenPair",m_DAPRpcSocket))), QString("rcvXchangeTokenPair")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPriceAverage("DapGetXchangeTokenPriceAverage",m_DAPRpcSocket))), QString("rcvXchangeTokenPriceAverage")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPriceHistory("DapGetXchangeTokenPriceHistory",m_DAPRpcSocket))), QString("rcvXchangeTokenPriceHistory")));
#endif

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWordBook("DapGetWordBook",m_DAPRpcSocket))), QString("rcvWordBook")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapXchangeOrderPurchase("DapXchangeOrderPurchase",m_DAPRpcSocket))), QString("rcvXchangePurchase")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapWalletActivateOrDeactivateCommand("DapWalletActivateOrDeactivateCommand",m_DAPRpcSocket))), QString("rcvActivateOrDeactivateReply")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapWebConnectRequest("DapWebConnectRequest",m_DAPRpcSocket))), QString("dapWebConnectRequest")));


#ifdef SERVICE_IMITATOR
    connect(imitator, &ServiceImitator::versionControllerResult,
            this, &DapServiceController::versionControllerResult,
            Qt::QueuedConnection);

    connect(imitator, &ServiceImitator::walletsReceived,
            this, &DapServiceController::walletsReceived,
            Qt::QueuedConnection);

    connect(imitator, &ServiceImitator::signalXchangeTokenPairReceived,
            this, &DapServiceController::signalXchangeTokenPairReceived,
            Qt::QueuedConnection);

    connect(imitator, &ServiceImitator::rcvXchangeTokenPriceAverage,
            this, &DapServiceController::rcvXchangeTokenPriceAverage,
            Qt::QueuedConnection);

    connect(imitator, &ServiceImitator::rcvXchangeTokenPriceHistory,
            this, &DapServiceController::rcvXchangeTokenPriceHistory,
            Qt::QueuedConnection);

    connect(imitator, &ServiceImitator::signalXchangeOrderListReceived,
            this, &DapServiceController::signalXchangeOrderListReceived,
            Qt::QueuedConnection);

    connect(imitator, &ServiceImitator::rcvXchangeCreate,
            this, &DapServiceController::rcvXchangeCreate,
            Qt::QueuedConnection);

    connect(imitator, &ServiceImitator::rcvXchangeTxList,
            this, &DapServiceController::rcvXchangeTxList,
            Qt::QueuedConnection);
#endif

//    connect(this, &DapServiceController::walletsInfoReceived, [=] (const QVariant& walletList)
//    {
////        QByteArray  array = QByteArray::fromHex(walletList.toByteArray());
////        QList<DapWallet> tempWallets;

////        QDataStream in(&array, QIODevice::ReadOnly);
////        in >> tempWallets;

////        QList<QObject*> wallets;
////        auto begin = tempWallets.begin();
////        auto end = tempWallets.end();
////        DapWallet * wallet = nullptr;
////        for(;begin != end; ++begin)
////        {
////            wallet = new DapWallet(*begin);
////            wallets.append(wallet);
////        }

//        emit walletsReceived(walletList);
//    });

//    connect(this, &DapServiceController::walletInfoReceived, [=] (const QVariant& wallet_arg)
//    {
//        QByteArray  array = QByteArray::fromHex(wallet_arg.toByteArray());
//        DapWallet wallet;

//        QDataStream in(&array, QIODevice::ReadOnly);
//        in >> wallet;

////        qDebug() << "walletInfoReceived" << wallet.getName();

//        DapWallet * outWallet = new DapWallet(wallet);

//        emit walletReceived(outWallet);
//    });

    connect(this, &DapServiceController::historyReceived, [=] (const QVariant& wallethistory)
    {
        QByteArray  array = QByteArray::fromHex(wallethistory.toByteArray());
        QList<DapWalletHistoryEvent> tempWalletHistory;

        QDataStream in(&array, QIODevice::ReadOnly);
        in >> tempWalletHistory;

        QList<QObject*> walletHistory;
        auto begin = tempWalletHistory.begin();
        auto end = tempWalletHistory.end();
        DapWalletHistoryEvent * wallethistoryEvent = nullptr;
        for(;begin != end; ++begin)
        {
            wallethistoryEvent = new DapWalletHistoryEvent(*begin);
            walletHistory.append(wallethistoryEvent);
        }

        qDebug() << "DapServiceController::registerCommand"
                 << "DapServiceController::historyReceived" << walletHistory.size();

        emit walletHistoryReceived(walletHistory);
    });

//    connect(this, &DapServiceController::allHistoryReceived, [=] (const QVariant& wallethistory)
//    {
//        QByteArray  array = QByteArray::fromHex(wallethistory.toByteArray());
//        QList<DapWalletHistoryEvent> tempWalletHistory;

//        QDataStream in(&array, QIODevice::ReadOnly);
//        in >> tempWalletHistory;

//        QList<QObject*> walletHistory;
//        auto begin = tempWalletHistory.begin();
//        auto end = tempWalletHistory.end();
//        DapWalletHistoryEvent * wallethistoryEvent = nullptr;
//        for(;begin != end; ++begin)
//        {
//            wallethistoryEvent = new DapWalletHistoryEvent(*begin);
//            walletHistory.append(wallethistoryEvent);
//        }

//        emit allWalletHistoryReceived(walletHistory);
//    });

    connect(this, &DapServiceController::ordersListReceived, [=] (const QVariant& ordersList)
    {
        QByteArray  array = QByteArray::fromHex(ordersList.toByteArray());
        QList<DapVpnOrder> tempOrders;

        QDataStream in(&array, QIODevice::ReadOnly);
        in >> tempOrders;

        QList<QObject*> orders;
        auto begin = tempOrders.begin();
        auto end = tempOrders.end();
        DapVpnOrder * order = nullptr;
        for(;begin != end; ++begin)
        {
            order = new DapVpnOrder(*begin);
            orders.append(order);
        }

        emit ordersReceived(orders);
    });

    connect(this, &DapServiceController::networkStatesListReceived, [=] (const QVariant& networkList)
    {
        QByteArray  array = QByteArray::fromHex(networkList.toByteArray());
        QList<DapNetworkStr> tempNetworks;

        QDataStream in(&array, QIODevice::ReadOnly);
        in >> tempNetworks;

        QList<QObject*> networks;
        auto begin = tempNetworks.begin();
        auto end = tempNetworks.end();
        DapNetworkStr * network = nullptr;
        for(;begin != end; ++begin)
        {
            network = new DapNetworkStr(*begin);
            networks.append(network);
        }

        emit networksStatesReceived(networks);
    });

    connect(this, &DapServiceController::networksListReceived, [=] (const QVariant& networksList)
    {
        QByteArray  array = QByteArray::fromHex(networksList.toByteArray());
        QList<DapNetworkStr> tempNetworks;

        QDataStream in(&array, QIODevice::ReadOnly);
        in >> tempNetworks;

        QList<QObject*> networks;
        auto begin = tempNetworks.begin();
        auto end = tempNetworks.end();
        DapNetworkStr * network = nullptr;
        for(;begin != end; ++begin)
        {
            network = new DapNetworkStr(*begin);
            networks.append(network);
        }

        emit networksReceived(networks);
    });

    connect(this, &DapServiceController::dapRcvNotify, [=] (const QVariant& rcvData)
    {
        m_DapNotifyController->rcvData(rcvData);
    });

    connect(this, &DapServiceController::dapWebConnectRequest, [=] (const QVariant& rcvData)
    {
        qDebug()<<"Rcv web request " << rcvData.toStringList()[0] << "---" << rcvData.toStringList()[1];
    });

    connect(this, &DapServiceController::tokensListReceived, [=] (const QVariant& tokensResult)
    {
        if(!tokensResult.isValid())
            return ;

//        emit signalTokensListReceived(tokensResult);

        if (tokensResult.toString() == "isEqual")
        {
            qDebug() << "tokensListReceived isEqual";
            emit signalTokensListReceived("isEqual");
        }
        else
        {
            emit signalTokensListReceived(tokensResult);
        }

/*        if(s_bufferTokensJson.isEmpty())
        {
            s_bufferTokensJson = tokensResult.toByteArray();
            emit signalTokensListReceived(tokensResult);
            return ;
        }else{
            if(!compareJson(s_bufferTokensJson, tokensResult))
            {
                s_bufferTokensJson = tokensResult.toByteArray();
                emit signalTokensListReceived(tokensResult);
                return ;
            }
            emit signalTokensListReceived("isEqual");
        }*/
    });

    connect(this, &DapServiceController::rcvXchangeOrderList, [=] (const QVariant& rcvData)
    {
        if (!rcvData.isValid())
            return ;

        emit signalXchangeOrderListReceived(rcvData);

/*        if(s_bufferOrdersJson.isEmpty())
        {
            s_bufferOrdersJson = rcvData.toByteArray();
            emit signalXchangeOrderListReceived(rcvData);
            return ;
        }else{
            if(!compareJson(s_bufferOrdersJson, rcvData))
            {
                s_bufferOrdersJson = rcvData.toByteArray();
                emit signalXchangeOrderListReceived(rcvData);
                return ;
            }
            emit signalXchangeOrderListReceived("isEqual");
        }*/
    });

    connect(this, &DapServiceController::rcvXchangeTokenPair, [=] (const QVariant& rcvData)
    {
        qDebug() << "DapServiceController::rcvXchangeTokenPair";

        if(!rcvData.isValid())
            return ;

        if (rcvData.toString() == "isEqual")
        {
            qDebug() << "rcvXchangeTokenPair isEqual";
            emit signalXchangeTokenPairReceived("isEqual");
        }
        else
        {
            emit signalXchangeTokenPairReceived(rcvData);
        }
    });


    registerEmmitedSignal();
}

/// Find the emitted signal.
/// @param aValue Transmitted parameter.
void DapServiceController::findEmittedSignal(const QVariant &aValue)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand *>(sender());
//    qDebug() << "findEmittedSignal, transceiver:" << transceiver  << ", value:" << aValue;
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


bool DapServiceController::compareJson(QByteArray buff, QVariant data)
{
    json_object *obj = json_object_new_string(data.toByteArray());
    json_object *obj2 = json_object_new_string(buff);

    if(json_object_equal(obj, obj2))
    {
        json_object_put(obj);
        json_object_put(obj2);
        return true;
    }
    json_object_put(obj);
    json_object_put(obj2);

    return false;
}


/// Register a signal handler for notification results.
void DapServiceController::registerEmmitedSignal()
{
    foreach (auto command, m_transceivers)
    {
        connect(command.first, SIGNAL(clientNotifed(QVariant)), SLOT(findEmittedSignal(QVariant)));
    } 
}

void DapServiceController::notifySignalsAttach()
{
    connect(m_DapNotifyController, SIGNAL(socketState(QString,int,int)), this, SLOT(slotStateSocket(QString,int,int)));
    connect(m_DapNotifyController, SIGNAL(netStates(QVariantMap)), this, SLOT(slotNetState(QVariantMap)));
}

void DapServiceController::notifySignalsDetach()
{
    disconnect(m_DapNotifyController, SIGNAL(socketState(QString,int,int)), this, SLOT(slotStateSocket(QString,int,int)));
    disconnect(m_DapNotifyController, SIGNAL(netStates(QVariantMap)), this, SLOT(slotNetState(QVariantMap)));
}



