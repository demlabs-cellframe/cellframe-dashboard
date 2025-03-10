#include "DapModuleNetworks.h"
#include "DapDataManagerController.h"
#include "DapNetworksManagerLocal.h"

DapModuleNetworks::DapModuleNetworks(DapModulesController *parent)
    :DapAbstractModule(parent)
    , m_networkModel(new DapNetworkModel())
    , m_netListModel(new DapStringListModel)
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("networkModel", m_networkModel);
    m_netListModel->setStringList({"All"});
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("netListModel", m_netListModel);

    if(DapNodeMode::g_node_mode == DapNodeMode::LOCAL)
    {
        connect(this, &DapModuleNetworks::sigNetLoadProgress, m_modulesCtrl, &DapModulesController::setNodeLoadProgress);
        connect(this, &DapModuleNetworks::sigNetsLoading, m_modulesCtrl, &DapModulesController::setIsNodeWorking);
    }
    else
    {
        m_modulesCtrl->setIsNodeWorking(true);
    }

    auto* networkManager = m_modulesCtrl->getManagerController()->getNetworkManager();
    connect(networkManager, &DapNetworksManagerLocal::deleteNetworksSignal,    this, &DapModuleNetworks::deleteNetworksSlot);
    connect(networkManager, &DapNetworksManagerBase::updateNetworkInfoSignal,  this, &DapModuleNetworks::updateModelInfo);
    connect(networkManager, &DapNetworksManagerLocal::isConnectedChanged,      this, &DapModuleNetworks::slotNotifyIsConnected);
    connect(networkManager, &DapNetworksManagerLocal::sigUpdateItemNetLoad,    this, &DapModuleNetworks::slotUpdateItemNetLoad);
    connect(networkManager, &DapNetworksManagerLocal::networkListChanged,      this, &DapModuleNetworks::networkListChangedSlot);
}

DapModuleNetworks::~DapModuleNetworks()
{
    disconnect();
    delete m_networkModel;
}

void DapModuleNetworks::slotUpdateData()
{
    m_networkModel->clear();
}

void DapModuleNetworks::goSync(QString net)
{
    s_serviceCtrl->requestToService("DapNetworkSingleSyncCommand",QStringList()<<net);
}

void DapModuleNetworks::goOnline(QString net)
{
    s_serviceCtrl->requestToService("DapNetworkGoToCommand",QStringList()<<net<<"online");
}

void DapModuleNetworks::goOffline(QString net)
{
    s_serviceCtrl->requestToService("DapNetworkGoToCommand",QStringList()<<net<<"offline");
}

void DapModuleNetworks::networkListChangedSlot()
{
    QStringList list = {"All"};
    QStringList netList = m_modulesCtrl->getManagerController()->getNetworkList();
    list.append(netList);
    m_netListModel->setStringList(std::move(list));

    m_networkModel->updateListModel(netList);
}

void DapModuleNetworks::deleteNetworksSlot(const QStringList& list)
{
    m_networkModel->remove(list);
}

void DapModuleNetworks::updateModelInfo(const NetworkInfo& info)
{
    if(m_networkModel->isEmpty())
    {
        m_networkModel->add(info);
    }
    else
    {
        m_networkModel->updateModel(info);
    }
}

int DapModuleNetworks::getIndexItemModel(QString netName)
{
    if(m_networkModel->size() > 0)
    {
        for(auto itr = m_networkModel->size()-1; itr != -1; itr--)
        {
            if(m_networkModel->at(itr).networkName == netName)
            {
                return itr;
            }
        }
    }
    else
    {
        qDebug()<<"Model is empty";
        return -1;
    }
    qDebug()<<"Could'n find item: " << netName << " in model";
    return -1;
}

void DapModuleNetworks::clearAll()
{
    m_networkModel->clear();
    // m_netsLoadProgress.clear();
}

void DapModuleNetworks::slotUpdateItemNetLoad()
{
    auto& netLoadProgress = m_modulesCtrl->getManagerController()->getNetworkManager()->getNetworkLoadProgress();
    int netsCount = netLoadProgress.count();
    double totalProgressLoading = 0.0f;

    for (const auto &key : netLoadProgress.keys())
    {
        const NetworkLoadProgress &netLoadItm = netLoadProgress.value(key);

        if(netLoadItm.state == "" || netLoadItm.state == "Error.")
            continue;

        if (netLoadItm.state == "LOADING")
        {
            bool ok;
            double percent = netLoadItm.percent.toDouble(&ok);

            if (!ok) {
                qDebug() << "Conversion failed for percent:" << netLoadItm.percent;
                percent = 0.0f;
            }

            totalProgressLoading += percent;
        }
        else
        {
            totalProgressLoading += 100.0;
        }
    }

    double calc = totalProgressLoading / netsCount;

    calc = calc >= 0 ? calc : 0;
    emit sigNetLoadProgress((int)calc);

    if(calc != 100.0)
    {
        emit sigNetsLoading(false);
    }
    else
    {
        emit sigNetsLoading(true);
    }
}

void DapModuleNetworks::slotNotifyIsConnected(bool isConnected)
{
    if(!isConnected)
    {
        clearAll();
        emit sigNetsLoading(false);
        emit sigNetLoadProgress(0);
    }
}

QString DapModuleNetworks::convertProgress(QJsonObject obj)
{
    auto getChainPercent = [](const QJsonObject& chainObj, QString chainName) -> double
    {
        double chainPercent = 0.0;
        if(chainObj.contains("status"))
        {
            QString status = chainObj["status"].toString();
            if(status == "synced")
            {
                chainPercent = 100.0;
            }
            else if(status == "not synced")
            {
                chainPercent = 0.0;
            }
            else
            {
                if(chainObj.contains("percent"))
                {
                    bool ok;
                    QString percntStr = chainObj["percent"].toString();
                    percntStr = percntStr.remove("%").trimmed();
                    chainPercent = percntStr.toDouble(&ok);
                    if(!ok)
                    {
                        chainPercent = 0.0;
                        qDebug() << "Value of 'percent' is not a number:" << percntStr;
                    }
                }
                else
                {
                    qDebug() << "No have key 'percent' in the chain:" << chainName;
                }
            }
        }
        else
        {
            qDebug() << "No have key of chain with name:" << chainName;
        }
        return chainPercent;
    };

    double summPercent = 0.0;

    QStringList chains = obj.keys();

    if(chains.count())
    {
        for(const auto &chain : chains)
        {
            summPercent += (getChainPercent(obj[chain].toObject(), chain) * 0.45);
        }
    }
    else
    {
        qDebug() << "No chains";
    }

    return QString::number(static_cast<int>(std::round(summPercent)));
}
