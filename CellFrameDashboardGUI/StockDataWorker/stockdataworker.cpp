#include "stockdataworker.h"

#include <QDateTime>
#include <QRandomGenerator>
#include <QDebug>

constexpr int visibleDefaultCandles {40};
constexpr double maxZoom{3.0};
constexpr double minZoom{0.2};

StockDataWorker::StockDataWorker(QObject *parent) :
    QObject(parent)
{

}

/*QObject* StockDataWorker::createStructure()
{
    CandleInfo* structure = new CandleInfo(this);
    structure->m_number = ++m_structureCount;
    structure->m_message = QString("Structure %1").arg(m_structureCount);
    return structure;
}*/

void StockDataWorker::generatePriceData(int length)
{
//    qDebug() << "StockDataWorker::generatePriceData" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    double currentPrice = 0.245978;
    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

//    m_minimum24h = currentPrice;
//    m_maximum24h = currentPrice;

    m_currentTokenPrice = currentPrice;
    m_previousTokenPrice = currentPrice;

    priceModel.resize(length);

    for (auto i = length-1; i >= 0; --i)
    {
        PriceInfo info{currentTime, currentPrice};

//        if (m_minimum24h > currentPrice)
//            m_minimum24h = currentPrice;
//        if (m_maximum24h < currentPrice)
//            m_maximum24h = currentPrice;

        priceModel[i] = info;
//        priceModel.prepend(info);
//        priceModel.append(info);

        currentPrice +=
            QRandomGenerator::global()->generateDouble() * 0.0001 - 0.00005;

        if (i == length-1)
            m_previousTokenPrice = currentPrice;

        currentTime -= 5000 + static_cast<qint64>(
            QRandomGenerator::global()->generateDouble() * 3000);
    }

//    emit minimum24hChanged(m_minimum24h);
//    emit maximum24hChanged(m_maximum24h);

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit previousTokenPriceChanged(m_previousTokenPrice);

//    qDebug() << "StockDataWorker::generatePriceData" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

QVariantMap StockDataWorker::getPriceInfo(int index)
{
    if (index < 0 || index >= priceModel.size())
        return {};
    else
        return priceModel.at(index).getMap();
}

void StockDataWorker::getCandleModel()
{
//    qDebug() << "StockDataWorker::getCandleModel" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    double open = 0;
    double close = 0;
    double min = 0;
    double max = 0;
    qint64 candleBegin = 0;

//    qDebug() << "StockDataWorker::getCandleModel"
//             << "m_candleWidth" << m_candleWidth;

    if (!priceModel.isEmpty())
    {
        candleBegin = priceModel.first().time;
        open = close = min = max = priceModel.first().price;
    }

    qint64 timeLength = priceModel.last().time - priceModel.first().time;
    int length = timeLength / m_candleWidth;
    if (timeLength % m_candleWidth)
        ++length;

//    qDebug() << "timeLength" << timeLength << "length" << length;

    candleModel.resize(length);

    int candleIndex = 0;

    for (auto i = 0; i < priceModel.size(); ++i)
    {
        double currPrice = priceModel.at(i).price;

        close = currPrice;
        if (min > currPrice)
            min = currPrice;
        if (max < currPrice)
            max = currPrice;

        if (priceModel.at(i).time > candleBegin + m_candleWidth ||
            i == priceModel.size()-1)
        {
            if (candleIndex >= candleModel.size())
                candleModel.resize(candleIndex+1);

            CandleInfo info {candleBegin + m_candleWidth/2,
                            open, close, min, max};

            candleModel[candleIndex] = info;
            ++candleIndex;

            candleBegin += m_candleWidth;

            open = currPrice;
            close = currPrice;
            min = currPrice;
            max = currPrice;
        }
    }

    if (candleIndex < candleModel.size())
        candleModel.resize(candleIndex);

//    qDebug() << "candleModel.size()" << candleModel.size();

    if (m_lastCandleNumber != candleModel.size()-1)
    {
        qDebug() << "NEW CANDLE" << candleModel.size()-1;

        qint64 lastTime = candleModel.last().time;
        if (m_rightCandleNumber == m_lastCandleNumber &&
            m_rightTime < lastTime + m_candleWidth*1.1 &&
                m_rightTime > lastTime - m_candleWidth*1.1)
            resetRightTime();

        m_lastCandleNumber = candleModel.size()-1;
    }

//    qDebug() << "StockDataWorker::getCandleModel"
//             << "candleModel.last().time" << candleModel.last().time;

//    qDebug() << "StockDataWorker::getCandleModel" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

QVariantMap StockDataWorker::getCandleInfo(int index)
{
    if (index < 0 || index >= candleModel.size())
        return {};
    else
        return candleModel.at(index).getMap();
}

void StockDataWorker::getMinimumMaximum24h()
{
    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    qint64 timeMinus24h = QDateTime::fromMSecsSinceEpoch
            (currentTime - 3600000*24).toMSecsSinceEpoch();

    m_minimum24h = priceModel.last().price;
    m_maximum24h = priceModel.last().price;

    for (auto i = priceModel.size()-1; i >= 0; --i)
    {
        if (priceModel.at(i).time < timeMinus24h)
            break;

        double currPrice = priceModel.at(i).price;

        if (m_minimum24h > currPrice)
            m_minimum24h = currPrice;
        if (m_maximum24h < currPrice)
            m_maximum24h = currPrice;
    }

    emit minimum24hChanged(m_minimum24h);
    emit maximum24hChanged(m_maximum24h);
}

void StockDataWorker::resetRightTime()
{
    if (!candleModel.isEmpty())
        setRightTime(candleModel.last().time + m_candleWidth/2);
}

void StockDataWorker::setNewCandleWidth(qint64 width)
{
//    qDebug() << "StockDataWorker::setNewCandleWidth" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    setCandleWidth(width);

    setVisibleTime(m_candleWidth * visibleDefaultCandles);

    getCandleModel();

    resetRightTime();

//    qDebug() << "StockDataWorker::setNewCandleWidth" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

void StockDataWorker::dataAnalysis()
{
//    qDebug() << "StockDataWorker::dataAnalysis" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

//    qDebug() << "StockDataWorker::dataAnalysis"
//             << "m_rightTime" << m_rightTime
//             << "candleModel.first().time" << candleModel.first().time
//             << "candleModel.last().time" << candleModel.last().time
//             << "m_rightTime" << m_rightTime
//             << "m_visibleTime" << m_visibleTime;

    bool reset = true;

    m_maxTime = m_rightTime;

    m_minTime = m_rightTime - m_visibleTime;

    if (!candleModel.isEmpty())
    {
        m_minPrice = candleModel.first().minimum;
        m_maxPrice = candleModel.first().maximum;
        m_beginTime = candleModel.first().time - m_candleWidth/2;
        m_endTime = candleModel.last().time + m_candleWidth/2;
    }

    m_rightCandleNumber = 0;

    for (auto i = 0; i < candleModel.size(); ++i)
    {
        qint64 currX = candleModel.at(i).time;
        double minimum = candleModel.at(i).minimum;
        double maximum = candleModel.at(i).maximum;

        if (currX + m_candleWidth/2 < m_rightTime - m_visibleTime)
            continue;

        if (currX - m_candleWidth/2 > m_rightTime)
            break;

        m_rightCandleNumber = i;

        if (reset)
        {
            m_minPrice = minimum;
            m_maxPrice = maximum;

            reset = false;
        }
        else
        {
            if (m_minPrice > minimum)
                m_minPrice = minimum;
            if (m_maxPrice < maximum)
                m_maxPrice = maximum;
        }
    }

    if (m_minTime == m_maxTime)
    {
        m_minTime -= 1;
        m_maxTime += 1;
    }
    if (m_minPrice == m_maxPrice)
    {
        m_minPrice -= 0.00000000000000000001;
        m_maxPrice += 0.00000000000000000001;
    }

    m_firstVisibleCandle = 0;
    m_lastVisibleCandle = 0;

    for (auto i = 0; i < candleModel.size(); ++i)
    {
        if (candleModel.at(i).time + m_candleWidth*0.5 <
                m_rightTime - m_visibleTime)
            continue;

        if (m_firstVisibleCandle == 0)
            m_firstVisibleCandle = i;

        if (candleModel.at(i).time - m_candleWidth*0.5 >
                m_rightTime)
            break;

        m_lastVisibleCandle = i;
    }

//    qDebug() << "StockDataWorker::dataAnalysis"
//             << "m_minTime" << m_minTime
//             << "m_maxTime" << m_maxTime;

/*    if (m_maxPrice > m_minPrice)
        m_coefficientPrice = chartHeight/(maxPrice - minPrice)
    if (visibleTime > 0)
        coefficientTime = chartWidth/visibleTime

    getRoundedStepY()

    getRoundedStepTime()*/

//    qDebug() << "StockDataWorker::dataAnalysis" << "END"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");
}

void StockDataWorker::generateNewPrice()
{
    m_previousTokenPrice = m_currentTokenPrice;
    m_currentTokenPrice +=
        QRandomGenerator::global()->generateDouble()*0.00004 - 0.00002;

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    PriceInfo info{currentTime, m_currentTokenPrice};

    priceModel.append(info);

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit previousTokenPriceChanged(m_previousTokenPrice);
}

bool StockDataWorker::zoomTime(int step)
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
        m_rightTime += (m_visibleTime - oldVisibleTime)*0.5;

        emit visibleTimeChanged(m_visibleTime);
        emit rightTimeChanged(m_rightTime);

        return true;
    }
}

void StockDataWorker::shiftTime(double step)
{
    m_rightTime -= step;

    if (m_rightTime > m_endTime + m_visibleTime*0.5)
        m_rightTime = m_endTime + m_visibleTime*0.5;

    if (m_rightTime < m_beginTime + m_visibleTime*0.5)
        m_rightTime = m_beginTime + m_visibleTime*0.5;

    emit rightTimeChanged(m_rightTime);
}

void StockDataWorker::setCandleWidth(qint64 width)
{
    if (m_candleWidth == width)
        return;

    m_candleWidth = width;
    emit candleWidthChanged(m_candleWidth);
}

void StockDataWorker::setVisibleTime(double time)
{
    if (m_visibleTime == time)
        return;

    m_visibleTime = time;
    emit visibleTimeChanged(m_visibleTime);
}

void StockDataWorker::setRightTime(qint64 time)
{
    if (m_rightTime == time)
        return;

    m_rightTime = time;
    emit rightTimeChanged(m_rightTime);
}

void StockDataWorker::setMinTime(qint64 time)
{
    if (m_minTime == time)
        return;

    m_minTime = time;
    emit minTimeChanged(m_minTime);
}

void StockDataWorker::setMaxTime(qint64 time)
{
    if (m_maxTime == time)
        return;

    m_maxTime = time;
    emit maxTimeChanged(m_maxTime);
}

void StockDataWorker::setMinPrice(double price)
{
    if (m_minPrice == price)
        return;

    m_minPrice = price;
    emit minPriceChanged(m_minPrice);
}

void StockDataWorker::setMaxPrice(double price)
{
    if (m_maxPrice == price)
        return;

    m_maxPrice = price;
    emit maxPriceChanged(m_maxPrice);
}

void StockDataWorker::setBeginTime(qint64 time)
{
    if (m_beginTime == time)
        return;

    m_beginTime = time;
    emit beginTimeChanged(m_beginTime);
}

void StockDataWorker::setEndTime(qint64 time)
{
    if (m_endTime == time)
        return;

    m_endTime = time;
    emit endTimeChanged(m_endTime);
}

void StockDataWorker::setMinimum24h(double min)
{
    if (m_minimum24h == min)
        return;

    m_minimum24h = min;
    emit minimum24hChanged(m_minimum24h);
}

void StockDataWorker::setMaximum24h(double max)
{
    if (m_maximum24h == max)
        return;

    m_maximum24h = max;
    emit maximum24hChanged(m_maximum24h);
}

void StockDataWorker::setLastCandleNumber(int number)
{
    if (m_lastCandleNumber == number)
        return;

    m_lastCandleNumber = number;
    emit lastCandleNumberChanged(m_lastCandleNumber);
}

void StockDataWorker::setRightCandleNumber(int number)
{
    if (m_rightCandleNumber == number)
        return;

    m_rightCandleNumber = number;
    emit rightCandleNumberChanged(m_rightCandleNumber);
}

void StockDataWorker::setCurrentTokenPrice(double price)
{
    if (m_currentTokenPrice == price)
        return;

    m_currentTokenPrice = price;
    emit currentTokenPriceChanged(m_currentTokenPrice);
}

void StockDataWorker::setPreviousTokenPrice(double price)
{
    if (m_previousTokenPrice == price)
        return;

    m_previousTokenPrice = price;
    emit previousTokenPriceChanged(m_previousTokenPrice);
}

/*void StockDataWorker::setCoefficientTime(double coeff)
{
    if (m_coefficientTime == coeff)
        return;

    m_coefficientTime = coeff;
    emit coefficientTimeChanged(m_coefficientTime);
}

void StockDataWorker::setCoefficientPrice(double coeff)
{
    if (m_coefficientPrice == coeff)
        return;

    m_coefficientPrice = coeff;
    emit coefficientPriceChanged(m_coefficientPrice);
}*/
