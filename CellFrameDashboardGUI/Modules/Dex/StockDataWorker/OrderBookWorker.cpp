#include "OrderBookWorker.h"

#include <QDateTime>
#include <QRandomGenerator>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>

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
    m_sellMaxTotal = 0;
    m_buyMaxTotal = 0;

    sellOrderModel.clear();
    buyOrderModel.clear();

    getVariantBookModels();

    sendCurrentBookModels();
}

void OrderBookWorker::generateBookModel(double price, int length, double step)
{
    m_sellMaxTotal = 0;
    m_buyMaxTotal = 0;

    sellOrderModel.clear();
    buyOrderModel.clear();

    double temp_price = price;

    for (auto i = 0; i < length; i++)
    {
        temp_price +=
            QRandomGenerator::global()->generateDouble()*step;
        double amount = QRandomGenerator::global()->generateDouble()*1500;
        double total = amount * temp_price;

        allOrders.append(FullOrderInfo{OrderType::sell, temp_price, amount, total});
    }

    temp_price = price;

    for (auto i = 0; i < length; i++)
    {
        temp_price -=
            QRandomGenerator::global()->generateDouble()*step;
        double amount = QRandomGenerator::global()->generateDouble()*1500;
        double total = amount * temp_price;

        allOrders.append(FullOrderInfo{OrderType::buy, temp_price, amount, total});
    }

    updateBookModels();
}

void OrderBookWorker::setBookModel(const QByteArray &json)
{
    QJsonDocument doc = QJsonDocument::fromJson(json);

    if (!doc.isArray())
        return;

    allOrders.clear();

    QJsonArray netArray = doc.array();

    for(auto i = 0; i < netArray.size(); i++)
    {
       // if (netArray.at(i)["network"].toString() == network)
        {
            QJsonArray orders = netArray[i].toArray();// /*["orders"].*/toArray();

            for(auto j = 0; j < orders.size(); j++)
            {
                QString tok1 = orders.at(j)["buyToken"].toString();
                QString tok2 = orders.at(j)["sellToken"].toString();

                if ((tok1 == token1 && tok2 == token2) ||
                    (tok2 == token1 && tok1 == token2))
                {
                    OrderType type;

                    if (tok1 == token1)
                        type = OrderType::buy;
                    else
                        type = OrderType::sell;

                    double price = orders.at(j)["rate"].toString().toDouble();

                    if (type == OrderType::buy)
                    {
                        if (price > 0.000000000000000000000001)
                            price = 1/price;
                        else
                            price = 1;
                    }

                    double amount = orders.at(j)["amount"].toString().toDouble();

                    amount *= 0.000000000000000001;

                    double total = amount * price;

                    allOrders.append(FullOrderInfo{type, price, amount, total});
                }
            }
        }

    }

    updateBookModels();
}

void OrderBookWorker::generateNewBookState()
{
    if (QRandomGenerator::global()->bounded(2))
    {
        int index =
            QRandomGenerator::global()->bounded(sellOrderModel.size());

        sellOrderModel[index].amount +=
                QRandomGenerator::global()->bounded(1, 20);
        sellOrderModel[index].total = sellOrderModel.at(index).amount *
                sellOrderModel.at(index).price;

        if (m_sellMaxTotal < sellOrderModel.at(index).total)
            m_sellMaxTotal = sellOrderModel.at(index).total;
    }
    else
    {
        int index =
            QRandomGenerator::global()->bounded(buyOrderModel.size());

        buyOrderModel[index].amount +=
                QRandomGenerator::global()->bounded(1, 20);
        buyOrderModel[index].total = buyOrderModel.at(index).amount *
                buyOrderModel.at(index).price;

        if (m_buyMaxTotal < buyOrderModel.at(index).total)
            m_buyMaxTotal = buyOrderModel.at(index).total;
    }

    getVariantBookModels();

    sendCurrentBookModels();
}

void OrderBookWorker::setBookRoundPower(const QString &text)
{
    double value = text.toDouble();

    qDebug() << "OrderBookWorker::setBookRoundPower" << text << value
             << QString::number(value, 'f', 20);

    double power = 20;
    double test = pow(10, -power);

    while (test < value
           && power > -20)
    {
        --power;
        test = pow(10, -power);
    }

    m_bookRoundPower = power;

    updateBookModels();
}

double OrderBookWorker::roundDoubleValue(double value, int round)
{
    double p = pow (10, -round);

    value /= p;
    value = QString::number(value, 'f', 0).toDouble();
    value *= p;

    return value;
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
        insertBookOrder(order.type, order.price, order.amount, order.total);
    }

    m_sellMaxTotal = 0;
    m_buyMaxTotal = 0;

    for(auto i = 0; i < sellOrderModel.size(); i++)
        if (m_sellMaxTotal < sellOrderModel.at(i).total)
            m_sellMaxTotal = sellOrderModel.at(i).total;

    for(auto i = 0; i < buyOrderModel.size(); i++)
        if (m_buyMaxTotal < buyOrderModel.at(i).total)
            m_buyMaxTotal = buyOrderModel.at(i).total;

    getVariantBookModels();

    sendCurrentBookModels();
}

void OrderBookWorker::insertBookOrder(const OrderType& type, double price, double amount, double total)
{
    price = roundDoubleValue(price, m_bookRoundPower);

    QVector <OrderInfo>& model =
            type == OrderType::sell ? sellOrderModel : buyOrderModel;

    int index = 0;

    while (index < model.size())
    {
        if (price == model.at(index).price)
        {
            model[index].amount += amount;
            model[index].total = model.at(index).amount *
                    model.at(index).price;

            break;
        }
        else
        {
            if ((type == OrderType::sell && price < model.at(index).price)
                || (type == OrderType::buy && price > model.at(index).price))
            {
                model.insert(index, OrderInfo{price, amount, total});
                break;
            }
        }

        ++index;
    }

    if (index == model.size())
        model.append(OrderInfo{price, amount, total});
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
