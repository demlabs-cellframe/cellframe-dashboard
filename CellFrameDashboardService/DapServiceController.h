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

#include "DapWebControll.h"

#include "DapNotificationWatcher.h"
#include "DapNetSyncController.h"
#include "DapRegularRequestsController.h"

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
    
signals:
    /// The signal is emitted in case of successful connection of a new client.
    void onNewClientConnected();
    void onClientDisconnected();
    
private slots:
    void sendNotifyDataToGui(QVariant);
    void rcvReplyFromClient(QVariant);
    void rcvBlockListFromClient(QVariant);
    void sendConnectRequest(QString site, int index);

private:
    /// Service core.
    DapUiService        *m_pServer {nullptr};

    DapNotificationWatcher *m_watcher;
    DapNetSyncController *m_syncControll;
    DapWebControll *m_web3Controll;

    // Regular requests controller
    QThread *m_threadRegular;
    DapRegularRequestsController *m_reqularRequestsCtrl;

    QList<QThread*> m_threadPool;
    QThread* m_threadNotify;
    QList<DapRpcService*> m_servicePool;
};

#endif // DAPSERVICECONTROLLER_H
