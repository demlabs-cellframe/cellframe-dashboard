#include "DapModuleWalletAddition.h"

DapModuleWalletAddition::DapModuleWalletAddition(DapModulesController *parent)
    : DapModuleWallet(parent)
{
    m_currentNetworkName = m_modulesCtrl->getSettings()->value("networkName", "").toString();
}

DapModuleWalletAddition::~DapModuleWalletAddition()
{

}

void DapModuleWalletAddition::walletsListReceived(const QVariant &rcvData)
{
    QJsonDocument doc = QJsonDocument::fromJson(rcvData.toByteArray());

    QJsonObject replyObj = doc.object();
    QJsonArray resultArr = replyObj["result"].toArray();
    if(resultArr.isEmpty())
    {
        setCurrentWallet(-1);
    }

    if(m_walletListTest != doc.toJson())
    {
        m_walletListTest = doc.toJson();
        updateWalletInfo(resultArr);

        m_walletModel->updateWallets(m_walletsInfo);

        if(!m_firstDataLoad)
        {
            restoreIndex();
            m_firstDataLoad = true;
            m_modulesCtrl->tryStartModules();
        }
        int index = getIndexWallet(m_currentWallet.second);
        if(m_walletsInfo.isEmpty())
        {
            setCurrentWallet(-1);
        }
        else if(index == -1)
        {
            setCurrentWallet(0);
        }
        else
        {
            setCurrentWallet(index);
        }

        if(m_walletsInfo.contains(m_currentWallet.second))
        {
            m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);

            if(!m_currentNetworkName.isEmpty())
            {
                setWalletTokenModel(m_currentNetworkName);
            }
            updateDexTokenModel();
        }
        emit listWalletChanged();
    }
}

void DapModuleWalletAddition::updateWalletInfo(const QJsonArray &array)
{
    QStringList currentList;

    for(const QJsonValue value: array)
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
                }
                else
                {
                    if(!walletName.isEmpty())
                    {
                        CommonWallet::WalletInfo tmpWallet;
                        tmpWallet.walletName = walletName;
                        tmpWallet.status = tmpObject["status"].toString();
                        m_walletsInfo.insert(walletName, std::move(tmpWallet));
                        requestWalletInfo(walletName, "true");
                    }
                }
                currentList.append(walletName);
            }
        }
    }

    QStringList tmpList = m_walletsInfo.keys();
    QStringList diffList;
    for(const QString& str: tmpList)
    {
        if(!currentList.contains(str))
        {
            diffList.append(str);
        }
    }

    for(const QString& str: diffList)
    {
        m_walletsInfo.remove(str);
    }
}

void DapModuleWalletAddition::setCurrentWallet(int index)
{
    QPair<int,QString> newWallet;
    if(index == -1 || m_walletsInfo.isEmpty())
    {
        newWallet = {-1, ""};
    }
    else if(m_walletsInfo.size() > index)
    {
        QStringList list = m_walletsInfo.keys();
        newWallet = {index, list[index]};
    }
    else
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }

    if(newWallet.first != m_currentWallet.first)
    {
        setNewCurrentWallet(std::move(newWallet));
    }
}

void DapModuleWalletAddition::setCurrentWallet(const QString& walletName)
{
    QPair<int,QString> newWallet;

    if(m_walletsInfo.isEmpty())
    {
        newWallet = {-1, ""};
    }
    else if(walletName.isEmpty() || walletName.trimmed().isEmpty())
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }
    else if(m_walletsInfo.contains(walletName))
    {
        int index = getIndexWallet(walletName);
        newWallet = {index, walletName};
    }
    else
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }

    if(newWallet.first != m_currentWallet.first)
    {
        setNewCurrentWallet(std::move(newWallet));
    }
}

