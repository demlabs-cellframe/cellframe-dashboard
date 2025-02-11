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
#include <QtConcurrent/QtConcurrent>

#include "dapconfigreader.h"
#include "json.h"

#include "TransactionQueue/DapTransactionQueueController.h"


#include "serviceClient/DapServiceClient.h"
#include "DapServiceClientMessage.h"

#include "handlers/DapAbstractCommand.h"

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
#include "handlers/DapGetWalletAddressCommand.h"
#include "handlers/DapGetWalletTokenInfoCommand.h"
#include "handlers/DapMempoolProcessCommand.h"
#include "handlers/DapGetWalletHistoryCommand.h"
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
#include "handlers/DapSrvStakeInvalidate.h"
#include "handlers/DapNodeDel.h"
#include "handlers/DapSrvStakeRemove.h"
#include "handlers/DapWebBlockList.h"

#include "handlers/DapCreateTxCommand.h"


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
#define LOG_FILE QString("")
#define CMD_HISTORY QString("")

#endif

class DapServiceController : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(DapServiceController)

public:
    void run();
    explicit DapServiceController(QObject *apParent = nullptr);
    ~DapServiceController();
    // Q_INVOKABLE static DapServiceController &getInstance();
    Q_INVOKABLE void disconnectAll();

    Q_INVOKABLE void requestToService(const QString& asServiceName, const QVariant &args = QVariant());

    Q_PROPERTY(bool ReadingChains MEMBER m_bReadingChains READ getReadingChains WRITE setReadingChains NOTIFY readingChainsChanged)
    Q_INVOKABLE void setReadingChains(bool bReadingChains);
    bool getReadingChains() const {return m_bReadingChains;}

    Q_INVOKABLE void tryRemoveTransactions(const QVariant& transactions);

signals:
    void readingChainsChanged(bool bReadingChains);
    void webConnectRespond(bool accept, int index);
    void rcvWebConenctRequest(QString site, int index);

    void onServiceStarted();
private slots:
    void registerCommand();

    void sendUpdateHistory(const QVariant& data);
    void sendUpdateWallets(const QVariant& data);

private:
    void addService(const QString& name, const QString& signalName, DapAbstractCommand* commandService);

    template <typename ServiceType, typename... TArgs>
    void addServiceGeneric(const QString& name, const QString& signalName, TArgs... ctr_args);

    void initAdditionalParamrtrsService();
private:
    DapWebControllerForService *m_web3Controll;

    bool m_bReadingChains;

    QMap<QString, DapAbstractCommand*> m_transceivers;

///------RCV HANDLERS SIGNALS------///
signals:

    /*Wallet*/
    void walletCreated(const QVariant& wallet);
    void walletRemoved(const QVariant& wallet);
    void walletInfoReceived(const QVariant& walletInfo);
    void walletsReceived(const QVariant& walletList);
    void walletsListReceived(const QVariant& walletsList);
    void walletReceived(const QVariant& wallet);
    void moveWalletCommandReceived(const QVariant& rcvData);
    void passwordCreated(const QVariant& rcvData);
    void rcvActivateOrDeactivateReply(const QVariant& rcvData);
