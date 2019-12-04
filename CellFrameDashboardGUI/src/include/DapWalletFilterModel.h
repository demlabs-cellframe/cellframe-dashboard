#ifndef DAPWALLETFILTERMODEL_H
#define DAPWALLETFILTERMODEL_H

#include <QSortFilterProxyModel>
#include "DapChainWalletModel.h"

class DapWalletFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

private:
    QString m_filterWalletName;

protected:
    bool lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const;
    bool filterAcceptsRow(int source_row, const QModelIndex& source_parent) const;

public:
    explicit DapWalletFilterModel(QObject *parent = nullptr);
    static DapWalletFilterModel& instance();

public slots:
    Q_INVOKABLE void setWalletFilter(const QString& aName);
};

#endif // DAPWALLETFILTERMODEL_H
