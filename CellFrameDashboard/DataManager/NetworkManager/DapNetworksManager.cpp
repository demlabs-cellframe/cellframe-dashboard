#include "DapNetworksManagerLocal.h"
#include <cmath>
#include "Modules/DapModulesController.h"
#include <QSet>
#include <QStringList>
#include "DapCommonMethods.h"

DapNetworksManagerLocal::DapNetworksManagerLocal(DapModulesController* moduleController)
    : DapNetworksManagerBase(moduleController)
{
    connect(m_modulesController, &DapModulesController::sigNotifyControllerIsInit, this, &DapNetworksManagerLocal::initNotifyConnet);
}

void DapNetworksManagerLocal::initNotifyConnet()
{
    m_notifyController = m_modulesController->getNotifyCtrl();
    connect(m_notifyController, &DapNotifyController::isConnectedChanged,   this, &DapNetworksManagerLocal::slotNotifyIsConnected);
    connect(m_notifyController, &DapNotifyController::sigNotifyRcvNetList,  this, &DapNetworksManagerLocal::slotRcvNotifyNetList);
    connect(m_notifyController, &DapNotifyController::sigNotifyRcvNetInfo,  this, &DapNetworksManagerLocal::slotRcvNotifyNetInfo);
    connect(m_notifyController, &DapNotifyController::sigNotifyRcvNetsInfo, this, &DapNetworksManagerLocal::slotRcvNotifyNetsInfo);
}

DapNetworksManagerLocal::~DapNetworksManagerLocal()
{
    disconnect();
}

void DapNetworksManagerLocal::slotNotifyIsConnected(bool isConnected)
{
    if(!isConnected)
    {
        clearAll();
    }
    emit isConnectedChanged(isConnected);
}

void DapNetworksManagerLocal::slotRcvNotifyNetList(QJsonDocument doc)
{
    QStringList list = doc.toVariant().toStringList();

    if(list.length() && list.first() == "notify_timeout"){
        m_modulesController->setIsNodeWorking(true);
    }
    else{
        updateNetworkList(list);
    }
}

void DapNetworksManagerLocal::updateNetworkList(const QStringList& list)
{
    if(!DapCommonMethods::isEqualStringList(m_netList, list))
    {
        QStringList diffForDelete = DapCommonMethods::getDifference(m_netList, list);
        // TODO: If new networks need to be identified.
        // QStringList diffForNew = getDifference(list, m_netList);

        m_netList = list;
        qDebug()<<"[DapNetworksManagerLocal] Change net list: " << m_netList;

        if(!diffForDelete.isEmpty())
        {
            for(const QString &net : qAsConst(diffForDelete))
            {
                m_netsLoadProgress.remove(net);
            }
            emit deleteNetworksSignal(diffForDelete);
        }
        emit networkListChanged();
    }

}

void DapNetworksManagerLocal::slotRcvNotifyNetInfo(QJsonDocument doc)
{
    QJsonObject netObj = doc.object();
    QString netName = netObj["net"].toString();
    NetworkInfo networkItem = getNetworkInfo(netName, netObj);

    emit updateNetworkInfoSignal(networkItem);

    NetworkLoadProgress netLoadItm;
    netLoadItm.name     = networkItem.networkName;
    netLoadItm.state    = networkItem.displayNetworkState;
    netLoadItm.percent  = networkItem.syncPercent;

    m_netsLoadProgress.insert(netLoadItm.name,netLoadItm);
    emit sigUpdateItemNetLoad();
}

void DapNetworksManagerLocal::slotRcvNotifyNetsInfo(QJsonDocument doc)
{
    QJsonObject obj = doc.object();
    QStringList keys = obj.keys();
    updateNetworkList(keys);

    QList<NetworkLoadProgress> netsLoadList;

    for(const QString &key : keys)
    {
        QJsonObject netObject = obj[key].toObject();

        NetworkInfo networkItem = getNetworkInfo(key, netObject);

        NetworkLoadProgress netLoadItm;
        netLoadItm.name     = networkItem.networkName;
        netLoadItm.state    = networkItem.displayNetworkState;
        netLoadItm.percent  = networkItem.syncPercent;
        netsLoadList.append(netLoadItm);

        emit updateNetworkInfoSignal(networkItem);
    }

    for(const auto &item : netsLoadList)
        m_netsLoadProgress.insert(item.name,item);

    emit sigUpdateItemNetLoad();
}

void DapNetworksManagerLocal::clearAll()
{
    m_netsLoadProgress.clear();
    {
        m_netList.clear();
        emit networkListChanged();
    }
}

NetworkInfo DapNetworksManagerLocal::getNetworkInfo(const QString& netName, const QJsonObject& itemModel)
{
    NetworkInfo networkItem;

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

QString DapNetworksManagerLocal::convertState(QString state)
{
    if(STATES_STRINGS.contains(state))
    {
        return STATES_STRINGS[state];
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

QString DapNetworksManagerLocal::convertProgress(QJsonObject obj)
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
