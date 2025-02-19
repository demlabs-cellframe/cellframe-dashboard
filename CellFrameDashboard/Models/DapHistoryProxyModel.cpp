#include "DapHistoryProxyModel.h"

DapHistoryProxyModel::DapHistoryProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
{
}

bool DapHistoryProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    Q_UNUSED(source_parent)

    if(source_row == 0)
    {
        m_count = 0;

        m_daysSet.clear();
        m_tmpDataLastActions.clear();
        m_countDays = 0;
        if(!m_isRange)
        {
            QDateTime currDate = QDateTime::currentDateTime();

            if(m_currentPeriod == TODAY_TEXT)
            {
                m_daysSet.insert(currDate.toString("yyyy-MM-dd"));
            }
            else if(m_currentPeriod == YESTERDAY_TEXT)
            {
                m_daysSet.insert(currDate.addDays(-1).toString("yyyy-MM-dd"));
            }
            else if(m_currentPeriod == LAST_WEEK_TEXT)
            {
                for (auto i = 0; i < 7; ++i)
                    m_daysSet.insert(currDate.addDays(-i).toString("yyyy-MM-dd"));
            }
        }
    }

    if(m_networkFilter == "All" && m_currentPeriod == ALL_DAY_TEXT
        && !m_isLastActions && m_currentStatus == "All statuses" && m_filterString.isEmpty())
    {
        return true;
    }
    const DapHistoryModel* model = static_cast<DapHistoryModel*>(sourceModel());
    if(!model)
    {
        return true;
    }
    DapHistoryModel::Item item = model->getItem(source_row);
    bool isNetwork = false;
    bool isPeriod = false;
    bool isLast = false;
    bool isStatus = false;
    bool isFilter = false;

    if(m_networkFilter == "All" || item.network == m_networkFilter)
    {
        isNetwork = true;
    }

    if(m_isRange)
    {
        QDateTime payDay = QDateTime::fromSecsSinceEpoch(item.date_to_secs);
        if(payDay >= m_begin && payDay <= m_end)
            isPeriod = true;
    }
    else
    {
        if (m_currentPeriod == ALL_DAY_TEXT ||
            (MAIN_PERIOD_TYPE.contains(m_currentPeriod) && m_daysSet.contains(item.date)) )
        {
            isPeriod = true;
        }
    }

    if(m_isLastActions && source_row < MAX_TRANSACTIONS_LAST_ACTIONS)
    {
        if(m_tmpDataLastActions != item.date)
        {
            m_tmpDataLastActions = item.date;
            m_countDays++;
        }

        if(m_countDays <= MAX_DAYS_LAST_ACTIONS)
        {
            isLast = true;
        }

    }
    else if(!m_isLastActions)
    {
        isLast = true;
    }

    if(m_currentStatus == "All statuses")
    {
        isStatus = true;
    }
    else
    {
        if(m_currentStatus == "Declined")
        {
            if("DECLINED" == item.tx_status)
            {
                isStatus = true;
            }
        }
        else if(item.status == m_currentStatus && "DECLINED" != item.tx_status)
        {
            isStatus = true;
        }
    }

    if(m_filterString.isEmpty() || checkText(item, m_filterString))
    {
        isFilter = true;
    }

    if(isNetwork && isPeriod && isLast && isStatus && isFilter)
    {
        m_count++;
    }
    if(source_row ==  model->size() - 1)
    {
        const_cast<DapHistoryProxyModel*>(this)->tryCountChanged();
        m_lastCount = m_count;
    }

    return isNetwork && isPeriod && isLast && isStatus && isFilter;
}

void DapHistoryProxyModel::setNetworkFilter(const QString& value)
{
    m_networkFilter = value;
    invalidateFilter();
}

void DapHistoryProxyModel::setCurrentPeriod(const QVariant& str)
{
    if (m_currentPeriod != str.toStringList()[0] || m_isRange != (str.toStringList()[1] == "true" ))
    {
        m_currentPeriod = str.toStringList()[0];
        m_isRange = str.toStringList()[1] == "true";

        if (m_isRange)
        {
            int index = m_currentPeriod.indexOf('-');

            auto getDate = [](const QString& date) -> QDateTime
            {
                return QDateTime::fromString(date, "dd.MM.yyyy");
            };

            m_begin = getDate(m_currentPeriod.mid(0, index));
            m_end = getDate(m_currentPeriod.mid(index+1));
            m_end = m_end.addMSecs(86399999); // 00:00:00 + 23:59:59:9999
        }

        invalidateFilter();
    }
}

void DapHistoryProxyModel::setLastActions(bool flag)
{
    if (m_isLastActions != flag)
    {
        m_isLastActions = flag;
        invalidateFilter();
    }
}

void DapHistoryProxyModel::setCurrentStatus(const QString& str)
{
    if (m_currentStatus != str)
    {
        m_currentStatus = str;

        invalidateFilter();
    }
}

void DapHistoryProxyModel::setFilterString(const QString& str)
{
    if (m_filterString != str)
    {
        m_filterString = str;

        invalidateFilter();
    }
}

bool DapHistoryProxyModel::checkText(const DapHistoryModel::Item& item, const QString& str) const
{
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

    if(item.tx_hash.toLower().indexOf(fstr) >= 0)
        return true;

    return false;
}

void DapHistoryProxyModel::tryCountChanged()
{
    emit countChanged(m_count);
}

void DapHistoryProxyModel::resetCount()
{
    m_lastCount = m_count = 0;
    emit countChanged(m_count);
}
