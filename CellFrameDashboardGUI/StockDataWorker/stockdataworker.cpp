#include "stockdataworker.h"

#include <QDateTime>
#include <QRandomGenerator>
#include <QDebug>

constexpr double visibleDefaultCandles {40};
constexpr double maxZoom{3.0};
constexpr double minZoom{0.2};

constexpr double minAverageStep {0.5};
constexpr double averageDelta {20};

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

void StockDataWorker::getAveragedModel()
{
    int averStep = m_candleWidth * minAverageStep;

    qint64 timeLength = priceModel.last().time - priceModel.first().time;
    int length = timeLength / averStep;
    if (timeLength % averStep)
        ++length;

    qint64 averBegin = priceModel.first().time;
    qint64 averNext = averBegin + averStep;

    QVector <PriceInfo> tempModel;

    tempModel.resize(length);

//    qDebug() << "StockDataWorker::getAveragedModel"
//             << "averStep" << averStep
//             << "length" << length;

    int averIndex = 0;

    int counter = 0;
    double summ = 0;

    for (auto i = 0; i < priceModel.size(); ++i)
    {
        if (priceModel.at(i).time > averNext ||
            i == priceModel.size()-1)
        {
            if (averIndex >= tempModel.size())
                tempModel.resize(averIndex+1);

            PriceInfo info;

            info.time = averBegin + averStep/2;

            if (counter == 0)
                info.price = priceModel.at(i).price;
            else
                info.price = summ/counter;

            tempModel[averIndex] = info;

//            qDebug() << "StockDataWorker::getAveragedModel"
//                     << averIndex
//                     << "info.time" << info.time
//                     << "info.price" << info.price
//                     << "counter" << counter
//                     << "summ" << summ;

            counter = 0;
            summ = 0;

            averBegin = averNext;
            averNext = averBegin + averStep;

            ++averIndex;
        }
        else
        {
            ++counter;
            summ += priceModel.at(i).price;
        }
    }

    if (averIndex < tempModel.size())
        tempModel.resize(averIndex);

//    qDebug() << "StockDataWorker::getAveragedModel"
//             << "tempModel.size()" << tempModel.size();

    averagedModel.resize(tempModel.size());

    for (auto i = 0; i < tempModel.size(); ++i)
    {
        counter = 0;
        summ = 0;

        for (auto j = i - averageDelta; j <= i + averageDelta; ++j)
        {
            if (j < 0)
                continue;
            if (j >= tempModel.size())
                break;

            ++counter;
            summ += tempModel.at(j).price;
        }

        PriceInfo info{tempModel.at(i).time, summ/counter};

        averagedModel[i] = info;

//        qDebug() << "StockDataWorker::getAveragedModel"
//                 << i
//                 << "info.time" << info.time
//                 << "info.price" << info.price
//                 << "counter" << counter
//                 << "summ" << summ;
    }
}

QVariantMap StockDataWorker::getAveragedInfo(int index)
{
//    qDebug() << "StockDataWorker::getAveragedInfo"
//             << index << averagedModel.size();

    if (index < 0 || index >= averagedModel.size())
        return {};
    else
        return averagedModel.at(index).getMap();
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
        m_rightTime = candleModel.last().time + m_candleWidth/2;
}

void StockDataWorker::setNewCandleWidth(qint64 width)
{
//    qDebug() << "StockDataWorker::setNewCandleWidth" << "BEGIN"
//             << QTime::currentTime().toString("hh:mm:ss.zzz");

    setCandleWidth(width);

    setVisibleTime(m_candleWidth * visibleDefaultCandles);

    getCandleModel();

    getAveragedModel();

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
        qint64 time = candleModel.at(i).time;

        if (time + m_candleWidth*0.5 <
                m_rightTime - m_visibleTime)
            continue;

        if (m_firstVisibleCandle == 0)
            m_firstVisibleCandle = i;

        if (time - m_candleWidth*0.5 >
                m_rightTime)
            break;

        m_lastVisibleCandle = i;
    }

    m_firstVisibleAverage = 0;
    m_lastVisibleAverage = 0;

    for (auto i = 0; i < averagedModel.size(); ++i)
    {
        qint64 time = averagedModel.at(i).time;

        if (time < m_rightTime - m_visibleTime)
            continue;

        if (m_firstVisibleAverage == 0)
            m_firstVisibleAverage = i;

        if (time > m_rightTime)
            break;

        m_lastVisibleAverage = i;
    }

//    qDebug() << "StockDataWorker::dataAnalysis"
//             << "m_firstVisibleAverage" << m_firstVisibleAverage
//             << "m_lastVisibleAverage" << m_lastVisibleAverage;

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
