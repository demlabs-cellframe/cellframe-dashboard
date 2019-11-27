#include "DapWalletFilterModel.h"

DapWalletFilterModel::DapWalletFilterModel(QObject *parent) :
    QSortFilterProxyModel(parent),
    m_filterWalletName(TITLE_ALL_WALLETS)
{
    sort(0, Qt::DescendingOrder);
}

DapWalletFilterModel& DapWalletFilterModel::instance()
{
    static DapWalletFilterModel instance;
    return instance;
}

void DapWalletFilterModel::setWalletFilter(const QString& aName)
{
    if(m_filterWalletName == aName) return;
    m_filterWalletName = aName;
    setFilterKeyColumn(0);
}

bool DapWalletFilterModel::lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const
{
    QString first = source_left.data(DapChainWalletModel::NetworkDisplayRole).toString();
    QString second = source_right.data(DapChainWalletModel::NetworkDisplayRole).toString();
    return first < second;
}

bool DapWalletFilterModel::filterAcceptsRow(int source_row, const QModelIndex& source_parent) const
{
    if(m_filterWalletName == TITLE_ALL_WALLETS) return true;

    QModelIndex index = sourceModel()->index(source_row, 0, source_parent);
    QString wallet = index.data(DapChainWalletModel::WalletNameDisplayRole).toString();

    return wallet == m_filterWalletName;
}
