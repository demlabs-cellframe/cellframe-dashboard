#include "DapServiceController.h"


#include "DapNetworkStr.h"

#include "dapconfigreader.h"

/// Standard constructor.
/// @param apParent Parent.
DapServiceController::DapServiceController(QObject *apParent)
    : QObject(apParent)
{
    DapConfigReader configReader;
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



//    notifySocketStateChanged(m_DapNotifyController->getSocketState());
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
    this->requestToService("DapGetWalletsInfoCommand", QStringList() << "true");
}

/*void DapServiceController::requestWalletInfo(const QString &a_walletName, const QStringList &a_networks)
{
    this->requestToService("DapGetWalletInfoCommand", a_walletName, a_networks);
}*/

void DapServiceController::requestNetworkStatus(QString a_networkName)
{
    this->requestToService("DapGetNetworkStatusCommand", QStringList() << a_networkName);
}

void DapServiceController::changeNetworkStateToOffline(QString a_networkName)
{
    this->requestToService("DapGetNetworkStatusCommand", QStringList() << a_networkName << "offline");
}

void DapServiceController::changeNetworkStateToOnline(QString a_networkName)
{
    this->requestToService("DapNetworkGoToCommand", QStringList() << a_networkName << "online");
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
void DapServiceController::requestToService(const QString &asServiceName, const QVariant &args)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->findService(asServiceName));
//    qDebug() << "DapServiceController::requestToService, asServiceName:"
//             << asServiceName << arg1.toString() << arg2.toString()
//             << arg3.toString() << arg4.toString() << arg5.toString()
//             << "transceiver:" << transceiver;
    Q_ASSERT(transceiver);
    disconnect(transceiver, SIGNAL(serviceResponded(QVariant)), this, SLOT(findEmittedSignal(QVariant)));
    connect(transceiver, SIGNAL(serviceResponded(QVariant)), SLOT(findEmittedSignal(QVariant)));
    transceiver->requestToService(args);

}

/// Notify service.
/// @details In this case, only a notification is sent to the service, the answer should not be expected.
/// @param asServiceName Service name.
/// @param arg1...arg10 Parametrs.
void DapServiceController::notifyService(const QString &asServiceName, const QVariant &args)
{
    qDebug() << "DapServiceController::notifyService" << asServiceName << args;
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->findService(asServiceName));

    Q_ASSERT(transceiver);

    transceiver->notifyToService(args);
}

