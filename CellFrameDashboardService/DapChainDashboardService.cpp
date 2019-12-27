#include "DapChainDashboardService.h"

DapChainDashboardService::DapChainDashboardService() : DapRpcService(nullptr)
{
    connect(this, &DapChainDashboardService::onNewClientConnected, [=] {
        qDebug() << "Frontend connected";
    });
}

bool DapChainDashboardService::start()
{
    qInfo() << "DapChainDashboardService::start()";
    
    m_pServer = new DapUiService();
    m_pServer->setSocketOptions(QLocalServer::WorldAccessOption	);
    if(m_pServer->listen(DAP_BRAND)) 
    {
        connect(m_pServer, SIGNAL(onClientConnected()), SIGNAL(onNewClientConnected()));
        m_pServer->addService(this);
    }
    else
    {
        qCritical() << QString("Can't listen on %1").arg(DAP_BRAND);
        qCritical() << m_pServer->errorString();
        return false;
    }
    return true;
}