void DapModuleWalletAddition::setNewCurrentWallet(const QPair<int,QString> newWallet)
{
    if(m_currentWallet.second == newWallet.second)
    {
        if(newWallet.first != m_currentWallet.first)
        {
            m_currentWallet.first = newWallet.first;
        }
        return;
    }
    m_currentWallet = newWallet;
    m_modulesCtrl->getSettings()->setValue("walletName", m_currentWallet.second);
    m_modulesCtrl->setCurrentWallet(m_currentWallet);
    if(!m_currentWallet.second.isEmpty())
    {
        m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);
        if(!m_currentNetworkName.isEmpty())
        {
            setWalletTokenModel(m_currentNetworkName);
        }
        updateDexTokenModel();
    }
    else
    {
        m_infoWallet->updateModel({});
        if(!m_currentNetworkName.isEmpty())
        {
            setWalletTokenModel(m_currentNetworkName);
        }
    }

    startUpdateCurrentWallet();
    emit currentWalletChanged();
    emit currentWalletNameChanged(m_currentWallet.second);
    emit currentDataChange();
    updateBalanceDEX();
}

void DapModuleWalletAddition::rcvCreateTx(const QVariant &rcvData)
{
    emit sigTxCreate(rcvData);
}

void DapModuleWalletAddition::updateWalletModel(QVariant data, bool isSingle)
{
    QByteArray byteArrayData = data.toByteArray();

    if(isSingle)
    {
        if(m_walletInfoTest != byteArrayData)
        {
            m_walletInfoTest = byteArrayData;
        }
        else
        {
            return;
        }
    }
    else
    {
        if(m_walletsInfoTest != byteArrayData)
        {
            m_walletsInfoTest = byteArrayData;
        }
        else
        {
            return;
        }
    }

    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);

    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    if(!isSingle)
    {
        QJsonArray walletArray = document.array();
        if(walletArray.isEmpty())
        {
            return;
        }

        for(const QJsonValue& walletValue: walletArray)
        {
            CommonWallet::WalletInfo tmpInfo = creatInfoObject(std::move(walletValue.toObject()));
            if(m_walletsInfo.contains(tmpInfo.walletName))
            {
                m_walletsInfo[tmpInfo.walletName] = std::move(tmpInfo);
            }
            else
            {
                if(!tmpInfo.walletName.isEmpty())
                {
                    m_walletsInfo.insert(tmpInfo.walletName, std::move(tmpInfo));
                }
            }
        }
        emit walletsModelChanged();
    }
    else
    {

        QJsonObject replyObj = document.object();

        QJsonObject inObject = replyObj["result"].toObject();
        CommonWallet::WalletInfo tmpInfo = creatInfoObject(std::move(inObject));
        if(m_walletsInfo.contains(tmpInfo.walletName))
        {
            m_walletsInfo[tmpInfo.walletName] = std::move(tmpInfo);
        }
        else
        {
            if(!tmpInfo.walletName.isEmpty())
            {
                m_walletsInfo.insert(tmpInfo.walletName, std::move(tmpInfo));
            }
        }
        emit walletsModelChanged();
    }

    updateDexTokenModel();
    if(m_walletsInfo.contains(m_currentWallet.second))
    {
        m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);
    }
    if(!m_currentNetworkName.isEmpty())
    {
        setWalletTokenModel(m_currentNetworkName);
    }
    m_walletModel->updateWallets(m_walletsInfo);
    emit walletsModelChanged();
    emit currentDataChange();
    if(getCurrentNetworkName().isEmpty() && !m_walletsInfo[m_currentWallet.second].walletInfo.isEmpty())
    {
        setCurrentNetworkName(m_walletsInfo[m_currentWallet.second].walletInfo.first().network);
    }
    updateBalanceDEX();
}

