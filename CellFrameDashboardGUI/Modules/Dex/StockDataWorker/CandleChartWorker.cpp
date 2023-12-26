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

constexpr double minAverageStep {0.5};

constexpr int numberAverageCharts {3};

constexpr int commonRoundPowerDelta {9};

CandleChartWorker::CandleChartWorker(QObject *parent) :
    QObject(parent)
{
    for (auto i = 0; i < numberAverageCharts; ++i)
    {
        QVector <PriceInfo> vector;
        averagedModel.append(vector);

        firstVisibleAverage.append(0);
        lastVisibleAverage.append(0);

        switch (i)
        {
            case 0:
                averageDelta.append(5);
                break;
            case 1:
                averageDelta.append(15);
                break;
            case 2:
                averageDelta.append(45);
                break;
            default:
                averageDelta.append(1);
        }
    }
}

void CandleChartWorker::resetPriceData(
        double price, const QString &priceText, bool init)
{
    qDebug() << "CandleChartWorker::resetPriceData" << price;

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

    m_currentTokenPrice = price;
    m_currentTokenPriceText = priceText;
    m_previousTokenPrice = price;

    priceModel.clear();

    if (!init && price > 0.000000000000000000001)
    {
        PriceInfo info{currentTime, price};

        priceModel.append(info);
    }

    getCandleModel(false);

    resetRightTime();

    getAveragedModels(false);

    getMinimumMaximum24h();

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit currentTokenPriceTextChanged(m_currentTokenPriceText);
    emit previousTokenPriceChanged(m_previousTokenPrice);

    checkNewRoundPower();
}

void CandleChartWorker::generatePriceData(int length)
{
    double currentPrice = 0.245978;
    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

    m_currentTokenPrice = currentPrice;
    m_currentTokenPriceText = "0.245978";
    m_previousTokenPrice = currentPrice;

    if (length < 1)
        length = 1;

    priceModel.resize(length);

    for (auto i = length-1; i >= 0; --i)
    {
        PriceInfo info{currentTime, currentPrice};

        priceModel[i] = info;

        currentPrice +=
            QRandomGenerator::global()->generateDouble() * 0.0001 - 0.00005;

        if (i == length-1)
            m_previousTokenPrice = currentPrice;

        currentTime -= 5000 + static_cast<qint64>(
            QRandomGenerator::global()->generateDouble() * 3000);
    }

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit currentTokenPriceTextChanged(m_currentTokenPriceText);
    emit previousTokenPriceChanged(m_previousTokenPrice);

    checkNewRoundPower();
}

QVariantMap CandleChartWorker::getPriceInfo(int index)
{
    if (index < 0 || index >= priceModel.size())
        return {};
    else
        return priceModel.at(index).getMap();
}

void CandleChartWorker::setTokenPriceHistory(const QJsonArray &history)
{
    if(history.isEmpty())
    {
        priceModel.clear();
        return;
    }
    priceModel.resize(history.size());

    for(auto i = 0; i < history.size(); i++)
    {
        QJsonObject item = history[i].toObject();
        QString priceText = item["rate"].toString();
        double price = priceText.toDouble();
        qint64 time = item["time"].toString().toLongLong();
        PriceInfo info{time, price, priceText};
        priceModel[i] = std::move(info);
    }

    std::sort (priceModel.begin(), priceModel.end(),
               [](const PriceInfo& lha, const PriceInfo& rha){
        return lha.time < rha.time;
    });

    if (priceModel.size() > 0)
    {
        m_previousTokenPrice = m_currentTokenPrice = priceModel.last().price;
        m_currentTokenPriceText = priceModel.last().priceText;
    }
    if (priceModel.size() > 1)
    {
        m_previousTokenPrice = priceModel.at(priceModel.size()-2).price;
    }

    getCandleModel(false);

    resetRightTime();

    getAveragedModels(false);

    getMinimumMaximum24h();

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit currentTokenPriceTextChanged(m_currentTokenPriceText);
    emit previousTokenPriceChanged(m_previousTokenPrice);

    checkNewRoundPower();
}

void CandleChartWorker::updateAllModels()
{
    getCandleModel(true);

    getAveragedModels(true);
}

