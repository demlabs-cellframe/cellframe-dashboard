#include "serviceimitator.h"

#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>

#include <QRandomGenerator>
#include <QDateTime>

ServiceImitator::ServiceImitator(QObject *parent) : QObject(parent)
{

}

void ServiceImitator::requestToService(const QString &asServiceName,
    const QVariant &args)
{
    QStringList params = args.toStringList();

    qDebug() << "ServiceImitator::requestToService" << asServiceName
        << params;

//    if (asServiceName == "DapVersionController")
//        DapVersionController(params);

//    if (asServiceName == "DapGetWalletsInfoCommand")
//        DapGetWalletsInfoCommand();

//    if (asServiceName == "DapGetXchangeTokenPair")
//        DapGetXchangeTokenPair(params);

    if (asServiceName == "DapGetXchangeTokenPriceAverage")
        DapGetXchangeTokenPriceAverage(params);

    if (asServiceName == "DapGetXchangeTokenPriceHistory")
        DapGetXchangeTokenPriceHistory(params);

    if (asServiceName == "DapGetXchangeOrdersList")
        DapGetXchangeOrdersList();

    if (asServiceName == "DapXchangeOrderCreate")
        DapXchangeOrderCreate(params);

    if (asServiceName == "DapGetXchangeTxList")
        DapGetXchangeTxList(params);

}

const QString LAST_VERSION = "lastVersion";
const QString HAS_UPDATE = "hasUpdate";
const QString MESSAGE = "message";
const QString URL = "url";

void ServiceImitator::DapVersionController(const QStringList& arg)
{
    qDebug() << "ServiceImitator::DapVersionController" << arg[0];

    QJsonObject resultObj;

    if(arg[0] == "version")
    {
        resultObj.insert(LAST_VERSION,QJsonValue("2 . 10 - 444"));
        resultObj.insert(HAS_UPDATE,QJsonValue(true));
        resultObj.insert(MESSAGE,QJsonValue("Reply version"));
        resultObj.insert(URL,QJsonValue("https://pub.cellframe.net/windows/Dashboard-latest/"));
    }

    emit versionControllerResult(resultObj);
}

void ServiceImitator::DapGetWalletsInfoCommand()
{
    qDebug() << "ServiceImitator::DapVersionController";

    QJsonArray walletsArray;

    QStringList netlist {"Backbone", "private"};

//    while (itr.hasNext())
    {
        QJsonObject walletObj;

        QString walletName = "TestWallet";
        QString status = "Active";

        if(!status.isEmpty())
            status = status.remove("(").remove(")");

        walletObj.insert("name", walletName);
        walletObj.insert("status", status);

        if(status == "Active" || status.isEmpty())
        {
            QJsonArray networkArray;

            for (QString net: netlist)
            {
                QJsonArray tokenArray;

//                while (matchIt.hasNext())
                {
                    QJsonObject tokenObj;
                    tokenObj.insert("name", "TKN1");
                    tokenObj.insert("coins", "1234567890");
                    tokenObj.insert("datoshi", "56789");

                    tokenArray.append(tokenObj);

                    tokenObj.insert("name", "TKN2");
                    tokenObj.insert("coins", "123456789012");
                    tokenObj.insert("datoshi", "56789012");

                    tokenArray.append(tokenObj);
                }
                QJsonObject networkObj;
                networkObj.insert("tokens", tokenArray);
                networkObj.insert("address", "Rj7J7MiX2bWy8sNyYXgSeGUFDkcGXZhxxmPpN8S8bYw41UgjW6xqF1rDcBVwUGZyQzjsPV5DJM2Eyr3p5xuTG6h1ELRFsaRUEwQkncWV");
                networkObj.insert("name", net);

                networkArray.append(networkObj);
            }
            walletObj.insert("networks", networkArray);
        }
        walletsArray.append(walletObj);
    }

    QJsonDocument docResult;
    docResult.setArray(walletsArray);

//    qDebug() << "ServiceImitator::DapGetWalletsInfoCommand" << docResult.toJson();

   // emit walletsReceived(docResult.toJson());
}

