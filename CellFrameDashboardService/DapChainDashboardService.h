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

#ifndef DAPCHAINDASHBOARDSERVICE_H
#define DAPCHAINDASHBOARDSERVICE_H

#include <QObject>
#include <QCoreApplication>

#include "DapRpcAbstractServer.h"
#include "DapRpcLocalServer.h"
#include "DapRpcTCPServer.h"
#include "DapRpcService.h"

#include <QLocalServer>
typedef class DapRpcLocalServer DapUiService;

/**
 * @brief The DapChainDashboardService class
 * Service class which provide handle operations with dashboard.
 * Class is server which works clients. Protocol to communacate with client is RPC.
 * Work with serves start from public methos start().
 * Class consist of follow handlers:
 * @see DapChainLogHandler
 */
class DapChainDashboardService : public DapRpcService
{
    Q_OBJECT
    Q_CLASSINFO("serviceName", "RPCServer")
    /// Service core.
    DapUiService            * m_pServer {nullptr};

public:
    /// Standard сonstructor.
    explicit DapChainDashboardService();
    /// Start service: creating server and socket
    bool start();
    
signals:
    /// The signal is emitted in case of successful connection of a new client.
    void onNewClientConnected();
};

#endif // DAPCHAINDASHBOARDSERVICE_H