CommonWallet::WalletInfo DapModuleWalletAddition::creatInfoObject(const QJsonObject& walletObject)
{
    CommonWallet::WalletInfo wallet;

    if(walletObject.contains("name"))
    {
        wallet.walletName = walletObject["name"].toString();
    }
    else
    {
        qWarning() << "[creatInfoObject] No wallet name";
        return CommonWallet::WalletInfo();
    }

    if(walletObject.contains("status"))
    {
        wallet.status = walletObject["status"].toString();
    }
    wallet.isLoad = true;
    if(walletObject.contains("networks"))
    {
        for(const QJsonValue& networkValue: walletObject["networks"].toArray())
        {
            QJsonObject networkObject = networkValue.toObject();
            CommonWallet::WalletNetworkInfo networkInfo;

            if(networkObject.contains("address"))
            {
                networkInfo.address = networkObject["address"].toString();
            }
            else
            {
                qWarning() << "The wallet address is missing on the network or the input data has changed";
                continue;
            }

            if(networkObject.contains("name"))
            {
                networkInfo.network = networkObject["name"].toString();
            }
            else
            {
                qWarning() << "The network name is missing or the input data has changed";
                continue;
            }

            if(networkObject.contains("tokens"))
            {
                for(const QJsonValue& tokenValue: networkObject["tokens"].toArray())
                {
                    QJsonObject tokenObject = tokenValue.toObject();
                    CommonWallet::WalletTokensInfo token;
                    token.network = networkInfo.network;
                    if(tokenObject.contains("coins"))
                    {
                        token.value = tokenObject["coins"].toString();
                    }
                    if(tokenObject.contains("datoshi"))
                    {
                        token.datoshi = tokenObject["datoshi"].toString();
                    }
                    if(tokenObject.contains("name"))
                    {
                        token.ticker = tokenObject["name"].toString();
                        token.tokenName = tokenObject["name"].toString();
                    }

                    networkInfo.networkInfo.append(token);
                }
            }

            wallet.walletInfo.insert(networkInfo.network, networkInfo);
        }
    }
    return wallet;
}

bool DapModuleWalletAddition::checkWalletLocked(QString walletName)
{
    bool locked = false;
    if(m_walletsInfo.contains(walletName))
    {
        const CommonWallet::WalletInfo& wallet = m_walletsInfo[walletName];
        if(wallet.status == "non-Active") locked = true;
    }
    return locked;
}

void DapModuleWalletAddition::rcvFee(const QVariant &rcvData)
{
    auto feeDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject feeObject = feeDoc.object()["result"].toObject();
    if(feeObject.isEmpty())
    {
        qDebug() << "[DapModuleWallet] The list of networks is empty";
        return;
    }

    for(const auto& networkName: feeObject.keys())
    {
        QJsonObject networkObj = feeObject[networkName].toObject();
        CommonWallet::FeeInfo tmpFeeInfo;
        if(!networkObj.contains("network_fee"))
        {
            qDebug() << "[DapModuleWallet] There is no information on the network commission";
        }
        else
        {
            QJsonObject netFeeObject = networkObj["network_fee"].toObject();
            QStringList netFeeKeys = netFeeObject.keys();
            for(const QString& itemName: netFeeKeys)
            {
                tmpFeeInfo.netFee.insert(itemName, netFeeObject[itemName].toString());
            }
        }

        if(!networkObj.contains("validator_fee"))
        {
            qDebug() << "[DapModuleWallet] There is no information on the validator commission";
        }
        else
        {
            QJsonObject netValidatorObject = networkObj["validator_fee"].toObject();
            QStringList validatorKeys = netValidatorObject.keys();
            for(const QString& itemName: validatorKeys)
            {
                tmpFeeInfo.validatorFee.insert(itemName, netValidatorObject[itemName].toString());
            }
        }
        m_feeInfo.insert(networkName, std::move(tmpFeeInfo));
    }
    emit feeInfoUpdated();
}