void CandleChartWorker::getCandleModel(bool update)
{
    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

    qint64 timeLength = 0;

    if (!priceModel.isEmpty())
        timeLength = currentTime - priceModel.first().time;

    int length = timeLength / m_candleWidth;
    if (timeLength % m_candleWidth)
        ++length;

    candleModel.resize(length);

    double open = 0;
    double close = 0;
    double min = 0;
    double max = 0;
    double sum = 0;
    int counter = 1;
    qint64 candleBegin = 0;

    if (!priceModel.isEmpty())
    {
        candleBegin = priceModel.first().time;
        open = close = min = max = sum =
                priceModel.first().price;
    }

    int candleIndex = 0;

    int priceIndex = 0;

    if (update)
    {
        candleIndex = m_lastCandleNumber;

        candleBegin += m_candleWidth*m_lastCandleNumber;

        if (m_lastCandleNumber < candleModel.size())
        {
            open = close = min = max = sum =
                candleModel.at(m_lastCandleNumber).open;
        }

        priceIndex = priceModel.size()-1;

        while (!priceModel.isEmpty() && priceIndex > 0 &&
               priceModel.at(priceIndex).time > candleBegin)
        {
            --priceIndex;
        }

        if (priceIndex < 0)
            priceIndex = 0;

        if (!priceModel.isEmpty() && priceModel.at(priceIndex).time < candleBegin)
            ++priceIndex;
    }

    int index = priceIndex;
    qint64 nextTime = 0;

    if (index < priceModel.size()-1)
        nextTime = priceModel.at(index+1).time;
    else
        nextTime = currentTime;

    while (index < priceModel.size())
    {
        double currPrice = priceModel.at(index).price;

        if (nextTime > candleBegin + m_candleWidth ||
            index == priceModel.size()-1)
        {
            if (candleIndex >= candleModel.size())
                candleModel.resize(candleIndex+1);

            close = currPrice;
            if (min > currPrice)
                min = currPrice;
            if (max < currPrice)
                max = currPrice;

            CandleInfo info {candleBegin + m_candleWidth/2,
                            open, close, min, max, sum/counter};

            candleModel[candleIndex] = info;

            ++candleIndex;

            candleBegin += m_candleWidth;

            open = currPrice;
            close = currPrice;
            min = currPrice;
            max = currPrice;

            sum = currPrice;
            counter = 1;

            if (candleBegin > currentTime)
                break;
        }
        else
        {
            close = currPrice;
            if (min > currPrice)
                min = currPrice;
            if (max < currPrice)
                max = currPrice;

            sum += currPrice;
            ++counter;

            ++index;

            if (index < priceModel.size()-1)
                nextTime = priceModel.at(index+1).time;
            else
                nextTime = currentTime;
        }

    }

    if (candleIndex < candleModel.size())
        candleModel.resize(candleIndex);

    if (m_lastCandleNumber != candleModel.size()-1 &&
        !candleModel.isEmpty())
    {
        qint64 lastTime = candleModel.last().time;
        if (m_rightCandleNumber == m_lastCandleNumber &&
            m_rightTime < lastTime + m_candleWidth*1.1 &&
                m_rightTime > lastTime - m_candleWidth*1.1)
            resetRightTime();

        m_lastCandleNumber = candleModel.size()-1;
    }
}

QVariantMap CandleChartWorker::getCandleInfo(int index)
{
    if (index < 0 || index >= candleModel.size())
        return {};
    else
        return candleModel.at(index).getMap();
}

void CandleChartWorker::getAveragedModels(bool update)
{
    for (auto ch = 0; ch < numberAverageCharts; ++ch)
    {
        averagedModel[ch].resize(candleModel.size());

        int tempIndex = 0;

        if (update)
        {
            tempIndex = averagedModel[ch].size() -
                    averageDelta.at(ch) - 2;

            if (tempIndex < 0)
                tempIndex = 0;
        }

        for (auto i = tempIndex; i < candleModel.size(); ++i)
        {
            double value = 0;
            double valsum = 0;
            double pricesum = 0;

            for (auto k = i - averageDelta.at(ch);
                 k <= i + averageDelta.at(ch); ++k)
            {
                if (k < 0)
                    continue;
                if (k >= candleModel.size())
                    break;

                if (k < i)
                    value = averageDelta.at(ch) - (i - k) + 1;
                else
                    value = averageDelta.at(ch) + (i - k) + 1;

                valsum += value;

                pricesum += value*candleModel.at(k).average;

            }

            PriceInfo info{candleModel.at(i).time, pricesum/valsum};

            averagedModel[ch][i] = info;

        }
    }
}

