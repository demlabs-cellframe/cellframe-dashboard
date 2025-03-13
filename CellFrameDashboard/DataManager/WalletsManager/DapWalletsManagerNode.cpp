#include "DapWalletsManagerNode.h"
#include "DapServiceController.h"
#include "Modules/DapModulesController.h"
#include "DapDataManagerController.h"
#include <QMap>

DapWalletsManagerNode::DapWalletsManagerNode(DapModulesController *moduleController)
    : DapWalletsManagerBase(moduleController)
    , m_walletsListTimer(new QTimer())
    , m_timerUpdateWallet(new QTimer())
    , m_timerFeeUpdateWallet(new QTimer())
{
    connect(m_walletsListTimer, &QTimer::timeout, this, &DapWalletsManagerNode::updateListWallets, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletsListReceived, this, &DapWalletsManagerNode::walletsListReceived, Qt::QueuedConnection);
    connect(m_modulesController->getServiceController(), &DapServiceController::walletReceived, this, &DapWalletsManagerNode::rcvWalletInfo, Qt::QueuedConnection);
    connect(m_timerUpdateWallet, &QTimer::timeout, this, [this]{
        updateInfoWallets();
    });
}

void DapWalletsManagerNode::updateWalletList()
{
    updateListWallets();
}

void DapWalletsManagerNode::initManager()
{
    updateListWallets();
    m_walletsListTimer->start(TIME_WALLET_LIST_UPDATE);
}

void DapWalletsManagerNode::walletsListReceived(const QVariant &rcvData)
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
    QStringList newListWallet;

    bool isUpdateWallet = false;

    for(const QJsonValue &value: walletArray)
    {
        QJsonObject tmpObject = value.toObject();
        if(tmpObject.contains(Dap::JsonKeys::NAME) && tmpObject.contains(Dap::JsonKeys::STATUS))
        {
            QString walletName = tmpObject[Dap::JsonKeys::NAME].toString();
            newListWallet.append(walletName);
            if(walletName.isEmpty())
            {
                continue;
            }

            if(m_walletsInfo.contains(walletName))
            {
                if(m_walletsInfo[walletName].status != tmpObject[Dap::JsonKeys::STATUS].toString())
                {
                    m_walletsInfo[walletName].status = tmpObject[Dap::JsonKeys::STATUS].toString();
                    emit walletInfoChanged(walletName);
                    emit walletListChanged();
                    isUpdateWallet = true;
                }
            }
            else
            {
                CommonWallet::WalletInfo tmpWallet;
                tmpWallet.walletName = walletName;
                tmpWallet.status = tmpObject[Dap::JsonKeys::STATUS].toString();
                m_walletsInfo.insert(walletName, std::move(tmpWallet));
                isUpdateWallet = true;
            }
        }
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
        m_requestInfoWallets.clear();
        updateInfoWallets();
        emit walletListChanged();
    }
}

bool DapWalletsManagerNode::updateWalletModel()
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

void DapWalletsManagerNode::rcvWalletInfo(const QVariant &rcvData)
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

    QString walletName = inObject.value(Dap::JsonKeys::WALLET_NAME).toString();
    QString networkName = inObject.value(Dap::JsonKeys::NETWORK_NAME).toString();

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

    if(!m_walletsInfo.contains(walletName))
    {
        qWarning() << "[DapWalletsManagerNode] The list does not contain a wallet with the name " << walletName;
        return;
    }

    auto& wallet = m_walletsInfo[walletName];
    if(!wallet.walletInfo.contains(networkName))
    {
        wallet.isLoad = true;
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
            wallet.isLoad = true;
            wallet.walletInfo.insert(networkName, netInfo);
            isUpdateNetwork = true;
        }

        if(isUpdateNetwork)
        {        
            emit walletInfoChanged(walletName, networkName);
        }
    }
    updateInfoWallets();
}

void DapWalletsManagerNode::currentWalletChangedSlot()
{
    QString currWallet = getCurrentWallet().second;
    updateInfoWallets(currWallet);
}

void DapWalletsManagerNode::updateInfoWallets(const QString &walletName)
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
        m_requestInfoWallets.clear();
        return;
    }
    auto walletList = m_walletsInfo.keys();

    if(!walletName.isEmpty())
    {
        m_lastRequestInfoNetworkName = netList[0];
        m_requestInfoWallets.clear();
        m_requestInfoWallets.append(walletName);
    }
    else if((m_lastRequestInfoNetworkName.isEmpty() || m_requestInfoWallets.isEmpty())||
               (!netList.contains(m_lastRequestInfoNetworkName) ||
        !walletList.contains(m_requestInfoWallets.last())))
    {
        m_lastRequestInfoNetworkName = netList[0];
        m_requestInfoWallets.append(m_walletsInfo.firstKey());
    }
    else
    {
        int netIndex = netList.indexOf(m_lastRequestInfoNetworkName);
        if(netList.size() - 1 == netIndex)
        {
            QString nextWallet;
            for(const auto& wallet: walletList)
            {
                if(!m_requestInfoWallets.contains(wallet))
                {
                    nextWallet = wallet;
                    break;
                }
            }
            if(nextWallet.isEmpty())
            {
                m_lastRequestInfoNetworkName.clear();
                m_requestInfoWallets.clear();
                m_timerUpdateWallet->start(TIME_WALLET_INFO_UPDATE);
                return;
            }
            else
            {
                m_requestInfoWallets.append(nextWallet);
                m_lastRequestInfoNetworkName = netList[0];
            }
        }
        else
        {
            m_lastRequestInfoNetworkName = netList[netIndex + 1];
        }
    }

    if(!m_requestInfoWallets.isEmpty() && !m_lastRequestInfoNetworkName.isEmpty())
    {
        requestWalletInfo(m_requestInfoWallets.last(), m_lastRequestInfoNetworkName);
    }
    else
    {
        m_lastRequestInfoNetworkName.clear();
        m_requestInfoWallets.clear();
        m_timerUpdateWallet->start(TIME_WALLET_INFO_UPDATE);
    }
}

void DapWalletsManagerNode::updateListWallets()
{
    QVariantMap request = {{Dap::KeysParam::NODE_MODE_KEY, Dap::NodeMode::LOCAL_MODE}};
    m_modulesController->getServiceController()->requestToService("DapGetListWalletsCommand", request);
}

void DapWalletsManagerNode::requestWalletInfo(const QString& walletName, const QString& network)
{
    m_isRequestInfo = true;
    QString nodeMade = Dap::NodeMode::LOCAL_MODE;
    QVariantMap request = {{Dap::KeysParam::NODE_MODE_KEY, nodeMade}
                           ,{Dap::KeysParam::NETWORK_NAME, network}
                           ,{Dap::KeysParam::WALLET_NAME, walletName}};
    m_modulesController->getServiceController()->requestToService("DapGetWalletInfoCommand", request);
}