void ServiceImitator::DapGetXchangeTokenPair(
        const QStringList& args)
{
    qDebug() << "ServiceImitator::DapGetXchangeTokenPair";

    QJsonArray arrPairs;

    QString fullInfo = args[0];

    bool update = false;
    if (fullInfo == "update" || args[1] == "update")
        update = true;

    QStringList netlist {"Backbone", "private"};

    for (QString net : netlist)
    {
        QStringList pairs = {"TKN1:TKN2", "TKN2:TKN1"};

        for(auto p : pairs)
        {
            if (p.contains(":"))
            {
                QStringList pair = p.split(":");
//                    qDebug() << pair;

                QJsonObject orderObj;
                orderObj.insert("token1", pair.first());
                orderObj.insert("token2", pair.last());

                if (fullInfo == "full_info")
                {
                    orderObj.insert("rate", "0.1");

                    orderObj.insert("network",  net);

                    orderObj.insert("change", "0%");
                }

                arrPairs.append(orderObj);
            }
        }
    }

    QJsonDocument docResult;
    docResult.setArray(arrPairs);

//    qDebug() << "ServiceImitator::DapGetXchangeTokenPair" << docResult.toJson();

//    qDebug() << "ServiceImitator::DapGetXchangeTokenPair" << "update" << update;

    if (update)
        emit signalXchangeTokenPairReceived(QVariant(QString("isEqual")));
    else
        emit signalXchangeTokenPairReceived(docResult.toJson());
}

double currentTokenPrice {2.5631};

void ServiceImitator::DapGetXchangeTokenPriceAverage(
        const QStringList& args)
{
    qDebug() << "ServiceImitator::DapGetXchangeTokenPriceAverage";

    QString net = args[0];
    QString token1 = args[1];
    QString token2 = args[2];

//    currentTokenPrice +=
//        QRandomGenerator::global()->generateDouble()*0.00004 - 0.00002;
    currentTokenPrice +=
        QRandomGenerator::global()->generateDouble()*0.0004 - 0.0002;

    QString rate = QString::number(currentTokenPrice, 'f', 7);

    QJsonObject resultObj;
    resultObj.insert("token1",QJsonValue(token1));
    resultObj.insert("token2",QJsonValue(token2));
    resultObj.insert("network",QJsonValue(net));
    resultObj.insert("rate",QJsonValue(rate));

    // emit rcvXchangeTokenPriceAverage(resultObj);
}

void ServiceImitator::DapGetXchangeTokenPriceHistory(const QStringList &args)
{
    qDebug() << "ServiceImitator::DapGetXchangeTokenPriceHistory";

    QString net = args[0];
    QString token1 = args[1];
    QString token2 = args[2];

    QJsonArray arrHistory;

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

    QJsonObject historyObj;

    historyObj.insert("rate", "2.8");
    historyObj.insert("date", QString::number(currentTime - 1000000));
    arrHistory.append(historyObj);

    historyObj.insert("rate", "3.5");
    historyObj.insert("date", QString::number(currentTime - 800000));
    arrHistory.append(historyObj);

    historyObj.insert("rate", "2.22");
    historyObj.insert("date", QString::number(currentTime - 500000));
    arrHistory.append(historyObj);

    historyObj.insert("rate", "3.0");
    historyObj.insert("date", QString::number(currentTime - 400000));
    arrHistory.append(historyObj);

    historyObj.insert("rate", "2.56304");
    historyObj.insert("date", QString::number(currentTime - 200000));
    arrHistory.append(historyObj);

    QJsonObject resultObject;
    resultObject.insert("history", arrHistory);
    resultObject.insert("token1", token1);
    resultObject.insert("token2", token2);
    resultObject.insert("network", net);

    QJsonDocument docResult;
    docResult.setObject(resultObject);

//   qDebug() << "ServiceImitator::rcvXchangeTokenPriceHistory" << docResult.toJson();

   emit rcvXchangeTokenPriceHistory(docResult.toJson());
}

