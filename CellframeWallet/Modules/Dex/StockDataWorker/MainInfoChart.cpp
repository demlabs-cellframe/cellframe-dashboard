#include "MainInfoChart.h"

void MainInfoChart::onInit()
{
}

void MainInfoChart::moveFrom(MainInfoChart& other)
{
    if (this == &other)
        return ;

    m_priceModel.swap(other.m_priceModel);
    m_candleModel.swap(other.m_candleModel);
    m_averagedModel.swap(other.m_averagedModel);

    m_currentTokenPriceText = other.m_currentTokenPriceText;
    m_currentTokenPrice = other.m_currentTokenPrice;
    m_previousTokenPrice = other.m_previousTokenPrice;
    m_minimum24h = other.m_minimum24h;
    m_maximum24h = other.m_maximum24h;

    m_lastCandleNumber = other.m_lastCandleNumber;
    m_rightCandleNumber = other.m_rightCandleNumber;
    m_commonRoundPower = other.m_commonRoundPower;
    m_rightTime = other.m_rightTime;
}

MainInfoChart& MainInfoChart::operator=(const MainInfoChart& other)
{
    if (this == &other)
        return *this;

    m_priceModel = other.m_priceModel;
    m_candleModel = other.m_candleModel;
    m_averagedModel = other.m_averagedModel;

    m_currentTokenPriceText = other.m_currentTokenPriceText;
    m_currentTokenPrice = other.m_currentTokenPrice;
    m_previousTokenPrice = other.m_previousTokenPrice;
    m_minimum24h = other.m_minimum24h;
    m_maximum24h = other.m_maximum24h;

    m_lastCandleNumber = other.m_lastCandleNumber;
    m_rightCandleNumber = other.m_rightCandleNumber;
    m_commonRoundPower = other.m_commonRoundPower;
    m_rightTime = other.m_rightTime;

    return *this;
}

MainInfoChart& MainInfoChart::operator=(const MainInfoChart&& other)
{
    if (this == &other)
        return *this;

    m_priceModel = other.m_priceModel;
    m_candleModel = other.m_candleModel;
    m_averagedModel = other.m_averagedModel;

    m_currentTokenPriceText = other.m_currentTokenPriceText;
    m_currentTokenPrice = other.m_currentTokenPrice;
    m_previousTokenPrice = other.m_previousTokenPrice;
    m_minimum24h = other.m_minimum24h;
    m_maximum24h = other.m_maximum24h;

    m_lastCandleNumber = other.m_lastCandleNumber;
    m_rightCandleNumber = other.m_rightCandleNumber;
    m_commonRoundPower = other.m_commonRoundPower;

    m_rightTime = other.m_rightTime;
    return *this;
}

void MainInfoChart::clear()
{
    m_priceModel.clear();
    m_candleModel.clear();

    m_currentTokenPriceText = "0.0";
    m_currentTokenPrice = 0.0f;
    m_previousTokenPrice = 0.0f;
    m_minimum24h = 0.0f;
    m_maximum24h = 0.0f;    

    m_lastCandleNumber = 0;
    m_rightCandleNumber = 0;
    m_commonRoundPower = 8;

    m_rightTime = 0;
}
