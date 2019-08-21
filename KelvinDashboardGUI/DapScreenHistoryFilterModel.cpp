#include "DapScreenHistoryFilterModel.h"

DapScreenHistoryFilterModel::DapScreenHistoryFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent)
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

void DapScreenHistoryFilterModel::setFilterDate(const QDateTime& aDateLeft, const QDateTime& aDateRight)
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

    return  (index.data(DapScreenHistoryModel::DisplayNumberWalletRole).toString() == m_walletNumber) ||
            (index.data(DapScreenHistoryModel::DisplayStatusRole).toInt() == m_status) ||
            (time >= m_dateLeft && time <= m_dateRight);
}
