#include "DapScreenHistoryFilterModel.h"

DapScreenHistoryFilterModel::DapScreenHistoryFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent)
{

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
}

void DapScreenHistoryFilterModel::setFilterDate(const QDateTime& aDateLeft, const QDateTime& aDateRight)
{
    if(m_dateLeft == aDateLeft || m_dateRight == aDateRight) return;
    m_dateLeft = aDateLeft;
    m_dateRight = aDateRight;
}

void DapScreenHistoryFilterModel::setFilterStatus(const DapTransactionStatus aStatus)
{
    if(m_status == aStatus) return;
    m_status = aStatus;
}

bool DapScreenHistoryFilterModel::lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const
{
    QString first = source_left.data().toString();
    QString second = source_right.data().toString();
    return first < second;
}

bool DapScreenHistoryFilterModel::filterAcceptsRow(int source_row, const QModelIndex& source_parent) const
{
    QDateTime time;
    QModelIndex index = sourceModel()->index(source_row, 0, source_parent);
    QString timeStr = index.data(DapScreenHistoryModel::DisplayDateRole).toString();

    if(timeStr == tr("Today")) time = QDateTime::currentDateTime();
    else time = QDateTime::fromString(MASK_FOR_MODEL);

    return  (index.data(DapScreenHistoryModel::DisplayNumberWalletRole).toString() == m_walletNumber) ||
            (index.data(DapScreenHistoryModel::DisplayStatusRole).toInt() == m_status) ||
            (time >= m_dateLeft && time <= m_dateRight);
}