QVariantMap CandleChartWorker::getAveragedInfo(int chart, int index)
{
    if (chart < 0 || chart >= numberAverageCharts)
        return {};

    if (index < 0 || index >= averagedModel.at(chart).size())
        return {};
    else
        return averagedModel.at(chart).at(index).getMap();
}

int CandleChartWorker::getFirstVisibleAverage(int chart)
{
    if (chart < 0 || chart >= numberAverageCharts)
        return 0;
    else
        return firstVisibleAverage.at(chart);
}

int CandleChartWorker::getLastVisibleAverage(int chart)
{
    if (chart < 0 || chart >= numberAverageCharts)
        return 0;
    else
        return lastVisibleAverage.at(chart);
}

void CandleChartWorker::getMinimumMaximum24h()
{
    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    qint64 timeMinus24h = QDateTime::fromMSecsSinceEpoch
            (currentTime - 3600000*24).toMSecsSinceEpoch();

    if (priceModel.isEmpty())
    {
        m_minimum24h = 0.0;
        m_maximum24h = 0.0;
    }
    else
    {
        m_minimum24h = priceModel.last().price;
        m_maximum24h = priceModel.last().price;

        for (auto i = priceModel.size()-1; i >= 0; --i)
        {
            double currPrice = priceModel.at(i).price;

            if (m_minimum24h > currPrice)
                m_minimum24h = currPrice;
            if (m_maximum24h < currPrice)
                m_maximum24h = currPrice;

            if (priceModel.at(i).time < timeMinus24h)
                break;
        }
    }

    emit minimum24hChanged(m_minimum24h);
    emit maximum24hChanged(m_maximum24h);
}

void CandleChartWorker::resetRightTime()
{
    if (!candleModel.isEmpty())
        m_rightTime = candleModel.last().time + m_candleWidth/2;
    else
        m_rightTime = QDateTime::currentDateTime().toMSecsSinceEpoch() + m_candleWidth;
}

void CandleChartWorker::setNewCandleWidth(qint64 width)
{
    setCandleWidth(width);

    setVisibleTime(m_candleWidth * visibleDefaultCandles);

    getCandleModel(false);

    getAveragedModels(false);

    resetRightTime();
}

