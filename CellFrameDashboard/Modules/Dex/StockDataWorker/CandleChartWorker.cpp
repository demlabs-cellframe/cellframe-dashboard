#include "CandleChartWorker.h"

#include <QDateTime>
#include <QRandomGenerator>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include "Workers/mathworker.h"
#include <cmath>

constexpr double visibleDefaultCandles {40};
constexpr double maxZoom{3.0};
constexpr double minZoom{0.2};

CandleChartWorker::CandleChartWorker(QObject *parent)
    : QObject(parent)
{
    qRegisterMetaType<QSharedPointer<QVector<PriceInfo>>>();
    qRegisterMetaType<QSharedPointer<QVector<CandleInfo>>>();
    qRegisterMetaType<QSharedPointer<QVector<QVector<PriceInfo>>>>();

    m_infoChart.onInit();

    for (auto i = 0; i < NUMBER_AVERAGE_CHARTS; ++i)
    {
        QVector <PriceInfo> vector;
        m_infoChart.m_averagedModel.append(vector);

        firstVisibleAverage.append(0);
        lastVisibleAverage.append(0);
        switch (i)
        {
        case 0:
            m_averageDelta.append(5);
            break;
        case 1:
            m_averageDelta.append(15);
            break;
        case 2:
            m_averageDelta.append(45);
            break;
        default:
            m_averageDelta.append(1);
        }
    }
}

CandleChartWorker::~CandleChartWorker()
{
}

void CandleChartWorker::initThreadController(CreatingSheduleController* controller)
{
    connect(controller, &CreatingSheduleController::rightTimeChanged,  this, &CandleChartWorker::setRightTime);
    
    QThread *thread = new QThread;

    controller->moveToThread(thread);

    connect(thread, &QThread::started, controller, &CreatingSheduleController::startProcess);

    connect(controller, &CreatingSheduleController::finished, [this, thread, controller] (TypeProcessing type, const MainInfoChart& info){
        threadFinished(type, info);
        thread->quit();
    });

    thread->start();
    setProcessStatus(true);
}

void CandleChartWorker::updateAllModels()
{
    if(isProcessing())
    {
        addRequest(TypeRequest::UPDATE_REQUEST, QVariant());
        return;
    }

    CreatingSheduleController* controller = new CreatingSheduleController();

    controller->setChartProperty(getChartProperty());
    controller->setTypeProcess(TypeProcessing::UPDATE_MODEL);
    controller->setMemderAverageCharts(NUMBER_AVERAGE_CHARTS);
    controller->setAverageDelta(&m_averageDelta);
    controller->setCommonRoundPowerDelta(COMMON_ROUND_POWER_DELTA);
    controller->setPriceModel(&m_infoChart.m_priceModel);

    initThreadController(controller);

}

void CandleChartWorker::respondTokenPairsHistory(const QJsonArray &history)
{

    if(isProcessing())
    {
        addRequest(TypeRequest::HISTORY_REQUEST, QVariant(history));
        return;
    }

    CreatingSheduleController* controller = new CreatingSheduleController();
    controller->setHistoryArray(history);
    controller->setChartProperty(getChartProperty());
    controller->setTypeProcess(TypeProcessing::NEW_HISTORY);
    controller->setMemderAverageCharts(NUMBER_AVERAGE_CHARTS);
    controller->setAverageDelta(&m_averageDelta);
    controller->setCommonRoundPowerDelta(COMMON_ROUND_POWER_DELTA);

    controller->setLastVisibleAverage(&lastVisibleAverage);
    controller->setFirstVisibleAverage(&firstVisibleAverage);
    initThreadController(controller);
}

