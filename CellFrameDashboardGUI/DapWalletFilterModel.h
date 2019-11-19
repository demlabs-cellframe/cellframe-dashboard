#ifndef DAPWALLETFILTERMODEL_H
#define DAPWALLETFILTERMODEL_H

#include <QSortFilterProxyModel>
#include "DapChainWalletModel.h"

class DapWalletFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

protected:
    bool lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const;
//    bool filterAcceptsRow(int source_row, const QModelIndex& source_parent) const;

public:
    explicit DapWalletFilterModel(QObject *parent = nullptr);
    static DapWalletFilterModel& instance();
};

#endif // DAPWALLETFILTERMODEL_H
