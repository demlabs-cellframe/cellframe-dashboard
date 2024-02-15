#ifndef CANDLEINFO_H
#define CANDLEINFO_H

#include <QVariantMap>

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

#endif // CANDLEINFO_H
