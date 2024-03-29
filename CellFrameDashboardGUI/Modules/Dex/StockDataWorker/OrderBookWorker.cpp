#include "OrderBookWorker.h"

#include <QDateTime>
#include <QRandomGenerator>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include "Workers/mathworker.h"
#include <cmath>

constexpr int bookRoundPowerDelta {7};

OrderBookWorker::OrderBookWorker(QQmlContext *cont, QObject *parent) :
    QObject(parent),
    context(cont)
{
    sendCurrentBookModels();

}

//void OrderBookWorker::setContext(QQmlContext *cont)
//{
//    context = cont;

//    sendCurrentBookModels();
//}

void OrderBookWorker::resetBookModel()
{
    m_sellMaxTotal.clear();
    m_buyMaxTotal.clear();

    sellOrderModel.clear();
    buyOrderModel.clear();

    getVariantBookModels();

    sendCurrentBookModels();
}

void OrderBookWorker::generateBookModel(double price, int length, double step)
{
//    m_sellMaxTotal.clear();
//    m_buyMaxTotal.clear();

//    sellOrderModel.clear();
//    buyOrderModel.clear();

//    double temp_price = price;

//    for (auto i = 0; i < length; i++)
//    {
//        temp_price +=
//            QRandomGenerator::global()->generateDouble()*step;
//        double amount = QRandomGenerator::global()->generateDouble()*1500;
//        double total = amount * temp_price;

//        allOrders.append(FullOrderInfo{OrderType::sell, temp_price, amount, total});
//    }

//    temp_price = price;

//    for (auto i = 0; i < length; i++)
//    {
//        temp_price -=
//            QRandomGenerator::global()->generateDouble()*step;
//        double amount = QRandomGenerator::global()->generateDouble()*1500;
//        double total = amount * temp_price;

//        allOrders.append(FullOrderInfo{OrderType::buy, temp_price, amount, total});
//    }

//    updateBookModels();
}

QString OrderBookWorker::invertValue(const QString& price)
{
    if(price.isEmpty() || price == "0.0" || price == "0")
    {
        return "0.0";
    }
    QString resPrice(price);
    if(!price.contains('.'))
    {
        resPrice.append(".0");
    }
    QString one = "1.0";
    uint256_t oneDatoshi= dap_uint256_scan_decimal(one.toStdString().data());
    uint256_t priceDatoshi= dap_uint256_scan_decimal(resPrice.toStdString().data());
    uint256_t accum = {};
    DIV_256_COIN(oneDatoshi, priceDatoshi, &accum);
    QString result  = dap_chain_balance_to_coins(accum);

    return result;
}

QString OrderBookWorker::sumCoins(const QString& val1, const QString& val2)
{
    if(val1.isEmpty() || val1 == "0.0" || val1 == "0" || val2.isEmpty() || val2 == "0.0" || val2 == "0")
    {
        return "0.0";
    }
    QString resVal1(val1), resVal2(val2);
    if(!resVal1.contains('.'))
    {
        resVal1.append(".0");
    }
    if(!resVal2.contains('.'))
    {
        resVal2.append(".0");
    }

    uint256_t val1_t = dap_uint256_scan_decimal(resVal1.toStdString().data());
    uint256_t val2_t = dap_uint256_scan_decimal(resVal2.toStdString().data());
    uint256_t accum = {};

    SUM_256_256(val1_t, val2_t, &accum);
    return dap_chain_balance_to_coins(accum);
}

QString OrderBookWorker::multCoins(const QString& val1, const QString& val2)
{
    if(val1.isEmpty() || val1 == "0.0" || val1 == "0" || val2.isEmpty() || val2 == "0.0" || val2 == "0")
    {
        return "0.0";
    }
    QString resVal1(val1), resVal2(val2);
    if(!resVal1.contains('.'))
    {
        resVal1.append(".0");
    }
    if(!resVal2.contains('.'))
    {
        resVal2.append(".0");
    }

    uint256_t val1_t = dap_uint256_scan_decimal(resVal1.toStdString().data());
    uint256_t val2_t = dap_uint256_scan_decimal(resVal2.toStdString().data());
    uint256_t accum = {};

    MULT_256_COIN(val1_t, val2_t, &accum);
    return dap_chain_balance_to_coins(accum);
}

