#ifndef DAPSCREENHISTORYFILTERMODEL_H
#define DAPSCREENHISTORYFILTERMODEL_H

#include <QSortFilterProxyModel>

#include "DapScreenHistoryModel.h"

class DapScreenHistoryFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

private:
    QString m_walletNumber;
    QDate m_dateLeft;
    QDate m_dateRight;
    int m_status;

protected:
    bool lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const;
    bool filterAcceptsRow(int source_row, const QModelIndex& source_parent) const;

public:
    explicit DapScreenHistoryFilterModel(QObject *parent = nullptr);
    static DapScreenHistoryFilterModel &getInstance();

public slots:
    /// Filter model with wallet
    /// @param Wallet number
    void setFilterWallet(const QString& aWalletNumber);
    /// Filter model with dates
    /// @param Min date
    /// @param Max date
    void setFilterDate(const QDate& aDateLeft, const QDate& aDateRight);
    /// Filter with status of transacrion
    void setFilterStatus(const DapTransactionStatus aStatus);
};

#endif // DAPSCREENHISTORYFILTERMODEL_H
