#pragma once

#include <QSortFilterProxyModel>
#include <QObject>
#include <QSet>
#include <QDateTime>
#include "DapHistoryModel.h"

class DapHistoryProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit DapHistoryProxyModel(QObject *parent = nullptr);
    Q_INVOKABLE void setNetworkFilter(const QString& value);
    Q_INVOKABLE void setCurrentPeriod(const QVariant& str);
    Q_INVOKABLE void setLastActions(bool flag);
    Q_INVOKABLE void setCurrentStatus(const QString& str);
    Q_INVOKABLE void setFilterString(const QString &str = "");

    Q_PROPERTY(int count READ getCount WRITE countChanged)
    Q_INVOKABLE int getCount(){return m_count;}
    void resetCount();

    Q_INVOKABLE int getLastDays(){return m_countLastDays;}

signals:
    void countChanged(int& count);

protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

private:
    inline bool checkText(const DapHistoryModel::Item& item, const QString& str) const;
private:
    QString m_networkFilter = "All";
    QString m_currentStatus = "All statuses";
    QString m_currentPeriod  = "All time";
    QString m_filterString = "";

    QDateTime m_begin;
    QDateTime m_end;
    mutable QSet<QString> m_daysSet;

    bool m_isRange = false;
    bool m_isLastActions = true;

    void tryCountChanged();

    mutable int m_lastCount = 0;
    mutable int m_count = 0;
    mutable int m_countDays = 0;
    mutable int m_countLastDays = 0;
    mutable QString m_tmpDataLastActions = "";

    const QString LAST_ACTIONS_TEXT = "LastActions";
    const QString ALL_DAY_TEXT = "All time";
    const QString TODAY_TEXT = "Today";
    const QString YESTERDAY_TEXT = "Yesterday";
    const QString LAST_WEEK_TEXT = "Last week";
    const QStringList MAIN_PERIOD_TYPE = {TODAY_TEXT, YESTERDAY_TEXT, LAST_WEEK_TEXT};

    const int MAX_DAYS_LAST_ACTIONS = 2;
    const int MAX_TRANSACTIONS_LAST_ACTIONS = 15;

};
