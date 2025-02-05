#include "DapModuleTxExplorer.h"
#include <QQmlContext>
#include "DapDataManagerController.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>

#include <QDebug>

// static DapHistoryModel *m_historyModel = DapHistoryModel::global();

DapModuleTxExplorer::DapModuleTxExplorer(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_timerHistoryUpdate(new QTimer(this))
    , m_timerRequest(new QTimer(this))
    , m_historyProxyModel(new DapHistoryProxyModel())
    , m_historyModel(new DapHistoryModel)
{
    m_historyProxyModel->setSourceModel(m_historyModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelLastActions", m_historyProxyModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelHistory", m_historyProxyModel);

    connect(m_modulesCtrl, &DapModulesController::initDone, this, [this] ()
    {
        initConnect();
        updateHistory();
    });
    connect(m_modulesCtrl->getManagerController()->getWalletManager(), &DapWalletsManagerBase::currentWalletChanged, this, &DapModuleTxExplorer::cleareData);
}

void DapModuleTxExplorer::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleTxExplorer::setHistoryModel, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::historyServiceInitRcv, this, &DapModuleTxExplorer::setHistoryModel, Qt::QueuedConnection);
    connect(m_modulesCtrl, &DapModulesController::nodeWorkingChanged, this, [this]()
    {
        if(!m_modulesCtrl->isNodeWorking())
        {
            this->cleareData();
        }
    });
    connect(m_timerHistoryUpdate, &QTimer::timeout, this, &DapModuleTxExplorer::slotHistoryUpdate, Qt::QueuedConnection);
    connect(m_timerRequest, &QTimer::timeout, this, &DapModuleTxExplorer::slotHistoryUpdate, Qt::QueuedConnection);

    auto walletManager = getWalletManager();
    connect(walletManager, &DapWalletsManagerBase::walletInfoChanged, this, &DapModuleTxExplorer::walletInfoChangedsSlot);
}

void DapModuleTxExplorer::slotUpdateData()
{
    m_timerHistoryUpdate->stop();
    m_timerRequest->stop();
    m_historyModel->clear();
    m_listsWallets.clear();
    setStatusInit(false);
    isSendReqeust = false;
    updateHistory();
}

void DapModuleTxExplorer::setHistoryModel(const QVariant &rcvData)
{
    isSendReqeust = false;
    m_timerRequest->stop();
    auto historyByte = rcvData.toByteArray();

    QJsonDocument doc = QJsonDocument::fromJson(historyByte);

    if (!doc.isObject())
        return;

    QString walletName = doc["walletName"].toString();
    QString networkName = doc["networkName"].toString();

    if(m_modulesCtrl->getManagerController()->getCurrentWallet().second != walletName)
    {
        return;
    }

    QJsonArray historyArray = doc["history"].toArray();

    HistoryList resultList;

    for(auto i = 0; i < historyArray.size(); i++)
    {
        DapHistoryModel::Item itemHistory;
        itemHistory.fee_token    = historyArray.at(i)["fee_token"].toString();
        itemHistory.fee_net      = historyArray.at(i)["fee_net"].toString();
        itemHistory.fee          = historyArray.at(i)["fee"].toString();
        itemHistory.value        = historyArray.at(i)["value"].toString();
        itemHistory.m_value      = historyArray.at(i)["m_value"].toString();
        itemHistory.m_token      = historyArray.at(i)["m_token"].toString();
        itemHistory.m_direction  = historyArray.at(i)["m_direction"].toString();
        itemHistory.x_value      = historyArray.at(i)["x_value"].toString();
        itemHistory.x_token      = historyArray.at(i)["x_token"].toString();
        itemHistory.x_direction  = historyArray.at(i)["x_direction"].toString();
        itemHistory.direction    = historyArray.at(i)["direction"].toString();
        itemHistory.token        = historyArray.at(i)["token"].toString();
        itemHistory.status       = historyArray.at(i)["status"].toString();
        itemHistory.address      = historyArray.at(i)["address"].toString();
        itemHistory.date_to_secs = historyArray.at(i)["date_to_secs"].toString().toLongLong();
        itemHistory.date         = historyArray.at(i)["date"].toString();
        itemHistory.wallet_name  = historyArray.at(i)["wallet_name"].toString();
        itemHistory.network      = historyArray.at(i)["network"].toString();
        itemHistory.atom         = historyArray.at(i)["atom"].toString();
        itemHistory.tx_hash      = historyArray.at(i)["tx_hash"].toString();
        itemHistory.tx_status    = historyArray.at(i)["tx_status"].toString();

        QDateTime time = QDateTime::fromSecsSinceEpoch(itemHistory.date_to_secs);
        itemHistory.time = time.toString("hh:mm:ss");
        resultList.append(std::move(itemHistory));
    }

    if(addHistory(walletName, resultList))
    {
        m_historyModel->updateModel(m_listsWallets[walletName].history);
    }

    setStatusInit(true);

    emit updateHistoryModel();
    updateHistory();
}

