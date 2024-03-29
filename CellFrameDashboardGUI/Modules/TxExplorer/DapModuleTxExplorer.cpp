#include "DapModuleTxExplorer.h"
#include <QQmlContext>

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>

#include <QDebug>

static DapHistoryModel *s_historyModel = DapHistoryModel::global();

DapModuleTxExplorer::DapModuleTxExplorer(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_timerHistoryUpdate(new QTimer(this))
{
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelLastActions", s_historyModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelHistory", s_historyModel);

    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        initConnect();
        updateHistory(true);
    });
    connect(m_modulesCtrl, &DapModulesController::currentWalletNameChanged, [this] ()
            {
                this->setWalletName(m_modulesCtrl->getCurrentWalletName());
            });
}

void DapModuleTxExplorer::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived,
            this, &DapModuleTxExplorer::setHistoryModel,
            Qt::QueuedConnection);
    connect(m_timerHistoryUpdate, &QTimer::timeout,
            this, &DapModuleTxExplorer::slotHistoryUpdate,
            Qt::QueuedConnection);

    connect(this, &DapAbstractModule::statusProcessingChanged, [=]
    {
//            qDebug()<<"m_statusProcessing" << m_statusProcessing;
        if(m_statusProcessing)
        {
            m_timerHistoryUpdate->start(10000);
            sendCurrentHistoryModel();
        }
        else
        {
            m_timerHistoryUpdate->stop();
            setStatusInit(false);
        }
    });
}

void DapModuleTxExplorer::setHistoryModel(const QVariant &rcvData)
{
    isSendReqeust = false;
//    qDebug() << "DapModuleTxExplorer::setHistoryModel"
//             << "isEqual" << (rcvData.toString() == "isEqual");
    if(rcvData.toString() == "isEqual")
        return;

    QJsonDocument doc = QJsonDocument::fromJson(rcvData.toByteArray());

    if (!doc.isObject())
        return;

    if (doc["walletName"].toString() != m_walletName /*||
        doc["isLastActions"].toBool() != m_isLastActions */)
    {
        qWarning() << "ERROR"
                   << "walletName" << doc["walletName"].toString() << m_walletName
                   << "isLastActions" << doc["isLastActions"].toBool() << m_isLastActions;
        return;
    }

//    qDebug() << "walletName" << doc["walletName"].toString()
//            << "isLastActions" << doc["isLastActions"].toBool();
    fullModel.clear();

    QJsonArray historyArray = doc["history"].toArray();

//    qDebug() << "historyArray.size()" << historyArray.size();

    for(auto i = 0; i < historyArray.size(); i++)
    {
//        qDebug() << i << historyArray.at(i)["tx_status"].toString()
//                 << historyArray.at(i)["tx_hash"].toString()
//                 << historyArray.at(i)["atom"].toString()
//                 << historyArray.at(i)["network"].toString()
//                 << historyArray.at(i)["wallet_name"].toString()
//                 << historyArray.at(i)["date"].toString()
//                 << historyArray.at(i)["date_to_secs"].toString().toLongLong()
//                 << historyArray.at(i)["address"].toString()
//                 << historyArray.at(i)["status"].toString()
//                 << historyArray.at(i)["token"].toString()
//                 << historyArray.at(i)["direction"].toString()
//                 << historyArray.at(i)["value"].toString()
//                 << historyArray.at(i)["fee"].toString()
//                 << historyArray.at(i)["fee_token"].toString();

        DapHistoryModel::Item itemHistory;
        itemHistory.fee_token    = historyArray.at(i)["fee_token"].toString();
        itemHistory.fee_net      = historyArray.at(i)["fee_net"].toString();
        itemHistory.fee          = historyArray.at(i)["fee"].toString();
        itemHistory.value        = historyArray.at(i)["value"].toString();
        itemHistory.m_value      = historyArray.at(i)["m_value"].toString();
        itemHistory.m_token      = historyArray.at(i)["m_token"].toString();
        itemHistory.m_direction  = historyArray.at(i)["m_direction"].toString();
        itemHistory.direction    = historyArray.at(i)["direction"].toString();
        itemHistory.token        = historyArray.at(i)["token"].toString();
        itemHistory.status       = historyArray.at(i)["status"].toString();
        itemHistory.address      = historyArray.at(i)["address"].toString();
        itemHistory.date_to_secs = historyArray.at(i)["date_to_secs"].toString().toLongLong();
        itemHistory.date         = historyArray.at(i)["date"].toString();
        itemHistory.wallet_name  = historyArray.at(i)["wallet_name"].toString();
        itemHistory.network      = historyArray.at(i)["network"].toString();
        itemHistory.atom         = historyArray.at(i)["atom"].toString();
        itemHistory.tx_hash      = historyArray.at(i)["tx_hash"].toString();
        itemHistory.tx_status    = historyArray.at(i)["tx_status"].toString();

        QDateTime time = QDateTime::fromSecsSinceEpoch(itemHistory.date_to_secs);
        itemHistory.time = time.toString("hh:mm:ss");


        int index = fullModel.indexOfTime(itemHistory.date_to_secs);

//        qDebug() << "index" << index
//                 << "itemHistory.date_to_secs" << itemHistory.date_to_secs
//                 << historyArray.at(i)["date_to_secs"].toString()
//                 << historyArray.at(i)["tx_hash"].toString();

        fullModel.insert(index, itemHistory);
    }

    if(!fullModel.size())
        setStatusInit(true);

    sendCurrentHistoryModel();
}