QString DapModuleWalletAddition::isCreateOrder(const QString& network, const QString& amount, const QString& tokenName)
{
    auto checkValue = [](const QString& str) -> QString
    {
        if(str.isEmpty())
        {
            return str;
        }
        QString result = str;
        if(!str.contains('.'))
        {
            result.append(".0");
        }
        return result;
    };

    QString normalAmount = checkValue(amount);

    const auto& infoWallet = m_walletsInfo[m_currentWallet.second];
    if(!infoWallet.walletInfo.contains(network))
    {
        return "Error, network not found";
    }
    const auto& infoNetwork = infoWallet.walletInfo[network];

    auto getCoins = [&infoNetwork](const QString& ticker) -> QString
    {
        auto itemIt = std::find_if(infoNetwork.networkInfo.begin(), infoNetwork.networkInfo.end(), [&ticker](const CommonWallet::WalletTokensInfo& item){
            return item.ticker == ticker;
        });

        return itemIt != infoNetwork.networkInfo.end() ? itemIt->value : QString();
    };

    const auto& feeInfo = m_feeInfo[network];

    QString netFeeTicker;
    QString netFee;
    if(feeInfo.netFee.contains("fee_ticker") && feeInfo.netFee.contains("fee_coins"))
    {
        netFeeTicker = feeInfo.netFee["fee_ticker"];
        netFee = feeInfo.netFee["fee_coins"];
    }

    uint256_t result = dap_uint256_scan_uninteger(normalAmount.toStdString().data());

    if(!netFee.isEmpty() && netFee != "0.0")
    {
        uint256_t net = dap_uint256_scan_uninteger(netFee.toStdString().data());
        if(netFeeTicker == tokenName)
        {
            SUM_256_256(net, result, &result);
        }
        else
        {
            QString netValue = getCoins(netFeeTicker);
            if(!netValue.isEmpty())
            {
                uint256_t value = dap_uint256_scan_uninteger(netValue.toStdString().data());
                if(compare256(value, net) == -1)
                {
                    return "Error. It is not possible to pay the Internet fee";
                }

            }
        }
    }

    QString valFeeTicker;
    QString valFee;
    if(feeInfo.validatorFee.contains("fee_ticker") && feeInfo.validatorFee.contains("average_fee_coins"))
    {
        valFeeTicker = feeInfo.validatorFee["fee_ticker"];
        valFee = feeInfo.validatorFee["average_fee_coins"];
    }

    if(!valFee.isEmpty() && valFee != "0.0")
    {
        uint256_t val = dap_uint256_scan_uninteger(valFee.toStdString().data());
        if(valFeeTicker == tokenName)
        {
            SUM_256_256(val, result, &result);
        }
        else
        {
            QString netValue = getCoins(valFeeTicker);
            if(!netValue.isEmpty())
            {
                uint256_t value = dap_uint256_scan_uninteger(netValue.toStdString().data());
                if(compare256(value, val) == -1)
                {
                    return "Error. It is not possible to pay the Validate fee";
                }

            }
        }
    }

    QString currentValue = getCoins(tokenName);
    uint256_t value = dap_uint256_scan_uninteger(currentValue.toStdString().data());
    if(compare256(value, result) == -1)
    {
        return "Error. It is not possible to pay the Validate fee";
    }

    return "OK";
}


void DapModuleWalletAddition::setCurrentNetworkName(const QString& networkName)
{
    m_currentNetworkName = networkName;
    m_modulesCtrl->getSettings()->setValue("networkName", networkName);
    setWalletTokenModel(networkName);
    emit currentNetworkChanged(networkName);
    emit currentDataChange();
}

QString DapModuleWalletAddition::getCurrentAddressNetwork()
{
    auto name = m_currentWallet.second;
    if(name.isEmpty())
    {
        return {};
    }
    if(!m_walletsInfo.contains(name))
    {
        return {};
    }
    const CommonWallet::WalletInfo& wallet = m_walletsInfo[name];

    if(!wallet.walletInfo.contains(m_currentNetworkName))
    {
        return {};
    }

    return wallet.walletInfo[m_currentNetworkName].address;
}

QString DapModuleWalletAddition::getAddressNetworkByWallet(const QString& walletName)
{
    if(!m_walletsInfo.contains(walletName))
    {
        return {};
    }
    const CommonWallet::WalletInfo& wallet = m_walletsInfo[walletName];

    if(!wallet.walletInfo.contains(m_currentNetworkName))
    {
        return {};
    }

    return wallet.walletInfo[m_currentNetworkName].address;
}

bool DapModuleWalletAddition::isModel() const
{
    return m_tokenModel->size() != 0;
}

void DapModuleWalletAddition::requestWalletInfo(const QString& walletName, const QString& key)
{
    s_serviceCtrl->requestToService("DapGetWalletInfoCommand", QStringList() << walletName << key);
}