void ServiceImitator::DapGetXchangeOrdersList()
{
    qDebug() << "ServiceImitator::DapGetXchangeOrdersList";

    QJsonArray array;

    QStringList netlist {"Backbone", "private"};

    for (QString net : netlist)
    {
        QJsonObject obj;
        obj.insert("network", net);
        QJsonArray arrTokens;

        int length = 20;
        double step = 0.01;

        double temp_price = 2.5;

        for (auto i = 0; i < length; i++)
        {
            QJsonObject tokenObject;

            temp_price +=
                QRandomGenerator::global()->generateDouble()*step;
            double amount = QRandomGenerator::global()->generateDouble()*1500;
            amount /= 0.000000000000000001;

            double total = amount * temp_price;

            tokenObject.insert("order_hash",
                               "0x0FBB49D89EC5373CB9CB7091269E6560A788D955CA5A5A0684DD9D18167D6A23");
            tokenObject.insert("sell_token", "TKN1");
            tokenObject.insert("net", net);
            tokenObject.insert("buy_token", "TKN2");
            tokenObject.insert("sell_amount", QString::number(amount));
            tokenObject.insert("buy_amount", QString::number(total));
            tokenObject.insert("rate", QString::number(temp_price));

            arrTokens.append(tokenObject);
        }

        temp_price = 2.5;

        for (auto i = 0; i < length; i++)
        {
            QJsonObject tokenObject;

            temp_price -=
                QRandomGenerator::global()->generateDouble()*step;
            double amount = QRandomGenerator::global()->generateDouble()*1500;
            amount /= 0.000000000000000001;

            double total = amount / temp_price;

            tokenObject.insert("order_hash",
                               "0x0FBB49D89EC5373CB9CB7091269E6560A788D955CA5A5A0684DD9D18167D6A23");
            tokenObject.insert("sell_token", "TKN2");
            tokenObject.insert("net", net);
            tokenObject.insert("buy_token", "TKN1");
            tokenObject.insert("sell_amount", QString::number(amount));
            tokenObject.insert("buy_amount", QString::number(total));
            tokenObject.insert("rate", QString::number(1/temp_price));

            arrTokens.append(tokenObject);
        }

        obj.insert("orders", arrTokens);
        array.append(obj);
    }

    QJsonDocument docResult;
    docResult.setArray(array);

    emit signalXchangeOrderListReceived(docResult.toJson());
}

const QString SUCCESS = "success";

void ServiceImitator::DapXchangeOrderCreate(const QStringList& args)
{
    qDebug() << "ServiceImitator::DapXchangeOrderCreate";

    QString net = args[0];
    QString tokenSell = args[1];
    QString tokenBuy = args[2];

    QString wallet = args[3];
    QString coins = args[4];

    QString checkPut = args[5];

    QString rate;

    if(checkPut.contains(".") && checkPut[checkPut.length() - 1] != ".")
        rate = checkPut;
    else
        rate = QString::number(args[5].toDouble(), 'f', 1);

    QJsonObject resultObj;

    qDebug() << "srv_xchange order create"
             << "net" << net
             << "tokenSell" << tokenSell
             << "wallet" << wallet
             << "coins" << coins
             << "rate" << rate;

//    auto command = QString("%1 srv_xchange order create -net %2 -token_sell %3 -token_buy %4 -wallet %5 -coins %6 -rate %7").arg(CLI_PATH);
//    command = command.arg(net);
//    command = command.arg(tokenSell);
//    command = command.arg(tokenBuy);
//    command = command.arg(wallet);
//    command = command.arg(coins);
//    command = command.arg(rate);

    resultObj.insert(SUCCESS,QJsonValue(true));
    resultObj.insert(MESSAGE,QJsonValue("Successfully created order"));

    emit rcvXchangeCreate(resultObj);
}