void CandleChartWorker::resetPriceData(double price, const QString &priceText, bool init)
{
    if(isProcessing())
    {
        QList<QVariant> list;
        list.append(QVariant(price));
        list.append(QVariant(priceText));
        list.append(QVariant(init));
        addRequest(TypeRequest::RESET_REQUEST, QVariant(price));
        return;
    }

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

    m_infoChart.m_currentTokenPrice = price;
    m_infoChart.m_currentTokenPriceText = priceText;
    m_infoChart.m_previousTokenPrice = price;

    m_infoChart.m_priceModel.clear();

    if (!init && price > 0.000000000000000000001)
    {
        PriceInfo info{currentTime, price};

        m_infoChart.m_priceModel.append(info);
    }

    CreatingSheduleController* controller = new CreatingSheduleController();
    controller->setChartProperty(getChartProperty());
    controller->setTypeProcess(TypeProcessing::RESET_UPDATE);
    controller->setMemderAverageCharts(NUMBER_AVERAGE_CHARTS);
    controller->setAverageDelta(&m_averageDelta);
    controller->setCommonRoundPowerDelta(COMMON_ROUND_POWER_DELTA);
    controller->setPriceModel(&m_infoChart.m_priceModel);

    controller->setLastVisibleAverage(&lastVisibleAverage);
    controller->setFirstVisibleAverage(&firstVisibleAverage);
    initThreadController(controller);
}

void CandleChartWorker::respondCurrentTokenPairs(const QList<QPair<QString,QString>> &rateList)
{

    if(isProcessing())
    {

        for( const auto& item: rateList)
        {
            QVariant value;
            value.setValue(item);
            addRequest(TypeRequest::NEW_PRICE_REQUEST, value);
        }

        return;
    }

    {
        for(const auto& item: rateList)
        {
            QString price = item.second;
            m_infoChart.m_previousTokenPrice = m_infoChart.m_currentTokenPrice;
            m_infoChart.m_currentTokenPrice = price.toDouble();
            m_infoChart.m_currentTokenPriceText = price;
            qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

            if(!m_infoChart.m_priceModel.isEmpty() && m_infoChart.m_priceModel.size() > 2)
            {
                int size = m_infoChart.m_priceModel.size();
                auto& lastItem = m_infoChart.m_priceModel[size - 1];
                auto& beforeLastItem = m_infoChart.m_priceModel[size - 2];
                if(lastItem.price == beforeLastItem.price && beforeLastItem.price == m_infoChart.m_currentTokenPrice)
                {
                    lastItem.time = currentTime;
                }
                else
                {
                    PriceInfo info{currentTime, m_infoChart.m_currentTokenPrice, m_infoChart.m_currentTokenPriceText};
                    m_infoChart.m_priceModel.append(std::move(info));
                }
            }
            else
            {
                PriceInfo info{currentTime, m_infoChart.m_currentTokenPrice, m_infoChart.m_currentTokenPriceText};
                m_infoChart.m_priceModel.append(std::move(info));
            }
        }

        CreatingSheduleController* controller = new CreatingSheduleController();
        controller->setPreviousTokenPrice(m_infoChart.m_previousTokenPrice);
        controller->setCurrentTokenPrice(m_infoChart.m_currentTokenPrice);
        controller->setCurrentTokenPriceText(m_infoChart.m_currentTokenPriceText);

        controller->setChartProperty(getChartProperty());
        controller->setTypeProcess(TypeProcessing::NEW_PRICE);
        controller->setMemderAverageCharts(NUMBER_AVERAGE_CHARTS);
        controller->setAverageDelta(&m_averageDelta);
        controller->setCommonRoundPowerDelta(COMMON_ROUND_POWER_DELTA);
        controller->setPriceModel(&m_infoChart.m_priceModel);

        controller->setLastVisibleAverage(&lastVisibleAverage);
        controller->setFirstVisibleAverage(&firstVisibleAverage);
        initThreadController(controller);
    }
}


ChartProperty CandleChartWorker::getChartProperty() const
{
    ChartProperty result(m_candleWidth, m_infoChart.m_rightTime, m_infoChart.m_lastCandleNumber,
                         m_infoChart.m_rightCandleNumber, m_infoChart.m_commonRoundPower, m_infoChart.m_currentTokenPrice, m_visibleTime);
    return result;
}