void CandleChartWorker::dataAnalysis()
{
    bool reset = true;

    m_maxTime = m_rightTime;

    m_minTime = m_rightTime - m_visibleTime;

    if (!candleModel.isEmpty())
    {
        m_minPrice = candleModel.first().minimum;
        m_maxPrice = candleModel.first().maximum;
        m_beginTime = candleModel.first().time - m_candleWidth/2;
        m_endTime = candleModel.last().time + m_candleWidth/2;

        m_minPriceTime = candleModel.first().time;
        m_maxPriceTime = candleModel.first().time;
    }
    else
    {
        m_minPrice = 0;
        m_maxPrice = 0;
        m_beginTime = m_rightTime;
        m_endTime = m_rightTime;
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

    m_firstVisibleCandle = -1;
    m_lastVisibleCandle = 0;

    for (auto i = 0; i < candleModel.size(); ++i)
    {
        qint64 time = candleModel.at(i).time;

        if (time + m_candleWidth*0.5 <
                m_rightTime - m_visibleTime)
            continue;

        if (m_firstVisibleCandle == -1)
            m_firstVisibleCandle = i;

        if (time - m_candleWidth*0.5 >
                m_rightTime)
            break;

        m_lastVisibleCandle = i;
    }

    if (m_firstVisibleCandle < 0)
        m_firstVisibleCandle = 0;

    for (auto ch = 0; ch < numberAverageCharts; ++ch)
    {
        firstVisibleAverage[ch] = 0;
        lastVisibleAverage[ch] = 0;

        for (auto i = 0; i < averagedModel.at(ch).size(); ++i)
        {
            qint64 time = averagedModel.at(ch).at(i).time;

            if (time < m_rightTime - m_visibleTime - m_candleWidth*minAverageStep)
                continue;

            if (firstVisibleAverage.at(ch) == 0)
                firstVisibleAverage[ch] = i;

            if (time > m_rightTime + m_candleWidth*minAverageStep)
                break;

            lastVisibleAverage[ch] = i;
        }
    }
}

void CandleChartWorker::setNewPrice(const QString &price)
{
    if (priceModel.isEmpty())
    {
        resetPriceData(price.toDouble(), price, false);
    }
    else
    {
        m_previousTokenPrice = m_currentTokenPrice;
        m_currentTokenPrice = price.toDouble();
        m_currentTokenPriceText = price;

        qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
        PriceInfo info{currentTime, m_currentTokenPrice, m_currentTokenPriceText};

        priceModel.append(info);

        emit currentTokenPriceChanged(m_currentTokenPrice);
        emit previousTokenPriceChanged(m_previousTokenPrice);
        emit currentTokenPriceTextChanged(m_currentTokenPriceText);
    }

    getMinimumMaximum24h();

    checkNewRoundPower();
}

void CandleChartWorker::generateNewPrice(double step)
{
    m_previousTokenPrice = m_currentTokenPrice;
    m_currentTokenPrice +=
        QRandomGenerator::global()->generateDouble()*step - step*0.5;
    m_currentTokenPriceText = QString::number(m_currentTokenPrice, 'f', 18);


    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    PriceInfo info{currentTime, m_currentTokenPrice, m_currentTokenPriceText};

    priceModel.append(info);

    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit previousTokenPriceChanged(m_previousTokenPrice);
    emit currentTokenPriceTextChanged(m_currentTokenPriceText);

    getMinimumMaximum24h();

    checkNewRoundPower();
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
        m_rightTime += (m_visibleTime - oldVisibleTime)*0.5;

        emit visibleTimeChanged(m_visibleTime);

        return true;
    }
}

void CandleChartWorker::shiftTime(double step)
{
    if (candleModel.isEmpty())
        return;

    m_rightTime -= step;

    if (m_rightTime > m_endTime + m_visibleTime*0.5)
        m_rightTime = m_endTime + m_visibleTime*0.5;

    if (m_rightTime < m_beginTime + m_visibleTime*0.5)
        m_rightTime = m_beginTime + m_visibleTime*0.5;
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

void CandleChartWorker::setMinimum24h(double min)
{
    if (m_minimum24h == min)
        return;

    m_minimum24h = min;
    emit minimum24hChanged(m_minimum24h);
}

void CandleChartWorker::setMaximum24h(double max)
{
    if (m_maximum24h == max)
        return;

    m_maximum24h = max;
    emit maximum24hChanged(m_maximum24h);
}

void CandleChartWorker::setLastCandleNumber(int number)
{
    if (m_lastCandleNumber == number)
        return;

    m_lastCandleNumber = number;
    emit lastCandleNumberChanged(m_lastCandleNumber);
}

void CandleChartWorker::setRightCandleNumber(int number)
{
    if (m_rightCandleNumber == number)
        return;

    m_rightCandleNumber = number;
    emit rightCandleNumberChanged(m_rightCandleNumber);
}

void CandleChartWorker::checkNewRoundPower()
{
//    qDebug() << "CandleChartWorker::checkNewRoundPower" << m_currentTokenPrice;

    int tempPower = -10;
    double tempMask = pow (10, tempPower);

    while (tempMask < m_currentTokenPrice && tempPower < 77)
    {
        ++tempPower;

        tempMask = pow (10, tempPower);
    }

    int tempCommonPower = - tempPower + commonRoundPowerDelta;

    if (tempCommonPower > 8)
        tempCommonPower = 8;
    if (tempCommonPower < 0)
        tempCommonPower = 0;

    if (tempCommonPower != m_commonRoundPower)
    {
        m_commonRoundPower = tempCommonPower;

        qDebug() << "m_commonRoundPower" << m_commonRoundPower;

        emit commonRoundPowerChanged(m_commonRoundPower);
    }

    emit checkBookRoundPower(m_currentTokenPrice);
}
