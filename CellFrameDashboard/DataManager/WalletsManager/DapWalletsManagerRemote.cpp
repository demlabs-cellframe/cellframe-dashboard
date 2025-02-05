#include "DapWalletsManagerRemote.h"
#include "DapServiceController.h"
#include "Modules/DapModulesController.h"
#include "DapDataManagerController.h"
#include <QMap>

DapWalletsManagerRemote::DapWalletsManagerRemote(DapModulesController *moduleController)
    : DapWalletsManagerBase(moduleController)
    , m_walletsListTimer(new QTimer())
    , m_timerUpdateWallet(new QTimer())
    , m_timerAlarmUpdateWallet(new QTimer())
{
    connect(m_modulesController, &DapModulesController::sigUpdateData, this, &DapWalletsManagerRemote::clearAndUpdateDataSlot);
    connect(m_walletsListTimer, &QTimer::timeout, this, &DapWalletsManagerRemote::updateListWallets, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletsListReceived, this, &DapWalletsManagerRemote::walletsListReceived, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletReceived, this, &DapWalletsManagerRemote::rcvWalletInfo, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletAddressReceived, this, &DapWalletsManagerRemote::rcvWalletAddress, Qt::QueuedConnection);
    connect(m_timerUpdateWallet, &QTimer::timeout, this, [this]{
        updateInfoWallets();
    });
    connect(m_timerAlarmUpdateWallet, &QTimer::timeout, this, &DapWalletsManagerRemote::alarmTimerSlot, Qt::QueuedConnection);
    updateListWallets();
    m_walletsListTimer->start(TIME_WALLET_LIST_UPDATE);
}

void DapWalletsManagerRemote::updateWalletList()
{
    updateListWallets();
}

void DapWalletsManagerRemote::updateWalletInfo()
{
    QString currentWalletName = m_currentWallet.second;
    m_isRequestInfo = false;
    m_lastRequestInfoNetworkName.clear();
    m_lastRequestInfoWalletName.clear();
    updateInfoWallets(currentWalletName);
}

void DapWalletsManagerRemote::walletsListReceived(const QVariant &rcvData)
{
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());
    if(m_walletListCash == byteArrayData)
    {
        return;
    }
    m_walletListCash = byteArrayData;

    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);
    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    QJsonArray walletArray = document.array();
    QStringList tmpWallets;

    bool isUpdateWallet = false;

    for(const QJsonValue &value: walletArray)
    {
        QJsonObject tmpObject = value.toObject();
        if(tmpObject.contains(Dap::JsonKeys::NAME) && tmpObject.contains(Dap::JsonKeys::PATH))
        {
            QString walletName = tmpObject[Dap::JsonKeys::NAME].toString();
            if(walletName.isEmpty())
            {
                continue;
            }

            if(m_walletsInfo.contains(walletName))
            {

                if(tmpObject[Dap::JsonKeys::STATUS].toString() != m_walletsInfo[walletName].status)
                {
                    m_walletsInfo[walletName].status = tmpObject[Dap::JsonKeys::STATUS].toString();
                    emit walletInfoChanged(walletName);
                }
                m_walletsInfo[walletName].path = tmpObject[Dap::JsonKeys::PATH].toString();
                isUpdateWallet = true;
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

            tmpWallets.append(walletName);
        }
    }

    for(const QString &name: m_walletsInfo.keys())
    {
        if(!tmpWallets.contains(name))
        {
            m_walletsInfo.remove(name);
        }
    }

    if(isUpdateWallet)
    {
        m_lastRequestInfoNetworkName.clear();
        m_lastRequestInfoWalletName.clear();
        updateAddressWallets();
    }

    emit walletListChanged();
}

void DapWalletsManagerRemote::setIsLoad(CommonWallet::WalletInfo& wallet, bool isLoad)
{
    if(wallet.isLoad != isLoad)
    {
        wallet.isLoad = isLoad;
        emit walletListChanged();
    }
}

void DapWalletsManagerRemote::updateAddressWallets()
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

void DapWalletsManagerRemote::rcvWalletAddress(const QVariant &rcvData)
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
        qWarning() << "[DapWalletsManagerRemote][rcvWalletAddress] The wallet addresses were not found. wallet: "<< walletName;
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
        m_isFirstRequestCurrWall = true;
    }

    updateAddressWallets();
}

void DapWalletsManagerRemote::rcvWalletInfo(const QVariant &rcvData)
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

    QString walletIdent = inObject.value(Dap::JsonKeys::WALLET_IDENT).toString();
    QString networkName = inObject.value(Dap::JsonKeys::NETWORK_NAME).toString();

    if(walletIdent.isEmpty())
    {
        qWarning() << "[DapWalletsManagerRemote] Empty wallet address for " << networkName << " network";
        return;
    }

    QString walletName;
    for(const auto& key: m_walletsInfo.keys())
    {
        if(m_walletsInfo.value(key).walletInfo.value(networkName).address == walletIdent)
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
        qWarning() << "[DapWalletsManagerRemote] The list does not contain a wallet with the name " << walletName;
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
        setIsLoad(wallet, true);

        if(isUpdateNetwork)
        {
            emit walletInfoChanged(walletName, networkName);
        }
    }
    updateInfoWallets();
}

