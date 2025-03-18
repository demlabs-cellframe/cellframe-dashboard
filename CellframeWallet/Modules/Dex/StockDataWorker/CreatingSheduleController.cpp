#include "CreatingSheduleController.h"
#include <QJsonObject>


CreatingSheduleController::CreatingSheduleController(QObject *parent)
    : QObject{parent}
    , m_priceModel(new QVector<PriceInfo>())
    , m_candleModel(new QVector<CandleInfo>())
    , m_averagedModel(new QVector <QVector <PriceInfo>>())
{
}

CreatingSheduleController::~CreatingSheduleController()
{
}

void CreatingSheduleController::setMemderAverageCharts(int charts)
{
    m_memderAverageCharts = charts;
    m_averagedModel->resize(m_memderAverageCharts);
}

void CreatingSheduleController::startProcess()
{
    for(auto& item: m_levelProcess)
    {
        item=false;
    }
    m_countAveragedModel = 0;

    switch (m_type)
    {
    case TypeProcessing::NEW_HISTORY:
        startHistoryUpdate();
        break;
    case TypeProcessing::NEW_PRICE:
        addNewPrice();
        break;
    case TypeProcessing::RESET_UPDATE:
        startResetUpdate();
        break;
    default:
        break;
    }
}

void CreatingSheduleController::LastDataPrepaeration()
{
    emit currentTokenPriceChanged(m_currentTokenPrice);
    emit previousTokenPriceChanged(m_previousTokenPrice);
    emit currentTokenPriceTextChanged(m_currentTokenPriceText);
}

void CreatingSheduleController::startHistoryUpdate()
{
    creatPriceModel();
    createMinimumMaximum24hThread();
    creatHistoryThread();
    checkNewRoundPowerThread();
}

void CreatingSheduleController::creatPriceModel()
{
    (*m_priceModel).resize(m_historyArray.size());

    for(auto i = 0; i < m_historyArray.size(); i++)
    {
        QJsonObject item = m_historyArray[i].toObject();
        QString priceText = item["rate"].toString();
        double price = priceText.toDouble();
        qint64 time = item["time"].toString().toLongLong();
        PriceInfo info{time, price, priceText};
        (*m_priceModel)[i] = std::move(info);
    }

    m_historyArray = QJsonArray();

    std::sort (m_priceModel->begin(), m_priceModel->end(),
              [](const PriceInfo& lha, const PriceInfo& rha){
                  return lha.time < rha.time;
              });


    if (m_priceModel->size() > 0)
    {
        auto lastPrice = m_priceModel->last();
        m_currentTokenPrice = lastPrice.price;
        m_previousTokenPrice = lastPrice.price;
        m_currentTokenPriceText = lastPrice.priceText;
    }
    if (m_priceModel->size() > 1)
    {
        m_previousTokenPrice = m_priceModel->at(m_priceModel->size()-2).price;
    }

    m_chartInfo.currentTokenPrice = m_currentTokenPrice;
    finalActions(ThreadsType::PRICE);
}

void CreatingSheduleController::initThread(CreateCandleChart* chartCounting)
{
    chartCounting->setChartProperty(m_chartInfo);
    chartCounting->setTypeProcess(m_type);
    chartCounting->setAverageDelta(m_averageDelta);
    chartCounting->setCommonRoundPowerDelta(m_commonRoundPowerDelta);
    chartCounting->setMemderAverageCharts( m_memderAverageCharts);

    chartCounting->setMinAverageStep(m_minAverageStep);
    chartCounting->setFirstVisibleAverage(m_firstVisibleAverage);
    chartCounting->setLastVisibleAverage(m_lastVisibleAverage);

    connect(chartCounting, &CreateCandleChart::minimum24hChanged,  [this](double min){ m_minimum24h = min; });
    connect(chartCounting, &CreateCandleChart::maximum24hChanged, [this](double max){ m_maximum24h = max; });
    connect(chartCounting, &CreateCandleChart::lastCandleNumberChanged, [this](int val){ m_lastCandleNumber = val; });
    connect(chartCounting, &CreateCandleChart::commonRoundPowerChanged, [this](int val){ m_commonRoundPower = val; });

    connect(chartCounting, &CreateCandleChart::finished, chartCounting, &CreateCandleChart::deleteLater);
}

