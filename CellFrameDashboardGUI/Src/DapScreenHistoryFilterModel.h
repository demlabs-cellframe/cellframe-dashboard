#ifndef DAPSCREENHISTORYFILTERMODEL_H
#define DAPSCREENHISTORYFILTERMODEL_H

#include <QSortFilterProxyModel>

#include "DapScreenHistoryModel.h"

/// Class screen of history transaction
class DapScreenHistoryFilterModel : public QSortFilterProxyModel
{
    Q_OBJECT

private:
    /// Number of wallet
    QString m_walletNumber;
    /// Minimum date
    QDate m_dateLeft;
    /// Maximum date
    QDate m_dateRight;
    /// Filter status
    int m_status;

protected:
    /// Overides methods
    bool lessThan(const QModelIndex& source_left, const QModelIndex& source_right) const;
    bool filterAcceptsRow(int source_row, const QModelIndex& source_parent) const;

public:
    explicit DapScreenHistoryFilterModel(QObject *parent = nullptr);
    /// Get instance of this class
    /// @return instance of this class
    static DapScreenHistoryFilterModel &getInstance();

public slots:
    /// Filter model with wallet
    /// @param number of wallet
    void setFilterWallet(const QString& aWalletNumber);
    /// Filter model with dates
    /// @param Min date
    /// @param Max date
    void setFilterDate(const QDate& aDateLeft, const QDate& aDateRight);
    /// Filter with status of transaction
    /// @param status of transaction
    void setFilterStatus(const DapTransactionStatus aStatus);
};

#endif // DAPSCREENHISTORYFILTERMODEL_H
