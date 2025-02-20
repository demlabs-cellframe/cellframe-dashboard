#include "DapWalletsManager.h"
#include "DapServiceController.h"
#include "Modules/DapModulesController.h"
#include "DapDataManagerController.h"
#include <QMap>

DapWalletsManager::DapWalletsManager(DapModulesController *moduleController)
    : DapWalletsManagerBase(moduleController)
    , m_walletsListTimer(new QTimer())
    , m_timerUpdateWallet(new QTimer())
    , m_timerAlarmUpdateWallet(new QTimer())
{
    connect(m_modulesController, &DapModulesController::sigUpdateData, this, &DapWalletsManager::clearAndUpdateDataSlot);
    connect(m_walletsListTimer, &QTimer::timeout, this, &DapWalletsManager::updateListWallets, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletsListReceived, this, &DapWalletsManager::walletsListReceived, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletReceived, this, &DapWalletsManager::rcvWalletInfo, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletAddressReceived, this, &DapWalletsManager::rcvWalletAddress, Qt::QueuedConnection);
    connect(m_timerUpdateWallet, &QTimer::timeout, this, [this]{
        updateInfoWallets();
    });
    connect(m_timerAlarmUpdateWallet, &QTimer::timeout, this, &DapWalletsManager::alarmTimerSlot, Qt::QueuedConnection);
    updateListWallets();
    m_walletsListTimer->start(TIME_WALLET_LIST_UPDATE);
}

void DapWalletsManager::updateWalletList()
{
    updateListWallets();
}

void DapWalletsManager::updateWalletInfo()
{
    QString currentWalletName = m_currentWallet.second;
    m_isRequestInfo = false;
    m_lastRequestInfoNetworkName.clear();
    m_requestInfoWalletsName.clear();
    updateInfoWallets(currentWalletName);
}

void DapWalletsManager::walletsListReceived(const QVariant &rcvData)
{
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());

    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);
    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    QJsonArray walletArray = document.array();

    bool isUpdateWallet = false;
    QStringList newListWallet;
    QVariantList doubleWalletArray;
    for(const QJsonValue &value: walletArray)
    {
        QJsonObject tmpObject = value.toObject();
        if(tmpObject.contains(Dap::JsonKeys::NAME) && tmpObject.contains(Dap::JsonKeys::PATH))
        {
            QString walletName = tmpObject[Dap::JsonKeys::NAME].toString();
            newListWallet.append(walletName);
            if(walletName.isEmpty())
            {
                continue;
            }

            if(m_walletsInfo.contains(walletName))
            {

                CommonWallet::WalletInfo tmpWallet;
                tmpWallet.walletName = walletName;
                tmpWallet.path = tmpObject[Dap::JsonKeys::PATH].toString();
                tmpWallet.status = tmpObject[Dap::JsonKeys::STATUS].toString();

                if(tmpWallet.path != m_walletsInfo[walletName].path)
                {
                    QJsonObject wallet;
                    if(tmpWallet.path != Dap::UiSdkDefines::DataFolders::WALLETS_DIR)
                    {
                        wallet.insert("walletName", tmpWallet.walletName);
                        wallet.insert("walletPath", tmpWallet.path);
                    }
                    else
                    {
                        wallet.insert("walletName", m_walletsInfo[walletName].walletName);
                        wallet.insert("walletPath", m_walletsInfo[walletName].path);
                        m_walletsInfo.remove(walletName);
                        m_walletsInfo.insert(walletName, std::move(tmpWallet));
                        isUpdateWallet = true;
                    }
                    doubleWalletArray.append(wallet);
                }
                else if(tmpWallet.status != m_walletsInfo[walletName].status)
                {
                    m_walletsInfo[walletName].status = tmpObject[Dap::JsonKeys::STATUS].toString();
                    isUpdateWallet = true;
                    emit walletInfoChanged(walletName);
                }
            }
            else
            {
                CommonWallet::WalletInfo tmpWallet;
                tmpWallet.walletName = walletName;
                tmpWallet.path = tmpObject[Dap::JsonKeys::PATH].toString();
                tmpWallet.status = tmpObject[Dap::JsonKeys::STATUS].toString();
                m_walletsInfo.insert(walletName, std::move(tmpWallet));
                isUpdateWallet = true;
            }
        }
    }

    if(m_duplicateWallets != doubleWalletArray)
    {
        m_duplicateWallets = doubleWalletArray;
    }

    QStringList curListWallet = m_walletsInfo.keys();
    if(!DapCommonMethods::isEqualStringList(newListWallet, curListWallet))
    {
        QStringList toRemoveList = DapCommonMethods::getDifference(curListWallet, newListWallet);
        for(const auto& wallet: toRemoveList)
        {
            m_walletsInfo.remove(wallet);
            isUpdateWallet = true;
        }
    }

    if(isUpdateWallet || updateWalletModel())
    {
        m_lastRequestInfoNetworkName.clear();
        m_requestInfoWalletsName.clear();
        updateAddressWallets();
        emit walletListChanged();
    }
}

