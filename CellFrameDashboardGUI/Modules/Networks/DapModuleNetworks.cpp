#include "DapModuleNetworks.h"

static const QMap<QString, QString> s_stateStrings = {
    { "NET_STATE_OFFLINE", "OFFLINE"},
    { "NET_STATE_ONLINE", "ONLINE"},
    { "NET_STATE_LINKS_PREPARE", "LINKS PREPARE"},
    { "NET_STATE_LINKS_ESTABLISHED", "LINKS ESTABLISHED"},
    { "NET_STATE_LINKS_CONNECTING", "LINKS CONNECTING"},
    { "NET_STATE_SYNC_CHAINS", "SYNC CHAINS"},
    { "NET_STATE_SYNC_GDB", "SYNC GDB"},
    { "NET_STATE_ADDR_REQUEST", "ADDR REQUEST"},
    { "UNDEFINED", "ERROR"}
};


DapModuleNetworks::DapModuleNetworks(DapModulesController *parent)
    :DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_networkModel(new DapNetworkModel())
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("networkModel", m_networkModel);

    connect(this, &DapModuleNetworks::sigNetLoadProgress, m_modulesCtrl, &DapModulesController::setNodeLoadProgress);
    connect(this, &DapModuleNetworks::sigNetsLoading, m_modulesCtrl, &DapModulesController::setIsNodeWorking);

    connect(m_modulesCtrl, &DapModulesController::sigNotifyControllerIsInit, [this] ()
    {
        m_notifyCtrl = m_modulesCtrl->getNotifyCtrl();
        connect(m_notifyCtrl, &DapNotifyController::isConnectedChanged,   this, &DapModuleNetworks::slotNotifyIsConnected);
        connect(m_notifyCtrl, &DapNotifyController::sigNotifyRcvNetList,  this, &DapModuleNetworks::slotRcvNotifyNetList);
        connect(m_notifyCtrl, &DapNotifyController::sigNotifyRcvNetInfo,  this, &DapModuleNetworks::slotRcvNotifyNetInfo);
        connect(m_notifyCtrl, &DapNotifyController::sigNotifyRcvNetsInfo, this, &DapModuleNetworks::slotRcvNotifyNetsInfo);


        connect(this, &DapModuleNetworks::sigUpdateItemNetLoad, this, &DapModuleNetworks::slotUpdateItemNetLoad);
    });
}


DapModuleNetworks::~DapModuleNetworks()
{
    disconnect();
    delete m_networkModel;
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

void DapModuleNetworks::slotRcvNotifyNetList(QJsonDocument doc)
{
    QStringList list = doc.toVariant().toStringList();

    auto getDifference = [] (const QStringList list1, const QStringList list2) -> QStringList
    {
        QStringList difference;
        for (const QString &item : list1)
        {
            if (!list2.contains(item))
            {
                difference.append(item);
            }
        }
        return difference;
    };

    QStringList diff = getDifference(s_netList, list);

    if(s_netList.count() != list.count() || diff.count())
    {
        qDebug()<<"Change net list";
        s_netList = list;

        //If model contains item  - remove him.
        //Because there is no such element in the received list of networks.
        for(const QString &net : qAsConst(diff))
        {
            m_netsLoadProgress.remove(net);
            int idx = getIndexItemModel(net);
            if(idx >= 0)
            {
                m_networkModel->remove(idx);
            }
        }
    }
    else
    {
        qDebug()<<"Net lists is equal";
    }
}

void DapModuleNetworks::slotRcvNotifyNetInfo(QJsonDocument doc)
{
    QJsonObject netObj = doc.object();
    QString netName = netObj["net"].toString();
    DapNetworkModel::Item networkItem = itemModelGenerate(netName, netObj);

    updateItemModel(networkItem);

    NetLoadProgress netLoadItm;
    netLoadItm.name     = networkItem.networkName;
    netLoadItm.state    = networkItem.displayNetworkState;
    netLoadItm.percent  = networkItem.syncPercent;

    m_netsLoadProgress.insert(netLoadItm.name,netLoadItm);
    emit sigUpdateItemNetLoad();
}

void DapModuleNetworks::slotRcvNotifyNetsInfo(QJsonDocument doc)
{
    QJsonObject obj = doc.object();
    QStringList keys = obj.keys();
    QList<NetLoadProgress> netsLoadList;


    for(const QString &key : keys)
    {
        QJsonObject netObject = obj[key].toObject();

        DapNetworkModel::Item networkItem = itemModelGenerate(key, netObject);

        NetLoadProgress netLoadItm;
        netLoadItm.name     = networkItem.networkName;
        netLoadItm.state    = networkItem.displayNetworkState;
        netLoadItm.percent  = networkItem.syncPercent;
        netsLoadList.append(netLoadItm);

        if(m_networkModel->isEmpty())
        {
            m_networkModel->add(networkItem);
        }
        else
        {
            updateItemModel(networkItem);
        }
    }


    for(const auto &item : netsLoadList)
        m_netsLoadProgress.insert(item.name,item);

    emit sigUpdateItemNetLoad();
}

DapNetworkModel::Item DapModuleNetworks::itemModelGenerate(QString netName, QJsonObject itemModel)
{
    DapNetworkModel::Item networkItem;

    networkItem.networkName  = netName;
    networkItem.address      = itemModel["current_addr"].toString();
    networkItem.errorMessage = itemModel["errorMessage"].toString();
    networkItem.syncPercent  = convertProgress(itemModel["processed"].toObject());

    if(!itemModel.contains("links"))
    {
        networkItem.activeLinksCount = "0";
        networkItem.linksCount       = "0";
    }
    else
    {
        QJsonObject links = itemModel["links"].toObject();
        networkItem.activeLinksCount = links["active"].toVariant().toString();
        networkItem.linksCount       = links["required"].toVariant().toString();
    }


    QJsonObject states = itemModel["states"].toObject();
    networkItem.networkState        = states["current"].toString();
    networkItem.targetState         = states["target"].toString();
    networkItem.displayNetworkState = convertState(states["current"].toString());
    networkItem.displayTargetState  = convertState(states["target"].toString());

    return networkItem;
}

void DapModuleNetworks::updateItemModel(DapNetworkModel::Item itmModel)
{
    int idx = getIndexItemModel(itmModel.networkName);

    if(idx >= 0)
    {
        m_networkModel->set(idx, itmModel);
    }
    else
    {
        m_networkModel->add(itmModel);
    }
}

void DapModuleNetworks::updateFullModel(QJsonDocument docModel)
{
    //TODO: ...
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
    m_netsLoadProgress.clear();
}

void DapModuleNetworks::slotUpdateItemNetLoad()
{
    int netsCount = m_netsLoadProgress.count();
    double totalProgressLoading = 0.0f;

    for (const auto &key : m_netsLoadProgress.keys())
    {
        const NetLoadProgress &netLoadItm = m_netsLoadProgress.value(key);

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
    m_totalProgressNetsLoad = (int)calc;

    emit sigNetLoadProgress(m_totalProgressNetsLoad);

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

QString DapModuleNetworks::convertState(QString state)
{
    if(s_stateStrings.contains(state))
    {
        return s_stateStrings[state];
    }

    auto substr = QString("NET_STATE_");
    if(state.contains(substr))
    {
        QString result = state;
        result.remove(substr);
        return result;
    }

    return state;
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
