#ifndef DAPSERVICECONTROLLER_H
#define DAPSERVICECONTROLLER_H

#include <QObject>
#include <QGenericArgument>
#include <QQmlEngine>
#include <QJSEngine>
#include <QVector>
#include <algorithm>
#include <QDataStream>
#include <QJsonDocument>
#include <QThread>

#include "dapconfigreader.h"
#include "DapNodePathManager.h"
#include "json.h"

#include "DapNotificationWatcher.h"
#include "TransactionQueue/DapTransactionQueueController.h"

#include "NotifyController/DapNotifyController.h"
#include "serviceClient/DapServiceClient.h"
#include "DapServiceClientMessage.h"

#include "handlers/DapAbstractCommand.h"

#include "RequestController/DapRegularRequestsController.h"
#include "DapWebControllerForService.h"

#include "handlers/DapQuitApplicationCommand.h"
#include "handlers/DapActivateClientCommand.h"
#include "handlers/DapCertificateManagerCommands.h"
#include "handlers/DapUpdateLogsCommand.h"
#include "handlers/DapAddWalletCommand.h"
#include "handlers/DapRemoveWalletCommand.h"
#include "handlers/DapGetWalletInfoCommand.h"
#include "handlers/DapGetWalletsInfoCommand.h"
#include "handlers/DapGetNetworkStatusCommand.h"
#include "handlers/DapNetworkGoToCommand.h"
#include "handlers/DapGetListNetworksCommand.h"
#include "handlers/DapExportLogCommand.h"
#include "handlers/DapGetWalletAddressesCommand.h"
#include "handlers/DapGetWalletTokenInfoCommand.h"
//#include "models/DapWalletModel.h"
#include "handlers/DapMempoolProcessCommand.h"
#include "handlers/DapGetAllWalletHistoryCommand.h"
#include "handlers/DapRunCmdCommand.h"
#include "handlers/DapGetHistoryExecutedCmdCommand.h"
#include "handlers/DapSaveHistoryExecutedCmdCommand.h"
#include "handlers/DapGetListOrdersCommand.h"
#include "handlers/DapGetNetworksStateCommand.h"
#include "handlers/DapNetworkSingleSyncCommand.h"
#include "handlers/DapRcvNotify.h"
#include "handlers/DapGetListWalletsCommand.h"
#include "handlers/DapNodeConfigController.h"
#include "handlers/DapVersionController.h"
#include "handlers/DapGetListTokensCommand.h"
#include "handlers/DapTokenEmissionCommand.h"
#include "handlers/DapWebConnectRequest.h"
#include "handlers/DapTokenDeclCommand.h"
#include "handlers/DapGetXchangeTxList.h"
#include "handlers/DapGetXchangeOrdersList.h"
#include "handlers/DapGetXchangeTokenPair.h"
#include "handlers/DapGetXchangeTokenPriceAverage.h"
#include "handlers/DapGetXchangeTokenPriceHistory.h"
#include "handlers/DapDictionaryCommand.h"
#include "handlers/DapWalletActivateOrDeactivateCommand.h"
#include "handlers/DapNodeRestart.h"
#include "handlers/DapRemoveChainsOrGdbCommand.h"
#include "handlers/DapGetFeeCommand.h"
#include "handlers/DapCreatePassForWallet.h"
#include "handlers/DapCreateVPNOrder.h"
#include "handlers/DapCreateStakeOrder.h"
#include "handlers/DapRemoveTransactionsQueueCommand.h"
#include "handlers/DapCheckTransactionsQueueCommand.h"
#include "handlers/DapServiceInitCommand.h"
#include "handlers/DapAddNodeCommand.h"
#include "handlers/DapCheckQueueTransactionCommand.h"
#include "handlers/DapNodeListCommand.h"
#include "handlers/MempoolCheckCommand.h"
#include "handlers/DapCreateStakeOrder.h"
#include "handlers/DapGetListKeysCommand.h"
#include "handlers/DapMoveWalletCommand.h"
#include "handlers/DapNetIdCommand.h"
#include "handlers/DapGetOnceWalletInfoCommand.h"
#include "handlers/DapMempoolListCommand.h"
#include "handlers/DapTransactionListCommand.h"
#include "handlers/DapLedgerTxHashCommand.h"
#include "handlers/DapNodeDumpCommand.h"
#include "handlers/DapGetNodeIPCommand.h"
#include "handlers/DapGetNodeStatus.h"
#include "handlers/DapGetServiceLimitsCommand.h"
#include "handlers/DapVoitingListCommand.h"
#include "handlers/DapVoitingDumpCommand.h"
#include "handlers/stackCommand/DapXchangeOrderCreateStack.h"
#include "handlers/stackCommand/DapXchangeOrderRemoveStack.h"
#include "handlers/stackCommand/DapXchangeOrderPurchaseStack.h"
#include "handlers/stackCommand/DapVoitingCreateCommandStack.h"
#include "handlers/stackCommand/DapVoitingVoteCommandStack.h"
#include "handlers/stackCommand/DapCreateTransactionCommandStack.h"
#include "handlers/stackCommand/DapSrvStakeDelegateCommandStack.h"
#include "handlers/stackCommand/DapTXCondCreateCommandStack.h"
#include "handlers/stackCommand/DapStakeLockHoldCommandStack.h"
#include "handlers/stackCommand/DapStakeLockTakeCommandStack.h"
#include "handlers/stackCommand/DapCreateJsonTransactionCommandStack.h"
#include "handlers/DapTransactionsInfoQueueCommand.h"


