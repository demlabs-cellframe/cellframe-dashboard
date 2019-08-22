#include "DapScreenHistoryFilterModel.h"

DapScreenHistoryFilterModel::DapScreenHistoryFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent),
    m_status(-1)
{
    sort(0, Qt::DescendingOrder);
}

DapScreenHistoryFilterModel& DapScreenHistoryFilterModel::getInstance()
{
    static DapScreenHistoryFilterModel instance;
    return instance;
}

void DapScreenHistoryFilterModel::setFilterWallet(const QString& aWalletNumber)
{
    if(m_walletNumber == aWalletNumber) return;
    m_walletNumber = aWalletNumber;
    setFilterKeyColumn(0);
}

void DapScreenHistoryFilterModel::setFilterDate(const QDate& aDateLeft, const QDate& aDateRight)
{
    if(m_dateLeft == aDateLeft || m_dateRight == aDateRight) return;
    m_dateLeft = aDateLeft;
    m_dateRight = aDateRight;
    setFilterKeyColumn(0);
}

void DapScreenHistoryFilterModel::setFilterStatus(const DapTransactionStatus aStatus)
{
    if(m_status == aStatus) return;
    m_status = aStatus;
    setFilterKeyColumn(0);
}

bool DapScreenHistoryFilterModel::lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const
{
    QDateTime first = source_left.data(DapScreenHistoryModel::DateRole).toDateTime();
    QDateTime second = source_right.data(DapScreenHistoryModel::DateRole).toDateTime();
    return first < second;
}

bool DapScreenHistoryFilterModel::filterAcceptsRow(int source_row, const QModelIndex& source_parent) const
{
    QModelIndex index = sourceModel()->index(source_row, 0, source_parent);
    QDateTime time = index.data(DapScreenHistoryModel::DateRole).toDateTime();

    bool result = true;
    bool filterByWalletNumber = !m_walletNumber.isEmpty();
    bool filterByDate = m_dateLeft.isValid() && m_dateRight.isValid();
    bool filterByStatus = m_status > -1;

    if(filterByDate) result &= (time.date() >= m_dateLeft && time.date() <= m_dateRight);
    if(filterByStatus) result &= (index.data(DapScreenHistoryModel::StatusRole).toInt() == m_status);
    if(filterByWalletNumber) result &= (index.data(DapScreenHistoryModel::DisplayNumberWalletRole).toString() == m_walletNumber);

    return result;
}