void DapWalletsManagerRemote::alarmTimerSlot()
{
    qDebug() << QString("[DapWalletsManagerRemote] ALARM The waiting time for requesting information about wallet %1 of network %2 has been exceeded.")
                    .arg(m_lastRequestInfoWalletName, m_lastRequestInfoNetworkName);
    if(!m_isRequestInfo)
    {
        return;
    }
    m_isRequestInfo = false;
    m_timerAlarmUpdateWallet->stop();
    updateInfoWallets();
}

void DapWalletsManagerRemote::updateInfoWallets(const QString &walletName)
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
        m_lastRequestInfoWalletName.clear();
        return;
    }
    auto walletList = m_walletsInfo.keys();
    if(!walletName.isEmpty())
    {
        m_lastRequestInfoNetworkName = netList[0];
        m_lastRequestInfoWalletName = walletName;
    }
    else if((!netList.contains(m_lastRequestInfoNetworkName) ||
         !walletList.contains(m_lastRequestInfoWalletName)) ||
        (m_lastRequestInfoNetworkName.isEmpty() || m_lastRequestInfoWalletName.isEmpty()))
    {
        m_lastRequestInfoNetworkName = netList[0];
        m_lastRequestInfoWalletName = m_walletsInfo.firstKey();
    }
    else
    {
        int netIndex = netList.indexOf(m_lastRequestInfoNetworkName);
        if(netList.size() - 1 == netIndex)
        {
            int walletIndex = walletList.indexOf(m_lastRequestInfoWalletName);
            if(walletList.size() - 1  == walletIndex)
            {
                if(m_isFirstRequestCurrWall)
                {
                    m_isFirstRequestCurrWall = false;
                    m_lastRequestInfoNetworkName = netList[0];
                    m_lastRequestInfoWalletName = m_walletsInfo.firstKey();
                }
                else
                {
                    m_lastRequestInfoNetworkName.clear();
                    m_lastRequestInfoWalletName.clear();
                    m_timerUpdateWallet->start(TIME_WALLET_INFO_UPDATE);
                    return;
                }
            }
            else
            {
                int index = walletIndex + 1;
                for(; index < walletList.size(); index++)
                {
                    QString wallet = walletList.value(index);
                    if(m_walletsInfo.value(wallet).status != Dap::WalletStatus::NON_ACTIVE_KEY)
                    {
                        break;
                    }
                }

                if(index >= walletList.size())
                    index = walletList.size() - 1;

                m_lastRequestInfoWalletName = walletList[index];
                m_lastRequestInfoNetworkName = netList[0];
                m_isFirstRequestCurrWall = false;
            }
        }
        else
        {
            m_lastRequestInfoNetworkName = netList[netIndex + 1];
        }
    }
    QString address = m_walletsInfo.value(m_lastRequestInfoWalletName)
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

void DapWalletsManagerRemote::updateListWallets()
{
    m_modulesController->getServiceController()->requestToService("DapGetListWalletsCommand", QStringList() <<
                                                                 Dap::CommandParamKeys::NODE_MODE_KEY << Dap::NodeMode::REMOTE_MODE);
}

void DapWalletsManagerRemote::requestWalletInfo(const QString& walletAddr, const QString& network)
{
    m_isRequestInfo = true;
    m_modulesController->getServiceController()->requestToService("DapGetWalletInfoCommand", QStringList() << walletAddr << network <<
                                                                  Dap::CommandParamKeys::NODE_MODE_KEY << Dap::NodeMode::REMOTE_MODE);

    m_timerAlarmUpdateWallet->start(TIME_ALARM_REQUEST);
}

void DapWalletsManagerRemote::requestWalletAddress(const QString& walletName, const QString& path, const QStringList& netList)
{
    QVariantMap requestMap = {{Dap::KeysParam::NETWORK_LIST, netList}
                             ,{Dap::KeysParam::WALLET_PATH, path}
                             ,{Dap::KeysParam::WALLET_NAME, walletName}};


    m_modulesController->getServiceController()->requestToService("DapGetWalletAddressCommand", requestMap);
}

void DapWalletsManagerRemote::clearAndUpdateDataSlot()
{
    m_walletsInfo.clear();
    m_walletsListTimer->stop();
    m_timerUpdateWallet->stop();
    m_timerAlarmUpdateWallet->stop();
    m_walletListCash.clear();
    m_lastRequestInfoWalletName.clear();
    m_lastRequestInfoNetworkName.clear();
    m_isRequestInfo = false;
    m_isFirstRequestCurrWall = false;

    updateListWallets();
    m_walletsListTimer->start(TIME_WALLET_LIST_UPDATE);
}
