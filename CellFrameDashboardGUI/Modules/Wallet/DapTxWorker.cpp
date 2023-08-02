#include "DapTxWorker.h"

DapTxWorker::DapTxWorker(QObject *parent)
    : QObject{parent}
{

}

QVariantMap DapTxWorker::getFee(QString network)
{
    QVariantMap mapResult;

    if(m_feeBuffer.isNull())
    {
        mapResult.insert("error", (int)DAP_RCV_FEE_ERROR);
        mapResult.insert("fee_ticker","UNKNOWN");
        mapResult.insert("network_fee", "0.00");
        mapResult.insert("validator_fee", "0.00");
        return mapResult;
    }

    QJsonObject fee      = m_feeBuffer.object()[network].toObject();
    QString feeNetwork   = fee["network_fee"].toObject()["fee_coins"].toString();
    QString feeTicker    = fee["validator_fee"].toObject()["fee_ticker"].toString();
    QString feeValidator = fee["validator_fee"].toObject()["average_fee_coins"].toString();

    mapResult.insert("error", (int)DAP_NO_ERROR);
    mapResult.insert("fee_ticker", feeTicker);
    mapResult.insert("network_fee", feeNetwork);
    mapResult.insert("validator_fee", feeValidator);

    return mapResult;
}

QVariantMap DapTxWorker::getAvailableBalance(QVariantMap data)
{
    QVariantMap mapResult;

    if(m_feeBuffer.isNull())
    {
        mapResult.insert("error", (int)DAP_RCV_FEE_ERROR);
        mapResult.insert("availBalance", "0.00");
        return mapResult;
    }

    DapErrors err{DAP_NO_ERROR};
    QVariant availBalance{"0.00"};

    MathWorker mathWorker;
    StringWorker stringWorker;

    QString walletName = data.value("wallet_name").toString();
    QString network    = data.value("network").toString();
    QString sendTicker = data.value("send_ticker").toString();

    QJsonObject fee    = m_feeBuffer.object()[network].toObject();
    QString feeTicker  = fee["validator_fee"].toObject()["fee_ticker"].toString();

    QVariantMap balances = getBalanceInfo(walletName, network, feeTicker, sendTicker);
    if(balances.isEmpty())
    {
        mapResult.insert("error", (int)DAP_NO_TOKENS);
        mapResult.insert("availBalance", "0.00");
        return mapResult;
    }

    QString balancePayFee = balances.value("balancePayFeeCoins").toString();
    QString balanceDatoshi = balances.value("balanceSendDatoshi").toString();

    QVariant commission = mathWorker.sumCoins(fee["network_fee"].toObject()["fee_datoshi"].toVariant(),
                                              fee["validator_fee"].toObject()["average_fee_datoshi"].toVariant(),
                                              false);

    if(!stringWorker.testAmount(balancePayFee, commission.toString()))
    {
        mapResult.insert("error", (int)DAP_NOT_ENOUGHT_TOKENS_FOR_PAY_FEE);
        mapResult.insert("availBalance", balancePayFee);
        mapResult.insert("feeSum", commission.toString());

        return mapResult;
    }
    else
    {
        QVariant comissionDatoshi = mathWorker.coinsToBalance(commission);
        if(sendTicker == feeTicker)
            availBalance = mathWorker.subCoins(balanceDatoshi, comissionDatoshi, true);
        else
            availBalance = balanceDatoshi;
    }

    mapResult.insert("error", err);
    mapResult.insert("availBalance", availBalance);

    return mapResult;
}

QVariant DapTxWorker::calculatePrecentAmount(QVariantMap data)
{
    MathWorker mathWorker;
    int percent = data.value("percent").toInt();
    QVariantMap balanceInfo = getAvailableBalance(data);

    if(balanceInfo.value("error").toInt() == (int)DAP_NO_ERROR)
    {
        QVariant availBalance = balanceInfo.value("availBalance");

        QVariant resAmount;

        switch (percent) {
        case 25:
            resAmount = mathWorker.divDatoshi(availBalance, "4", false); break;
        case 50:
            resAmount = mathWorker.divDatoshi(availBalance, "2", false); break;
        case 75:
        {
            QVariant val1 = mathWorker.divDatoshi(availBalance, "2", true);
            QVariant val2 = mathWorker.divDatoshi(availBalance, "4", true);
            resAmount = mathWorker.sumCoins(val1,val2,false);
            break;
        }
        case 100:
            resAmount = mathWorker.divDatoshi(availBalance, "1", false); break;
        default:
            break;
        }

        return resAmount;
    }

    return "0.00";
}

