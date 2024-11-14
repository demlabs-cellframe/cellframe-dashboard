#include "CreateCandleChart.h"
#include <cmath>

CreateCandleChart::CreateCandleChart(QObject *parent, QWeakPointer<QVector<PriceInfo>> priceModel, QWeakPointer<QVector<CandleInfo>> candleModel, QWeakPointer<QVector<QVector<PriceInfo>>> averagedModel)
    : QObject(parent)
    , m_priceModel(priceModel)
    , m_candleModel(candleModel)
    , m_averagedModel(averagedModel)
{

}

CreateCandleChart::~CreateCandleChart()
{

}

void CreateCandleChart::createModels()
{
    createCandleModel(false);
    emit finished();
}

void CreateCandleChart::tryCreateCandleModel()
{
    createCandleModel(false);
    emit finished();
}

void CreateCandleChart::createMinimumMaximum24h()
{
    Q_ASSERT_X(!m_priceModel.isNull(), "createMinimumMaximum24h() priceModel is null", 0);
    auto priceModel = m_priceModel.lock();

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();
    qint64 timeMinus24h = QDateTime::fromMSecsSinceEpoch(currentTime - 3600000*24).toMSecsSinceEpoch();

    double minimum24h(0.0f);
    double maximum24h(0.0f);

    if (priceModel->isEmpty())
    {
        minimum24h = 0.0f;
        maximum24h = 0.0f;
    }
    else
    {
        minimum24h = priceModel->last().price;
        maximum24h = priceModel->last().price;

        for (auto i = priceModel->size()-1; i >= 0; --i)
        {
            double currPrice = priceModel->at(i).price;

            if (minimum24h > currPrice)
                minimum24h = currPrice;
            if (maximum24h < currPrice)
                maximum24h = currPrice;

            if (priceModel->at(i).time < timeMinus24h)
                break;
        }
    }

    emit minimum24hChanged(minimum24h);
    emit maximum24hChanged(maximum24h);

    emit finished();
}

void CreateCandleChart::createCandleModel(bool key)
{
    Q_ASSERT_X(!m_priceModel.isNull(), "createCandleModel() priceModel is null", 0);
    Q_ASSERT_X(!m_candleModel.isNull(), "createCandleModel() candleModel is null", 0);
    auto priceModel = m_priceModel.lock();
    auto candleModel = m_candleModel.lock();

    qint64 currentTime = QDateTime::currentDateTime().toMSecsSinceEpoch();

    qint64 timeLength = 0;

    if (!priceModel->isEmpty())
        timeLength = currentTime - priceModel->first().time;

    int length = timeLength / m_chartInfo.candleWidth;
    if (timeLength % m_chartInfo.candleWidth)
        ++length;

    length = m_limitIndexesModel < length ? m_limitIndexesModel : length;

    candleModel->resize(length);

    int maxIndexModel = candleModel->size() - 1;
    int lastPriceIndex = priceModel->size() - 1;

    qint64 lastTime = currentTime;

    for(int i = maxIndexModel; i >=0 ; i--)
    {
        qint64 minTime;
        qint64 remains = lastTime % m_chartInfo.candleWidth;
        if(remains > 0)
        {
            minTime = lastTime - remains;
        }
        else
        {
            minTime = lastTime - m_chartInfo.candleWidth;
        }


        double open = 0;
        double close = 0;
        double min = 0;
        double max = 0;
        double sum = 0;
        int counter = 1;

        if(i == maxIndexModel)
        {
            open = close = min = max = sum = priceModel->at(lastPriceIndex).price;
        }
        else
        {
            open = close = min = max = sum = candleModel->at(i+1).open;
        }

        while(minTime < priceModel->at(lastPriceIndex).time)
        {
            auto currPrice = priceModel->at(lastPriceIndex).price;

            if(min > currPrice)
            {
                min = currPrice;
            }
            if(max < currPrice)
            {
                max = currPrice;
            }
            sum += currPrice;
            counter++;
            lastPriceIndex--;
            if(lastPriceIndex < 0)
            {
                lastPriceIndex = 0;
                break;
            }
        }

        if(open != priceModel->at(lastPriceIndex).price)
        {
            open = priceModel->at(lastPriceIndex).price;
        }

        if(lastTime == currentTime)
        {
            counter = 1;
            sum = priceModel->at(priceModel->size() - 1).price;
        }

        min = std::min(open,min);
        min = std::min(close,min);
        max = std::max(open,max);
        max = std::max(close,max);


        CandleInfo info {minTime + m_chartInfo.candleWidth / 2,
                        open, close, min, max, sum/counter};

        (*candleModel)[i] = info;
        lastTime = minTime;
    }

    if (m_chartInfo.lastCandleNumber != candleModel->size() - 1 &&
        !candleModel->isEmpty())
    {
        qint64 lastTime = candleModel->last().time;
        if (m_chartInfo.rightCandleNumber == m_chartInfo.lastCandleNumber &&
            m_chartInfo.rightTime < lastTime + m_chartInfo.candleWidth * 1.1 &&
            m_chartInfo.rightTime > lastTime - m_chartInfo.candleWidth * 1.1)
        {
            emit resetRightTimeSignal();
        }
        emit lastCandleNumberChanged(candleModel->size()-1);
    }
}

