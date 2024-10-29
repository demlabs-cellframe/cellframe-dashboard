#ifndef CREATECANDLECHART_H
#define CREATECANDLECHART_H

#include <QObject>
#include <QJsonArray>
#include <QJsonObject>
#include "ChartTypes.h"
#include <QSharedPointer>
#include <QWeakPointer>
#include <QDateTime>


class CreateCandleChart : public QObject
{
    Q_OBJECT
public:
    explicit CreateCandleChart(QObject *parent, QWeakPointer<QVector<PriceInfo>> priceModel, QWeakPointer<QVector<CandleInfo>> candleModel, QWeakPointer<QVector<QVector<PriceInfo>>> averagedModel);
    ~CreateCandleChart();

    void setChartProperty(const ChartProperty& chartInfo) { m_chartInfo = chartInfo; }

//    void setPriceModel(QVector<PriceInfo>* model) { m_priceModel = model; }
//    void setCandleModel(QVector <CandleInfo>* model) { m_candleModel = model; }
//    void setAveragedModel(QVector<QVector<PriceInfo>>* model) { m_averagedModel = model; }

    void setCommonRoundPowerDelta(int delta) { m_commonRoundPowerDelta = delta;}
    void setAverageDelta(QVector<int>* deltaCont) { m_averageDelta = deltaCont; }
    void setMemderAverageCharts(int charts) { m_memderAverageCharts = charts; }
    void setNewPriceInfo(const PriceInfo& newPrice) { m_newPrice = newPrice; }
    void setTypeProcess(TypeProcessing type) { m_type = type; }
    void setCurrentDelta(int delta) { m_currentDelta = delta; }
    void setIndexAveragedModel(int index) { m_indexAveragedModel = index; }
    void setMinAverageStep(const double step) {m_minAverageStep = step;}
    void setNewPriceText(const QString& price) { m_newPriceText = price; }
    void setIndexes(int from, int to) { m_indexFrom = from; m_indexTo = to;}
    void setAveragedKey(bool key) { m_averagedKey = key; }

    void setFirstVisibleAverage(QVector<int>* value){m_firstVisibleAverage = value;}
    void setLastVisibleAverage(QVector<int>* value){m_lastVisibleAverage = value;}
    void setLimitIndexesModel(const int limit) { m_limitIndexesModel = limit; }
    void setRightTime(qint64 time) { m_rightTime = time; }
public slots:

    void createModels();

    void tryCreateCandleModel();
    void createAveragedModel();
    void createMinimumMaximum24h();
    void checkNewRoundPower();

signals:
    void previousTokenPriceChanged(double value);
    void currentTokenPriceChanged(double value);
    void currentTokenPriceTextChanged(const QString& value);
    void lastCandleNumberChanged(int value);

    void commonRoundPowerChanged(int power);
    void checkBookRoundPower();
    void resetRightTimeSignal();

//    void candleModelChanged(QSharedPointer<QVector <CandleInfo>> candleModel);
//    void averagedModelChanged(QSharedPointer<QVector <QVector <PriceInfo>>> models);
//    void priceModelChanged(QSharedPointer<QVector <PriceInfo>> priceModel);

    void newRateAdded(const PriceInfo& info);

    void minimum24hChanged(double min);
    void maximum24hChanged(double max);

    // ANALISIS
    void minTimeChanged(qint64 time);
    void maxTimeChanged(qint64 time);
    void minPriceTimeChanged(qint64 time);
    void maxPriceTimeChanged(qint64 time);
    void beginTimeChanged(qint64 time);
    void endTimeChanged(qint64 time);

    void minPriceChanged(double price);
    void maxPriceChanged(double price);

    void rightCandleNumberChanged(int value);
    void firstVisibleCandleChanged(int value);
    void lastVisibleCandleChanged(int value);
    // __ANALISIS

    void finished();
private:
    void createCandleModel(bool key);

    

private:
    int m_indexFrom = 0;
    int m_indexTo = 0;

    QVector<int>* m_averageDelta = nullptr;
    int m_commonRoundPowerDelta = 9;
    int m_memderAverageCharts = 3;

    QWeakPointer<QVector<PriceInfo>> m_priceModel;
    QWeakPointer<QVector<CandleInfo>> m_candleModel;
    QWeakPointer<QVector<QVector<PriceInfo>>> m_averagedModel;

    QVector <int>* m_firstVisibleAverage = nullptr;
    QVector <int>* m_lastVisibleAverage = nullptr;

    int m_indexAveragedModel = 0;
    int m_currentDelta = 1;
    bool m_averagedKey = false;

    ChartProperty m_chartInfo;

    QString m_newPriceText = "";
    PriceInfo m_newPrice;
    TypeProcessing m_type = TypeProcessing::NONE;

    double m_minAverageStep = 0.5f;

    qint64 m_rightTime = 0;
    int m_limitIndexesModel = 3000;
};

#endif // CREATECANDLECHART_H
