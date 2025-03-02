/****************************************************************************
**
** This file is part of the CellFrameDashboardService application.
** 
** The class implements the main application object CalvinDashboardService. 
** It involves the implementation of the interaction of all the components 
** of the service components. For example, identification of commands, 
** control of the authorization mechanism, management of an GUI client, etc.
**
****************************************************************************/

#ifndef DAPSERVICECONTROLLER_H
#define DAPSERVICECONTROLLER_H

#include <QObject>
#include <QCoreApplication>


#ifdef Q_OS_ANDROID
#include "DapRpcTCPServer.h"
typedef class DapRpcTCPServer DapUiService;
#else
#include "DapRpcLocalServer.h"
typedef class DapRpcLocalServer DapUiService;
#endif

#include "DapWebControllerForService.h"

#include "RequestController/DapRegularRequestsController.h"

/**
 * @brief The DapServiceController class
 * Service class which provide handle operations with dashboard.
 * Class is server which works clients. Protocol to communacate with client is RPC.
 * Work with serves start from public methos start().
 */
class DapServiceController : public QObject
{
    Q_OBJECT
public:
    /// Standard constructor.
    /// @param parent Parent.
    explicit DapServiceController(QObject * parent = nullptr);
    /// Destructor.
    ~DapServiceController();
    /// Start service: creating server and socket.
    /// @return Returns true if the service starts successfully, otherwise false.
    bool start();

private:
    void initServices();
    void initAdditionalParamrtrsService();
    void activityGUIProcessing(bool isRun);
signals:
    /// The signal is emitted in case of successful connection of a new client.
    void onNewClientConnected();
    void onClientDisconnected();
    void onServiceStarted();
private slots:
    void rcvReplyFromClient(QVariant);
    void rcvBlockListFromClient(QVariant);
    void sendConnectRequest(QString site, int index);
    void sendUpdateHistory(const QVariant&);
    void sendUpdateWallets(const QVariant&);
private:
    /// Service core.
    DapUiService        *m_pServer {nullptr};

    DapWebControllerForService *m_web3Controll;

    QThread *m_threadRegular;
    DapRegularRequestsController *m_reqularRequestsCtrl;

    QList<QThread*> m_threadPool;
    QList<DapRpcService*> m_servicePool;

    QSet<QString> m_onceThreadList = { "DapCreateTransactionCommand"
                                    ,"DapXchangeOrderCreate"
                                    ,"DapVersionController"
                                    ,"DapWebConnectRequest"
                                    ,"DapWebBlockList"
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
                                    ,"DapWalletServiceInitCommand"
                                    ,"DapSrvStakeInvalidate"};
};

#endif // DAPSERVICECONTROLLER_H
