#ifndef CHARTTYPES_H
#define CHARTTYPES_H

#include <QVariantMap>
#include <QGuiApplication>
#include <QString>
#include "../DapTypes/DapCoin.h"

struct CandleInfo
{
    inline QVariantMap getMap() const
    {
        return { {"time", time},
                {"open", open},
                {"close", close},
                {"minimum", minimum},
                {"maximum", maximum},
                {"average", average} };
    }

    qint64 time;
    double open;
    double close;
    double minimum;
    double maximum;
    double average;
};
Q_DECLARE_METATYPE(CandleInfo)

struct ChartProperty
{
    ChartProperty() = default;
    ChartProperty(qint64 candleWidth, qint64 rightTime, int lastCandleNumber,
                  int rightCandleNumber, int commonRoundPower, double currentTokenPrice, qint64 visibleTime)
        : candleWidth(candleWidth)
        , rightTime(rightTime)
        , lastCandleNumber(lastCandleNumber)
        , rightCandleNumber(rightCandleNumber)
        , commonRoundPower(commonRoundPower)
        , currentTokenPrice(currentTokenPrice)
        , visibleTime(visibleTime)
    {}

    qint64 candleWidth {60000};
    qint64 rightTime {0};
    int lastCandleNumber {0};
    int rightCandleNumber {0};
    int commonRoundPower {8};
    double currentTokenPrice {0.0};
    qint64 visibleTime {1000000};
};

struct OrderInfo
{
    Q_GADGET
    Q_PROPERTY(QString price MEMBER price)
    Q_PROPERTY(QString amount MEMBER amount)
    Q_PROPERTY(QString total MEMBER total)
    Q_PROPERTY(double filled MEMBER filled)
public:
    QString price;
    QString amount;
    QString total;
    double filled;

    Dap::Coin rateCoin;
    Dap::Coin amountCoin;
    Dap::Coin totalCoin;

    OrderInfo(QString price = "0.0",
              QString amount = "0.0",
              QString total = "0.0")
        : price(price)
        , amount(amount)
        , total(total)
    {}
};
Q_DECLARE_METATYPE(OrderInfo)

enum class OrderType
{
    sell, buy
};

struct FullOrderInfo
{
    OrderType type;
    Dap::Coin rateCoin;
    Dap::Coin amountCoin;
    Dap::Coin totalCoin;
    QString price = "";
    QString amount = "";
    QString total = "";
};

struct PriceInfo
{
    inline QVariantMap getMap() const
    {
        return { {"price", price}, {"time", time} };
    }

    qint64 time;
    double price;
    QString priceText;
};
Q_DECLARE_METATYPE(PriceInfo)

enum TypeProcessing
{
    NEW_HISTORY = 0,
    NEW_PRICE,
    RESET_UPDATE,
    UPDATE_MODEL,
    ANALISE,
    NONE
};

#endif // CHARTTYPES_H
