#include "stockdataworker.h"

#include <QDateTime>
#include <QRandomGenerator>
#include <QDebug>
#include <QJsonArray>
#include <QJsonObject>

#include <cmath>

constexpr double visibleDefaultCandles {40};
constexpr double maxZoom{3.0};
constexpr double minZoom{0.2};

constexpr double minAverageStep {0.5};
//constexpr double averageDelta {20};

constexpr int numberAverageCharts {3};

constexpr int bookRoundPowerDelta {8};

double roundDoubleValue(double value, int round)
{
    double p = pow (10, -round);

    value /= p;
    value = QString::number(value, 'f', 0).toDouble();
    value *= p;

    return value;
}

StockDataWorker::StockDataWorker(QObject *parent) :
    QObject(parent)
{
    for (auto i = 0; i < numberAverageCharts; ++i)
    {
        QVector <PriceInfo> vector;
        averagedModel.append(vector);

        firstVisibleAverage.append(0);
        lastVisibleAverage.append(0);

        switch (i)
        {
            case 0:
                averageDelta.append(10);
                break;
            case 1:
                averageDelta.append(30);
                break;
            case 2:
                averageDelta.append(90);
                break;
            default:
                averageDelta.append(1);
        }
    }
}

void StockDataWorker::setContext(QQmlContext *cont)
{
    context = cont;

//    buyModel.append(QVariant::fromValue(OrderInfo{2.561, 2000, 2000}));
//    buyModel.append(QVariant::fromValue(OrderInfo{2.562, 2000, 2000}));
//    buyModel.append(QVariant::fromValue(OrderInfo{2.563, 2000, 2000}));

//    sellModel.append(QVariant::fromValue(OrderInfo{2.565, 2000, 2000}));
//    sellModel.append(QVariant::fromValue(OrderInfo{2.566, 2000, 2000}));
//    sellModel.append(QVariant::fromValue(OrderInfo{2.567, 2000, 2000}));
//    for (int i = 0; i < maxLines; ++i)
//        infoList << QVariant::fromValue(Info{});

    //    updateHistogram();

    sendCurrentBookModels();
}

void StockDataWorker::setTokenPair(const QString &tok1,
    const QString &tok2, const QString &net)
{
    token1 = tok1;
    token2 = tok2;
    network = net;

//    qDebug() << "StockDataWorker::setTokenPair" << token1 << token2 << network;
}

