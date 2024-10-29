#ifndef DEXTYPES_H
#define DEXTYPES_H

#include <QtQml>
#include <QString>

namespace DEX
{
    enum class TypeSide
    {
        SELL = 0,
        BUY,
        BOTH
    };

    enum class AffilationOrder
    {
        ALL = 0,
        MY_ORDERS,
        OTHER_ORDERS
    };

    struct InfoTokenPairLight
    {
        QString rate = "";
        QString token = "";
        QString type = "";
        QString displayText = "";
    };

    struct InfoTokenPair
    {
        QString change = "";
        QString network = "";
        QString rate = "";
        QString token1 = "";
        QString token2 = "";
        QString displayText = "";
        double rate_double = 0.0f;
    };

    struct Order
    {
        QString hash = "";
        QString sellToken = "";
        QString buyToken = "";
        QString sellTokenOrigin = "";
        QString buyTokenOrigin = "";
        QString network = "";
        QString amount = "";
        QString amountDatoshi = "";
        QString rate = "";
        QString rateOrigin = "";
        QString time = "";
        QString unixTime = "";
        QString filled = "";
        QString status = "";
        QString side = "";
        QString adaptiveSide = "";
        QString adaptivePair = "";
    };

    struct TXList
    {
        QString status = "";
        QString type = "";
    };
}

#endif // DEXTYPES_H