void CreatingSheduleController::creatHistoryThread()
{
    Q_ASSERT_X(m_priceModel, "creatHistoryThread() priceModel is null", 0);
    Q_ASSERT_X(m_candleModel, "creatHistoryThread() candleModel is null", 0);
    Q_ASSERT_X(m_averagedModel, "creatHistoryThread() averagedModel is null", 0);
    CreateCandleChart* chart = new CreateCandleChart(nullptr, m_priceModel.toWeakRef(), m_candleModel.toWeakRef(), m_averagedModel.toWeakRef());
    initThread(chart);

    QThread *thread = new QThread;
    chart->moveToThread(thread);

    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    connect(chart, &CreateCandleChart::finished, thread, &QThread::quit);
    connect(chart, &CreateCandleChart::finished, [this](){
    });

    connect(thread, &QThread::started, chart, &CreateCandleChart::tryCreateCandleModel);
    connect(chart, &CreateCandleChart::finished, this, &CreatingSheduleController::candleModelCreated);
    thread->start();
}

void CreatingSheduleController::candleModelCreated()
{
    createAveragedModels();
    resetRightTime();

    finalActions(ThreadsType::CANDLE);
}

void CreatingSheduleController::finalActions(ThreadsType type)
{
    m_levelProcess[type] = true;

    if(m_type == TypeProcessing::NEW_HISTORY)
    {
        int count = 0;
        for(auto item: m_levelProcess)
        {
            if(item) count++;
        }
        if(count == m_levelProcess.size())
        {           
            MainInfoChart result;
            result.m_priceModel.swap(*m_priceModel);
            result.m_previousTokenPrice = m_previousTokenPrice;
            result.m_currentTokenPrice = m_currentTokenPrice;
            result.m_currentTokenPriceText = m_currentTokenPriceText;
            result.m_candleModel.swap(*m_candleModel);
            result.m_lastCandleNumber = m_lastCandleNumber;
            result.m_rightTime = m_rightTime;
            result.m_averagedModel.swap(*m_averagedModel);
            result.m_minimum24h = m_minimum24h;
            result.m_maximum24h = m_maximum24h;
            result.m_commonRoundPower = m_commonRoundPower;
            result.m_currentTokenPrice = m_currentTokenPrice;
            result.m_rightCandleNumber = m_rightCandleNumber;

            emit finished(m_type, std::move(result));
        }
    }
    else if(m_type == TypeProcessing::RESET_UPDATE)
    {

        int count = 0;
        for(auto item: m_levelProcess)
        {
            if(item) count++;
        }
        if(count == m_levelProcess.size() - 1)
        {

            MainInfoChart result;
            result.m_previousTokenPrice = m_previousTokenPrice;
            result.m_currentTokenPrice = m_currentTokenPrice;
            result.m_currentTokenPriceText = m_currentTokenPriceText;
            result.m_candleModel.swap(*m_candleModel);
            result.m_lastCandleNumber = m_lastCandleNumber;
            result.m_rightTime = m_rightTime;
            result.m_averagedModel.swap(*m_averagedModel);
            result.m_minimum24h = m_minimum24h;
            result.m_maximum24h = m_maximum24h;
            result.m_commonRoundPower = m_commonRoundPower;
            result.m_currentTokenPrice = m_currentTokenPrice;
            result.m_rightCandleNumber = m_rightCandleNumber;

            emit finished(m_type, std::move(result));
        }
    }
    else if(m_type == TypeProcessing::NEW_PRICE)
    {

        int count = 0;
        for(auto item: m_levelProcess)
        {
            if(item) count++;
        }
        if(count == m_levelProcess.size() - 1)
        {
            MainInfoChart result;
            result.m_previousTokenPrice = m_previousTokenPrice;
            result.m_currentTokenPrice = m_currentTokenPrice;
            result.m_currentTokenPriceText = m_currentTokenPriceText;
            result.m_candleModel.swap(*m_candleModel);
            result.m_lastCandleNumber = m_lastCandleNumber;
            result.m_rightTime  = m_rightTime;
            result.m_averagedModel.swap(*m_averagedModel);
            result.m_minimum24h = m_minimum24h;
            result.m_maximum24h = m_maximum24h;
            result.m_commonRoundPower = m_commonRoundPower;
            result.m_currentTokenPrice = m_currentTokenPrice;
            result.m_rightCandleNumber = m_rightCandleNumber;

            emit finished(m_type, std::move(result));
        }
    }
}