//    void rcvGetOnceWalletInfoCommand(const QVariant& rcvData);
//    void walletTokensReceived(const QVariant& walletTokens);
    void walletAddressReceived(const QVariant& walletAddresses);
    void rcvWalletListByPath(const QVariant& rcvData);

    /*Xchange*/
    void rcvXchangeTxList(const QVariant& rcvData);
    void rcvXchangeCreate(const QVariant& rcvData);
    void rcvXchangeRemove(const QVariant& rcvData);
    void rcvXchangeOrderPurchase(const QVariant& rcvData);
    void rcvXchangeOrderList(const QVariant& rcvData);
    void rcvXchangeTokenPair(const QVariant& rcvData);
    void rcvXchangeTokenPriceAverage(const QVariant& rcvData);
    void rcvXchangeTokenPriceHistory(const QVariant& rcvData);

    /*Voting*/
    void rcvVoitingCreateCommand(const QVariant& rcvData);
    void rcvVoitingVoteCommand(const QVariant& rcvData);
    void rcvVoitingListCommand(const QVariant& rcvData);
    void rcvVoitingDumpCommand(const QVariant& rcvData);

    /*Stake*/
    void rcvStakeLockHoldCommand(const QVariant& rcvData);
    void rcvStakeLockTakeCommand(const QVariant& rcvData);
    void rcvSrvStakeInvalidate(const QVariant& rcvData);
    void rcvSrvStakeRemove(const QVariant& rcvData);
    void createdStakeOrder(const QVariant& order);
    void srvStakeDelegateCreated(const QVariant& aResult);

    /*Network*/
    void networksListReceived(const QVariant& networksList);
    void networkStatusReceived(const QVariant& networkStatus);
    void newTargetNetworkStateReceived(const QVariant& targetStateString);
    void rcvNetIdCommand(const QVariant& rcvData);
    void networkStatesListReceived(const QVariant& networksStateList);

    /*Transaction*/
    void rcvCreateJsonTransactionCommand(const QVariant& rcvData);
    void rcvTransactionListCommand(const QVariant& rcvData);
    void rcvTransactionsInfoQueueCommand(const QVariant& rcvData);
    void rcvCheckQueueTransaction(const QVariant& rcvData);
    void transactionRemoved(const QVariant& rcvData);
    void transactionInfoReceived(const QVariant& rcvData);
    void transactionCreated(const QVariant& aResult);
    void rcvTXCondCreateCommand(const QVariant& rcvData);
    void rcvFee(const QVariant& rcvData);
    void rcvTxCreated(const QVariant& rcvData);

    /*Node*/
    void nodeRestart();
    void rcvAddNode(const QVariant& rcvData);
    void rcvNodeListCommand(const QVariant& rcvData);
    void rcvNodeDumpCommand(const QVariant& rcvData);
    void rcvGetNodeIPCommand(const QVariant& rcvData);
    void rcvGetNodeStatus(const QVariant& rcvData);
    void rcvNodeDel(const QVariant& rcvData);

    /*Mempool*/
    void rcvMempoolCheckCommand(const QVariant& rcvData);
    void rcvMempoolListCommand(const QVariant& rcvData);
    //    void mempoolProcessed(const QVariant& aResult);

    /*Token*/
    void tokensListReceived(const QVariant& tokensResult);
    void signalTokensListReceived(const QVariant& tokensResult);
    void responseEmissionToken(const QVariant& resultEmission);
    void responseDeclToken(const QVariant& resultDecl);

    /*Order*/
    void ordersListReceived(const QVariant& ordersInfo);
    void createdVPNOrder(const QVariant& order);

    /*Certificate*/
    void certificateManagerOperationResult(const QVariant& result);

    /*History*/
    void allWalletHistoryReceived(const QVariant& walletHistory);

    /*Other*/
    void logUpdated(const QVariant& logs);
    void historyExecutedCmdReceived(const QVariant& aHistory);
    void versionControllerResult(const QVariant& versionResult);
    void cmdRunned(const QVariant& asAnswer);
    void dapWebConnectRequest(const QVariant& rcvData);
    void rcvDictionary(const QVariant& rcvData);
    void rcvRemoveResult(const QVariant& rcvData);
    void exportLogs(const QVariant& rcvData);
    void historyServiceInitRcv(const QVariant& rcvData);
    void walletsServiceInitRcv(const QVariant& rcvData);
    void rcvGetListKeysCommand(const QVariant& rcvData);
    void rcvLedgerTxHashCommand(const QVariant& rcvData);
    void rcvGetServiceLimitsCommand(const QVariant& rcvData);
    void rcvWebBlockList(const QVariant& rcvData);
};

#endif // DAPSERVICECONTROLLER_H
