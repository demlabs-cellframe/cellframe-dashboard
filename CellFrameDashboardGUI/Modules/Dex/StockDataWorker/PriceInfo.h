#ifndef PRICEINFO_H
#define PRICEINFO_H

#include <QVariantMap>
#include <QString>

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

#endif // PRICEINFO_H