#ifdef Q_OS_WIN
#include "registry.h"
#define LOG_FILE    QString("%1/cellframe-node/var/log/cellframe-node.log").arg(regGetUsrPath())
#define CMD_HISTORY QString("%1/%2/data/cmd_history.txt").arg(regGetUsrPath()).arg(DAP_BRAND)
#endif

#ifdef Q_OS_MAC
#define LOG_FILE QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/log/cellframe-node.log").arg(getenv("USER"))
#define CMD_HISTORY QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/data/cmd_history.txt").arg(getenv("USER"))
#endif

#ifdef Q_OS_ANDROID
#include "DapRpcTCPServer.h"
typedef class DapRpcTCPServer DapUiService;
#else
#include "DapRpcLocalServer.h"
typedef class DapRpcLocalServer DapUiService;
#endif

class DapServiceController : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapServiceController)
    /// Standard constructor.
    /// @param apParent Parent.
    explicit DapServiceController(QObject *apParent = nullptr);
    
public:
    ~DapServiceController();
    /// Get an instance of a class.
    /// @return Instance of a class.
    Q_INVOKABLE static DapServiceController &getInstance();

    /// Disconnect all signals
    Q_INVOKABLE void disconnectAll();

    /// Send request to service.
    /// @details In this case, a request is sent to the service to which it is obliged to respond. Expect an answer.
    /// @param asServiceName Service name.
    /// @param arg1...arg10 Parametrs.
    Q_INVOKABLE void requestToService(const QString& asServiceName, const QVariant &args = QVariant());
    /// Notify service.
    /// @details In this case, only a notification is sent to the service, the answer should not be expected.
    /// @param asServiceName Service name.
    /// @param arg1...arg10 Parametrs.
    Q_INVOKABLE void notifyService(const QString& asServiceName, const QVariant &args = QVariant());
    
    /// Brand company.
    Q_PROPERTY(QString Brand MEMBER m_sBrand READ getBrand NOTIFY brandChanged)
    /// Application version.
    Q_PROPERTY(QString Version MEMBER m_sVersion READ getVersion NOTIFY versionChanged)

    Q_PROPERTY(QString CurrentNetwork MEMBER m_sCurrentNetwork READ getCurrentNetwork WRITE setCurrentNetwork NOTIFY currentNetworkChanged)

    Q_PROPERTY(int IndexCurrentNetwork MEMBER m_iIndexCurrentNetwork READ getIndexCurrentNetwork WRITE setIndexCurrentNetwork NOTIFY indexCurrentNetworkChanged)

    Q_PROPERTY(bool ReadingChains MEMBER m_bReadingChains READ getReadingChains WRITE setReadingChains NOTIFY readingChainsChanged)

    /// Client controller initialization.
    /// @param apDapServiceClient Network connection controller.
    void init();
    /// Get company brand.
    /// @return Brand сompany.
    QString getBrand() const;
    /// Get app version.
    /// @return Application version.
    QString getVersion() const;

    QString getCurrentNetwork() const;

    Q_INVOKABLE void setCurrentNetwork(const QString &sCurrentNetwork);
    int getIndexCurrentNetwork() const;
    Q_INVOKABLE void setIndexCurrentNetwork(int iIndexCurrentNetwork);

    bool getReadingChains() const;

    Q_INVOKABLE void setReadingChains(bool bReadingChains);
    Q_INVOKABLE void tryRemoveTransactions(const QVariant& transactions);
public slots:
    void requestWalletList();
//    void requestWalletInfo(const QString& a_walletName, const QStringList& a_networkName);
    void requestNetworkStatus(QString a_networkName);
    void changeNetworkStateToOnline(QString a_networkName);
    void changeNetworkStateToOffline(QString a_networkName);
    void requestOrdersList();
    void requestNetworksList();
    int getAutoOnlineValue();

