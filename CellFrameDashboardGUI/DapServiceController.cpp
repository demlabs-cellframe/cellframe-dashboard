#include "DapServiceController.h"

/// Standard constructor.
/// @param apParent Parent.
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

QString DapServiceController::getCurrentChain() const
{
    return (m_sCurrentNetwork == "private") ? "gdb" : "plasma";
}

/// Get an instance of a class.
/// @return Instance of a class.
DapServiceController &DapServiceController::getInstance()
{
    static DapServiceController instance;
    return instance;
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
    Q_ASSERT(transceiver);
    disconnect(transceiver, SIGNAL(serviceResponded(QVariant)), this, SLOT(findEmittedSignal(QVariant)));
    connect(transceiver, SIGNAL(serviceResponded(QVariant)), SLOT(findEmittedSignal(QVariant)));
    transceiver->requestToService(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
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
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->findService(asServiceName));

    Q_ASSERT(transceiver);

    transceiver->notifyToService(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
}

/// Register command.
void DapServiceController::registerCommand()
{
    // Application shutdown team
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapQuitApplicationCommand("DapQuitApplicationCommand", m_DAPRpcSocket))), QString()));
    // GUI client activation command in case it is minimized/expanded
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapActivateClientCommand("DapActivateClientCommand", m_DAPRpcSocket))), QString("clientActivated")));
    // Log update command on the Logs tab
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapUpdateLogsCommand("DapUpdateLogsCommand", m_DAPRpcSocket))), QString("logUpdated")));
    // The team to create a new wallet on the Dashboard tab
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapAddWalletCommand("DapAddWalletCommand", m_DAPRpcSocket))), QString("walletCreated")));
    // The command to get a list of available wallets
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListWalletsCommand("DapGetListWalletsCommand", m_DAPRpcSocket))), QString("walletsListReceived")));
    // Command to save data from the Logs tab
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapExportLogCommand("DapExportLogCommand",m_DAPRpcSocket))), QString("exportLogs")));
    // The command to get a list of available networks
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetListNetworksCommand("DapGetListNetworksCommand", m_DAPRpcSocket))), QString("networksListReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletAddressesCommand("DapGetWalletAddressesCommand", m_DAPRpcSocket))), QString("walletAddressesReceived")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletTokenInfoCommand("DapGetWalletTokenInfoCommand", m_DAPRpcSocket))), QString("walletTokensReceived")));
    // Creating a token transfer transaction between wallets
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapCreateTransactionCommand("DapCreateTransactionCommand",m_DAPRpcSocket))), QString("transactionCreated")));
    // Transaction confirmation
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapMempoolProcessCommand("DapMempoolProcessCommand",m_DAPRpcSocket))), QString("mempoolProcessed")));

    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetWalletHistoryCommand("DapGetWalletHistoryCommand",m_DAPRpcSocket))), QString("historyReceived")));
    // Run cli command
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapRunCmdCommand("DapRunCmdCommand",m_DAPRpcSocket))), QString("cmdRunned")));
    // Get history of commands executed by cli handler
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapGetHistoryExecutedCmdCommand("DapGetHistoryExecutedCmdCommand",m_DAPRpcSocket))), QString("historyExecutedCmdReceived")));
    // Save cmd command in file
    m_transceivers.append(qMakePair(dynamic_cast<DapAbstractCommand*>(m_DAPRpcSocket->addService(new DapSaveHistoryExecutedCmdCommand("DapSaveHistoryExecutedCmdCommand",m_DAPRpcSocket))), QString()));


    connect(this, &DapServiceController::walletsListReceived, [=] (const QVariant& walletList)
    {
        QByteArray  array = QByteArray::fromHex(walletList.toByteArray());
        QList<DapWallet> tempWallets;

        QDataStream in(&array, QIODevice::ReadOnly);
        in >> tempWallets;

        QList<QObject*> wallets;
        auto begin = tempWallets.begin();
        auto end = tempWallets.end();
        DapWallet * wallet = nullptr;
        for(;begin != end; ++begin)
        {
            wallet = new DapWallet(*begin);
            wallets.append(wallet);
        }

        emit walletsReceived(wallets);
    });

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

        emit walletHistoryReceived(walletHistory);
    });

    registerEmmitedSignal();
}

/// Find the emitted signal.
/// @param aValue Transmitted parameter.
void DapServiceController::findEmittedSignal(const QVariant &aValue)
{
    DapAbstractCommand * transceiver = dynamic_cast<DapAbstractCommand *>(sender());
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

/// Register a signal handler for notification results.
void DapServiceController::registerEmmitedSignal()
{
    foreach (auto command, m_transceivers)
    {
        connect(command.first, SIGNAL(clientNotifed(QVariant)), SLOT(findEmittedSignal(QVariant)));
    }
}




