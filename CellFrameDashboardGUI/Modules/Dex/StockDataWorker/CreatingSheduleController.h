#ifndef CREATINGSHEDULECONTROLLER_H
#define CREATINGSHEDULECONTROLLER_H

#include <QObject>
#include <QJsonArray>
#include <QThread>
#include <QMap>
#include <QVector>
#include <QSharedPointer>
#include <QWeakPointer>
#include "CreateCandleChart.h"
#include "ChartTypes.h"
#include "MainInfoChart.h"


class CreatingSheduleController : public QObject
{
    Q_OBJECT

    enum ThreadsType
    {
        PRICE,
        CANDLE,
        AVERAGE,
        ROUND_POWER,
        MIN_MAX,
        ANALISE
    };

public:
    explicit CreatingSheduleController(QObject *parent = nullptr);
    ~CreatingSheduleController();
    void setHistoryArray(const QJsonArray &history) { m_historyArray = history; }
    TypeProcessing getTypeProcessing() {return m_type; }
    void setTypeProcess(TypeProcessing type) { m_type = type; }
    void setChartProperty(const ChartProperty& chartInfo) { m_chartInfo = chartInfo; }
    void setMemderAverageCharts(int charts);

    void setPriceModel(QVector<PriceInfo>* model) {m_priceModel = QSharedPointer<QVector<PriceInfo>>(model);}

    void setAverageDelta(QVector<int>* deltaCont) { m_averageDelta = deltaCont; }
    void setCommonRoundPowerDelta(int delta) { m_commonRoundPowerDelta = delta;}

    void setMinAverageStep(const double step) {m_minAverageStep = step;}
    void setFirstVisibleAverage(QVector<int>* value){m_firstVisibleAverage = value;}
    void setLastVisibleAverage(QVector<int>* value){m_lastVisibleAverage = value;}

    void setCurrentTokenPrice(const double value) { m_currentTokenPrice = value; }
    void setPreviousTokenPrice(const double value) { m_previousTokenPrice = value; }
    void setCurrentTokenPriceText(const QString& value) {m_currentTokenPriceText = value; }
    void setAnalisisRequestFrom(const QString& value) {m_analisisRequestFrom = value; }
    void setLimitIndexesModel(const int limit) { m_limitIndexesModel = limit; }
public slots:
    void startProcess();
signals:
    void previousTokenPriceChanged(double value);
    void currentTokenPriceChanged(double value);
    void currentTokenPriceTextChanged(const QString& value);
    void lastCandleNumberChanged(int value);
    void rightTimeChanged(const qint64 value);

    void commonRoundPowerChanged(int power);
    void checkBookRoundPower(double currentTokenPrice);

    void resetRightTimeSignal();

    void candleModelChanged(QSharedPointer<QVector <CandleInfo>> candleModel);
    void averagedModelChanged(QSharedPointer<QVector <QVector <PriceInfo>>> models);
    void priceModelChanged(QSharedPointer<QVector <PriceInfo>> priceModel);

    void newRateAdded(const PriceInfo& info);

    void minimum24hChanged(double min);
    void maximum24hChanged(double min);

    void finished(TypeProcessing, const MainInfoChart&);

private:
    void LastDataPrepaeration();

    void startHistoryUpdate();
    void addNewPrice();
    void startResetUpdate();

    void creatPriceModel();
    void creatHistory();
    void creatHistoryThread();
    void createAveragedModels();
    void createMinimumMaximum24hThread();
    void checkNewRoundPowerThread();

    void resetRightTime();

    void initThread(CreateCandleChart* chartCounting);

private slots:

    void candleModelCreated();
    void addCountAveragedModel();

    void finalActions(ThreadsType type);
private:
    QJsonArray m_historyArray;

    QSharedPointer<QVector<PriceInfo>> m_priceModel = nullptr;
    QSharedPointer<QVector<CandleInfo>> m_candleModel = nullptr;
    QSharedPointer<QVector<QVector <PriceInfo>>> m_averagedModel = nullptr;

    QVector <int>* m_averageDelta = nullptr;

    QVector <int>* m_firstVisibleAverage = nullptr;
    QVector <int>* m_lastVisibleAverage = nullptr;

    QMap<ThreadsType, bool> m_levelProcess = {{ThreadsType::AVERAGE,false}
                                             ,{ThreadsType::CANDLE,false}
                                             ,{ThreadsType::PRICE,false}
                                             ,{ThreadsType::ROUND_POWER,false}
                                             ,{ThreadsType::MIN_MAX,false}};

    QString m_analisisRequestFrom = "";
    ChartProperty m_chartInfo;

    double m_currentTokenPrice;
    double m_previousTokenPrice;
    QString m_currentTokenPriceText;

    double m_minimum24h = 0.0f;
    double m_maximum24h = 0.0f;

    double m_minAverageStep = 0.5f;

    qint64 m_rightTime = 0;

    int m_lastCandleNumber = 0;
    int m_rightCandleNumber = 0;

    int m_maxCountThread = 4;
    int m_minModelSize = 5000;

    int m_countAveragedModel = 0;
    int m_memderAverageCharts = 3;

    int m_commonRoundPowerDelta = 9;

    int m_commonRoundPower = 8;

//    qint64 m_minTime {0};
//    qint64 m_maxTime {0};
//    double m_minPrice {0.0};
//    double m_maxPrice {0.0};

//    qint64 m_minPriceTime {0};
//    qint64 m_maxPriceTime {0};

//    qint64 m_beginTime {0};
//    qint64 m_endTime {0};

    int m_firstVisibleCandle {0};
    int m_lastVisibleCandle {0};

    int counter = 0;

    int m_limitIndexesModel = 3000;

    TypeProcessing m_type = TypeProcessing::NONE;
};

#endif // CREATINGSHEDULECONTROLLER_H