void DapWalletsManager::setIsLoad(CommonWallet::WalletInfo& wallet, bool isLoad)
{
    if(wallet.isLoad != isLoad)
    {
        wallet.isLoad = isLoad;
        emit walletListChanged();
    }
}

void DapWalletsManager::updateAddressWallets()
{
    QString currWallet = m_currentWallet.second;
    auto netList = m_modulesController->getManagerController()->getNetworkList();

    auto addNetworkToWallet = [](QMap<QString, CommonWallet::WalletNetworkInfo>& list, const QString& network)
    {
        CommonWallet::WalletNetworkInfo info;
        info.network = network;
        list.insert(network, std::move(info));
    };

    if(!currWallet.isEmpty() && m_walletsInfo.contains(currWallet))
    {
        if(m_walletsInfo[currWallet].status != Dap::WalletStatus::NON_ACTIVE_KEY)
        {
            auto& netsInfo = m_walletsInfo[currWallet].walletInfo;
            if((netsInfo.isEmpty() && !netList.isEmpty()) || !DapCommonMethods::isEqualStringList(netsInfo.keys(), netList))
            {
                for(const auto& net: qAsConst(netList))
                {
                    addNetworkToWallet(netsInfo, net);
                }
                requestWalletAddress(currWallet, m_walletsInfo[currWallet].path, m_walletsInfo[currWallet].walletInfo.keys());
                return;
            }
            else if(!netsInfo.isEmpty())
            {
                for(const auto& item: qAsConst(netsInfo))
                {
                    if(item.address.isEmpty())
                    {
                        requestWalletAddress(currWallet, m_walletsInfo[currWallet].path, m_walletsInfo[currWallet].walletInfo.keys());
                        return;
                    }
                }
            }
        }
        else
        {
            m_walletsInfo[currWallet].walletInfo.clear();
        }
    }

    for(const auto& wallet: m_walletsInfo.keys())
    {
        if(m_walletsInfo[wallet].status == Dap::WalletStatus::NON_ACTIVE_KEY)
        {
            continue;
        }
        auto& netInfoArray = m_walletsInfo[wallet].walletInfo;
        if(netInfoArray.isEmpty() || !DapCommonMethods::isEqualStringList(netInfoArray.keys(), netList))
        {
            for(const auto& network : netList)
            {
                addNetworkToWallet(netInfoArray, network);
            }
        }
        for(const auto& netInfo: netInfoArray)
        {
            if(netInfo.address.isEmpty())
            {
                requestWalletAddress(wallet, m_walletsInfo[wallet].path, netInfoArray.keys());
                return;
            }
        }
    }
    updateInfoWallets();
}

