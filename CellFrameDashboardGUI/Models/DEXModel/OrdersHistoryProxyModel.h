#ifndef ORDERSHISTORYPROXYMODEL_H
#define ORDERSHISTORYPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QObject>
#include <QMap>
#include "DEXTypes.h"

class OrdersHistoryProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit OrdersHistoryProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void setFilterSide(const QString& type);
    Q_INVOKABLE void setAffilationOrderFilter(const QString& type);
    Q_INVOKABLE void setOrderFilter(const QString& type, const QString& affilation = "All");

protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

private:

    const QMap<QString, DEX::TypeSide> m_typeOrderStrToType = {{"Both", DEX::TypeSide::BOTH},
                                                                {"Buy", DEX::TypeSide::BUY},
                                                                {"Sell", DEX::TypeSide::SELL}};
    const QMap<DEX::TypeSide, QString> m_typeOrderTypeToStr = {{DEX::TypeSide::BUY, "Buy"}, {DEX::TypeSide::SELL, "Sell"}};
    const QMap<QString, DEX::AffilationOrder> m_typeAffilationOrderStrToType = {{"My_orders", DEX::AffilationOrder::MY_ORDERS},
                                                                                {"Other", DEX::AffilationOrder::OTHER_ORDERS},
                                                                                {"All", DEX::AffilationOrder::ALL}};

    DEX::AffilationOrder m_affilationOrder = DEX::AffilationOrder::ALL;
    DEX::TypeSide m_typeOrder = DEX::TypeSide::BOTH;
};

#endif // ORDERSHISTORYPROXYMODEL_H
