#ifndef CANDLECHARTWORKER_H
#define CANDLECHARTWORKER_H

#include <QObject>
#include <QVector>
#include <QVariantMap>
#include <QThread>

#include <QSharedPointer>
#include <QWeakPointer>

#include "CreatingSheduleController.h"
#include "ChartTypes.h"
#include "MainInfoChart.h"

 Q_DECLARE_METATYPE(QSharedPointer<QVector<PriceInfo>>)
 Q_DECLARE_METATYPE(QSharedPointer<QVector<CandleInfo>>)
 Q_DECLARE_METATYPE(QSharedPointer<QVector<QVector<PriceInfo>>>)

class CandleChartWorker : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qint64 candleWidth READ candleWidth WRITE setCandleWidth NOTIFY candleWidthChanged)
    Q_PROPERTY(double visibleTime READ visibleTime WRITE setVisibleTime NOTIFY visibleTimeChanged)
    Q_PROPERTY(qint64 rightTime READ rightTime NOTIFY chartInfoChanged)

    Q_PROPERTY(qint64 minTime READ minTime NOTIFY analisisCompleted)
    Q_PROPERTY(qint64 maxTime READ maxTime NOTIFY analisisCompleted)
    Q_PROPERTY(double minPrice READ minPrice NOTIFY analisisCompleted)
    Q_PROPERTY(double maxPrice READ maxPrice NOTIFY analisisCompleted)

    Q_PROPERTY(qint64 minPriceTime READ minPriceTime NOTIFY analisisCompleted)
    Q_PROPERTY(qint64 maxPriceTime READ maxPriceTime NOTIFY analisisCompleted)

    Q_PROPERTY(qint64 beginTime READ beginTime NOTIFY analisisCompleted)
    Q_PROPERTY(qint64 endTime READ endTime NOTIFY analisisCompleted)

    Q_PROPERTY(double minimum24h READ minimum24h NOTIFY minimum24hChanged)
    Q_PROPERTY(double maximum24h READ maximum24h NOTIFY maximum24hChanged)

    Q_PROPERTY(int lastCandleNumber READ lastCandleNumber NOTIFY lastCandleNumberChanged)
    Q_PROPERTY(int rightCandleNumber READ rightCandleNumber NOTIFY rightCandleNumberChanged)

    Q_PROPERTY(double currentTokenPrice READ currentTokenPrice NOTIFY currentTokenPriceChanged)
    Q_PROPERTY(double previousTokenPrice READ previousTokenPrice NOTIFY previousTokenPriceChanged)
    Q_PROPERTY(QString currentTokenPriceText READ currentTokenPriceText NOTIFY currentTokenPriceTextChanged)

    Q_PROPERTY(int firstVisibleCandle READ firstVisibleCandle NOTIFY chartInfoChanged)
    Q_PROPERTY(int lastVisibleCandle READ lastVisibleCandle NOTIFY chartInfoChanged)

    Q_PROPERTY(int priceModelSize READ priceModelSize NOTIFY chartInfoChanged)

    Q_PROPERTY(int commonRoundPower READ commonRoundPower NOTIFY commonRoundPowerChanged)

    enum StateProcess
    {
        NONE = 0,
        PROCESSING
    };

    enum TypeRequest
    {
        HISTORY_REQUEST = 0,
        NEW_PRICE_REQUEST,
        RESET_REQUEST,
        UPDATE_REQUEST
    };