void DapModuleTxExplorer::clearHistory()
{
    s_historyModel->clear();
}


void DapModuleTxExplorer::setLastActions(bool flag)
{
//    qDebug() << "DapModuleTxExplorer::setLastActions" << flag;

    if (m_isLastActions != flag)
    {
        m_isLastActions = flag;
        sendCurrentHistoryModel();
    }
}

void DapModuleTxExplorer::setWalletName(QString str)
{
//    qDebug() << "DapModuleTxExplorer::setWalletName" << str;

    if (m_walletName != str)
    {
        m_walletName = str;

        fullModel.clear();
        isSendReqeust = false;
        updateHistory(true);
        setStatusInit(false);
        sendCurrentHistoryModel();
    }
}


void DapModuleTxExplorer::setCurrentStatus(QString str)
{
//    qDebug() << "DapModuleTxExplorer::setCurrentStatus" << str;

    if (m_currentStatus != str)
    {
        m_currentStatus = str;

        sendCurrentHistoryModel();
    }
}

void DapModuleTxExplorer::setFilterString(QString str)
{
//    qDebug() << "DapModuleTxExplorer::setFilterString" << str;

    if (m_filterString != str)
    {
        m_filterString = str;

        sendCurrentHistoryModel();
    }
}

void DapModuleTxExplorer::setCurrentPeriod(QVariant str)
{
//    qDebug() << "DapModuleTxExplorer::setCurrentPeriod" << str;

    if (m_currentPeriod != str.toStringList()[0] || m_isRange != (str.toStringList()[1] == "true" ))
    {

        m_currentPeriod = str.toStringList()[0];
        m_isRange = str.toStringList()[1] == "true";

        sendCurrentHistoryModel();
    }
}