void CreateCandleChart::createAveragedModel()
{
    Q_ASSERT_X(m_averageDelta, "createAveragedModel() averageDelta is null", 0);
    Q_ASSERT_X(!m_candleModel.isNull(), "createAveragedModel() candleModel is null", 0);
    Q_ASSERT_X(!m_averagedModel.isNull(), "createAveragedModel() averagedModel is null", 0);
    auto candleModel = m_candleModel.lock();
    auto averagedModel = m_averagedModel.lock();

    (*averagedModel)[m_indexAveragedModel].resize(candleModel->size());

    int tempIndex = 0;

    if (m_averagedKey)
    {
        tempIndex = (*averagedModel)[m_indexAveragedModel].size() -
                    m_averageDelta->at(m_indexAveragedModel) - 2;

        if (tempIndex < 0)
            tempIndex = 0;
    }

    for (auto i = tempIndex; i < candleModel->size(); ++i)
    {
        double value = 0;
        double valsum = 0;
        double pricesum = 0;

        int start = i - m_averageDelta->at(m_indexAveragedModel);

        for (auto k = i - m_averageDelta->at(m_indexAveragedModel);
             k <= i + m_averageDelta->at(m_indexAveragedModel); ++k)
        {
            if (k < 0)
                continue;
            if (k >= candleModel->size())
                break;

            if (k < i)
                value = m_averageDelta->at(m_indexAveragedModel) - (i - k) + 1;
            else
                value = m_averageDelta->at(m_indexAveragedModel) + (i - k) + 1;

            valsum += value;

            pricesum += value * candleModel->at(k).average;
        }

        PriceInfo info{candleModel->at(i).time, pricesum/valsum};

        (*averagedModel)[m_indexAveragedModel][i] = info;
    }
    emit finished();
}

void CreateCandleChart::checkNewRoundPower()
{
    int tempPower = -10;
    double tempMask = pow (10, tempPower);

    while (tempMask < m_chartInfo.currentTokenPrice && tempPower < 77)
    {
        ++tempPower;

        tempMask = pow (10, tempPower);
    }

    int tempCommonPower = - tempPower + m_commonRoundPowerDelta;

    if (tempCommonPower > 8)
        tempCommonPower = 8;
    if (tempCommonPower < 0)
        tempCommonPower = 0;

    if (tempCommonPower != m_chartInfo.commonRoundPower)
    {
        emit commonRoundPowerChanged(tempCommonPower);
    }

    emit finished();
}

