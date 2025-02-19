#include "DapModuleWallet.h"

int getTokenIndex(CommonWallet::WalletNetworkInfo data, QString findToken)
{
    for(int i = 0; i < data.networkInfo.count(); i++)
    {
        CommonWallet::WalletTokensInfo token = data.networkInfo.at(i);
        if(findToken == token.ticker)
            return i;
    }

    return -1;
}

QString DapModuleWallet::getTokenBalance(const QString& network, const QString& tokenName, const QString& walletName) const
{
    auto& walletsInfo = getWalletsInfo();
    QString name = walletName.isEmpty() ? getCurrentWallet().second : walletName;
    if(!walletsInfo.contains(name))
    {
        return QString("0.0");
    }
    const auto& info = walletsInfo[name];
    if(!info.walletInfo.contains(network))
    {
        return QString("0.0");
    }

    for(const auto& tokenInfo: info.walletInfo[network].networkInfo)
    {
        if(tokenInfo.ticker == tokenName)
        {
            return tokenInfo.value;
        }
    }
    return QString("0.0");
}

QVariant DapModuleWallet::calculatePrecentAmount(QVariantMap data)
{
    QVariantMap balanceInfo = getAvailableBalance(data);
    QString resStr = "0.00";

    if(balanceInfo.value("error").toInt() == (int)DAP_NO_ERROR)
    {
        Dap::Coin availableBalance(balanceInfo.value("availBalance").toString());
        Dap::Coin percentValue(data.value("percent").toString());
        Dap::Coin result("0.0");
        result = availableBalance * percentValue;
        resStr = result.toCoinsString();
        return resStr;
    }
    return resStr;
}

QVariantMap DapModuleWallet::getAvailableBalance(QVariantMap data)
{
    QVariantMap mapResult;

    if(m_modulesCtrl->getManagerController()->isFeeEmpty())
    {
        mapResult.insert("error", (int)DAP_RCV_FEE_ERROR);
        mapResult.insert("availBalance", "0.00");
        return mapResult;
    }

    DapErrors err{DAP_NO_ERROR};
    QString availBalance{"0.00"};

    QString network      = data.value("network").toString();
    QString walletName   = data.value("wallet_name").toString();
    QString sendTicker   = data.value("send_ticker").toString();

    const CommonWallet::FeeInfo& fee = m_modulesCtrl->getManagerController()->getFee(network);
    QString feeTicker  = fee.validatorFee.value("fee_ticker");

    CommonWallet::WalletInfo currentWalletInfo = getWalletManager()->getWalletInfo(walletName);
    CommonWallet::WalletNetworkInfo walletNetworkInfo = currentWalletInfo.walletInfo[network];
    int tokenIndex = getTokenIndex(walletNetworkInfo, sendTicker);

    if(tokenIndex == -1)
    {
        mapResult.insert("error", (int)DAP_NO_TOKENS);
        mapResult.insert("availBalance", "0.00");
        return mapResult;
    }
    CommonWallet::WalletTokensInfo walletTokenInfo = walletNetworkInfo.networkInfo.at(tokenIndex);

    Dap::Coin feeSum("0.0");
    Dap::Coin availableBalance(walletTokenInfo.value);

    if(walletTokenInfo.value.isEmpty() || walletTokenInfo.value == "0.0")
    {
        mapResult.insert("error", (int)DAP_NO_TOKENS);
        mapResult.insert("availBalance", "0.00");
        return mapResult;
    }

    if(feeTicker == sendTicker)
    {
        QString userFee = data.value("validator_fee").toString();
        QString validatorFee = userFee.isEmpty() || userFee == "0" || userFee == "0.0" ? fee.validatorFee.value("median_fee_coins") : userFee;

        Dap::Coin netFee(fee.netFee.value("fee_coins"));
        Dap::Coin validatorfee(validatorFee);
        feeSum = netFee + validatorfee;
        mapResult.insert("feeSum", feeSum.toCoinsString());

        Dap::Coin fullBalance(walletTokenInfo.value);

        if(fullBalance > feeSum)
        {
            availableBalance = fullBalance - feeSum;
            if(availableBalance.toCoinsString() == "0" || availableBalance.toCoinsString() == "0.0" || availableBalance.toCoinsString() == "0.00" || availableBalance.toCoinsString().isEmpty())
            {
                mapResult.insert("error", (int)DAP_NOT_ENOUGHT_TOKENS);
                mapResult.insert("availBalance", "0.00");
                return mapResult;
            }
        }
        else
        {
            mapResult.insert("error", (int)DAP_NOT_ENOUGHT_TOKENS_FOR_PAY_FEE);
            mapResult.insert("availBalance", "0.00");
            return mapResult;
        }
    }

    availBalance = availableBalance.toCoinsString();

    mapResult.insert("error", err);
    mapResult.insert("availBalance", availBalance);

    return mapResult;
}

QVariantMap DapModuleWallet::getFee(QString network)
{
    QVariantMap mapResult;

    const CommonWallet::FeeInfo& fee = m_modulesCtrl->getManagerController()->getFee(network);

    if(m_modulesCtrl->getManagerController()->isFeeEmpty() || fee.validatorFee.isEmpty())
    {
        mapResult.insert("error", (int)DAP_RCV_FEE_ERROR);
        mapResult.insert("fee_ticker", m_nativeTokens.value(network));
        mapResult.insert("network_fee", "0.00");
        mapResult.insert("validator_fee", "0.05");
        mapResult.insert("min_fee_coins",  "0.000000000000000001");
        mapResult.insert("max_validator_fee",  "100.0");
        return mapResult;
    }

    mapResult.insert("error", (int)DAP_NO_ERROR);
    mapResult.insert("fee_ticker", fee.validatorFee.value("fee_ticker"));
    mapResult.insert("network_fee", fee.netFee.value("fee_coins"));
    mapResult.insert("validator_fee", fee.validatorFee.value("median_fee_coins"));
    mapResult.insert("min_validator_fee", fee.validatorFee.value("min_fee_coins"));
    mapResult.insert("max_validator_fee", fee.validatorFee.value("max_fee_coins"));

    return mapResult;
}

