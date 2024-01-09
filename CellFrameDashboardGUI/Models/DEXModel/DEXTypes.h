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
        QString network = "";
        QString amount = "";
        QString amountDatoshi = "";
        QString rate = "";
        QString time = "";
        QString unixTime = "";
        QString filled = "";
        QString status = "";
        QString side = "";
    };

    struct TXList
    {
        QString status = "";
        QString type = "";
    };
}

#endif // DEXTYPES_H
