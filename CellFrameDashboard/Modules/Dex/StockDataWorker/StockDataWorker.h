#ifndef STOCKDATAWORKER_H
#define STOCKDATAWORKER_H

#include <QObject>
#include <QQmlContext>

#include "CandleChartWorker.h"
#include "OrderBookWorker.h"
#include "TokenPairsWorker.h"

class StockDataWorker : public QObject
{
    Q_OBJECT

public:
    explicit StockDataWorker(QQmlContext *cont, QObject *parent = nullptr);

    CandleChartWorker* getCandleChartWorker() const {return candleChartWorker; }
    OrderBookWorker* getOrderBookWorker() const { return orderBookWorker; }

public slots:
    // void signalXchangeOrderListReceived(const QVariant& rcvData);

//    void rcvXchangeTokenPriceHistory(const QVariant& rcvData);

//    void signalXchangeTokenPairReceived(const QVariant& rcvData);

private:

    QQmlContext *context;

    CandleChartWorker *candleChartWorker;
    OrderBookWorker *orderBookWorker;
    TokenPairsWorker *tokenPairsWorker;
};

#endif // STOCKDATAWORKER_H