QVariantMap CandleChartWorker::getPriceInfo(int index)
{
    if (index < 0 || index >= m_infoChart.m_priceModel.size())
        return {};
    else
        return m_infoChart.m_priceModel.at(index).getMap();
}

QVariantMap CandleChartWorker::getCandleInfo(int index)
{
    if (index < 0 || index >= m_infoChart.m_candleModel.size())
        return {};
    else
        return m_infoChart.m_candleModel.at(index).getMap();
}

QVariantMap CandleChartWorker::getAveragedInfo(int chart, int index)
{
    if (chart < 0 || chart >= NUMBER_AVERAGE_CHARTS)
        return {};

    if (index < 0 || index >= m_infoChart.m_averagedModel.at(chart).size())
        return {};
    else
        return m_infoChart.m_averagedModel.at(chart).at(index).getMap();
}

int CandleChartWorker::getFirstVisibleAverage(int chart)
{
    if (chart < 0 || chart >= NUMBER_AVERAGE_CHARTS)
        return 0;
    else
        return firstVisibleAverage.at(chart);
}

int CandleChartWorker::getLastVisibleAverage(int chart)
{
    if (chart < 0 || chart >= NUMBER_AVERAGE_CHARTS)
        return 0;
    else
        return lastVisibleAverage.at(chart);
}

void CandleChartWorker::setNewCandleWidth(qint64 width)
{
    setCandleWidth(width);

    setVisibleTime(m_candleWidth * visibleDefaultCandles);
    priceModelChanged();
}

void CandleChartWorker::dataAnalysis()
{
    bool reset = true;

    m_maxTime = m_infoChart.m_rightTime;

    m_minTime = m_infoChart.m_rightTime - m_visibleTime;

    if (!m_infoChart.m_candleModel.isEmpty())
    {
        m_minPrice = m_infoChart.m_candleModel.first().minimum;
        m_maxPrice = m_infoChart.m_candleModel.first().maximum;
        m_beginTime = m_infoChart.m_candleModel.first().time - m_candleWidth / 2;
        m_endTime = m_infoChart.m_candleModel.last().time + m_candleWidth / 2;

        m_minPriceTime = m_infoChart.m_candleModel.first().time;
        m_maxPriceTime = m_infoChart.m_candleModel.first().time;
    }
    else
    {
        m_minPrice = 0.0f;
        m_maxPrice = 0.0f;
        m_beginTime = m_infoChart.m_rightTime;
        m_endTime = m_infoChart.m_rightTime;
    }

    int size = m_infoChart.m_candleModel.size();

    int rightIndex = 0;
    int leftIndex = 0;

    if(size)
    {
        qint64 lastTime = m_infoChart.m_candleModel.last().time;
        qint64 deltaTime = lastTime - m_infoChart.m_rightTime;


        rightIndex  = (size - 1) - deltaTime / m_candleWidth;
        rightIndex = rightIndex <= 0 ? size - 1 : rightIndex;
        rightIndex = rightIndex >= size ? size - 1 : rightIndex;

        leftIndex = rightIndex - m_visibleTime / m_candleWidth;
        leftIndex = leftIndex < 0 ? 0: leftIndex;
    }

    m_firstVisibleCandle = leftIndex;
    m_lastVisibleCandle = rightIndex;

    if(rightIndex)
    {
        for (auto i = leftIndex; i <= rightIndex; ++i)
        {
            qint64 currX = m_infoChart.m_candleModel.at(i).time;
            double minimum = m_infoChart.m_candleModel.at(i).minimum;
            double maximum = m_infoChart.m_candleModel.at(i).maximum;

            if (currX + m_candleWidth / 2 < m_infoChart.m_rightTime - m_visibleTime)
                continue;

            if (currX - m_candleWidth / 2 > m_infoChart.m_rightTime)
                break;

            m_infoChart.m_rightCandleNumber = i;

            if (reset)
            {
                m_minPrice = minimum;
                m_maxPrice = maximum;
                m_minPriceTime = currX;
                m_maxPriceTime = currX;

                reset = false;
            }
            else
            {
                if (m_minPrice > minimum)
                {
                    m_minPrice = minimum;
                    m_minPriceTime = currX;
                }
                if (m_maxPrice < maximum)
                {
                    m_maxPrice = maximum;
                    m_maxPriceTime = currX;
                }

                for (auto ch = 0; ch < NUMBER_AVERAGE_CHARTS; ++ch)
                {
                    auto price = m_infoChart.m_averagedModel.at(ch).at(i).price;
                    if(price < m_minPrice)
                    {
                        m_minPrice = price;
                        continue;
                    }
                    if(price > m_maxPrice)
                    {
                        m_maxPrice = price;
                        continue;
                    }
                }
            }
        }
    }

    if (m_minTime == m_maxTime)
    {
        m_minTime -= 1;
        m_maxTime += 1;
    }
    if (m_minPrice > m_maxPrice*0.999999999999999999)
    {
        m_minPrice -= 0.00000000000000000001;
        m_maxPrice += 0.00000000000000000001;
    }


    for (auto ch = 0; ch < NUMBER_AVERAGE_CHARTS; ++ch)
    {
        firstVisibleAverage[ch] = leftIndex;
        lastVisibleAverage[ch] = rightIndex;
    }
}