void DapWalletsManager::rcvWalletAddress(const QVariant &rcvData)
{
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());
    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);

    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    QJsonObject inObject = document.object();
    QString walletName = inObject.value(Dap::KeysParam::WALLET_NAME).toString();
    QJsonArray netArray = inObject.value(Dap::KeysParam::RESULT_ARRAY).toArray();
    if(netArray.isEmpty())
    {
        qWarning() << "[DapWalletsManager][rcvWalletAddress] The wallet addresses were not found. wallet: "<< walletName;
        updateAddressWallets();
        return;
    }
    bool isUpdated = false;
    for(const auto& itemValue: netArray)
    {
        auto item = itemValue.toObject();
        QString networkName = item.value(Dap::KeysParam::NETWORK_NAME).toString();
        QString address = item.value(Dap::KeysParam::WALLET_ADDRESS).toString();
        if(m_walletsInfo.contains(walletName))
        {
            if(m_walletsInfo[walletName].walletInfo.contains(networkName))
            {
                auto& netInfo = m_walletsInfo[walletName].walletInfo[networkName];
                if(netInfo.address.isEmpty())
                {
                    netInfo.address = address;
                    setIsLoad(m_walletsInfo[walletName], true);
                    emit walletInfoChanged(walletName, networkName);
                    isUpdated = true;
                }
            }
        }
    }
    if(QString currWallet = m_currentWallet.second; m_walletsInfo.contains(currWallet) && currWallet == walletName && isUpdated)
    {
        updateInfoWallets(currWallet);
    }

    updateAddressWallets();
}

void DapWalletsManager::rcvWalletInfo(const QVariant &rcvData)
{
    if(!m_isRequestInfo)
    {
        return;
    }
    m_isRequestInfo = false;
    m_timerAlarmUpdateWallet->stop();
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());
    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);

    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    QJsonObject inObject = document.object();

    QString walletAddr = inObject.value(Dap::JsonKeys::WALLET_ADDRESS).toString();
    QString networkName = inObject.value(Dap::JsonKeys::NETWORK_NAME).toString();

    if(walletAddr.isEmpty())
    {
        qWarning() << "[DapWalletsManager] Empty wallet address for " << networkName << " network";
        return;
    }

    QString walletName;
    for(const auto& key: m_walletsInfo.keys())
    {
        if(m_walletsInfo.value(key).walletInfo.value(networkName).address == walletAddr)
        {
            walletName = key;
            break;
        }
    }

    QJsonObject netObject = inObject.value(Dap::JsonKeys::NETWORK).toObject();
    QString netWalletAddress = netObject.value(Dap::JsonKeys::ADDRESS).toString();

    QJsonArray tokens = netObject.value(Dap::JsonKeys::TOKENS).toArray();
    CommonWallet::WalletNetworkInfo netInfo;
    netInfo.network = networkName;
    netInfo.address = netWalletAddress;
    for(const auto& value: tokens)
    {
        auto object = value.toObject();
        CommonWallet::WalletTokensInfo token;
        token.tokenName = object.value(Dap::JsonKeys::TOKEN_NAME).toString();
        token.value = object.value(Dap::JsonKeys::BALANCE).toString();
        token.availableCoins = object.value(Dap::JsonKeys::AVAILABLE_COINS).toString();
        token.availableDatoshi = object.value(Dap::JsonKeys::AVAILABLE_DATOSHI).toString();
        token.datoshi = object.value(Dap::JsonKeys::DATOSHI).toString();
        token.ticker = object.value(Dap::JsonKeys::TOKEN_NAME).toString();
        token.network = networkName;
        netInfo.networkInfo.append(std::move(token));
    }

    if(walletName.isEmpty())
    {
        qWarning() << "[DapWalletsManager] The list does not contain a wallet with the name " << walletName;
        return;
    }

    auto& wallet = m_walletsInfo[walletName];
    if(!wallet.walletInfo.contains(networkName))
    {
        wallet.walletInfo.insert(networkName, netInfo);
        emit walletInfoChanged(walletName, networkName);
        emit walletListChanged();
    }
    else
    {
        bool isUpdateNetwork = false;
        auto& network = wallet.walletInfo[networkName];
        auto getListToken = [](const QList<CommonWallet::WalletTokensInfo>& list) -> QStringList
        {
            QStringList result;
            for(auto& item: list)
            {
                result.append(item.tokenName);
            }
            return result;
        };
        QStringList newItem = getListToken(netInfo.networkInfo);
        QStringList currItem = getListToken(network.networkInfo);

        QStringList toAppToken = DapCommonMethods::getDifference(newItem, currItem);

        for(auto& newItem: netInfo.networkInfo)
        {
            if(toAppToken.contains(newItem.tokenName))
            {
                network.networkInfo.append(newItem);
                isUpdateNetwork = true;
                continue;
            }
            for(auto& item: network.networkInfo)
            {
                if(newItem.tokenName != item.tokenName)
                {
                    continue;
                }
                if(item.datoshi != newItem.datoshi ||
                    item.availableDatoshi != newItem.availableDatoshi)
                {
                    item = newItem;
                    isUpdateNetwork = true;
                }
            }
        }

        if(wallet.walletInfo[networkName].address.isEmpty())
        {
            wallet.walletInfo.insert(networkName, netInfo);
            isUpdateNetwork = true;
        }

        setIsLoad(wallet, true);

        if(isUpdateNetwork)
        {
            emit walletInfoChanged(walletName, networkName);
        }
    }
    updateInfoWallets();
}

