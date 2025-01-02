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

//void StockDataWorker::signalXchangeOrderListReceived(const QVariant &rcvData)
//{
////    qDebug() << "StockDataWorker::signalXchangeOrderListReceived"
////             << rcvData << rcvData.typeName();
////    if (strncmp(rcvData.typeName(), "QByteArray", 10) == 0)
//    if(rcvData.toString() != "")
//        orderBookWorker->setBookModel(rcvData.toByteArray());
//}

//void StockDataWorker::rcvXchangeTokenPriceHistory(const QVariant &rcvData)
//{
////    qDebug() << "StockDataWorker::rcvXchangeTokenPriceHistory"
////             << rcvData << rcvData.typeName();
////    if (strncmp(rcvData.typeName(), "QByteArray", 10) == 0)
////        if(rcvData.toString() != "")
//        //candleChartWorker->setTokenPriceHistory(rcvData.toByteArray());
//}

//void StockDataWorker::signalXchangeTokenPairReceived(const QVariant &rcvData)
//{
////    qDebug() << "StockDataWorker::signalXchangeTokenPairReceived"
////             << rcvData << rcvData.typeName()
////             <<strncmp(rcvData.typeName(), "QByteArray", 10);
////    if (strncmp(rcvData.toByteArray(), "QByteArray", 10) == 0)
//    if(rcvData.toString() != "isEqual")
//        tokenPairsWorker->setPairModel(rcvData.toByteArray());
//}