void StockDataWorker::resetPriceData(double price, double init)
{
//    qDebug() << "StockDataWorker::resetPriceData" << price;

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

    m_currentTokenPrice = price;
    m_previousTokenPrice = price;

    priceModel.clear();

    if (!init && price > 0.000000000000000000001)
    {
        PriceInfo info{currentTime, price};

        priceModel.append(info);
    }

    getCandleModel(false);

    resetRightTime();

    getTempAveragedModel(false);

    getAveragedModels(false);

    getMinimumMaximum24h();

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit previousTokenPriceChanged(m_previousTokenPrice);

//    qDebug() << "StockDataWorker::generatePriceData" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

void StockDataWorker::generatePriceData(int length)
{
//    qDebug() << "StockDataWorker::generatePriceData" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    double currentPrice = 0.245978;
    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

//    m_minimum24h = currentPrice;
//    m_maximum24h = currentPrice;

    m_currentTokenPrice = currentPrice;
    m_previousTokenPrice = currentPrice;

    if (length < 1)
        length = 1;

    priceModel.resize(length);

    for (auto i = length-1; i >= 0; --i)
    {
        PriceInfo info{currentTime, currentPrice};

//        if (m_minimum24h > currentPrice)
//            m_minimum24h = currentPrice;
//        if (m_maximum24h < currentPrice)
//            m_maximum24h = currentPrice;

        priceModel[i] = info;
//        priceModel.prepend(info);
//        priceModel.append(info);

        currentPrice +=
            QRandomGenerator::global()->generateDouble() * 0.0001 - 0.00005;

        if (i == length-1)
            m_previousTokenPrice = currentPrice;

        currentTime -= 5000 + static_cast<qint64>(
            QRandomGenerator::global()->generateDouble() * 3000);
    }

//    emit minimum24hChanged(m_minimum24h);
//    emit maximum24hChanged(m_maximum24h);

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit previousTokenPriceChanged(m_previousTokenPrice);

//    qDebug() << "StockDataWorker::generatePriceData" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

QVariantMap StockDataWorker::getPriceInfo(int index)
{
    if (index < 0 || index >= priceModel.size())
        return {};
    else
        return priceModel.at(index).getMap();
}

void StockDataWorker::setTokenPriceHistory(const QByteArray &json)
{
    qDebug() << "StockDataWorker::setTokenPriceHistory";

/*    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    priceModel.resize(4);
    PriceInfo info;

    info.price = 12.3;
    info.time = currentTime - 1000*60*10;
    priceModel[0] = info;

    info.price = 24.5;
    info.time = currentTime - 1000*60*7;
    priceModel[1] = info;

    info.price = 18.7;
    info.time = currentTime - 1000*60*4;
    priceModel[2] = info;

    info.price = 31.2;
    info.time = currentTime - 1000*60*3;
    priceModel[3] = info;*/

    QJsonDocument doc = QJsonDocument::fromJson(json);

//    qDebug() << doc.isObject();

//    qDebug() << doc["network"].toString();
//    qDebug() << doc["token1"].toString();
//    qDebug() << doc["token2"].toString();

    QJsonArray history = doc["history"].toArray();

    qDebug() << "history.size()" << history.size();

    priceModel.resize(history.size());

    for(auto i = 0; i < history.size(); i++)
    {
        QString date = history.at(i)["date"].toString();

        double price = history.at(i)["rate"].toString().toDouble();
        qint64 time = date.toLongLong();

        qDebug() << price
                << time
                << QDateTime::fromMSecsSinceEpoch(time).toString("dd MM yyyy HH:mm:ss");

        PriceInfo info{time, price};

        priceModel[i] = info;
    }

    if (priceModel.size() > 0)
    {
        m_previousTokenPrice = m_currentTokenPrice = priceModel.last().price;
    }
    if (priceModel.size() > 1)
    {
        m_previousTokenPrice = priceModel.at(priceModel.size()-2).price;
    }

    getCandleModel(false);

    resetRightTime();

    getTempAveragedModel(false);

    getAveragedModels(false);

    getMinimumMaximum24h();

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit previousTokenPriceChanged(m_previousTokenPrice);
}

void StockDataWorker::resetBookModel()
{
    m_sellMaxTotal = 0;
    m_buyMaxTotal = 0;

    sellOrderModel.clear();
    buyOrderModel.clear();

    getVariantBookModels();

    sendCurrentBookModels();
}

void StockDataWorker::generateBookModel(double price, int length, double step)
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

//        sellOrderModel.append(OrderInfo{temp_price, amount, total});

        allOrders.append(FullOrderInfo{OrderType::sell, temp_price, amount, total});

//        insertBookOrder(OrderType::sell, temp_price, amount, total);
    }

    temp_price = price;

    for (auto i = 0; i < length; i++)
    {
        temp_price -=
            QRandomGenerator::global()->generateDouble()*step;
        double amount = QRandomGenerator::global()->generateDouble()*1500;
        double total = amount * temp_price;

//        buyOrderModel.append(OrderInfo{temp_price, amount, total});

        allOrders.append(FullOrderInfo{OrderType::buy, temp_price, amount, total});

//        insertBookOrder(OrderType::buy, temp_price, amount, total);
    }

    updateBookModels();

/*    for(auto i = 0; i < sellOrderModel.size(); i++)
        if (m_sellMaxTotal < sellOrderModel.at(i).total)
            m_sellMaxTotal = sellOrderModel.at(i).total;

    for(auto i = 0; i < buyOrderModel.size(); i++)
        if (m_buyMaxTotal < buyOrderModel.at(i).total)
            m_buyMaxTotal = buyOrderModel.at(i).total;

    getVariantBookModels();

    sendCurrentBookModels();*/
}

void StockDataWorker::setBookModel(const QByteArray &json)
{
//    qDebug() << "StockDataWorker::setBookModel";

    QJsonDocument doc = QJsonDocument::fromJson(json);

    if (!doc.isArray())
        return;

    allOrders.clear();

    QJsonArray netArray = doc.array();
//        qDebug() << "array.size()" << netArray.size();

    for(auto i = 0; i < netArray.size(); i++)
    {
//            qDebug() << netArray.at(i)["network"].toString()
//                    << (netArray.at(i)["network"].toString() == network);

        if (netArray.at(i)["network"].toString() == network)
        {
            QJsonArray orders = netArray.at(i)["orders"].toArray();

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

//                    qDebug () << "buy_token" << tok1
//                              << "sell_token" << tok2
//                              << "buy_amount" << orders.at(j)["buy_amount"].toString()
//                              << "sell_amount" << orders.at(j)["sell_amount"].toString();

                    double price = orders.at(j)["rate"].toString().toDouble();

                    if (type == OrderType::buy)
                    {
                        if (price > 0.000000000000000000000001)
                            price = 1/price;
                        else
                            price = 1;
                    }

                    double amount;

                    if (type == OrderType::buy)
                    {
                        amount = orders.at(j)["buy_amount"].toString().toDouble();
//                            if (price > 0.000000000000000000001)
//                                amount /= price;
                    }
                    else
                    {
                        amount = orders.at(j)["sell_amount"].toString().toDouble();
                    }

                    amount *= 0.000000000000000001;

                    double total = amount * price;

//                        qDebug () << tok1 << tok2
//                                  << price
//                                  << amount
//                                  << total
//                                  << QString::number(total)
//                                  << QString::number(amount);

//                    qDebug () << "buy_token" << tok1
//                              << "sell_token" << tok2
//                              << "price" << price
//                              << "amount" << amount
//                              << "total" << total;


                    allOrders.append(FullOrderInfo{type, price, amount, total});

//                    insertBookOrder(type, price, amount, total);
                }
            }
        }

    }

    updateBookModels();