signals:
    void webConnectRespond(bool accept, int index);
    void rcvWebConenctRequest(QString site, int index);

    /// The signal is emitted when the Brand company property changes.
    /// @param asBrand Brand
    void brandChanged(const QString &brand);
    /// The signal is emitted when the Application version property changes.
    /// @param version Version
    void versionChanged(const QString &version);

    void currentNetworkChanged(const QString &asCurrentNetwork);

    /// The signal is emitted when a command to activate a client is received.
    void clientActivated();
    ///This signal sends data about saving a file from the Logs tab
    /// @param saveLogRezult
    void saveLogRezult(const QVariant& message);
    ///A signal that is used to transmit data to the log model.
    /// @param logUpdated QStringList
    void logUpdated(const QVariant& logs);
    /// A signal is emitted if a transaction is successfully created.
    /// @param aResult Transaction result.
    void transactionCreated(const QVariant& aResult);

    void srvStakeDelegateCreated(const QVariant& aResult);
    /// Signal emitted in case of successful processing of the mempool.
    /// @param aResult Mempool processing result.
    void mempoolProcessed(const QVariant& aResult);

    void walletCreated(const QVariant& wallet);
    void walletRemoved(const QVariant& wallet);

    void walletInfoReceived(const QVariant& walletInfo);
    void walletsInfoReceived(const QVariant& walletList);

    void walletsReceived(const QVariant& walletList);

    void walletReceived(const QVariant& wallet);

    void networksListReceived(const QVariant& networksList);


    void networkStatusReceived(const QVariant& networkStatus);
    void newTargetNetworkStateReceived(const QVariant& targetStateString);

    void walletAddressesReceived(const QVariant& walletAddresses);

    void walletTokensReceived(const QVariant& walletTokens);

    void walletsListReceived(const QVariant& walletsList);

    void indexCurrentNetworkChanged(int iIndexCurrentNetwork);

    void readingChainsChanged(bool bReadingChains);


    void allHistoryReceived(const QVariant& walletHistory);

    void versionControllerResult(const QVariant& versionResult);

    void walletHistoryReceived(const QList<QObject*>& walletHistory);

    void allWalletHistoryReceived(const QVariant& walletHistory);
    /// The signal is emitted when the command is executed by the cli node command handler.
    /// @param asAnswer The response of the cli node command handler.
    void cmdRunned(const QVariant& asAnswer);
    /// The signal is emitted when receiving a history of commands executed by the cli handler.
    /// @param aHistory History of commands executed by cli handler.
    void historyExecutedCmdReceived(const QVariant& aHistory);

    void certificateManagerOperationResult(const QVariant& result);

    void ordersListReceived(const QVariant& ordersInfo);

    void networkStatesListReceived(const QVariant& networksStateList);

    void networksReceived(QList<QObject*> networksList);

    void tokensListReceived(const QVariant& tokensResult);
    void signalTokensListReceived(const QVariant& tokensResult);
    void responseEmissionToken(const QVariant& resultEmission);
    void responseDeclToken(const QVariant& resultDecl);

    void rcvXchangeTxList(const QVariant& rcvData);
    void rcvXchangeCreate(const QVariant& rcvData);
    void rcvXchangeRemove(const QVariant& rcvData);
    void rcvXchangeOrderPurchase(const QVariant& rcvData);

    void rcvXchangeOrderList(const QVariant& rcvData);
    void signalXchangeOrderListReceived(const QVariant& rcvData);
    
    void rcvXchangeTokenPair(const QVariant& rcvData);
    void rcvXchangeTokenPriceAverage(const QVariant& rcvData);
    void rcvXchangeTokenPriceHistory(const QVariant& rcvData);

    void rcvActivateOrDeactivateReply(const QVariant& rcvData);

    void passwordCreated(const QVariant& rcvData);
    
    void rcvFee(const QVariant& rcvData);


    void dapRcvNotify(const QVariant& rcvData);
    void notifyReceived(const QVariant& rcvData);
    void dapWebConnectRequest(const QVariant& rcvData);

    void rcvWordBook(const QVariant& rcvData);

    void rcvDictionary(const QVariant& rcvData);
    void transactionRemoved(const QVariant& rcvData);
    void transactionInfoReceived(const QVariant& rcvData);
    void nodeRestart();

    void rcvRemoveResult(const QVariant& rcvData);

    void exportLogs(const QVariant& rcvData);

    void createdVPNOrder(const QVariant& order);
    void createdStakeOrder(const QVariant& order);

    void historyServiceInitRcv(const QVariant& rcvData);
    void walletsServiceInitRcv(const QVariant& rcvData);
    void rcvAddNode(const QVariant& rcvData);
    void rcvCheckQueueTransaction(const QVariant& rcvData);
    void rcvNodeListCommand(const QVariant& rcvData);
    void rcvMempoolCheckCommand(const QVariant& rcvData);
    void rcvCreateStakeOrder(const QVariant& rcvData);
    void rcvGetListKeysCommand(const QVariant& rcvData);
    void moveWalletCommandReceived(const QVariant& rcvData);
    void rcvNetIdCommand(const QVariant& rcvData);
    void rcvTXCondCreateCommand(const QVariant& rcvData);
    void rcvGetOnceWalletInfoCommand(const QVariant& rcvData);
    void rcvStakeLockHoldCommand(const QVariant& rcvData);
    void rcvStakeLockTakeCommand(const QVariant& rcvData);
    void rcvCreateJsonTransactionCommand(const QVariant& rcvData);
    void rcvMempoolListCommand(const QVariant& rcvData);
    void rcvTransactionListCommand(const QVariant& rcvData);
    void rcvLedgerTxHashCommand(const QVariant& rcvData);
    void rcvNodeDumpCommand(const QVariant& rcvData);
    void rcvGetNodeIPCommand(const QVariant& rcvData);
    void rcvGetNodeStatus(const QVariant& rcvData);
    void rcvGetServiceLimitsCommand(const QVariant& rcvData);
    void rcvVoitingCreateCommand(const QVariant& rcvData);
    void rcvVoitingVoteCommand(const QVariant& rcvData);
    void rcvVoitingListCommand(const QVariant& rcvData);
    void rcvVoitingDumpCommand(const QVariant& rcvData);
    void rcvTransactionsInfoQueueCommand(const QVariant& rcvData);

    void signalStateSocket(QString state, int isFirst, int isError);
    void signalNetState(QVariantMap netState);
    void signalChainsLoadProgress(QVariantMap loadProgress);

    void onServiceStarted();