QString OrderBookWorker::divCoins(const QString& val1, const QString& val2)
{
    if(val1.isEmpty() || val1 == "0.0" || val1 == "0" || val2.isEmpty() || val2 == "0.0" || val2 == "0")
    {
        return "0.0";
    }
    QString resVal1(val1), resVal2(val2);
    if(!resVal1.contains('.'))
    {
        resVal1.append(".0");
    }
    if(!resVal2.contains('.'))
    {
        resVal2.append(".0");
    }

    uint256_t val1_t = dap_uint256_scan_decimal(resVal1.toStdString().data());
    uint256_t val2_t = dap_uint256_scan_decimal(resVal2.toStdString().data());
    uint256_t accum = {};
    DIV_256_COIN(val1_t, val2_t, &accum);
    return dap_chain_balance_to_coins(accum);
}

double OrderBookWorker::roundCoinsToDouble(const QString& value, int round)
{
    QString result(value);
    auto parts = result.split(".");
    if (parts.size() == 2 && parts[1].size() > round)
    {
        parts[1].resize(round);
        result = parts.join(".");
    }
    return result.toDouble();
}

int OrderBookWorker::compareCoins(const QString& val1, const QString& val2)
{
    if(val1.isEmpty() || val2.isEmpty())
    {
        return 0;
    }
    QString resVal1(val1), resVal2(val2);
    if(!resVal1.contains('.'))
    {
        resVal1.append(".0");
    }
    if(!resVal2.contains('.'))
    {
        resVal2.append(".0");
    }
    uint256_t val1_t = dap_uint256_scan_decimal(resVal1.toStdString().data());
    uint256_t val2_t = dap_uint256_scan_decimal(resVal2.toStdString().data());
    return compare256(val1_t, val2_t);
}

void OrderBookWorker::setBookModel(const QByteArray &json)
{
    QJsonDocument document = QJsonDocument::fromJson(json);

    if (!document.isObject())
        return;

    allOrders.clear();
    auto object = document.object();
    auto keys = object.keys();

    for(const auto& netName: keys)
    {
        QJsonArray orders = object[netName].toArray();

        for(auto j = 0; j < orders.size(); j++)
        {
            QString tok1 = orders.at(j)["buy_token"].toString();
            QString tok2 = orders.at(j)["sell_token"].toString();

            if ((tok1 == token1 && tok2 == token2) ||
                (tok2 == token1 && tok1 == token2))
            {
                OrderType type;

                if (tok1 == token1)
                    type = OrderType::buy;
                else
                    type = OrderType::sell;

                FullOrderInfo item;
                item.type = type;
                item.price = orders.at(j)["rate"].toString();

                if (type == OrderType::buy)
                {
                    item.price = invertValue(item.price);
                }
                item.amount = orders.at(j)["amount"].toString();
                item.total = multCoins(item.amount, item.price);

                allOrders.append(std::move(item));
            }
        }
    }

    updateBookModels();
}

double OrderBookWorker::getfilledForPrice(bool isSell, const QString& price)
{
    auto serchResult = [this](const QVector <OrderInfo>& model,const QString price, const QString maxValue) ->double
    {
        for(const auto& item: model)
        {
            if(item.price == price)
            {
                QString strResult = divCoins(item.total, maxValue);
                return roundCoinsToDouble(strResult);
            }
        }
    };

    double result;

    if(isSell)
    {
        result = serchResult(sellOrderModel, price, m_sellMaxTotal);
    }
    else
    {
        result = serchResult(buyOrderModel, price, m_buyMaxTotal);
    }

    return result;
}

void OrderBookWorker::setBookRoundPower(const QString &text)
{
    qDebug() << "OrderBookWorker::setBookRoundPower" << text;

    auto parts = text.split('.');
    if(parts.size() != 2)
    {
        return;
    }
    m_bookRoundPower = parts[1].size();

    updateBookModels();
}

