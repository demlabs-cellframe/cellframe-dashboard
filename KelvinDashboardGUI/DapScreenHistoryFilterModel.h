#ifndef DAPSCREENHISTORYFILTERMODEL_H
#define DAPSCREENHISTORYFILTERMODEL_H

#include <QSortFilterProxyModel>

#include "DapScreenHistoryModel.h"

class DapScreenHistoryFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

private:
    QString m_walletNumber;
    QDateTime m_dateLeft;
    QDateTime m_dateRight;
    int m_status;

protected:
    bool lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const;
    bool filterAcceptsRow(int source_row, const QModelIndex& source_parent) const;

public:
    explicit DapScreenHistoryFilterModel(QObject *parent = nullptr);
    static DapScreenHistoryFilterModel &getInstance();

public slots:
    void setFilterWallet(const QString& aWalletNumber);
    void setFilterDate(const QDateTime& aDateLeft, const QDateTime& aDateRight);
    void setFilterStatus(const DapScreenHistoryModel::DapTransactionStatus aStatus);
};

#endif // DAPSCREENHISTORYFILTERMODEL_H
