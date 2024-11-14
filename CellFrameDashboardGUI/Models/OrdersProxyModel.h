#pragma once

#include <QSortFilterProxyModel>
#include <QObject>
#include "Models/DapOrdersModel.h"

class OrdersProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit OrdersProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void setPkeyFilter(const QString& data);
    Q_INVOKABLE void setNodeAddrFilter(const QString& data);

    Q_INVOKABLE bool isFilter();
protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

private:
    QString m_pkey = "";
    QString m_nodeAddr = "";

    QString m_uidOrder = "Stake";
};