void DapWalletsManager::alarmTimerSlot()
{
    if(m_requestInfoWalletsName.length())
    {
        qDebug() << QString("[DapWalletsManager] ALARM The waiting time for requesting information about wallet %1 of network %2 has been exceeded.")
                        .arg(m_requestInfoWalletsName.last(), m_lastRequestInfoNetworkName);
    }
    if(!m_isRequestInfo)
    {
        return;
    }
    m_isRequestInfo = false;
    m_timerAlarmUpdateWallet->stop();
    updateInfoWallets();
}

bool DapWalletsManager::updateWalletModel()
{
    auto netList = m_modulesController->getManagerController()->getNetworkList();
    bool isUpdate = false;
    for(auto& wallet: m_walletsInfo)
    {
        auto currentNets = wallet.walletInfo.keys();
        if(DapCommonMethods::isEqualStringList(currentNets, netList))
        {
            continue;
        }
        QStringList toAppendList = DapCommonMethods::getDifference(netList, currentNets);
        QStringList toRemoveList = DapCommonMethods::getDifference(currentNets, netList);
        for(const auto& network: toAppendList)
        {
            CommonWallet::WalletNetworkInfo info;
            info.network = network;
            wallet.walletInfo.insert(network, std::move(info));
            isUpdate = true;
        }
        for(const auto& network: toRemoveList)
        {
            wallet.walletInfo.remove(network);
            isUpdate = true;
        }
    }
    return isUpdate;
}