/// Register command.
void DapServiceController::registerCommand()
{

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCertificateManagerCommands(DapCertificateCommands::serviceName(), m_DAPRpcSocket))), QString("certificateManagerOperationResult")));

    // Application shutdown team
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapQuitApplicationCommand("DapQuitApplicationCommand", m_DAPRpcSocket))), QString()));
    // GUI client activation command in case it is minimized/expanded
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapActivateClientCommand("DapActivateClientCommand", m_DAPRpcSocket))), QString("clientActivated")));
    // Log update command on the Logs tab
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapUpdateLogsCommand("DapUpdateLogsCommand", m_DAPRpcSocket))), QString("logUpdated")));
    // The team to create a new wallet on the Dashboard tab
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapAddWalletCommand("DapAddWalletCommand", m_DAPRpcSocket))), QString("walletCreated")));
    // The command to renove a wallet
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapRemoveWalletCommand("DapRemoveWalletCommand", m_DAPRpcSocket))), QString("walletRemoved")));
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

    

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapNetworkSingleSyncCommand("DapNetworkSingleSyncCommand", m_DAPRpcSocket))), QString()));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletAddressesCommand("DapGetWalletAddressesCommand", m_DAPRpcSocket))), QString("walletAddressesReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListWalletsCommand("DapGetListWalletsCommand",m_DAPRpcSocket))), QString("walletsListReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletTokenInfoCommand("DapGetWalletTokenInfoCommand", m_DAPRpcSocket))), QString("walletTokensReceived")));
    // Creating a token transfer transaction between wallets
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCreateTransactionCommand("DapCreateTransactionCommand",m_DAPRpcSocket))), QString("transactionCreated")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapSrvStakeDelegateCommand("DapSrvStakeDelegateCommand",m_DAPRpcSocket))), QString("srvStakeDelegateCreated")));
    // Transaction confirmation
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapMempoolProcessCommand("DapMempoolProcessCommand",m_DAPRpcSocket))), QString("mempoolProcessed")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetAllWalletHistoryCommand("DapGetAllWalletHistoryCommand",m_DAPRpcSocket))), QString("allWalletHistoryReceived")));
    // Run cli command
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapRunCmdCommand("DapRunCmdCommand",m_DAPRpcSocket))), QString("cmdRunned")));
    // Get history of commands executed by cli handler
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetHistoryExecutedCmdCommand("DapGetHistoryExecutedCmdCommand",m_DAPRpcSocket))), QString("historyExecutedCmdReceived")));
    // Save cmd command in file
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapSaveHistoryExecutedCmdCommand("DapSaveHistoryExecutedCmdCommand",m_DAPRpcSocket))), QString()));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapNodeRestart("DapNodeRestart",m_DAPRpcSocket))), QString("nodeRestart")));


    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapRcvNotify("DapRcvNotify",m_DAPRpcSocket))), QString("dapRcvNotify")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapNodeConfigController("DapNodeConfigController",m_DAPRpcSocket))), QString("dapNodeConfigController")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListTokensCommand("DapGetListTokensCommand",m_DAPRpcSocket))), QString("tokensListReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapTokenEmissionCommand("DapTokenEmissionCommand",m_DAPRpcSocket))), QString("responseEmissionToken")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapTokenDeclCommand("DapTokenDeclCommand",m_DAPRpcSocket))), QString("responseDeclToken")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletsInfoCommand("DapGetWalletsInfoCommand", m_DAPRpcSocket))), QString("walletsReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapVersionController("DapVersionController",m_DAPRpcSocket))), QString("versionControllerResult")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCreateVPNOrder("DapCreateVPNOrder",m_DAPRpcSocket))), QString("createdVPNOrder")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCreateStakeOrder("DapCreateStakeOrder",m_DAPRpcSocket))), QString("createdStakeOrder")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPair("DapGetXchangeTokenPair",m_DAPRpcSocket))), QString("rcvXchangeTokenPair")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPriceAverage("DapGetXchangeTokenPriceAverage",m_DAPRpcSocket))), QString("rcvXchangeTokenPriceAverage")));
    
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTokenPriceHistory("DapGetXchangeTokenPriceHistory",m_DAPRpcSocket))), QString("rcvXchangeTokenPriceHistory")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeTxList("DapGetXchangeTxList",m_DAPRpcSocket))), QString("rcvXchangeTxList")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapXchangeOrderCreate("DapXchangeOrderCreate",m_DAPRpcSocket))), QString("rcvXchangeCreate")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapXchangeOrderRemove("DapXchangeOrderRemove",m_DAPRpcSocket))), QString("rcvXchangeRemove")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetXchangeOrdersList("DapGetXchangeOrdersList",m_DAPRpcSocket))), QString("rcvXchangeOrderList")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapDictionaryCommand("DapDictionaryCommand",m_DAPRpcSocket))), QString("rcvDictionary")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapXchangeOrderPurchase("DapXchangeOrderPurchase",m_DAPRpcSocket))), QString("rcvXchangeOrderPurchase")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapWalletActivateOrDeactivateCommand("DapWalletActivateOrDeactivateCommand",m_DAPRpcSocket))), QString("rcvActivateOrDeactivateReply")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapWebConnectRequest("DapWebConnectRequest",m_DAPRpcSocket))), QString("dapWebConnectRequest")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapWebBlockList("DapWebBlockList",m_DAPRpcSocket))), QString("dapWebBlockList")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapRemoveChainsOrGdbCommand("DapRemoveChainsOrGdbCommand",m_DAPRpcSocket))), QString("rcvRemoveResult")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetFeeCommand("DapGetFeeCommand",m_DAPRpcSocket))), QString("rcvFee")));
    // The command creates a password for the wallet
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCreatePassForWallet("DapCreatePassForWallet", m_DAPRpcSocket))), QString("passwordCreated")));
    
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapSrvStakeRemove("DapSrvStakeRemove", m_DAPRpcSocket))), QString("rxvSrvStakeRemove")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapSrvStakeInvalidate("DapSrvStakeInvalidate", m_DAPRpcSocket))), QString("rcvSrvStakeInvalidate")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapNodeDel("DapNodeDel", m_DAPRpcSocket))), QString("rcvNodeDel")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapRemoveTransactionsQueueCommand("DapRemoveTransactionsQueueCommand", m_DAPRpcSocket))), QString("transactionRemoved")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCheckTransactionsQueueCommand("DapCheckTransactionsQueueCommand", m_DAPRpcSocket))), QString("transactionInfoReceived")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapServiceInitCommand("DapHistoryServiceInitCommand", m_DAPRpcSocket))), QString("historyServiceInitRcv")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapServiceInitCommand("DapWalletServiceInitCommand", m_DAPRpcSocket))), QString("walletsServiceInitRcv")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListKeysCommand("DapGetListKeysCommand", m_DAPRpcSocket))), QString("rcvGetListKeysCommand")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapAddNodeCommand("DapAddNodeCommand", m_DAPRpcSocket))), QString("rcvAddNode")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCheckQueueTransactionCommand("DapCheckQueueTransactionCommand", m_DAPRpcSocket))), QString("rcvCheckQueueTransaction")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new MempoolCheckCommand("MempoolCheckCommand", m_DAPRpcSocket))), QString("rcvMempoolCheckCommand")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapNodeListCommand("DapNodeListCommand", m_DAPRpcSocket))), QString("rcvNodeListCommand")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetNetworksStateCommand("DapGetNetworksStateCommand", m_DAPRpcSocket))), QString("networkStatesListReceived")));
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapMoveWalletCommand("DapMoveWalletCommand", m_DAPRpcSocket))), QString("moveWalletCommandReceived")));

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

    connect(this, &DapServiceController::dapWebConnectRequest, [=] (const QVariant& rcvData)
    {
        qDebug()<<"Rcv web request " << rcvData;
    });

    connect(this, &DapServiceController::dapWebBlockList, [=] (const QVariant& rcvData)
            {
                qDebug() << "Rcv blocklist " << rcvData;
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
    registerEmmitedSignal();
}

void DapServiceController::tryRemoveTransactions(const QVariant& transactions)
{
    QList<QStringList> list;
    QVariantList lists = transactions.toList();
    for (const QVariant& listVariant : lists) {
        QStringList strList = listVariant.toStringList();
        list.append(strList);
    }
    QVariantList variantList;
    for (const QStringList& strList : list) {
        QVariant variant = QVariant::fromValue(strList);
        variantList.append(variant);
    }

    QVariant finalVariant = QVariant::fromValue(variantList);
    this->requestToService("DapRemoveTransactionsQueueCommand", finalVariant);
}

/// Find the emitted signal.
/// @param aValue Transmitted parameter.
void DapServiceController::findEmittedSignal(const QVariant &aValue)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand *>(sender());
    //qDebug() << "findEmittedSignal, transceiver:" << transceiver  << ", value:" << aValue;
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
