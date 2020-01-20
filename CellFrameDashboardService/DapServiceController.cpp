#include "DapServiceController.h"

/// Standard constructor.
/// @param parent Parent.
DapServiceController::DapServiceController(QObject *parent) : QObject(parent)
{
    connect(this, &DapServiceController::onNewClientConnected, [=] {
        qDebug() << "Frontend connected";
    });
}

/// Start service: creating server and socket.
/// @return Returns true if the service starts successfully, otherwise false.
bool DapServiceController::start()
{
    qInfo() << "DapChainDashboardService::start()";
    
    m_pServer = new DapUiService();
    m_pServer->setSocketOptions(QLocalServer::WorldAccessOption);
    if(m_pServer->listen(DAP_BRAND)) 
    {
        connect(m_pServer, SIGNAL(onClientConnected()), SIGNAL(onNewClientConnected()));
        // Register command to cellframenode
        registerCommand();
    }
    else
    {
        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
        qCritical() << m_pServer->errorString();
        return false;
    }
    return true;
}

/// Register command.
void DapServiceController::registerCommand()
{
     m_pServer->addService(new DapAddWalletCommand("ADD", nullptr, this));
     m_pServer->addService(new DapUpdateLogsCommand("GET_LOG", nullptr, this));
}