private slots:
    /// Register command.
    void registerCommand();

    void slotStateSocket(QString state, int isFirst, int isError){emit signalStateSocket(state, isFirst, isError);}
    void slotNetState(QVariantMap netState){emit signalNetState(netState);}
    void slotChainsLoadProgress(QVariantMap loadProgress){emit signalChainsLoadProgress(loadProgress);}

    void sendUpdateHistory(const QVariant&);
    void sendUpdateWallets(const QVariant&);
private:
    void notifySignalsAttach();
    void notifySignalsDetach();

    bool compareJson(QByteArray, QVariant);

    void addService(const QString& name, const QString& signalName, DapAbstractCommand* commandService);
    void initAdditionalParamrtrsService();
private:
    DapRegularRequestsController *m_reqularRequestsCtrl;
    DapUiService        *m_pServer {nullptr};
    DapNotificationWatcher *m_watcher;
    DapWebControllerForService *m_web3Controll;
    /// Brand сompany.
    QString m_sBrand {DAP_BRAND};
    /// Application version.
    QString m_sVersion {DAP_VERSION};

    QString m_sCurrentNetwork;

    int m_iIndexCurrentNetwork;

    bool m_bReadingChains;

    DapNotifyController *m_DapNotifyController;

    /// Service connection management service.
//    DapServiceClient *m_pDapServiceClient {nullptr};
//    DapServiceClientMessage *m_pDapServiceClientMessage {nullptr};
    /// Command manager.
//    QVector<QPair<DapAbstractCommand*, QString>>      m_transceivers;
    QMap<QString, DapRpcService*> m_transceivers;
    QThread* m_threadRegular;
    QThread* m_threadNotify;
    QList<QThread*> m_threadPool;
    /// RPC socket.
    DapRpcSocket    * m_DAPRpcSocket {nullptr};

    QSet<QString> m_onceThreadList = { "DapCreateTransactionCommand"
                                      ,"DapXchangeOrderCreate"
                                      ,"DapVersionController"
                                      ,"DapWebConnectRequest"
                                      ,"DapRcvNotify"
                                      ,"DapQuitApplicationCommand"
                                      ,"DapXchangeOrderPurchase"
                                      ,"DapXchangeOrderRemove"
                                      ,"DapTXCondCreateCommand"
                                      ,"DapStakeLockHoldCommand"
                                      ,"DapCreateJsonTransactionCommand"
                                      ,"DapRemoveTransactionsQueueCommand"
                                      ,"DapCheckTransactionsQueueCommand"
                                      ,"DapStakeLockTakeCommand"
                                      ,"DapHistoryServiceInitCommand"
                                      ,"DapVoitingCreateCommand"
                                      ,"DapVoitingVoteCommand"
                                      ,"DapWalletServiceInitCommand"};
};

#endif // DAPSERVICECONTROLLER_H
