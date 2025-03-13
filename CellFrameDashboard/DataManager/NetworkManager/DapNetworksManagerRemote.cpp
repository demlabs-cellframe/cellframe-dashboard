#include "DapNetworksManagerRemote.h"
#include "Modules/DapModulesController.h"
#include "DapServiceController.h"
#include "CommandKeys.h"
#include <QJsonArray>

DapNetworksManagerRemote::DapNetworksManagerRemote(DapModulesController *moduleController)
    : DapNetworksManagerBase(moduleController)
    , m_netListTimer(new QTimer())
{
    connect(m_modulesController, &DapModulesController::sigUpdateData, this, &DapNetworksManagerRemote::clearAndUpdateDataSlot);
    connect(m_modulesController->getServiceController(), &DapServiceController::networksListReceived, this, &DapNetworksManagerRemote::networkListRespond);
    connect(m_modulesController->getServiceController(), &DapServiceController::networkStatesListReceived, this, &DapNetworksManagerRemote::networksStatesRespond);
    connect(m_netListTimer, &QTimer::timeout, this, &DapNetworksManagerRemote::requestNetworkList);
    requestNetworkList();
    m_netListTimer->start(10000);
}

void DapNetworksManagerRemote::requestNetworkList()
{
    if(!isSendRequest)
    {
        isSendRequest = true;
        m_modulesController->getServiceController()->requestToService("DapGetListNetworksCommand", QVariantMap({{Dap::KeysParam::NODE_MODE_KEY, Dap::NodeMode::REMOTE_MODE}}));
    }
}

void DapNetworksManagerRemote::requestNetworskInfo()
{
//    QVariantMap req;
//    req.insert(Dap::KeysParam::NODE_MODE_KEY, Dap::NodeMode::REMOTE_MODE);
//    req.insert(Dap::CommandParamKeys::NETWORK_LIST,  m_netList);

    QString nodeMade = Dap::NodeMode::REMOTE_MODE;
    QVariantMap request = {{Dap::KeysParam::NODE_MODE_KEY, nodeMade}
                           ,{Dap::KeysParam::NETWORK_LIST, m_netList}};


    m_modulesController->getServiceController()->requestToService("DapGetNetworksStateCommand", request);
}

void DapNetworksManagerRemote::networkListRespond(const QVariant &rcvData)
{
    isSendRequest = false;

    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    QJsonArray resultArr = replyObj[Dap::CommandParamKeys::RESULT_KEY].toArray();
    m_netListTimer->stop();
    if(resultArr.isEmpty())
    {
        if(!m_netList.isEmpty())
        {
            m_netList.clear();
            emit networkListChanged();
        }
        else
        {
            m_netListTimer->start(1000);
        }
        return;
    }
    QStringList netList;
    for(const auto& itemValue: resultArr)
    {
        QString network = itemValue.toString();
        netList.append(network);
    }
    if(m_netList != netList)
    {
        QStringList toRemoveList = DapCommonMethods::getDifference(m_netList, netList);
        if(!toRemoveList.isEmpty())
        {
            emit deleteNetworksSignal(toRemoveList);
        }
        m_netList = netList;
        emit networkListChanged();

        for(const QString& network: qAsConst(netList))
        {
            NetworkInfo networkItem;
            networkItem.networkName  = network;
            emit updateNetworkInfoSignal(networkItem);
        }
    }
    m_netListTimer->start(60000);
    requestNetworskInfo();
}

void DapNetworksManagerRemote::networksStatesRespond(const QVariant &rcvData)
{
    QJsonObject obj = QJsonDocument::fromJson(rcvData.toByteArray()).object();
    QJsonArray arr = obj[Dap::CommandParamKeys::RESULT_KEY].toArray();

    for(auto item : arr)
    {
        NetworkInfo netInfo;
        QJsonObject netObj = item.toObject();

        netInfo.networkName;

        netInfo.networkName         = netObj["name"].toString();
        netInfo.networkState        = netObj["networkState"].toString();
        netInfo.targetState         = netObj["targetState"].toString();
        netInfo.address             = netObj["nodeAddress"].toString();
        netInfo.activeLinksCount    = netObj["activeLinksCount"].toString();
        netInfo.linksCount          = netObj["linksCount"].toString();
        netInfo.syncPercent         = netObj["syncPercent"].toString();
        netInfo.errorMessage        = netObj["errorMessage"].toString();
        netInfo.displayNetworkState = netObj["displayNetworkState"].toString();
        netInfo.displayTargetState  = netObj["displayTargetState"].toString();

        emit updateNetworkInfoSignal(netInfo);
    }
}

void DapNetworksManagerRemote::clearAndUpdateDataSlot()
{
    m_netListTimer->stop();
    m_netList.clear();
    m_netsLoadProgress.clear();
    isSendRequest = false;
    requestNetworkList();
    m_netListTimer->start(10000);
}
