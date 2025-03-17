#include "DapModuleWalletAddition.h"

DapModuleWalletAddition::DapModuleWalletAddition(DapModulesController *parent)
    : DapModuleWallet(parent)
{
    m_currentNetworkName = m_modulesCtrl->getSettings()->value("networkName", "").toString();
    setCurrentNetworkName(m_currentNetworkName);
    connect(m_modulesCtrl, &DapModulesController::currentNetworkChanged, this, &DapModuleWalletAddition::setCurrentNetworkName, Qt::QueuedConnection);

}

DapModuleWalletAddition::~DapModuleWalletAddition()
{
    disconnect();
}

void DapModuleWalletAddition::setCurrentNetworkName(const QString& name)
{
    m_currentNetworkName = name;
    m_modulesCtrl->getSettings()->setValue("networkName", name);
    setWalletTokenModel(name);
    emit currentNetworkChanged(name);
    emit currentDataChange();
}

void DapModuleWalletAddition::setNewCurrentWallet(const QPair<int,QString> newWallet)
{
    DapModuleWallet::setNewCurrentWallet(newWallet);
    emit currentDataChange();
}

// void DapModuleWalletAddition::updateWalletModel(QVariant data, bool isSingle)
// {
//     DapModuleWallet::updateWalletModel(data, isSingle);
//     // if(m_modulesCtrl->getCurrentNetwork().isEmpty() && !m_walletsInfo[m_currentWallet.second].walletInfo.isEmpty())
//     // {
//     //     m_modulesCtrl->setCurrentNetwork(m_walletsInfo[m_currentWallet.second].walletInfo.first().network);
//     // }
//     emit currentDataChange();
// }

bool DapModuleWalletAddition::checkWalletLocked(QString walletName)
{
    bool locked = false;
    // if(m_walletsInfo.contains(walletName))
    // {
    //     const CommonWallet::WalletInfo& wallet = m_walletsInfo[walletName];
    //     if(wallet.status == "non-Active") locked = true;
    // }
    return locked;
}

QString DapModuleWalletAddition::isCreateOrder(const QString& network, const QString& amount, const QString& tokenName)
{
    // auto checkValue = [](const QString& str) -> QString
    // {
    //     if(str.isEmpty())
    //     {
    //         return str;
    //     }
    //     QString result = str;
    //     if(!str.contains('.'))
    //     {
    //         result.append(".0");
    //     }
    //     return result;
    // };

    // QString normalAmount = checkValue(amount);

    // const auto& infoWallet = m_walletsInfo[m_currentWallet.second];
    // if(!infoWallet.walletInfo.contains(network))
    // {
    //     return "Error, network not found";
    // }
    // const auto& infoNetwork = infoWallet.walletInfo[network];

    // auto getCoins = [&infoNetwork](const QString& ticker) -> QString
    // {
    //     auto itemIt = std::find_if(infoNetwork.networkInfo.begin(), infoNetwork.networkInfo.end(), [&ticker](const CommonWallet::WalletTokensInfo& item){
    //         return item.ticker == ticker;
    //     });

    //     return itemIt != infoNetwork.networkInfo.end() ? itemIt->value : QString();
    // };

    // const auto& feeInfo = m_feeInfo[network];

    // QString netFeeTicker;
    // QString netFee;
    // if(feeInfo.netFee.contains("fee_ticker") && feeInfo.netFee.contains("fee_coins"))
    // {
    //     netFeeTicker = feeInfo.netFee["fee_ticker"];
    //     netFee = feeInfo.netFee["fee_coins"];
    // }

    // uint256_t result = dap_uint256_scan_uninteger(normalAmount.toStdString().data());

    // if(!netFee.isEmpty() && netFee != "0.0")
    // {
    //     uint256_t net = dap_uint256_scan_uninteger(netFee.toStdString().data());
    //     if(netFeeTicker == tokenName)
    //     {
    //         SUM_256_256(net, result, &result);
    //     }
    //     else
    //     {
    //         QString netValue = getCoins(netFeeTicker);
    //         if(!netValue.isEmpty())
    //         {
    //             uint256_t value = dap_uint256_scan_uninteger(netValue.toStdString().data());
    //             if(compare256(value, net) == -1)
    //             {
    //                 return "Error. It is not possible to pay the Internet fee";
    //             }

    //         }
    //     }
    // }

    // QString valFeeTicker;
    // QString valFee;
    // if(feeInfo.validatorFee.contains("fee_ticker") && feeInfo.validatorFee.contains("average_fee_coins"))
    // {
    //     valFeeTicker = feeInfo.validatorFee["fee_ticker"];
    //     valFee = feeInfo.validatorFee["average_fee_coins"];
    // }

    // if(!valFee.isEmpty() && valFee != "0.0")
    // {
    //     uint256_t val = dap_uint256_scan_uninteger(valFee.toStdString().data());
    //     if(valFeeTicker == tokenName)
    //     {
    //         SUM_256_256(val, result, &result);
    //     }
    //     else
    //     {
    //         QString netValue = getCoins(valFeeTicker);
    //         if(!netValue.isEmpty())
    //         {
    //             uint256_t value = dap_uint256_scan_uninteger(netValue.toStdString().data());
    //             if(compare256(value, val) == -1)
    //             {
    //                 return "Error. It is not possible to pay the Validate fee";
    //             }

    //         }
    //     }
    // }

    // QString currentValue = getCoins(tokenName);
    // uint256_t value = dap_uint256_scan_uninteger(currentValue.toStdString().data());
    // if(compare256(value, result) == -1)
    // {
    //     return "Error. It is not possible to pay the Validate fee";
    // }

    return "OK";
}

QString DapModuleWalletAddition::getCurrentAddressNetwork()
{
    // auto name = m_currentWallet.second;
    // if(name.isEmpty())
    // {
    //     return {};
    // }
    // if(!m_walletsInfo.contains(name))
    // {
    //     return {};
    // }
    // const CommonWallet::WalletInfo& wallet = m_walletsInfo[name];

    // if(!wallet.walletInfo.contains(m_currentNetworkName))
    // {
    //     return {};
    // }

    // return wallet.walletInfo[m_currentNetworkName].address;
    return QString();
}

QString DapModuleWalletAddition::getAddressNetworkByWallet(const QString& walletName)
{
    // if(!m_walletsInfo.contains(walletName))
    // {
    //     return {};
    // }
    // const CommonWallet::WalletInfo& wallet = m_walletsInfo[walletName];

    // if(!wallet.walletInfo.contains(m_currentNetworkName))
    // {
    //     return {};
    // }

    // return wallet.walletInfo[m_currentNetworkName].address;
    return QString();
}

bool DapModuleWalletAddition::isModel() const
{
    return m_tokenModel->size() != 0;
}

void DapModuleWalletAddition::requestWalletInfo(const QString& walletName, const QString& key)
{
    // s_serviceCtrl->requestToService("DapGetWalletInfoCommand", QStringList() << walletName << key);
}
