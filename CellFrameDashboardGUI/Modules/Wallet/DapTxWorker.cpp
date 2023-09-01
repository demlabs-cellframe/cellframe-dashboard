#include "DapTxWorker.h"

DapTxWorker::DapTxWorker(QObject *parent)
    : QObject{parent}
{

}

QVariantMap DapTxWorker::getFee(QString network)
{
    QVariantMap mapResult;

    if(m_feeBuffer.isNull() || network.isEmpty())
    {
        mapResult.insert("error", (int)DAP_RCV_FEE_ERROR);
        mapResult.insert("fee_ticker","UNKNOWN");
        mapResult.insert("network_fee", 0.00f);
        mapResult.insert("validator_fee", 0.00f);
        mapResult.insert("validator_fee_min", 0.00f);
        mapResult.insert("validator_fee_max", 0.00f);
        return mapResult;
    }

    QJsonObject fee         = m_feeBuffer.object()[network].toObject();
    QString feeNetwork      = fee["network_fee"].toObject()["fee_coins"].toString();
    QString feeTicker       = fee["validator_fee"].toObject()["fee_ticker"].toString();

    QString feeValidator    = fee["validator_fee"].toObject()["median_fee_coins"].toString();
    QString feeValidatorMin = fee["validator_fee"].toObject()["min_fee_coins"].toString();
    QString feeValidatorMax = fee["validator_fee"].toObject()["max_fee_coins"].toString();

    mapResult.insert("error", (int)DAP_NO_ERROR);
    mapResult.insert("fee_ticker", feeTicker);
    mapResult.insert("network_fee", feeNetwork);
    mapResult.insert("validator_fee", feeValidator);
    mapResult.insert("validator_fee_min", feeValidatorMin);
    mapResult.insert("validator_fee_max", feeValidatorMax);

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
                                              fee["validator_fee"].toObject()["median_fee_datoshi"].toVariant(),
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
    QString feeDatoshi = fee["validator_fee"].toObject()["median_fee_datoshi"].toString();
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

void DapTxWorker::setFeeData(QVariantMap data)
{
    m_feeData = data;
    emit feeDataChanged();
}

QVariantMap DapTxWorker::feeData()
{
    return m_feeData;
}

void DapTxWorker::clearFeeData()
{
    m_feeData.clear();
    emit feeDataChanged();
}

QVariantMap DapTxWorker::generateFeeData(QString network)
{
    QVariantMap feeBuf = getFee(network);
    QVariantMap result;

    if(feeBuf.value("error").toInt() = DAP_NO_ERROR)
    {
        MathWorker mathWrkr;
        QString currPos;
        QVariant minFee, maxFee, midFee, currValue, currIndex;
        QVariant posVeryLow = -1, posLow = -1, posMid = -1, posHigh = -1, posVeryHigh = -1;
        QVariant minFee_datoshi, maxFee_datoshi, midFee_datoshi;

        currPos = "Mid";

        minFee  = feeBuf.value("validator_fee_min");
        maxFee  = feeBuf.value("validator_fee_max");
        midFee  = feeBuf.value("validator_fee");

        minFee_datoshi  = mathWrkr.coinsToBalance(minFee);
        maxFee_datoshi  = mathWrkr.coinsToBalance(maxFee);
        midFee_datoshi  = mathWrkr.coinsToBalance(midFee);


        if( mathWrkr.isEqual(minFee_datoshi, midFee_datoshi).toBool() &&
           !mathWrkr.isEqual(maxFee_datoshi, midFee_datoshi).toBool())
        {
            qDebug()<<"min and mid is equal";
            posMid = midFee;
            //posHigh coins = (max - mid)/2 + mid
            posHigh = mathWrkr.sumCoins(mathWrkr.divCoins(mathWrkr.subCoins(maxFee_datoshi, midFee_datoshi, true), "2", true), midFee_datoshi, false);
            posVeryHigh = maxFee;
        }
        if( mathWrkr.isEqual(maxFee_datoshi, midFee_datoshi).toBool() &&
           !mathWrkr.isEqual(minFee_datoshi, midFee_datoshi).toBool())
        {
            qDebug()<<"max and mid is equal";

            posVeryLow = minFee;
            //posLow coins = (mid - min)/2 + min
            posLow = mathWrkr.sumCoins(mathWrkr.divCoins(mathWrkr.subCoins(midFee_datoshi, minFee_datoshi, true), "2", true), minFee_datoshi, false);
            posMid = midFee;
        }
        if(!mathWrkr.isEqual(maxFee_datoshi, midFee_datoshi).toBool() &&
           !mathWrkr.isEqual(minFee_datoshi, midFee_datoshi).toBool())
        {
            posVeryLow = minFee;
            //posLow coins = (mid - min)/2 + min
            posLow = mathWrkr.sumCoins(mathWrkr.divCoins(mathWrkr.subCoins(midFee_datoshi, minFee_datoshi, true), "2", true), minFee_datoshi, false);
            posMid = midFee;
            //posHigh coins = (max - mid)/2 + mid
            posHigh = mathWrkr.sumCoins(mathWrkr.divCoins(mathWrkr.subCoins(maxFee_datoshi, midFee_datoshi, true), "2", true), midFee_datoshi, false);
            posVeryHigh = maxFee;
        }

        result.insert("minFee", minFee);
        result.insert("maxFee", maxFee);
        result.insert("midFee", midFee);
        result.insert("currPos", currPos);
        result.insert("VeryLow", posVeryLow);
        result.insert("Low", posLow);
        result.insert("Mid", posMid);
        result.insert("High", posHigh);
        result.insert("VeryHigh", posVeryHigh);
        result.insert("currIndex", 2); // VeryLow = 0, Low = 1 ... VeryHigh = 4
        result.insert("currValue", result.value(currPos)); // insert currentValue at current position
    }
    else
    {
        result.insert("minFee", "-1");
        result.insert("maxFee", "-1");
        result.insert("midFee", "-1");
        result.insert("currPos", "-1");
        result.insert("VeryLow", "-1");
        result.insert("Low", "-1");
        result.insert("Mid", "-1");
        result.insert("High", "-1");
        result.insert("VeryHigh", "-1");
        result.insert("currIndex", "-1");
        result.insert("currValue", "-1");

        qDebug()<<"bad data fee";
    }
    setFeeData(result);
    return result;
}

QVariantMap DapTxWorker::feeIncrement()
{
    QVariantMap result;
    QVariantMap feeBuf = m_feeData;
    QString currPos = feeBuf.value("currPos").toString();
    int currIndex = feeBuf.value("currIndex").toInt();
    QString currValue = feeBuf.value("currValue").toString();

    if(currPos != "-1")
    {


        if(currPos == "VeryHigh")
            currPos = "High";
        else if(currPos == "High")
            currPos = "Mid";
        else if(currPos == "Mid")
            currPos = "Low";
        else if(currPos == "Low")
            currPos = "VeryLow";
        else if(currPos == "VeryLow")
            currPos = "VeryHigh";

        if(currValue != "-1")
        {
            feeBuf.insert("currPos", currPos);
            feeBuf.insert("currValue", feeBuf.value(currPos)); // insert currentValue at current position
        }
        else
        {

        }
    }
    else
    {
        result = feeBuf;
    }

    return result;
}

QVariantMap DapTxWorker::feeDecrement()
{

}
