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

#include "DapRpcLocalServer.h"

#include <QLocalServer>
typedef class DapRpcLocalServer DapUiService;


#include "Handlers/DapAbstractCommand.h"
#include "Handlers/DapAddWalletCommand.h"
#include "Handlers/DapUpdateLogsCommand.h"

/**
 * @brief The DapServiceController class
 * Service class which provide handle operations with dashboard.
 * Class is server which works clients. Protocol to communacate with client is RPC.
 * Work with serves start from public methos start().
 */
class DapServiceController : public QObject
{
    Q_OBJECT

    /// Service core.
    DapUiService    * m_pServer {nullptr};
  
public:
    /// Standard constructor.
    /// @param parent Parent.
    explicit DapServiceController(QObject * parent = nullptr);
    /// Start service: creating server and socket.
    /// @return Returns true if the service starts successfully, otherwise false.
    bool start();
    
signals:
    /// The signal is emitted in case of successful connection of a new client.
    void onNewClientConnected();
    
private slots:
    /// Register command.
    void registerCommand();
};

#endif // DAPSERVICECONTROLLER_H
