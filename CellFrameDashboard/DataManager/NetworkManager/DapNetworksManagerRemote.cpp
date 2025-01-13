#include "DapNetworksManagerRemote.h"
#include "Modules/DapModulesController.h"
#include "DapServiceController.h"
#include "CommandKeys.h"
#include <QJsonArray>

DapNetworksManagerRemote::DapNetworksManagerRemote(DapModulesController *moduleController)
    : DapNetworksManagerBase(moduleController)
{
    connect(m_modulesController->getServiceController(), &DapServiceController::networksListReceived, this, &DapNetworksManagerRemote::networkListRespond);
    connect(m_modulesController, &DapModulesController::initDone, this, [this] ()
            {
                requestNetworkList();
            });
}

void DapNetworksManagerRemote::requestNetworkList()
{
    m_modulesController->getServiceController()->requestToService("DapGetListNetworksCommand", QStringList()
                                            << Dap::CommandParamKeys::NODE_MODE_KEY << Dap::NodeMode::REMOTE_MODE);
}

void DapNetworksManagerRemote::networkListRespond(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    QJsonArray resultArr = replyObj[Dap::CommandParamKeys::RESULT_KEY].toArray();
    if(resultArr.isEmpty())
    {
        if(!m_netList.isEmpty())
        {
            m_netList.clear();
            emit networkListChanged();
        }
        return;
    }
    QStringList netList;
    for(const auto& itemValue: resultArr)
    {
        QString network = itemValue.toString();
        netList.append(network);
    }
    m_netList = netList;
    emit networkListChanged();

    for(const QString& network: netList)
    {
        NetworkInfo networkItem;
        networkItem.networkName  = network;
        emit updateNetworkInfoSignal(networkItem);
    }
}