void ServiceImitator::DapGetXchangeTxList(const QStringList& args)
{
    qDebug() << "ServiceImitator::DapGetXchangeTxList";

    QString cmd = args[0];
    QString net = args[1];
    QString addr = args[2];
    QString timeFrom = args[3];
    QString timeTo = args[4];

    qDebug() << "cmd" << cmd
             << "net" << net
             << "addr" << addr
             << "timeFrom" << timeFrom
             << "timeTo" << timeTo;

//    QString command = QString("%1 srv_xchange tx_list -net %2").arg(m_sCliPath).arg(net);

//    if(cmd == "GetOrdersPrivate")
//        command += QString(" -addr %1 ").arg(addr);

//    if(timeFrom != "" && timeTo != "")
//        command += QString(" -time_from %1 -time_to %2").arg(timeFrom).arg(timeTo);

//    qDebug() << "command:" << command;
//    QString result = requestToNode(command);

//    QRegularExpression rx(R"(^hash: (.+)\norderHash: (.+)\nvalue1: (([0-9].+) ([A-Za-z]\S.+))\nvalue2: (([0-9].+) ([A-Za-z]\S.+)))", QRegularExpression::MultilineOption);
//    QRegularExpressionMatchIterator itr = rx.globalMatch(result);

    QJsonArray arrOrders;

    QJsonObject orderObj;

    orderObj.insert("tx_hash",
                    "0xB054F5CF08A37E3D917BC3560191FDF77F90C7DEE6911C84DCC1F3C639533814");
    orderObj.insert("order_hash",
                    "0x0FBB49D89EC5373CB9CB7091269E6560A788D955CA5A5A0684DD9D18167D6A23");
    orderObj.insert("price", "12.345678434543544354");
    orderObj.insert("available", "5678.346");
    orderObj.insert("limit", "3456789.39");
    orderObj.insert("side", "buy");
    orderObj.insert("tokenBuy", "TKN1");
    orderObj.insert("tokenSell", "TKN2");
    arrOrders.append(orderObj);

    orderObj.insert("tx_hash",
                    "0xB054F5CF08A37E3D917BC3560191FDF77F90C7DEE6911C84DCC1F3C639533814");
    orderObj.insert("order_hash",
                    "0x0FBB49D89EC5373CB9CB7091269E6560A788D955CA5A5A0684DD9D18167D6A23");
    orderObj.insert("price", "12345.34567");
    orderObj.insert("available", "5678234.346");
    orderObj.insert("limit", "3456789342.39");
    orderObj.insert("side", "sell");
    orderObj.insert("tokenBuy", "TKN2");
    orderObj.insert("tokenSell", "TKN1");
    arrOrders.append(orderObj);

    orderObj.insert("tx_hash",
                    "0xB054F5CF08A37E3D917BC3560191FDF77F90C7DEE6911C84DCC1F3C639533814");
    orderObj.insert("order_hash",
                    "0x0FBB49D89EC5373CB9CB7091269E6560A788D955CA5A5A0684DD9D18167D6A23");
    orderObj.insert("price", "12.345678434543544354");
    orderObj.insert("available", "5678.346");
    orderObj.insert("limit", "3456789.39");
    orderObj.insert("side", "buy");
    orderObj.insert("tokenBuy", "TKN1");
    orderObj.insert("tokenSell", "TKN2");
    arrOrders.append(orderObj);

    orderObj.insert("tx_hash",
                    "0xB054F5CF08A37E3D917BC3560191FDF77F90C7DEE6911C84DCC1F3C639533814");
    orderObj.insert("order_hash",
                    "0x0FBB49D89EC5373CB9CB7091269E6560A788D955CA5A5A0684DD9D18167D6A23");
    orderObj.insert("price", "12345.34567");
    orderObj.insert("available", "5678234.346");
    orderObj.insert("limit", "3456789342.39");
    orderObj.insert("side", "sell");
    orderObj.insert("tokenBuy", "TKN2");
    orderObj.insert("tokenSell", "TKN1");
    arrOrders.append(orderObj);

    orderObj.insert("tx_hash",
                    "0xB054F5CF08A37E3D917BC3560191FDF77F90C7DEE6911C84DCC1F3C639533814");
    orderObj.insert("order_hash",
                    "0x0FBB49D89EC5373CB9CB7091269E6560A788D955CA5A5A0684DD9D18167D6A23");
    orderObj.insert("price", "12.345678434543544354");
    orderObj.insert("available", "5678.346");
    orderObj.insert("limit", "3456789.39");
    orderObj.insert("side", "buy");
    orderObj.insert("tokenBuy", "TKN1");
    orderObj.insert("tokenSell", "TKN2");
    arrOrders.append(orderObj);

    orderObj.insert("tx_hash",
                    "0xB054F5CF08A37E3D917BC3560191FDF77F90C7DEE6911C84DCC1F3C639533814");
    orderObj.insert("order_hash",
                    "0x0FBB49D89EC5373CB9CB7091269E6560A788D955CA5A5A0684DD9D18167D6A23");
    orderObj.insert("price", "12345.34567");
    orderObj.insert("available", "5678234.346");
    orderObj.insert("limit", "3456789342.39");
    orderObj.insert("side", "sell");
    orderObj.insert("tokenBuy", "TKN2");
    orderObj.insert("tokenSell", "TKN1");
    arrOrders.append(orderObj);

    QJsonDocument docResult;
    docResult.setArray(arrOrders);

    emit rcvXchangeTxList(docResult.toJson());

//    qDebug() << "rcvXchangeTxList" << docResult.toJson();
}