QVariantMap DapTxWorker::approveTx(QVariantMap data)
{
    StringWorker stringWorker;
    MathWorker mathWorker;

    QString amount = data.value("amount").toString();
    QVariantMap balanceInfo = getAvailableBalance(data);
    QVariant availBalanceDatoshi = balanceInfo.value("availBalance");
    QString availBalance = mathWorker.balanceToCoins(availBalanceDatoshi).toString();

    DapErrors err = (DapErrors)balanceInfo.value("error").toInt();

    if(err == DAP_NO_ERROR)
    {
        if(!stringWorker.testAmount(availBalance, amount))
            err = DAP_NOT_ENOUGHT_TOKENS;

        QVariantMap mapResult;
        mapResult.insert("error", (int)err);
        mapResult.insert("availBalance", availBalance);

        return mapResult;
    }

    return balanceInfo;
}

void DapTxWorker::sendTx(QVariantMap data)
{
    MathWorker mathWorker;
    QString net = data.value("network").toString();
    QJsonObject fee    = m_feeBuffer.object()[net].toObject();
    QString feeDatoshi = fee["validator_fee"].toObject()["average_fee_datoshi"].toString();
    QString amount = mathWorker.coinsToBalance(data.value("amount")).toString();

    QStringList listData;
    listData.append(net);
    listData.append(data.value("wallet_from").toString());
    listData.append(data.value("wallet_to").toString());
    listData.append(data.value("send_ticker").toString());
    listData.append(amount);
    listData.append(feeDatoshi);

    emit sigSendTx(listData);
}

QVariantMap DapTxWorker::getBalanceInfo(QString name, QString network, QString feeTicker, QString sendTicker)
{
    QJsonObject wallet;
    QJsonArray walletsArr = m_walletBuffer.array();

    for (auto itr  = walletsArr.begin();
         itr != walletsArr.end(); itr++)
    {
        QJsonObject obj = itr->toObject();
        if(obj["name"].toString() == name)
        {
            wallet = obj;
            break;
        }
    }

    if(wallet.isEmpty())
    {
        qWarning()<< "Wallet is not found: " << name;
        return QVariantMap();
    }

    QJsonArray tokens;
    QJsonArray arr = wallet["networks"].toArray();

    for (auto itr  = arr.begin();
         itr != arr.end(); itr++)
    {
        QJsonObject obj = itr->toObject();
        if(obj["name"].toString() == network)
        {
            tokens = obj["tokens"].toArray();
            break;
        }
    }

    QString balancePayFeeDatoshi = "", balancePayFeeCoins = "";
    for (auto itr  = tokens.begin();
         itr != tokens.end(); itr++)
    {
        QJsonObject obj = itr->toObject();
        if(obj["name"].toString() == feeTicker)
        {
            balancePayFeeDatoshi = obj["datoshi"].toString();
            balancePayFeeCoins   = obj["coins"].toString();
            break;
        }
    }

    QString balanceDatoshi = "", balanceCoins = "";
    for (auto itr  = tokens.begin();
         itr != tokens.end(); itr++)
    {
        QJsonObject obj = itr->toObject();
        if(obj["name"].toString() == sendTicker)
        {
            balanceDatoshi = obj["datoshi"].toString();
            balanceCoins   = obj["coins"].toString();
            break;
        }
    }

    if(balancePayFeeDatoshi.isEmpty() || balancePayFeeCoins.isEmpty() ||
       balanceDatoshi.isEmpty()       || balanceCoins.isEmpty()       ||
       tokens.isEmpty())
    {
        qWarning()<< "No tokens"       << "\n"                  <<
            "network: "                << network               <<
            "feeToken: "               << feeTicker             <<
            "sendToken: "              << sendTicker            <<
            "walletName: "             << name                  <<
            "balancePayFeeDatoshi: "   << balancePayFeeDatoshi  <<
            "balancePayFeeCoins: "     << balancePayFeeCoins    <<
            "balanceDatoshi: "         << balanceDatoshi        <<
            "balanceCoins: "           << balanceCoins          <<
            "tokens.toVariantList(): " << tokens.toVariantList();
        return QVariantMap();
    }

    QVariantMap mapResult;
    mapResult.insert("balancePayFeeDatoshi", balancePayFeeDatoshi);
    mapResult.insert("balancePayFeeCoins"  , balancePayFeeCoins);
    mapResult.insert("balanceSendDatoshi"  , balanceDatoshi);
    mapResult.insert("balanceSendCoins"    , balanceCoins);

    return mapResult;
}