public:
    explicit CandleChartWorker(QObject *parent = nullptr);
    ~CandleChartWorker();
    Q_INVOKABLE void resetPriceData(double price, const QString &priceText, bool init);
    Q_INVOKABLE QVariantMap getPriceInfo(int index);
    Q_INVOKABLE QVariantMap getCandleInfo(int index);
    Q_INVOKABLE QVariantMap getAveragedInfo(int chart, int index);
    Q_INVOKABLE int getFirstVisibleAverage(int chart);
    Q_INVOKABLE int getLastVisibleAverage(int chart);
    Q_INVOKABLE void setNewCandleWidth(qint64 width);
    Q_INVOKABLE bool zoomTime(int step);
    Q_INVOKABLE void shiftTime(double step);
    Q_INVOKABLE void dataAnalysis();

    bool isProcessing() { return m_isProcessing; }
    void setProcessStatus(bool status) { m_isProcessing = status; }

    bool isPainting() { return m_isPainting; }
    Q_INVOKABLE bool setPaintingStatus(bool status);

    void respondTokenPairsHistory(const QJsonArray &history);
    void respondCurrentTokenPairs(const QList<QPair<QString,QString>> &rateList);

    Q_INVOKABLE void updateAllModels();

    qint64 candleWidth() const { return m_candleWidth; }
    double visibleTime() const { return m_visibleTime; }
    qint64 rightTime() const { return m_infoChart.m_rightTime; }

    qint64 minTime() const { return m_minTime; }
    qint64 maxTime() const { return m_maxTime; }
    double minPrice() const { return m_minPrice; }
    double maxPrice() const { return m_maxPrice; }

    qint64 minPriceTime() const { return m_minPriceTime; }
    qint64 maxPriceTime() const { return m_maxPriceTime; }

    qint64 beginTime() const { return m_beginTime; }
    qint64 endTime() const { return m_endTime; }

    double minimum24h() const { return m_infoChart.m_minimum24h; }
    double maximum24h() const { return m_infoChart.m_maximum24h; }

    int lastCandleNumber() const { return m_infoChart.m_lastCandleNumber; }
    int rightCandleNumber() const { return m_infoChart.m_rightCandleNumber; }

    double currentTokenPrice() const { return m_infoChart.m_currentTokenPrice; }
    
    double previousTokenPrice() const { return m_infoChart.m_previousTokenPrice; }
    
    QString currentTokenPriceText() const { return m_infoChart.m_currentTokenPriceText; }

    int firstVisibleCandle() const { return m_firstVisibleCandle; }
    int lastVisibleCandle() const { return m_lastVisibleCandle; }

    int priceModelSize() const { return m_infoChart.m_priceModel.size(); }

    int commonRoundPower() const { return m_infoChart.m_commonRoundPower; }

private:
    void addRequest(TypeRequest type, const QVariant& params);
    void tryStartRequestFromQueued();
    bool isQueued();

public slots:
    void setCandleWidth(qint64 width);
    void setVisibleTime(double time);

private slots:
    void setRightTime(qint64 number);
    
    void threadFinished(TypeProcessing type, const MainInfoChart& info);
//    void resetRightTime();
signals:
    void candleWidthChanged(qint64 width);
    void visibleTimeChanged(double time);

    void minimum24hChanged(double min);
    void maximum24hChanged(double min);

    void lastCandleNumberChanged(int number);
    void rightCandleNumberChanged(int number);

    void currentTokenPriceChanged(double price);
    void previousTokenPriceChanged(double price);
    void currentTokenPriceTextChanged(QString price);

    void commonRoundPowerChanged(int power);

    void checkBookRoundPower(double currentTokenPrice);

    void priceModelChanged();
    void candleModelChanged();
    void averagedModelChanged();

    void startProcess();

    void chartInfoChanged();
    void analisisCompleted();
private:
    ChartProperty getChartProperty() const;
    void initThreadController(CreatingSheduleController* controller);

    void setNewData();
private:
    MainInfoChart m_infoChart;
    QPair<bool, MainInfoChart> m_tmpInfoChart;

    QHash<TypeRequest, QList<QVariant>> m_queuedRequest = {{TypeRequest::HISTORY_REQUEST, {}}
                                                          ,{TypeRequest::NEW_PRICE_REQUEST, {}}
                                                          ,{TypeRequest::RESET_REQUEST, {}}
                                                          ,{TypeRequest::UPDATE_REQUEST, {}}};

    QVector <int> m_averageDelta;

    qint64 m_candleWidth = 60000;
    qint64 m_visibleTime = 1000000;

    bool m_isProcessing = false;
    bool m_isUpdate = false;
    bool m_isPainting = false;

    int m_countStepsToEnd = 0;

    double m_minPrice = 0.0f;
    double m_maxPrice = 0.0f;
    int m_firstVisibleCandle = 0;
    int m_lastVisibleCandle = 0;
    qint64 m_minTime = 0;
    qint64 m_maxTime = 0;
    qint64 m_minPriceTime = 0;
    qint64 m_maxPriceTime = 0;
    qint64 m_beginTime = 0;
    qint64 m_endTime = 0;

    QVector <int> firstVisibleAverage;
    QVector <int> lastVisibleAverage;

    StateProcess m_stateProcess = StateProcess::NONE;

    const int NUMBER_AVERAGE_CHARTS = 3;
    const int COMMON_ROUND_POWER_DELTA = 9;
    const int LIMIT_INDEXES_MODEL = 3000;
    const double MIN_AVERAGE_STEP = 0.5f;
};
#endif // CANDLECHARTWORKER_H
