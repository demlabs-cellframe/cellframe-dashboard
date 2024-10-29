#pragma once

#include <QSortFilterProxyModel>
#include <QObject>
#include <QMap>
#include "DEXTypes.h"
// #include "DapOrderHistoryModel.h"

class TokensProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit TokensProxyModel(QObject *parent = nullptr);

    void setParmsModel(const QString& type);

    Q_INVOKABLE void searchQuery(const QString& text);
protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

private:
    QString m_type = "sell";
    QString m_query = "";

    const QStringList TYPE_LIST = {"sell", "buy"};
};