bool DapModuleTxExplorer::addHistory(const QString& wallet, const HistoryList& list)
{
    auto& walletData = m_listsWallets[wallet];
    bool isUpdated = false;
    for(const auto& item: list)
    {
        if(!walletData.hashes.contains(item.tx_hash))
        {
            walletData.history.append(item);
            walletData.hashes.insert(item.tx_hash, item.status);
            isUpdated = true;
        }
        else if(walletData.hashes[item.tx_hash] != item.status)
        {
            QList<DapHistoryModel::Item>::Iterator iter = std::find_if(walletData.history.begin(), walletData.history.end(),
                [&item](const DapHistoryModel::Item& itemHistory)
                {
                    return itemHistory.tx_hash == item.tx_hash;
            });

            if(iter != walletData.history.end())
            {
                iter->status = item.status;
            }
            walletData.hashes[item.tx_hash] = item.status;
            isUpdated = true;
        }
    }
    if(isUpdated)
    {
        auto& walletHistory = m_listsWallets[wallet].history;
        std::sort((walletHistory).begin(), (walletHistory).end(),[]
                  (const DapHistoryModel::Item& a, const DapHistoryModel::Item& b)
                  {
                      return a.date_to_secs > b.date_to_secs;
                  });
    }
    return isUpdated;
}

bool DapModuleTxExplorer::updateModelBySaves()
{
    QString wallet = m_modulesCtrl->getManagerController()->getCurrentWallet().second;
    if(!wallet.isEmpty())
    {
        if(m_listsWallets.value(wallet).history.isEmpty())
        {
            return false;
        }

        m_historyModel->updateModel(m_listsWallets.value(wallet).history);
        return true;
    }
    return false;
}

void DapModuleTxExplorer::cleareData()
{
    m_lastWalletName.clear();
    m_lastNetworkName.clear();
    m_timerHistoryUpdate->stop();
    m_timerRequest->stop();
    isSendReqeust = false;
    updateHistory();
    if(!updateModelBySaves())
    {
        m_historyModel->clear();
        setStatusInit(false);
    }
}

void DapModuleTxExplorer::slotHistoryUpdate()
{
    updateHistory();
}

void DapModuleTxExplorer::updateHistory()
{
    if(isSendReqeust)
    {
        return;
    }
    QString currantWalletName = m_modulesCtrl->getManagerController()->getCurrentWallet().second;
    if(m_lastWalletName != currantWalletName)
    {
        m_lastWalletName = currantWalletName;
    }
    if(m_lastWalletName.isEmpty())
    {
        return;
    }
    auto& walletInfo = getWalletManager()->getWalletsInfo().value(m_lastWalletName);
    if(walletInfo.status == Dap::WalletStatus::NON_ACTIVE_KEY || walletInfo.walletInfo.isEmpty())
    {
        return;
    }
    QString network = getNewLastNetwork();
    if(network.isEmpty())
    {
        qDebug() << QString("[DapModuleTxExplorer] The history survey for wallet %1 is completed").arg(m_lastWalletName);
        m_lastWalletName.clear();
        m_timerHistoryUpdate->start(TIME_OUT_HISTORY_UPDATE);
        return;
    }

    QString walletAddr = walletInfo.walletInfo.value(network).address;
    if(walletAddr.isEmpty())
    {
        qWarning() << QString("[DapModuleTxExplorer] Wallet address not found. wallet: %1 network: %2").arg(m_lastWalletName).arg(network);
        return;
    }

    QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    if(m_timerRequest->isActive())
    {
        m_timerRequest->stop();
    }

    QVariantMap request = {
                            {Dap::CommandParamKeys::NETWORK_KEY, network},
                            {Dap::CommandParamKeys::WALLET_ADDRESS_KEY, walletAddr},
                            {Dap::CommandParamKeys::WALLET_NAME_KEY, m_lastWalletName},
                            {Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade}
                            };

    s_serviceCtrl->requestToService("DapGetWalletHistoryCommand", request);
    m_timerRequest->start(TIME_OUT_HISTORY_REQUEST);
    isSendReqeust = true;
}

void DapModuleTxExplorer::walletInfoChangedsSlot(const QString& walletName, const QString& networkName)
{
    auto walletManager = getWalletManager();
    if(walletManager->getCurrentWallet().second == walletName && !isSendReqeust)
    {
        updateHistory();
    }
}

QString DapModuleTxExplorer::getNewLastNetwork()
{
    auto& walletInfo = getWalletManager()->getWalletsInfo().value(m_lastWalletName);
    auto netList = walletInfo.walletInfo.keys();
    if(m_lastNetworkName.isEmpty())
    {
        m_lastNetworkName.append(netList.first());
    }
    else
    {
        for(int i = 0; i < netList.size(); i++)
        {
            if(!m_lastNetworkName.contains(netList[i]) &&
                !walletInfo.walletInfo[netList[i]].address.isEmpty())
            {
                m_lastNetworkName.append(netList[i]);
                break;
            }
            else if(i == netList.size() - 1)
            {
                m_lastNetworkName.clear();
            }
        }
    }
    return m_lastNetworkName.isEmpty() ? QString() : m_lastNetworkName.last();
}

DapWalletsManagerBase* DapModuleTxExplorer::getWalletManager() const
{
    Q_ASSERT_X(m_modulesCtrl, "DapModuleWallet", "ModuleController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController(), "DapModuleWallet", "ManagerController not found");
    Q_ASSERT_X(m_modulesCtrl->getManagerController()->getWalletManager(), "DapModuleWallet", "WalletManager not found");
    return m_modulesCtrl->getManagerController()->getWalletManager();
}
