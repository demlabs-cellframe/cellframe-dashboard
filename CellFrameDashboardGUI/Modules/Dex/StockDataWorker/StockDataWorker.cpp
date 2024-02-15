#include "StockDataWorker.h"

#include <QDebug>

StockDataWorker::StockDataWorker(QQmlContext *cont, QObject *parent) :
    QObject(parent),
    context(cont),
    candleChartWorker(new CandleChartWorker(this)),
    orderBookWorker(new OrderBookWorker(cont, this)),
    tokenPairsWorker(new TokenPairsWorker(cont, this))
{
    context->setContextProperty("stockDataWorker", this);

    context->setContextProperty("candleChartWorker", candleChartWorker);

    context->setContextProperty("orderBookWorker", orderBookWorker);

    context->setContextProperty("tokenPairsWorker", tokenPairsWorker);

    connect(candleChartWorker, &CandleChartWorker::checkBookRoundPower,
            orderBookWorker, &OrderBookWorker::checkBookRoundPower);

//    connect(tokenPairsWorker, &TokenPairsWorker::setTokenPair,
//            orderBookWorker, &OrderBookWorker::setTokenPair);
}