/*    m_sellMaxTotal = 0;
    m_buyMaxTotal = 0;

    for(auto i = 0; i < sellOrderModel.size(); i++)
        if (m_sellMaxTotal < sellOrderModel.at(i).total)
            m_sellMaxTotal = sellOrderModel.at(i).total;

    for(auto i = 0; i < buyOrderModel.size(); i++)
        if (m_buyMaxTotal < buyOrderModel.at(i).total)
            m_buyMaxTotal = buyOrderModel.at(i).total;

//    qDebug() << "m_buyMaxTotal" << m_buyMaxTotal
//             << "m_sellMaxTotal" << m_sellMaxTotal;

    getVariantBookModels();

    sendCurrentBookModels();*/
}

void StockDataWorker::updateAllModels()
{
//    qDebug() << "StockDataWorker::updateAllModels" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    getCandleModel(true);

    getTempAveragedModel(true);

    getAveragedModels(true);

//    qDebug() << "StockDataWorker::updateAllModels" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

void StockDataWorker::getCandleModel(bool update)
{
//    qDebug() << "StockDataWorker::getCandleModel" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

    qint64 timeLength = 0;

    if (!priceModel.isEmpty())
        timeLength = currentTime - priceModel.first().time;

    int length = timeLength / m_candleWidth;
    if (timeLength % m_candleWidth)
        ++length;

//    qDebug() << "timeLength" << timeLength << "length" << length;

    candleModel.resize(length);

    double open = 0;
    double close = 0;
    double min = 0;
    double max = 0;
    qint64 candleBegin = 0;

//    qDebug() << "StockDataWorker::getCandleModel"
//             << "m_candleWidth" << m_candleWidth;

    if (!priceModel.isEmpty())
    {
        candleBegin = priceModel.first().time;
        open = close = min = max = priceModel.first().price;
    }

    int candleIndex = 0;

    int priceIndex = 0;

    if (update)
    {
//        qDebug() << "update" << update
//                 << "m_lastCandleNumber" << m_lastCandleNumber;

        candleIndex = m_lastCandleNumber;

        candleBegin += m_candleWidth*m_lastCandleNumber;

        if (m_lastCandleNumber < candleModel.size())
        {
            open = close = min = max =
                candleModel.at(m_lastCandleNumber).open;
        }

        priceIndex = priceModel.size()-1;

//        qDebug() << "candleIndex" << candleIndex
//                 << "candleBegin" << candleBegin
//                 << "priceModel.size()" << priceModel.size();

        while (!priceModel.isEmpty() && priceIndex > 0 &&
               priceModel.at(priceIndex).time > candleBegin)
        {
            --priceIndex;
//            qDebug() << "priceModel.at(priceIndex).time"
//                     << priceModel.at(priceIndex).time;
        }

        if (priceIndex < 0)
            priceIndex = 0;

        if (!priceModel.isEmpty() && priceModel.at(priceIndex).time < candleBegin)
            ++priceIndex;

//        qDebug() << "END priceIndex" << priceIndex;
    }

    int index = priceIndex;
    qint64 nextTime = 0;

    if (index < priceModel.size()-1)
        nextTime = priceModel.at(index+1).time;
    else
        nextTime = currentTime;

    while (index < priceModel.size())
    {
        double currPrice = priceModel.at(index).price;

//        qDebug() << "nextTime"
//                 << QDateTime::fromMSecsSinceEpoch(nextTime)
//                    .toString("dd HH:mm:ss")
//                 << "candleBegin + m_candleWidth"
//                 << QDateTime::fromMSecsSinceEpoch(candleBegin + m_candleWidth)
//                    .toString("dd HH:mm:ss")
//                 << "currPrice" << currPrice;

        if (nextTime > candleBegin + m_candleWidth ||
            index == priceModel.size()-1)
        {
            if (candleIndex >= candleModel.size())
                candleModel.resize(candleIndex+1);

            close = currPrice;
            if (min > currPrice)
                min = currPrice;
            if (max < currPrice)
                max = currPrice;

            CandleInfo info {candleBegin + m_candleWidth/2,
                            open, close, min, max};

            candleModel[candleIndex] = info;

//            qDebug() << "CandleInfo"
//                     << "priceIndex" << index
//                     << QDateTime::fromMSecsSinceEpoch(priceModel.at(index).time)
//                        .toString("dd HH:mm:ss")
//                     << "currPrice" << currPrice
//                     << "candleIndex" << candleIndex
//                     << QDateTime::fromMSecsSinceEpoch(candleBegin)
//                        .toString("dd HH:mm:ss")
//                     << "open" << open
//                     << "close" << close
//                     << "min" << min
//                     << "max" << max;

            ++candleIndex;

            candleBegin += m_candleWidth;

            open = currPrice;
            close = currPrice;
            min = currPrice;
            max = currPrice;

            if (candleBegin > currentTime)
                break;
        }
        else
        {
            close = currPrice;
            if (min > currPrice)
                min = currPrice;
            if (max < currPrice)
                max = currPrice;

            ++index;

            if (index < priceModel.size()-1)
                nextTime = priceModel.at(index+1).time;
            else
                nextTime = currentTime;
        }

    }

/*    for (auto i = priceIndex; i < priceModel.size(); ++i)
    {
        double currPrice = priceModel.at(i).price;

        close = currPrice;
        if (min > currPrice)
            min = currPrice;
        if (max < currPrice)
            max = currPrice;

        if (priceModel.at(i).time > candleBegin + m_candleWidth ||
            i == priceModel.size()-1)
        {
            if (candleIndex >= candleModel.size())
                candleModel.resize(candleIndex+1);

            CandleInfo info {candleBegin + m_candleWidth/2,
                            open, close, min, max};

            candleModel[candleIndex] = info;

            qDebug() << "CandleInfo info"
                     << "priceIndex" << i
                     << "priceModel.at(i).time" << priceModel.at(i).time
                     << "candleIndex" << candleIndex
                     << "candleBegin" << candleBegin
                     << "open" << open
                     << "close" << close
                     << "min" << min
                     << "max" << max;

            ++candleIndex;

            candleBegin += m_candleWidth;

            open = currPrice;
            close = currPrice;
            min = currPrice;
            max = currPrice;
        }
    }*/

    if (candleIndex < candleModel.size())
        candleModel.resize(candleIndex);

//    qDebug() << "candleModel.size()" << candleModel.size();

    if (m_lastCandleNumber != candleModel.size()-1 &&
        !candleModel.isEmpty())
    {
//        qDebug() << "NEW CANDLE" << candleModel.size()-1;

        qint64 lastTime = candleModel.last().time;
        if (m_rightCandleNumber == m_lastCandleNumber &&
            m_rightTime < lastTime + m_candleWidth*1.1 &&
                m_rightTime > lastTime - m_candleWidth*1.1)
            resetRightTime();

        m_lastCandleNumber = candleModel.size()-1;
    }

//    qDebug() << "StockDataWorker::getCandleModel"
//             << "m_rightTime" << m_rightTime;

//    qDebug() << "StockDataWorker::getCandleModel" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

QVariantMap StockDataWorker::getCandleInfo(int index)
{
    if (index < 0 || index >= candleModel.size())
        return {};
    else
        return candleModel.at(index).getMap();
}

void StockDataWorker::getTempAveragedModel(bool update)
{
    return;

//    qDebug() << "StockDataWorker::getTempAveragedModel" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
    if (priceModel.isEmpty())
    {
        tempAverModel.clear();
        return;
    }

    int averStep = m_candleWidth * minAverageStep;

    qint64 timeLength = 0;

    if (!priceModel.isEmpty())
        timeLength = priceModel.last().time - priceModel.first().time;

    int length = timeLength / averStep;
    if (timeLength % averStep)
        ++length;

    qint64 averBegin = 0;

    if (!priceModel.isEmpty())
        averBegin = priceModel.first().time;
    qint64 averNext = averBegin + averStep;

    int lastAverIndex = tempAverModel.size()-1;

//    qDebug() << "StockDataWorker::getAveragedModel"
//             << "averStep" << averStep
//             << "length" << length;

    int averIndex = 0;

    int counter = 0;
    double summ = 0;

    int priceIndex = 0;

    if (update)
    {
        averIndex = lastAverIndex;

//        averBegin += averIndex * averStep;
        if (averIndex >= 0 && averIndex < tempAverModel.size())
            averBegin = tempAverModel.at(averIndex).time - averStep/2;
        averNext = averBegin + averStep;

        priceIndex = priceModel.size()-1;

//        qDebug() << "StockDataWorker::getTempAveragedModel"
//                 << "averIndex" << averIndex
//                 << "averBegin" << averBegin
//                 << "priceIndex" << priceIndex;

        while (priceIndex > 0 &&
               priceModel.at(priceIndex).time > averBegin)
        {
            --priceIndex;
//            qDebug() << "priceModel.at(priceIndex).time"
//                     << "averBegin" << averBegin
//                     << priceModel.at(priceIndex).time
//                     << "priceIndex" << priceIndex;
        }

        if (priceIndex < 0)
            priceIndex = 0;

        if (priceModel.at(priceIndex).time < averBegin)
            ++priceIndex;

//        qDebug() << "priceIndex END" << priceIndex;
    }

    tempAverModel.resize(length);

    for (auto i = priceIndex; i < priceModel.size(); ++i)
    {
        if (priceModel.at(i).time > averNext ||
            i == priceModel.size()-1)
        {
            if (averIndex >= tempAverModel.size())
                tempAverModel.resize(averIndex+1);

            PriceInfo info;

            info.time = averBegin + averStep/2;

            if (counter == 0)
                info.price = priceModel.at(i).price;
            else
                info.price = summ/counter;

            tempAverModel[averIndex] = info;

//            qDebug() << "StockDataWorker::getTempAveragedModel"
//                     << "averIndex" << averIndex
//                     << "i" << i
//                     << "info.time" << info.time
//                     << "info.price" << info.price
//                     << "counter" << counter
//                     << "summ" << summ;

            counter = 0;
            summ = 0;

            averBegin = averNext;
            averNext = averBegin + averStep;

            ++averIndex;
        }
        else
        {
            ++counter;
            summ += priceModel.at(i).price;
        }
    }

    if (averIndex < tempAverModel.size())
        tempAverModel.resize(averIndex);

//    qDebug() << "StockDataWorker::getAveragedModel"
//             << "tempAverModel.size()" << tempAverModel.size();

//    qDebug() << "StockDataWorker::getTempAveragedModel" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

void StockDataWorker::getAveragedModels(bool update)
{
    return;

//    update = false;

//    qDebug() << "StockDataWorker::getAveragedModels" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    int counter = 0;
    double summ = 0;

    for (auto ch = 0; ch < numberAverageCharts; ++ch)
    {
        averagedModel[ch].resize(tempAverModel.size());

        int tempIndex = 0;

        if (update)
        {
            tempIndex = averagedModel[ch].size() -
                    averageDelta.at(ch) - 2;

            if (tempIndex < 0)
                tempIndex = 0;

//            qDebug() << "tempIndex" << tempIndex;
        }

        for (auto i = tempIndex; i < tempAverModel.size(); ++i)
        {
            counter = 0;
            summ = 0;

            for (auto k = i - averageDelta.at(ch);
                 k <= i + averageDelta.at(ch); ++k)
            {
                if (k < 0)
                    continue;
                if (k >= tempAverModel.size())
                    break;

                ++counter;
                summ += tempAverModel.at(k).price;
            }

            PriceInfo info{tempAverModel.at(i).time, summ/counter};

            averagedModel[ch][i] = info;

    //        qDebug() << "StockDataWorker::getAveragedModel"
    //                 << i
    //                 << "info.time" << info.time
    //                 << "info.price" << info.price
    //                 << "counter" << counter
    //                 << "summ" << summ;
        }
    }

//    qDebug() << "StockDataWorker::getAveragedModels" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

QVariantMap StockDataWorker::getAveragedInfo(int chart, int index)
{
//    qDebug() << "StockDataWorker::getAveragedInfo"
//             << index << averagedModel.size();

    if (chart < 0 || chart >= numberAverageCharts)
        return {};

    if (index < 0 || index >= averagedModel.at(chart).size())
        return {};
    else
        return averagedModel.at(chart).at(index).getMap();
}

int StockDataWorker::getFirstVisibleAverage(int chart)
{
    if (chart < 0 || chart >= numberAverageCharts)
        return 0;
    else
        return firstVisibleAverage.at(chart);
}

int StockDataWorker::getLastVisibleAverage(int chart)
{
    if (chart < 0 || chart >= numberAverageCharts)
        return 0;
    else
        return lastVisibleAverage.at(chart);
}

void StockDataWorker::getMinimumMaximum24h()
{
    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    qint64 timeMinus24h = QDateTime::fromMSecsSinceEpoch
            (currentTime - 3600000*24).toMSecsSinceEpoch();

    if (priceModel.isEmpty())
    {
        m_minimum24h = 0.0;
        m_maximum24h = 0.0;
    }
    else
    {
        m_minimum24h = priceModel.last().price;
        m_maximum24h = priceModel.last().price;

        for (auto i = priceModel.size()-1; i >= 0; --i)
        {
            if (priceModel.at(i).time < timeMinus24h)
                break;

            double currPrice = priceModel.at(i).price;

            if (m_minimum24h > currPrice)
                m_minimum24h = currPrice;
            if (m_maximum24h < currPrice)
                m_maximum24h = currPrice;
        }
    }

    emit minimum24hChanged(m_minimum24h);
    emit maximum24hChanged(m_maximum24h);
}

void StockDataWorker::resetRightTime()
{
    if (!candleModel.isEmpty())
        m_rightTime = candleModel.last().time + m_candleWidth/2;
    else
        m_rightTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
}

void StockDataWorker::setNewCandleWidth(qint64 width)
{
//    qDebug() << "StockDataWorker::setNewCandleWidth" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    setCandleWidth(width);

    setVisibleTime(m_candleWidth * visibleDefaultCandles);

    getCandleModel(false);

    getTempAveragedModel(false);

    getAveragedModels(false);

    resetRightTime();

//    qDebug() << "StockDataWorker::setNewCandleWidth" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

void StockDataWorker::dataAnalysis()
{
//    qDebug() << "StockDataWorker::dataAnalysis" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

//    qDebug() << "StockDataWorker::dataAnalysis"
//             << "m_rightTime" << m_rightTime
//             << "candleModel.first().time" << candleModel.first().time
//             << "candleModel.last().time" << candleModel.last().time
//             << "m_rightTime" << m_rightTime
//             << "m_visibleTime" << m_visibleTime;

    bool reset = true;

    m_maxTime = m_rightTime;

    m_minTime = m_rightTime - m_visibleTime;

    if (!candleModel.isEmpty())
    {
        m_minPrice = candleModel.first().minimum;
        m_maxPrice = candleModel.first().maximum;
        m_beginTime = candleModel.first().time - m_candleWidth/2;
        m_endTime = candleModel.last().time + m_candleWidth/2;

        m_minPriceTime = candleModel.first().time;
        m_maxPriceTime = candleModel.first().time;
    }
    else
    {
        m_minPrice = 0;
        m_maxPrice = 0;
        m_beginTime = m_rightTime;
        m_endTime = m_rightTime;
    }

    m_rightCandleNumber = 0;

    for (auto i = 0; i < candleModel.size(); ++i)
    {
        qint64 currX = candleModel.at(i).time;
        double minimum = candleModel.at(i).minimum;
        double maximum = candleModel.at(i).maximum;

        if (currX + m_candleWidth/2 < m_rightTime - m_visibleTime)
            continue;

        if (currX - m_candleWidth/2 > m_rightTime)
            break;

        m_rightCandleNumber = i;

        if (reset)
        {
            m_minPrice = minimum;
            m_maxPrice = maximum;
            m_minPriceTime = currX;
            m_maxPriceTime = currX;

            reset = false;
        }
        else
        {
            if (m_minPrice > minimum)
            {
                m_minPrice = minimum;
                m_minPriceTime = currX;
            }
            if (m_maxPrice < maximum)
            {
                m_maxPrice = maximum;
                m_maxPriceTime = currX;
            }
        }
    }

    if (m_minTime == m_maxTime)
    {
        m_minTime -= 1;
        m_maxTime += 1;
    }
    if (m_minPrice == m_maxPrice)
    {
        m_minPrice -= 0.00000000000000000001;
        m_maxPrice += 0.00000000000000000001;
    }

    m_firstVisibleCandle = -1;
    m_lastVisibleCandle = 0;

    for (auto i = 0; i < candleModel.size(); ++i)
    {
        qint64 time = candleModel.at(i).time;

        if (time + m_candleWidth*0.5 <
                m_rightTime - m_visibleTime)
            continue;

        if (m_firstVisibleCandle == -1)
            m_firstVisibleCandle = i;

        if (time - m_candleWidth*0.5 >
                m_rightTime)
            break;

        m_lastVisibleCandle = i;
    }

    if (m_firstVisibleCandle < 0)
        m_firstVisibleCandle = 0;

    for (auto ch = 0; ch < numberAverageCharts; ++ch)
    {
        firstVisibleAverage[ch] = 0;
        lastVisibleAverage[ch] = 0;

        for (auto i = 0; i < averagedModel.at(ch).size(); ++i)
        {
            qint64 time = averagedModel.at(ch).at(i).time;

            if (time < m_rightTime - m_visibleTime - m_candleWidth*minAverageStep)
                continue;

            if (firstVisibleAverage.at(ch) == 0)
                firstVisibleAverage[ch] = i;

            if (time > m_rightTime + m_candleWidth*minAverageStep)
                break;

            lastVisibleAverage[ch] = i;
        }
    }

//    qDebug() << "StockDataWorker::dataAnalysis"
//             << "m_minPriceTime" << m_minPriceTime
//             << "m_maxPriceTime" << m_maxPriceTime;

//    qDebug() << "StockDataWorker::dataAnalysis"
//             << "m_firstVisibleAverage" << m_firstVisibleAverage
//             << "m_lastVisibleAverage" << m_lastVisibleAverage;

//    qDebug() << "StockDataWorker::dataAnalysis"
//             << "m_minTime" << m_minTime
//             << "m_maxTime" << m_maxTime;

/*    if (m_maxPrice > m_minPrice)
        m_coefficientPrice = chartHeight/(maxPrice - minPrice)
    if (visibleTime > 0)
        coefficientTime = chartWidth/visibleTime

    getRoundedStepY()

    getRoundedStepTime()*/

//    qDebug() << "StockDataWorker::dataAnalysis" << "END"
    //             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

void StockDataWorker::setNewPrice(const QString &price)
{
    qDebug() << "StockDataWorker::setNewPrice" << price;

    if (priceModel.isEmpty())
    {
        resetPriceData(price.toDouble(), false);
    }
    else
    {
        m_previousTokenPrice = m_currentTokenPrice;
        m_currentTokenPrice = price.toDouble();

        qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
        PriceInfo info{currentTime, m_currentTokenPrice};

        priceModel.append(info);

        emit currentTokenPriceChanged(m_currentTokenPrice);
        emit previousTokenPriceChanged(m_previousTokenPrice);
    }

    getMinimumMaximum24h();

    checkNewBookRoundPower();
}

void StockDataWorker::generateNewPrice()
{
    m_previousTokenPrice = m_currentTokenPrice;
    m_currentTokenPrice +=
        QRandomGenerator::global()->generateDouble()*0.00004 - 0.00002;

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    PriceInfo info{currentTime, m_currentTokenPrice};

    priceModel.append(info);

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit previousTokenPriceChanged(m_previousTokenPrice);

    getMinimumMaximum24h();

    checkNewBookRoundPower();
}

void StockDataWorker::generateNewBookState()
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

//        addOrderInfo(true, price, amount, total);
    }
    else
    {
        int index =
            QRandomGenerator::global()->bounded(buyOrderModel.size());

//        double price = buyOrderModel.at(index).price;
//        double amount = buyOrderModel.at(index).amount +
//            QRandomGenerator::global()->bounded(1, 20);

//        double total = amount * price;

        buyOrderModel[index].amount +=
                QRandomGenerator::global()->bounded(1, 20);
        buyOrderModel[index].total = buyOrderModel.at(index).amount *
                buyOrderModel.at(index).price;

        if (m_buyMaxTotal < buyOrderModel.at(index).total)
            m_buyMaxTotal = buyOrderModel.at(index).total;

//        addOrderInfo(false, price, amount, total);
    }

    getVariantBookModels();

    sendCurrentBookModels();
}

bool StockDataWorker::zoomTime(int step)
{
    double oldVisibleTime = m_visibleTime;

    if (step > 0)
    {
        m_visibleTime *= 1.2;
    }
    else
    {
        m_visibleTime /= 1.2;
    }

    if (m_visibleTime > m_candleWidth * visibleDefaultCandles * maxZoom ||
        m_visibleTime < m_candleWidth * visibleDefaultCandles * minZoom)
    {
        m_visibleTime = oldVisibleTime;

        return false;
    }
    else
    {
        m_rightTime += (m_visibleTime - oldVisibleTime)*0.5;

        emit visibleTimeChanged(m_visibleTime);

        return true;
    }
}

void StockDataWorker::shiftTime(double step)
{
    if (candleModel.isEmpty())
        return;

    m_rightTime -= step;

    if (m_rightTime > m_endTime + m_visibleTime*0.5)
        m_rightTime = m_endTime + m_visibleTime*0.5;

    if (m_rightTime < m_beginTime + m_visibleTime*0.5)
        m_rightTime = m_beginTime + m_visibleTime*0.5;
}

void StockDataWorker::setBookRoundPower(const QString &text)
{
    double value = text.toDouble();

//    qDebug() << "StockDataWorker::setBookRoundPower" << text << value
//             << QString::number(value, 'f', 20);

    double power = 20;
    double test = pow(10, -power);

//    while (QString::number(test, 'f', 20) != QString::number(value, 'f', 20)
//           && power > -20)
    while (test < value
           && power > -20)
    {
        --power;
        test = pow(10, -power);

//        qDebug() << power << test << QString::number(test, 'f', 20);
    }

    m_bookRoundPower = power;

    qDebug() << "StockDataWorker::setBookRoundPower"
             << text << m_bookRoundPower;

    updateBookModels();
//    if (m_bookRoundPower == power)
//        return;

//    m_bookRoundPower = power;
//    emit bookRoundPowerChanged(m_bookRoundPower);
}

void StockDataWorker::setCandleWidth(qint64 width)
{
    if (m_candleWidth == width)
        return;

    m_candleWidth = width;
    emit candleWidthChanged(m_candleWidth);
}

void StockDataWorker::setVisibleTime(double time)
{
    if (m_visibleTime == time)
        return;

    m_visibleTime = time;
    emit visibleTimeChanged(m_visibleTime);
}

void StockDataWorker::setMinimum24h(double min)
{
    if (m_minimum24h == min)
        return;

    m_minimum24h = min;
    emit minimum24hChanged(m_minimum24h);
}

void StockDataWorker::setMaximum24h(double max)
{
    if (m_maximum24h == max)
        return;

    m_maximum24h = max;
    emit maximum24hChanged(m_maximum24h);
}

void StockDataWorker::setLastCandleNumber(int number)
{
    if (m_lastCandleNumber == number)
        return;

    m_lastCandleNumber = number;
    emit lastCandleNumberChanged(m_lastCandleNumber);
}

void StockDataWorker::setRightCandleNumber(int number)
{
    if (m_rightCandleNumber == number)
        return;

    m_rightCandleNumber = number;
    emit rightCandleNumberChanged(m_rightCandleNumber);
}

void StockDataWorker::setCurrentTokenPrice(double price)
{
    if (m_currentTokenPrice == price)
        return;

    m_currentTokenPrice = price;
    emit currentTokenPriceChanged(m_currentTokenPrice);
}

void StockDataWorker::setPreviousTokenPrice(double price)
{
    if (m_previousTokenPrice == price)
        return;

    m_previousTokenPrice = price;
    emit previousTokenPriceChanged(m_previousTokenPrice);
}

void StockDataWorker::checkNewBookRoundPower()
{
    int tempPower = -10;
    double tempMask = pow (10, tempPower);

    while (tempMask < m_currentTokenPrice && tempPower < 77)
    {
        ++tempPower;

        tempMask = pow (10, tempPower);
    }

    if (- tempPower + bookRoundPowerDelta != bookRoundPowerMinimum)
    {
        bookRoundPowerMinimum = - tempPower + bookRoundPowerDelta;

        m_bookRoundPower = bookRoundPowerMinimum;

        emit setNewBookRoundPowerMinimum(bookRoundPowerMinimum);

        updateBookModels();
    }

}

void StockDataWorker::updateBookModels()
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

void StockDataWorker::insertBookOrder(const OrderType& type, double price, double amount, double total)
{
//    qDebug() << "StockDataWorker::insertBookOrder";

//    qDebug() << price << QString::number(price, 'f', bookRoundPower)
//             << QString::number(price, 'f', bookRoundPower).toDouble()
//             << QString("%1").arg(price, 0, 'g', 30);

//    if (sell)
//    {
//        sellOrderModel.append(OrderInfo{price, amount, total});
//    }
//    else
//    {
//        buyOrderModel.append(OrderInfo{price, amount, total});
//    }

//    price = QString::number(price, 'f', m_bookRoundPower).toDouble();
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

/*    if (type == OrderType::sell)
    {
        int index = 0;

        while (index < sellOrderModel.size())
        {
            if (price == sellOrderModel.at(index).price)
            {
                sellOrderModel[index].amount += amount;
                sellOrderModel[index].total = sellOrderModel.at(index).amount *
                        sellOrderModel.at(index).price;

                break;
            }
            else
            {
                if (price < sellOrderModel.at(index).price)
                {
                    sellOrderModel.insert(index, OrderInfo{price, amount, total});
                    break;
                }
            }

            ++index;
        }

        if (index == sellOrderModel.size())
            sellOrderModel.append(OrderInfo{price, amount, total});
    }
    else
    {
        int index = 0;

        while (index < buyOrderModel.size())
        {
            if (price == buyOrderModel.at(index).price)
            {
                buyOrderModel[index].amount += amount;
                buyOrderModel[index].total = buyOrderModel.at(index).amount *
                        buyOrderModel.at(index).price;

                break;
            }
            else
            {
                if (price > buyOrderModel.at(index).price)
                {
                    buyOrderModel.insert(index, OrderInfo{price, amount, total});
                    break;
                }
            }

            ++index;
        }

        if (index == buyOrderModel.size())
            buyOrderModel.append(OrderInfo{price, amount, total});
    }*/

}

void StockDataWorker::getVariantBookModels()
{
/*    sellModel.reserve(sellOrderModel.size());

    for (auto i = 0; i < sellOrderModel.size(); ++i)
        sellModel[i] = QVariant::fromValue(sellOrderModel.at(i));

    buyModel.reserve(buyOrderModel.size());

    for (auto i = 0; i < buyOrderModel.size(); ++i)
        buyModel[i] = QVariant::fromValue(buyOrderModel.at(i));*/

    sellModel.clear();

    for (auto i = 0; i < sellOrderModel.size(); ++i)
        sellModel << QVariant::fromValue(sellOrderModel.at(i));

    buyModel.clear();

    for (auto i = 0; i < buyOrderModel.size(); ++i)
        buyModel << QVariant::fromValue(buyOrderModel.at(i));
}

void StockDataWorker::sendCurrentBookModels()
{
    emit sellMaxTotalChanged(m_sellMaxTotal);
    emit buyMaxTotalChanged(m_buyMaxTotal);

    context->setContextProperty("buyModel", buyModel);
    context->setContextProperty("sellModel", sellModel);
}