QString OrderBookWorker::roundDoubleValue(const QString &value)
{
    QString result(value);
    auto parts = result.split('.');
    if(parts.size() != 2 || parts[1].size() <= m_bookRoundPower || m_bookRoundPower == 0)
    {
        return std::move(result);
    }
    parts[1].resize(m_bookRoundPower);
    result = parts.join(".");
    if(result.contains(REGULAR_ZERO_VALUE))
    {
        return QString();
    }

    return std::move(result);
}

void OrderBookWorker::checkBookRoundPower(double currentTokenPrice)
{
//    qDebug() << "OrderBookWorker::checkBookRoundPower" << currentTokenPrice;

    int tempPower = -10;
    double tempMask = pow (10, tempPower);

    while (tempMask < currentTokenPrice && tempPower < 77)
    {
        ++tempPower;

        tempMask = pow (10, tempPower);
    }

    if (- tempPower + bookRoundPowerDelta != m_bookRoundPowerMinimum)
    {
        m_bookRoundPowerMinimum = - tempPower + bookRoundPowerDelta;

        m_bookRoundPower = m_bookRoundPowerMinimum;

        qDebug() << "m_bookRoundPowerMinimum" << m_bookRoundPowerMinimum;

        emit setNewBookRoundPowerMinimum(m_bookRoundPowerMinimum);

        updateBookModels();
    }
}

void OrderBookWorker::setTokenPair(const QString &tok1,
    const QString &tok2, const QString &net)
{
    token1 = tok1;
    token2 = tok2;
    network = net;

    qDebug() << "OrderBookWorker::setTokenPair" << token1 << token2 << network;
}

void OrderBookWorker::setTokenPair(const DEX::InfoTokenPair& info, const QString& net)
{
    token1 = info.token1;
    token2 = info.token2;
    network = net;
}

void OrderBookWorker::updateBookModels()
{
    sellOrderModel.clear();
    buyOrderModel.clear();

    for (FullOrderInfo order : allOrders)
    {
        insertBookOrder(order);
    }

    m_sellMaxTotal = "0.0";
    m_buyMaxTotal = "0.0";

    for(auto i = 0; i < sellOrderModel.size(); i++)
        if (compareCoins(m_sellMaxTotal, sellOrderModel.at(i).total) == -1)
            m_sellMaxTotal = sellOrderModel.at(i).total;

    for(auto i = 0; i < buyOrderModel.size(); i++)
        if (compareCoins(m_buyMaxTotal, buyOrderModel.at(i).total) == -1)
            m_buyMaxTotal = buyOrderModel.at(i).total;

    getVariantBookModels();

    sendCurrentBookModels();
}

void OrderBookWorker::insertBookOrder(const FullOrderInfo &item)
{
    QString price = roundDoubleValue(item.price);
    if(price.isEmpty())
    {
        return;
    }

    QVector <OrderInfo>& model =
            item.type == OrderType::sell ? sellOrderModel : buyOrderModel;

    int index = 0;

    while (index < model.size())
    {
        if (price == model.at(index).price)
        {
            model[index].amount = sumCoins(model[index].amount, item.amount);
            model[index].total = multCoins(model.at(index).amount, model.at(index).price);

            break;
        }
        else
        {
            if ((item.type == OrderType::sell && compareCoins(price, model.at(index).price) == -1)
                || (item.type == OrderType::buy && compareCoins(price, model.at(index).price) == 1))
            {
                model.insert(index, OrderInfo{price, item.amount, item.total});
                break;
            }
        }

        ++index;
    }

    if (index == model.size())
        model.append(OrderInfo{price, item.amount, item.total});
}

void OrderBookWorker::getVariantBookModels()
{
    sellModel.clear();

    for (auto i = 0; i < sellOrderModel.size(); ++i)
        sellModel << QVariant::fromValue(sellOrderModel.at(i));

    buyModel.clear();

    for (auto i = 0; i < buyOrderModel.size(); ++i)
        buyModel << QVariant::fromValue(buyOrderModel.at(i));
}

void OrderBookWorker::sendCurrentBookModels()
{
    emit sellMaxTotalChanged(m_sellMaxTotal);
    emit buyMaxTotalChanged(m_buyMaxTotal);

    context->setContextProperty("buyModel", buyModel);
    context->setContextProperty("sellModel", sellModel);
}
