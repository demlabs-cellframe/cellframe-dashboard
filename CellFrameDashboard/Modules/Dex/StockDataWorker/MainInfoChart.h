#pragma once
#include <QObject>
#include <QSharedPointer>
#include <QString>
#include <QVector>
#include "ChartTypes.h"

struct MainInfoChart: public QObject
{
    Q_OBJECT

public:
    void clear();
    void onInit();
    void moveFrom(MainInfoChart& other);

    MainInfoChart& operator=(const MainInfoChart& other);
    MainInfoChart& operator=(const MainInfoChart&& other);

    QVector<PriceInfo> m_priceModel;
    QVector<CandleInfo> m_candleModel;
    QVector<QVector<PriceInfo>> m_averagedModel;

    QString m_currentTokenPriceText = "0.0";

    double m_currentTokenPrice = 0.0f;
    double m_previousTokenPrice = 0.0f;
    double m_minimum24h = 0.0f;
    double m_maximum24h = 0.0f;

    int m_lastCandleNumber = 0;
    int m_rightCandleNumber = 0;

    int m_commonRoundPower = 8;

    qint64 m_rightTime = 0;
};
