#include "DapWalletsManagerRemote.h"
#include "DapServiceController.h"
#include "Modules/DapModulesController.h"
#include "DapDataManagerController.h"
#include <QMap>

DapWalletsManagerRemote::DapWalletsManagerRemote(DapModulesController *moduleController)
    : DapWalletsManagerBase(moduleController)
    , m_walletsListTimer(new QTimer())
    , m_timerUpdateWallet(new QTimer())
    , m_timerFeeUpdateWallet(new QTimer())
{
    connect(m_walletsListTimer, &QTimer::timeout, this, &DapWalletsManagerRemote::updateListWallets, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletsListReceived, this, &DapWalletsManagerRemote::walletsListReceived, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletReceived, this, &DapWalletsManagerRemote::rcvWalletInfo, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletAddressReceived, this, &DapWalletsManagerRemote::rcvWalletAddress, Qt::QueuedConnection);
    connect(m_timerUpdateWallet, &QTimer::timeout, this, &DapWalletsManagerRemote::updateInfoWallets, Qt::QueuedConnection);
}

void DapWalletsManagerRemote::initManager()
{
    updateListWallets();
    m_walletsListTimer->start(TIME_WALLET_LIST_UPDATE);
}

void DapWalletsManagerRemote::walletsListReceived(const QVariant &rcvData)
{
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());
    if(walletListCash == byteArrayData)
    {
        return;
    }
    walletListCash = byteArrayData;

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
        if(tmpObject.contains("name") && tmpObject.contains("path"))
        {
            QString walletName = tmpObject["name"].toString();
            if(walletName.isEmpty())
            {
                continue;
            }

            if(m_walletsInfo.contains(walletName))
            {
                m_walletsInfo[walletName].status = tmpObject["status"].toString();
                m_walletsInfo[walletName].path = tmpObject["path"].toString();
                isUpdateWallet = true;
            }
            else
            {
                CommonWallet::WalletInfo tmpWallet;
                tmpWallet.walletName = walletName;
                tmpWallet.path = tmpObject["path"].toString();
                tmpWallet.status = tmpObject["status"].toString();
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
    for(const auto& wallet: m_walletsInfo.keys())
    {
        if(m_walletsInfo[wallet].status == Dap::WalletStatus::NON_ACTIVE_KEY)
        {
            continue;
        }
        auto& netInfoArray = m_walletsInfo[wallet].walletInfo;
        if(netInfoArray.isEmpty())
        {
            auto netList = m_modulesController->getManagerController()->getNetworkList();
            for(const auto& network : netList)
            {
                CommonWallet::WalletNetworkInfo info;
                info.network = network;
                netInfoArray.insert(network, std::move(info));
            }
        }
        for(const auto& netInfo: netInfoArray)
        {
            if(netInfo.address.isEmpty())
            {
                requestWalletAddress(wallet, m_walletsInfo[wallet].path);
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
                }
            }
        }
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

    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());
    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);

    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    QJsonObject inObject = document.object();

    QString walletIdent = inObject.value("walletIdent").toString();
    QString networkName = inObject.value("networkName").toString();

    QJsonObject netObject = inObject.value("network").toObject();
    QString netWalletAddress = netObject.value("address").toString();

    QJsonArray tokens = netObject.value("tokens").toArray();
    CommonWallet::WalletNetworkInfo netInfo;
    netInfo.network = networkName;
    netInfo.address = netWalletAddress;
    for(const auto& value: tokens)
    {
        auto object = value.toObject();
        CommonWallet::WalletTokensInfo token;
        token.tokenName = object.value("tokenName").toString();
        token.value = object.value("balance").toString();
        token.availableCoins = object.value("availableCoins").toString();
        token.availableDatoshi = object.value("availableDatoshi").toString();
        token.datoshi = object.value("datoshi").toString();
        token.ticker = object.value("tokenName").toString();
        token.network = networkName;
        netInfo.networkInfo.append(std::move(token));
    }

    QString walletName;
    for(const auto& key: m_walletsInfo.keys())
    {
        if(m_walletsInfo[key].walletInfo.contains(networkName) &&
            m_walletsInfo[key].walletInfo.value(networkName).address == walletIdent)
        {
            walletName = key;
        }
    }

    if(walletName.isEmpty())
    {
        qWarning() << "[DapWalletsManagerLocal] The list does not contain a wallet with the name " << walletName;
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

void DapWalletsManagerRemote::updateInfoWallets()
{
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

    auto getNextWalletIndex = [this, &walletList](int index) -> int
    {
        for(; index < walletList.size();)
        {
            QString wallet = walletList.value(index);
            if(m_walletsInfo.value(wallet).status != Dap::WalletStatus::NON_ACTIVE_KEY)
            {
                break;
            }
            index++;
        }
        return index;
    };
    if((!netList.contains(m_lastRequestInfoNetworkName) ||
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
                m_lastRequestInfoNetworkName.clear();
                m_lastRequestInfoWalletName.clear();
                m_timerUpdateWallet->start(TIME_WALLET_INFO_UPDATE);
                return;
            }
            else
            {
                int index = getNextWalletIndex(walletIndex + 1);
                m_lastRequestInfoWalletName = walletList[index];
                m_lastRequestInfoNetworkName = netList[0];
            }
        }
        else
        {
            m_lastRequestInfoNetworkName = netList[netIndex + 1];
        }
    }
    QString address = m_walletsInfo[m_lastRequestInfoWalletName].walletInfo[m_lastRequestInfoNetworkName].address;
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
}

void DapWalletsManagerRemote::requestWalletAddress(const QString& walletName, const QString& path)
{
    auto netList = m_modulesController->getManagerController()->getNetworkList();
    QVariantMap requestMap = {{Dap::KeysParam::NETWORK_LIST, netList}
                             ,{Dap::KeysParam::WALLET_PATH, path}
                             ,{Dap::KeysParam::WALLET_NAME, walletName}};


    m_modulesController->getServiceController()->requestToService("DapGetWalletAddressCommand", requestMap);
}