void DapWalletsManager::updateInfoWallets(const QString &walletName)
{
    if(m_isRequestInfo)
    {
        return;
    }
    m_timerUpdateWallet->stop();
    auto netList = m_modulesController->getManagerController()->getNetworkList();
    if(netList.isEmpty() || m_walletsInfo.isEmpty())
    {
        m_timerUpdateWallet->start(1000);
        m_lastRequestInfoNetworkName.clear();
        m_requestInfoWalletsName.clear();
        return;
    }
    auto walletList = m_walletsInfo.keys();
    if(!walletName.isEmpty())
    {
        m_lastRequestInfoNetworkName = netList[0];
        m_requestInfoWalletsName.append(walletName);
    }
    else if((!netList.contains(m_lastRequestInfoNetworkName) ||
         !walletList.contains(m_requestInfoWalletsName.last())) ||
        (m_lastRequestInfoNetworkName.isEmpty() || m_requestInfoWalletsName.isEmpty()))
    {
        m_lastRequestInfoNetworkName = netList[0];
        if(!m_currentWallet.second.isEmpty())
        {
            m_requestInfoWalletsName.append(m_currentWallet.second);
        }
        else
        {
            m_requestInfoWalletsName.append(m_walletsInfo.firstKey());
        }
    }
    else
    {
        int netIndex = netList.indexOf(m_lastRequestInfoNetworkName);
        if(netList.size() - 1 == netIndex)
        {
            if(m_requestInfoWalletsName.size() == walletList.size())
            {
                m_lastRequestInfoNetworkName.clear();
                m_requestInfoWalletsName.clear();
                m_timerUpdateWallet->start(TIME_WALLET_INFO_UPDATE);
                return;
            }
            else
            {
                for(const auto& wallet: walletList)
                {
                    if(!m_requestInfoWalletsName.contains(wallet)
                        && m_walletsInfo.value(wallet).status != Dap::WalletStatus::NON_ACTIVE_KEY)
                    {
                        m_requestInfoWalletsName.append(wallet);
                        m_lastRequestInfoNetworkName = netList[0];
                        break;
                    }
                }
            }
        }
        else
        {
            m_lastRequestInfoNetworkName = netList[netIndex + 1];
        }
    }
    QString address = m_walletsInfo.value(m_requestInfoWalletsName.last())
                          .walletInfo.value(m_lastRequestInfoNetworkName).address;
    if(address.isEmpty())
    {
        updateAddressWallets();
    }
    else
    {
        requestWalletInfo(address, m_lastRequestInfoNetworkName);
    }
}

void DapWalletsManager::updateListWallets()
{
    QStringList pathList;
    pathList.append(Dap::UiSdkDefines::DataFolders::WALLETS_DIR);
    pathList.append(Dap::UiSdkDefines::DataFolders::WALLETS_MIGRATE_DIR);
    QVariantMap request = {{Dap::KeysParam::PATH_LIST, std::move(pathList)}
                           ,{Dap::CommandParamKeys::NODE_MODE_KEY, Dap::NodeMode::REMOTE_MODE}};

    m_modulesController->getServiceController()->requestToService("DapGetListWalletsCommand", request);
}

void DapWalletsManager::requestWalletInfo(const QString& walletAddr, const QString& network)
{
    m_isRequestInfo = true;
    QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    QVariantMap request = {{Dap::KeysParam::WALLET_NAME, m_requestInfoWalletsName.last()}
                          ,{Dap::KeysParam::WALLET_ADDRESS, walletAddr}
                          ,{Dap::KeysParam::NETWORK_NAME, network}
                           ,{Dap::CommandParamKeys::NODE_MODE_KEY, Dap::NodeMode::REMOTE_MODE}};

    m_modulesController->getServiceController()->requestToService("DapGetWalletInfoCommand", request);

    m_timerAlarmUpdateWallet->start(TIME_ALARM_REQUEST);
}

void DapWalletsManager::requestWalletAddress(const QString& walletName, const QString& path, const QStringList& netList)
{
    QVariantMap requestMap = {{Dap::KeysParam::NETWORK_LIST, netList}
                             ,{Dap::KeysParam::WALLET_PATH, path}
                             ,{Dap::KeysParam::WALLET_NAME, walletName}};


    m_modulesController->getServiceController()->requestToService("DapGetWalletAddressCommand", requestMap);
}

void DapWalletsManager::clearAndUpdateDataSlot()
{
    m_walletsInfo.clear();
    m_walletsListTimer->stop();
    m_timerUpdateWallet->stop();
    m_timerAlarmUpdateWallet->stop();
    m_walletListCash.clear();
    m_requestInfoWalletsName.clear();
    m_lastRequestInfoNetworkName.clear();
    m_isRequestInfo = false;

    updateListWallets();
    m_walletsListTimer->start(TIME_WALLET_LIST_UPDATE);
}
