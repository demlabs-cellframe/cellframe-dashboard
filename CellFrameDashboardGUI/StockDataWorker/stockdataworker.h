#ifndef STOCKDATAWORKER_H
#define STOCKDATAWORKER_H

#include <QObject>
#include <QVector>
#include <QVariantMap>

#include "priceinfo.h"
#include "candleinfo.h"

class StockDataWorker : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qint64 candleWidth READ candleWidth WRITE setCandleWidth NOTIFY candleWidthChanged)
    Q_PROPERTY(double visibleTime READ visibleTime WRITE setVisibleTime NOTIFY visibleTimeChanged)
    Q_PROPERTY(qint64 rightTime READ rightTime WRITE setRightTime NOTIFY rightTimeChanged)

    Q_PROPERTY(qint64 minTime READ minTime WRITE setMinTime NOTIFY minTimeChanged)
    Q_PROPERTY(qint64 maxTime READ maxTime WRITE setMaxTime NOTIFY maxTimeChanged)
    Q_PROPERTY(double minPrice READ minPrice WRITE setMinPrice NOTIFY minPriceChanged)
    Q_PROPERTY(double maxPrice READ maxPrice WRITE setMaxPrice NOTIFY maxPriceChanged)

    Q_PROPERTY(qint64 beginTime READ beginTime WRITE setBeginTime NOTIFY beginTimeChanged)
    Q_PROPERTY(qint64 endTime READ endTime WRITE setEndTime NOTIFY endTimeChanged)

    Q_PROPERTY(double minimum24h READ minimum24h WRITE setMinimum24h NOTIFY minimum24hChanged)
    Q_PROPERTY(double maximum24h READ maximum24h WRITE setMaximum24h NOTIFY maximum24hChanged)

    Q_PROPERTY(int lastCandleNumber READ lastCandleNumber WRITE setLastCandleNumber NOTIFY lastCandleNumberChanged)
    Q_PROPERTY(int rightCandleNumber READ rightCandleNumber WRITE setRightCandleNumber NOTIFY rightCandleNumberChanged)

    Q_PROPERTY(double currentTokenPrice READ currentTokenPrice WRITE setCurrentTokenPrice NOTIFY currentTokenPriceChanged)
    Q_PROPERTY(double previousTokenPrice READ previousTokenPrice WRITE setPreviousTokenPrice NOTIFY previousTokenPriceChanged)

    Q_PROPERTY(int firstVisibleCandle READ firstVisibleCandle)
    Q_PROPERTY(int lastVisibleCandle READ lastVisibleCandle)

//    Q_PROPERTY(double coefficientTime READ coefficientTime WRITE setCoefficientTime NOTIFY coefficientTimeChanged)
//    Q_PROPERTY(double coefficientPrice READ coefficientPrice WRITE setCoefficientPrice NOTIFY coefficientPriceChanged)

public:
    explicit StockDataWorker(QObject *parent = nullptr);

    Q_INVOKABLE void generatePriceData(int length);

    Q_INVOKABLE QVariantMap getPriceInfo(int index);

    Q_INVOKABLE void getCandleModel();

    Q_INVOKABLE QVariantMap getCandleInfo(int index);

    Q_INVOKABLE void getMinimumMaximum24h();

    Q_INVOKABLE void resetRightTime();

    Q_INVOKABLE void setNewCandleWidth(qint64 width);

    Q_INVOKABLE void dataAnalysis();

    Q_INVOKABLE void generateNewPrice();

    Q_INVOKABLE bool zoomTime(int step);

    Q_INVOKABLE void shiftTime(double step);

    qint64 candleWidth() const
        {  return m_candleWidth; }
    double visibleTime() const
        {  return m_visibleTime; }
    qint64 rightTime() const
        { return m_rightTime; }

    qint64 minTime() const
        { return m_minTime; }
    qint64 maxTime() const
        { return m_maxTime; }
    double minPrice() const
        { return m_minPrice; }
    double maxPrice() const
        { return m_maxPrice; }

    qint64 beginTime() const
        { return m_beginTime; }
    qint64 endTime() const
        { return m_endTime; }

    double minimum24h() const
        { return m_minimum24h; }
    double maximum24h() const
        { return m_maximum24h; }

    int lastCandleNumber() const
        { return m_lastCandleNumber; }
    int rightCandleNumber() const
        { return m_rightCandleNumber; }

    double currentTokenPrice() const
        { return m_currentTokenPrice; }
    double previousTokenPrice() const
        { return m_previousTokenPrice; }

    int firstVisibleCandle() const
        { return m_firstVisibleCandle; }
    int lastVisibleCandle() const
        { return m_lastVisibleCandle; }

//    double coefficientTime() const
//        { return m_coefficientTime; }
//    double coefficientPrice() const
//        { return m_coefficientPrice; }

public slots:
    void setCandleWidth(qint64 width);
    void setVisibleTime(double time);
    void setRightTime(qint64 time);

    void setMinTime(qint64 time);
    void setMaxTime(qint64 time);
    void setMinPrice(double price);
    void setMaxPrice(double price);

    void setBeginTime(qint64 time);
    void setEndTime(qint64 time);

    void setMinimum24h(double min);
    void setMaximum24h(double max);

    void setLastCandleNumber(int number);
    void setRightCandleNumber(int number);

    void setCurrentTokenPrice(double price);
    void setPreviousTokenPrice(double price);

//    void setCoefficientTime(double coeff);
//    void setCoefficientPrice(double coeff);

signals:
    void candleWidthChanged(qint64 width);
    void visibleTimeChanged(double time);
    void rightTimeChanged(qint64 time);

    void minTimeChanged(double time);
    void maxTimeChanged(double time);
    void minPriceChanged(double price);
    void maxPriceChanged(double price);

    void beginTimeChanged(double time);
    void endTimeChanged(double time);

    void minimum24hChanged(double min);
    void maximum24hChanged(double min);

    void lastCandleNumberChanged(int number);
    void rightCandleNumberChanged(int number);

    void currentTokenPriceChanged(double price);
    void previousTokenPriceChanged(double price);

//    void coefficientTimeChanged(double coeff);
//    void coefficientPriceChanged(double coeff);

private:
    QVector <PriceInfo> priceModel;
    QVector <CandleInfo> candleModel;

    qint64 m_candleWidth {1000};
    double m_visibleTime {1000000};
    qint64 m_rightTime {0};

    qint64 m_minTime {0};
    qint64 m_maxTime {0};
    double m_minPrice {0.0};
    double m_maxPrice {0.0};

    qint64 m_beginTime {0};
    qint64 m_endTime {0};

    double m_minimum24h {0.0};
    double m_maximum24h {0.0};

    int m_lastCandleNumber {0};
    int m_rightCandleNumber {0};

    double m_currentTokenPrice {0.0};
    double m_previousTokenPrice {0.0};

    int m_firstVisibleCandle {0};
    int m_lastVisibleCandle {0};

//    double m_coefficientTime {0.0};
//    double m_coefficientPrice {0.0};
};

#endif // STOCKDATAWORKER_H
