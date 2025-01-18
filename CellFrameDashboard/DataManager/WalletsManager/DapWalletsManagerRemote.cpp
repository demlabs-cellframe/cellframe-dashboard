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
        if(tmpObject.contains("name") && tmpObject.contains("status"))
        {
            QString walletName = tmpObject["name"].toString();
            if(!walletName.isEmpty())
            {
                if(m_walletsInfo.contains(walletName))
                {
                    m_walletsInfo[walletName].status = tmpObject["status"].toString();
                    isUpdateWallet = true;
                }
                else
                {
                    CommonWallet::WalletInfo tmpWallet;
                    tmpWallet.walletName = walletName;
                    tmpWallet.status = tmpObject["status"].toString();
                    m_walletsInfo.insert(walletName, std::move(tmpWallet));
                    isUpdateWallet = true;
                }
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
        updateInfoWallets();
    }

    emit walletListChanged();
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

    QString walletName = inObject.value("walletName").toString();
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

    if(!m_walletsInfo.contains(walletName))
    {
        qWarning() << "[DapWalletsManagerLocal] The list does not contain a wallet with the name " << walletName;
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
        for(auto& item: network.networkInfo)
        {
            for(auto& newItem: netInfo.networkInfo)
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
                m_lastRequestInfoWalletName = walletList[walletIndex + 1];
                m_lastRequestInfoNetworkName = netList[0];
            }
        }
        else
        {
            m_lastRequestInfoNetworkName = netList[netIndex + 1];
        }
    }
    requestWalletInfo(m_lastRequestInfoWalletName, m_lastRequestInfoNetworkName);
}

void DapWalletsManagerRemote::updateListWallets()
{
    m_modulesController->getServiceController()->requestToService("DapGetListWalletsCommand", QStringList());
}

void DapWalletsManagerRemote::requestWalletInfo(const QString& walletName, const QString& network)
{
    m_isRequestInfo = true;
    m_modulesController->getServiceController()->requestToService("DapGetWalletInfoCommand", QStringList() << walletName << network);
}

