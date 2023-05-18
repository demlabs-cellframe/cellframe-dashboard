#include "historyworker.h"

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>

#include <QDebug>

static HistoryModel *s_historyModel = HistoryModel::global();

HistoryWorker::HistoryWorker(QQmlContext *cont, QObject *parent) :
    QObject(parent),
    context(cont)
{
    context->setContextProperty("modelLastActions", s_historyModel);
    context->setContextProperty("modelHistory", s_historyModel);
}

void HistoryWorker::setHistoryModel(const QVariant &rcvData)
{
    qDebug() << "HistoryWorker::setHistoryModel"
             << "isEqual" << (rcvData.toString() == "isEqual");

    if(rcvData.toString() == "isEqual")
        return;

    QJsonDocument doc = QJsonDocument::fromJson(rcvData.toByteArray());

//    if (!doc.isArray())
//        return;

    if (!doc.isObject())
        return;

    if (doc["walletName"].toString() != m_walletName ||
        doc["isLastActions"].toBool() != m_isLastActions )
    {
        qWarning() << "ERROR"
                   << "walletName" << doc["walletName"].toString() << m_walletName
                   << "isLastActions" << doc["isLastActions"].toBool() << m_isLastActions;
        return;
    }

    qDebug() << "walletName" << doc["walletName"].toString()
            << "isLastActions" << doc["isLastActions"].toBool();

//    historyModel.clear();
    fullModel.clear();

    QJsonArray historyArray = doc["history"].toArray();

    qDebug() << "historyArray.size()" << historyArray.size();

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

        HistoryModel::Item itemHistory;
        itemHistory.fee_token    = historyArray.at(i)["fee_token"].toString();
        itemHistory.fee          = historyArray.at(i)["fee"].toString();
        itemHistory.value        = historyArray.at(i)["value"].toString();
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

//        fullModel.add(itemHistory);

/*        auto test = fullModel.indexOf(itemHistory);

        if(test == -1)
            fullModel.add(itemHistory);
        else
            fullModel.set(test, itemHistory);*/
    }

    sendCurrentHistoryModel();

    //    emit pairModelUpdated();
}

void HistoryWorker::setLastActions(bool flag)
{
    qDebug() << "HistoryWorker::setLastActions" << flag;

    if (m_isLastActions != flag)
    {
        m_isLastActions = flag;

        s_historyModel->clear();
    }
}

void HistoryWorker::setWalletName(QString str)
{
    qDebug() << "HistoryWorker::setWalletName" << str;

    if (m_walletName != str)
    {
        m_walletName = str;

        s_historyModel->clear();
    }
}


void HistoryWorker::setCurrentStatus(QString str)
{
    qDebug() << "HistoryWorker::setCurrentStatus" << str;

    if (m_currentStatus != str)
    {
        m_currentStatus = str;

        sendCurrentHistoryModel();
    }
}

void HistoryWorker::setFilterString(QString str)
{
    qDebug() << "HistoryWorker::setFilterString" << str;

    if (m_filterString != str)
    {
        m_filterString = str;

        sendCurrentHistoryModel();
    }
}

void HistoryWorker::setCurrentPeriod(QVariant str)
{
    qDebug() << "HistoryWorker::setCurrentPeriod" << str;

    if (m_currentPeriod != str.toStringList()[0] || m_isRange != (str.toStringList()[1] == "true" ))
    {

        m_currentPeriod = str.toStringList()[0];
        m_isRange = str.toStringList()[1] == "true";

        sendCurrentHistoryModel();
    }
}

void HistoryWorker::sendCurrentHistoryModel()
{
//    model.clear();

    QDateTime currDate = QDateTime::currentDateTime();

    QString today = currDate.toString("yyyy-MM-dd");

    QString yesterday = currDate.addDays(-1).toString("yyyy-MM-dd");

    qint64 lastTime = 0;
    QString lastDate = "";

    qint64 prevTime = 0;
    QString prevDate = "";

    m_sectionNumber = 0;
    m_elementNumber = 0;

//    qint64 date_to_secs = date.toSecsSinceEpoch();

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
            const HistoryModel::Item &item = fullModel.getItem(i);

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

    qDebug() << "HistoryWorker::sendCurrentHistoryModel"
             << "lastDate" << lastDate
             << "prevDate" << prevDate;

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
        const HistoryModel::Item &item = fullModel.getItem(i);

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
                [](const HistoryModel::Item& item, const QString& str) -> bool{

                    QString fstr = str.toLower();

                    if(item.network.isEmpty() || item.token.isEmpty() || item.tx_status.isEmpty() ||
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

//    qDebug() << "HistoryWorker::sendCurrentHistoryModel" << s_historyModel->size();

//    if (m_isLastActions)
//        context->setContextProperty("modelLastActions", s_historyModel);
//    else
//        context->setContextProperty("modelHistory", s_historyModel);
}
