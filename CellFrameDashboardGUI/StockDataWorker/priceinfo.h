#ifndef PRICEINFO_H
#define PRICEINFO_H

#include <QVariantMap>

struct PriceInfo
{
    inline QVariantMap getMap() const
    {
        return { {"price", price}, {"time", time} };
    }

    qint64 time;
    double price;
};

#endif // PRICEINFO_H