bool CandleChartWorker::zoomTime(int step)
{
    double oldVisibleTime = m_visibleTime;

    if (step > 0)
    {
        m_visibleTime *= 1.2;
    }
    else
    {
        m_visibleTime /= 1.2;
    }

    if (m_visibleTime > m_candleWidth * visibleDefaultCandles * maxZoom ||
        m_visibleTime < m_candleWidth * visibleDefaultCandles * minZoom)
    {
        m_visibleTime = oldVisibleTime;

        return false;
    }
    else
    {
        m_infoChart.m_rightTime += (m_visibleTime - oldVisibleTime)*0.5;

        emit visibleTimeChanged(m_visibleTime);

        return true;
    }
}

void CandleChartWorker::shiftTime(double step)
{
    if (m_infoChart.m_candleModel.isEmpty())
        return;

    m_infoChart.m_rightTime -= step;

    if (m_infoChart.m_rightTime > m_endTime + m_visibleTime / 2)
        m_infoChart.m_rightTime = m_endTime + m_visibleTime / 2;

    if (m_infoChart.m_rightTime < m_beginTime + m_visibleTime / 2)
        m_infoChart.m_rightTime = m_beginTime + m_visibleTime / 2;

}

void CandleChartWorker::setCandleWidth(qint64 width)
{
    if (m_candleWidth == width)
        return;

    m_candleWidth = width;
    emit candleWidthChanged(m_candleWidth);
}

void CandleChartWorker::setVisibleTime(double time)
{
    if (m_visibleTime == time)
        return;

    m_visibleTime = time;
    emit visibleTimeChanged(m_visibleTime);
}

void CandleChartWorker::setRightTime(qint64 number)
{
    m_infoChart.m_rightTime = number;
}

//void CandleChartWorker::resetRightTime()
//{
//    if (!candleModel.isEmpty())
//        emit setRightTime(candleModel.last().time + candleWidth()/2);
//    else
//        emit setRightTime(QDateTime::currentDateTime().toMSecsSinceEpoch() + candleWidth());
//}


void CandleChartWorker::addRequest(TypeRequest type, const QVariant& params)
{

    if(TypeRequest::NEW_PRICE_REQUEST != type)
    {
       m_queuedRequest[type].clear();
    }

    m_queuedRequest[type].append(params);
}

