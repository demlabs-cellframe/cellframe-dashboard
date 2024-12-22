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

    connect(m_modulesCtrl, &DapModulesController::sigNotifyControllerIsInit, [=] ()
    {
        m_notifyCtrl = m_modulesCtrl->getNotifyCtrl();
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

void DapModuleNetworks::goSync()
{

}

void DapModuleNetworks::goOnline()
{

}

void DapModuleNetworks::goOffline()
{

}

void DapModuleNetworks::slotRcvNotifyNetList(QJsonDocument doc)
{
    QStringList list = doc.toVariant().toStringList();

    auto getDifference = [] (const QStringList list1, const QStringList list2) -> QStringList
    {
        QStringList difference;
        for (const QString &item : list1) {
            if (!list2.contains(item)) {
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
        for(const QString &net : qAsConst(s_netList))
        {
            int idx = getIndexItemModel(net);
            if(idx)
            {
                m_networkModel->remove(idx);
            }
            else
            {
                //TODO: Append empty network item until the data comes in ?
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

    emit sigUpdateItemNetLoad(netLoadItm);
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
        emit sigUpdateItemNetLoad(item);
}

DapNetworkModel::Item DapModuleNetworks::itemModelGenerate(QString netName, QJsonObject itemModel)
{
    DapNetworkModel::Item networkItem;

    networkItem.networkName  = netName;
    networkItem.address      = itemModel["current_addr"].toString();
    networkItem.errorMessage = "";
    networkItem.syncPercent  = convertProgress(itemModel["processed"].toObject());

    if(!itemModel.contains("links"))
    {
        networkItem.activeLinksCount = "0";
        networkItem.linksCount       = "0";
    }
    else
    {
        QJsonObject links = itemModel["links"].toObject();
        networkItem.activeLinksCount = links["active"].toString();
        networkItem.linksCount       = links["required"].toString();
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

    if(idx)
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
    for(auto itr = m_networkModel->size()-1; itr != 0; itr--)
    {
        if(m_networkModel->at(itr).networkName == netName)
        {
            return itr;
        }
    }
    qDebug()<<"Could'n find item: " << netName << " in model";
    return -1;
}

void DapModuleNetworks::slotUpdateItemNetLoad(NetLoadProgress netItm)
{
    m_netsLoadProgress.insert(netItm.name,netItm);

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
    m_totalProgressNetsLoad = QString::number(calc, 'f',0);

    if(calc != 100.0)
    {
        emit sinNetsLoading(false);
        emit sigNetLoadProgress(m_totalProgressNetsLoad);
    }
    else
    {
        emit sinNetsLoading(true);
        emit sigNetLoadProgress(m_totalProgressNetsLoad);
    }

    qDebug()<<m_totalProgressNetsLoad;
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
    auto getChainPercent = [](const QJsonObject& obj, const QString& chain) -> double
    {
        double chainPercent = 0.0;
        QJsonObject chainObj = obj[chain].toObject();
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
                    qDebug() << "No have key 'percent' in the chain:" << chain;
                }
            }
        }
        else
        {
            qDebug() << "No have key of chain with name:" << chain;
        }
        return chainPercent;
    };

    double summPercent = 0.0;

    if(obj.contains("main") && obj.contains("zerochain"))
    {
        double mainPercent = getChainPercent(obj, "main");
        double zeroPercent = getChainPercent(obj, "zerochain");
        summPercent = mainPercent * 0.45 + zeroPercent * 0.45;
    }
    else
    {
        qDebug() << "No have keys with name of chains";
    }

    return QString::number(static_cast<int>(std::round(summPercent)));
}