void DapModuleTxExplorer::sendCurrentHistoryModel()
{
//    model.clear();

    if(m_walletName != m_modulesCtrl->getCurrentWalletName() || !fullModel.size())
    {
        s_historyModel->clear();
        return;
    }

    QDateTime currDate = QDateTime::currentDateTime();

    QString today = currDate.toString("yyyy-MM-dd");

    QString yesterday = currDate.addDays(-1).toString("yyyy-MM-dd");

    qint64 lastTime = 0;
    QString lastDate = "";

    qint64 prevTime = 0;
    QString prevDate = "";

    m_sectionNumber = 0;
    m_elementNumber = 0;

    QSet<QString> weekSet;
    for (auto i = 0; i < 7; ++i)
        weekSet.insert(currDate.addDays(-i).toString("yyyy-MM-dd"));

//    qDebug() << "today" << today
//             << "yesterday" << yesterday
//             << "weekSet" << weekSet;

    if (m_isLastActions)
    {
        for (auto i = 0; i < fullModel.size(); ++i)
        {
            const DapHistoryModel::Item &item = fullModel.getItem(i);

            if (lastTime < item.date_to_secs)
            {
                lastTime = item.date_to_secs;
                lastDate = item.date;
            }

            if (prevTime < item.date_to_secs
                && lastTime != item.date_to_secs
                && item.date != lastDate)
            {
                prevTime = item.date_to_secs;
                prevDate = item.date;
            }
        }
    }

//    qDebug() << "DapModuleTxExplorer::sendCurrentHistoryModel"
//             << "lastDate" << lastDate
//             << "prevDate" << prevDate;

    bool lastDateUsed = false;
    bool prevDateUsed = false;

    s_historyModel->clear();

    auto lastActionsSize = 0;

    m_historyMore15 = false;

    QDateTime begin, end;

    if (m_isRange)
    {
        int index = m_currentPeriod.indexOf('-');

        auto getDate =
            [](const QString& date) -> QDateTime{
                return QDateTime::fromString(date, "dd.MM.yyyy");
            };

        begin = getDate(m_currentPeriod.mid(0, index));
        end = getDate(m_currentPeriod.mid(index+1));
        end = end.addMSecs(86399999); // 00:00:00 + 23:59:59:9999
    }

    for (auto i = 0; i < fullModel.size(); ++i)
    {
        const DapHistoryModel::Item &item = fullModel.getItem(i);

        QString status = item.tx_status == "ACCEPTED" || item.tx_status == "PROCESSING" ?
                    item.status : "Error";

        if (m_isLastActions)
        {

            if (item.date == lastDate || item.date == prevDate)
            {
                ++lastActionsSize;

                if (lastActionsSize > 15)
                {
                    m_historyMore15 = true;
                    break;
                }

                if (item.date == lastDate)
                    lastDateUsed = true;
                if (item.date == prevDate)
                    prevDateUsed = true;

                s_historyModel->add(item);
                ++m_elementNumber;
            }
        }
        else
        {
            auto checkText =
                [](const DapHistoryModel::Item& item, const QString& str) -> bool{

                    QString fstr = str.toLower();

                    if(item.network.isEmpty() || ( item.token.isEmpty() && item.tx_status != "PROCESSING") || item.tx_status.isEmpty() ||
                       item.status.isEmpty() || item.value.isEmpty() || item.date.isEmpty())
                        return false;

                    if (item.network.toLower().indexOf(fstr) >= 0)
                        return true;

                    if (item.token.toLower().indexOf(fstr) >= 0)
                        return true;

                    QString statusStr = item.tx_status == "ACCEPTED" || item.tx_status == "PROCESSING"  ? item.status : "Declined";
                    if (statusStr.toLower().indexOf(fstr) >= 0)
                        return true;

                    if (item.value.toLower().indexOf(fstr) >= 0)
                        return true;

                    return false;
                };

            if(m_filterString == "" || checkText(item,m_filterString))
            {
                if (m_currentStatus == "All statuses" || m_currentStatus == status)
                {
                    if(m_isRange)
                    {
                        QDateTime payDay = QDateTime::fromSecsSinceEpoch(item.date_to_secs);
                        if(payDay >= begin && payDay <= end)
                            s_historyModel->add(item);
                    }else
                     if (m_currentPeriod == "All time" ||
                        (m_currentPeriod == "Today" &&
                         item.date == today) ||
                        (m_currentPeriod == "Yesterday" &&
                         item.date == yesterday) ||
                        (m_currentPeriod == "Last week" &&
                         weekSet.contains(item.date)) )
                        s_historyModel->add(item);
                }
            }
        }
    }

    if (lastDateUsed)
        ++m_sectionNumber;
    if (prevDateUsed)
        ++m_sectionNumber;

    emit updateHistoryModel();

    emit historyMore15Changed(m_historyMore15);

    setStatusInit(true);

//    qDebug() << "DapModuleTxExplorer::sendCurrentHistoryModel" << s_historyModel->size();
}

void DapModuleTxExplorer::slotHistoryUpdate()
{
    updateHistory(false);
}

void DapModuleTxExplorer::updateHistory(bool flag)
{
    QString currantWalletName = m_modulesCtrl->currentWalletName();

    if((currantWalletName.isEmpty() && (m_modulesCtrl->getCurrentWalletIndex() < 0)) || isSendReqeust)
        return ;

    m_timerHistoryUpdate->stop();
    s_serviceCtrl->requestToService("DapGetAllWalletHistoryCommand", QVariantList()<<m_modulesCtrl->getCurrentWalletName() << flag << m_isLastActions);
    m_timerHistoryUpdate->start(10000);
    isSendReqeust = true;
}