void CandleChartWorker::tryStartRequestFromQueued()
{
    if(!m_queuedRequest[TypeRequest::HISTORY_REQUEST].isEmpty())
    {
        auto params = m_queuedRequest[TypeRequest::HISTORY_REQUEST];
        respondTokenPairsHistory(params[0].toJsonArray());
        for(auto& item: m_queuedRequest)
        {
            item.clear();
        }
    }
    else if(!m_queuedRequest[TypeRequest::NEW_PRICE_REQUEST].isEmpty())
    {
        auto& listRequest = m_queuedRequest[TypeRequest::NEW_PRICE_REQUEST];
        QList<QPair<QString, QString>> list;
        for(auto& item: listRequest)
        {
            list.append(item.value<QPair<QString, QString>>());
        }
        listRequest.clear();
        respondCurrentTokenPairs(list);
    }
    else if(!m_queuedRequest[TypeRequest::RESET_REQUEST].isEmpty())
    {
        auto paramsVar = m_queuedRequest[TypeRequest::RESET_REQUEST].first().toList();
        double price = paramsVar[0].toDouble();
        QString priceText = paramsVar[1].toString();
        bool init = paramsVar[2].toBool();
        m_queuedRequest[TypeRequest::RESET_REQUEST].removeFirst();
        resetPriceData(price, priceText, init);
    }
}

bool CandleChartWorker::isQueued()
{
    for(const auto& item: m_queuedRequest)
    {
        if(!item.isEmpty())
        {
            return true;
        }
    }
}

void CandleChartWorker::threadFinished(TypeProcessing type, const MainInfoChart &info)
{
    switch (type)
    {
    case TypeProcessing::NEW_HISTORY:
        {
            m_tmpInfoChart.second = info;
            m_tmpInfoChart.first = true;
        }
        break;
    case TypeProcessing::NEW_PRICE:
    case TypeProcessing::RESET_UPDATE:
        {
            MainInfoChart tmpInfo;
            tmpInfo = info;
            tmpInfo.m_priceModel = m_infoChart.m_priceModel;
            m_tmpInfoChart.second = tmpInfo;
            m_tmpInfoChart.first = true;
            tmpInfo.clear();
        }
        break;
    default:
        break;
    }

    setNewData();
}

void CandleChartWorker::setNewData()
{
    if(isPainting())
    {
        return;
    }
    m_isUpdate = true;

    qint64 rightTime;
    bool isOldRightTime = false;
    if(!m_infoChart.m_candleModel.isEmpty())
    {
        rightTime = m_infoChart.m_rightTime;
        qint64 realRightTime = m_infoChart.m_candleModel.last().time;
        if(rightTime < realRightTime)
        {
            isOldRightTime = true;
        }
    }

    m_infoChart.clear();
    m_infoChart = m_tmpInfoChart.second;
    if(isOldRightTime)
    {
        m_infoChart.m_rightTime = rightTime;
    }

    m_infoChart.m_lastCandleNumber = m_infoChart.m_candleModel.isEmpty() ? 0 :m_infoChart.m_candleModel.size() - 1;

    m_tmpInfoChart.first = false;
    m_tmpInfoChart.second.clear();
    m_isUpdate = false;
    emit chartInfoChanged();
    emit minimum24hChanged(m_infoChart.m_minimum24h);
    emit maximum24hChanged(m_infoChart.m_maximum24h);
    emit lastCandleNumberChanged(m_infoChart.m_lastCandleNumber);
    emit checkBookRoundPower(m_infoChart.m_currentTokenPrice);
    setProcessStatus(false);
    tryStartRequestFromQueued();
}

bool CandleChartWorker::setPaintingStatus(bool status)
{
    if(m_isUpdate)
    {
        return false;
    }
    m_isPainting = status;
    if(!status)
    {
        if(m_tmpInfoChart.first)
        {
            setNewData();
        }
        else if(!isProcessing())
        {
            tryStartRequestFromQueued();
        }
    }
    return true;
}
