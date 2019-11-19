#include "DapWalletFilterModel.h"

DapWalletFilterModel::DapWalletFilterModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    sort(0, Qt::DescendingOrder);
}

DapWalletFilterModel& DapWalletFilterModel::instance()
{
    static DapWalletFilterModel instance;
    return instance;
}

bool DapWalletFilterModel::lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const
{
    QString first = source_left.data(DapChainWalletModel::NetworkDisplayRole).toString();
    QString second = source_right.data(DapChainWalletModel::NetworkDisplayRole).toString();
    return first < second;
}