void CreatingSheduleController::resetRightTime()
{
    if (!m_candleModel->isEmpty())
        m_rightTime = m_candleModel->last().time + m_chartInfo.candleWidth / 2;
    else
        m_rightTime = QDateTime::currentDateTime().toMSecsSinceEpoch() + m_chartInfo.candleWidth;
}

void CreatingSheduleController::addCountAveragedModel()
{
    m_countAveragedModel++;
    if(m_countAveragedModel == m_memderAverageCharts)
    {
        finalActions(ThreadsType::AVERAGE);
    }
}

void CreatingSheduleController::createAveragedModels()
{
    if(m_averagedModel->size() < m_memderAverageCharts)
    {
        (*m_averagedModel).resize(m_memderAverageCharts);
    }
    for (auto ch = 0; ch < m_memderAverageCharts; ++ch)
    {
        Q_ASSERT_X(m_priceModel, "createAveragedModels() priceModel is null", 0);
        Q_ASSERT_X(m_candleModel, "createAveragedModels() candleModel is null", 0);
        Q_ASSERT_X(m_averagedModel, "createAveragedModels() averagedModel is null", 0);
        CreateCandleChart* chart = new CreateCandleChart(nullptr, m_priceModel.toWeakRef(), m_candleModel.toWeakRef(), m_averagedModel.toWeakRef());
        initThread(chart);
        chart->setAveragedKey(false);
        chart->setIndexAveragedModel(ch);

        QThread *thread = new QThread;
        chart->moveToThread(thread);

        connect(thread, &QThread::finished, thread, &QThread::deleteLater);
        connect(chart, &CreateCandleChart::finished, thread, &QThread::quit);
        connect(thread, &QThread::started, chart, &CreateCandleChart::createAveragedModel);
        connect(chart, &CreateCandleChart::finished, this, &CreatingSheduleController::addCountAveragedModel);
        thread->start();
    }
}

void CreatingSheduleController::createMinimumMaximum24hThread()
{
    Q_ASSERT_X(m_priceModel, "createMinimumMaximum24hThread() priceModel is null", 0);
    Q_ASSERT_X(m_candleModel, "createMinimumMaximum24hThread() candleModel is null", 0);
    Q_ASSERT_X(m_averagedModel, "createMinimumMaximum24hThread() averagedModel is null", 0);
    CreateCandleChart* chart = new CreateCandleChart(nullptr,m_priceModel.toWeakRef(), m_candleModel.toWeakRef(), m_averagedModel.toWeakRef());
    initThread(chart);

    QThread *thread = new QThread;
    chart->moveToThread(thread);

    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    connect(chart, &CreateCandleChart::finished, thread, &QThread::quit);
    connect(chart, &CreateCandleChart::finished, [this](){
        finalActions(ThreadsType::MIN_MAX);
    });
    connect(thread, &QThread::started, chart, &CreateCandleChart::createMinimumMaximum24h);
    thread->start();
}

void CreatingSheduleController::checkNewRoundPowerThread()
{
    Q_ASSERT_X(m_priceModel, "checkNewRoundPowerThread() priceModel is null", 0);
    Q_ASSERT_X(m_candleModel, "checkNewRoundPowerThread() candleModel is null", 0);
    Q_ASSERT_X(m_averagedModel, "checkNewRoundPowerThread() averagedModel is null", 0);
    CreateCandleChart* chart = new CreateCandleChart(nullptr,m_priceModel.toWeakRef(), m_candleModel.toWeakRef(), m_averagedModel.toWeakRef());
    initThread(chart);

    QThread *thread = new QThread;
    chart->moveToThread(thread);

    connect(thread, &QThread::finished, thread, &QThread::deleteLater);
    connect(chart, &CreateCandleChart::finished, thread, &QThread::quit);
    connect(chart, &CreateCandleChart::finished, [this]()
    {
        finalActions(ThreadsType::ROUND_POWER);
    });
    connect(thread, &QThread::started, chart, &CreateCandleChart::checkNewRoundPower);
    thread->start();
}

void CreatingSheduleController::addNewPrice()
{
    createMinimumMaximum24hThread();
    creatHistoryThread();
    checkNewRoundPowerThread();
}

void CreatingSheduleController::startResetUpdate()
{
    createMinimumMaximum24hThread();
    creatHistoryThread();
    checkNewRoundPowerThread();
}
