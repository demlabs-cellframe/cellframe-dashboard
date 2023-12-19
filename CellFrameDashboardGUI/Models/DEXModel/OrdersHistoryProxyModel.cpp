#include "OrdersHistoryProxyModel.h"
#include "DapOrderHistoryModel.h"


OrdersHistoryProxyModel::OrdersHistoryProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
{
}

bool OrdersHistoryProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    const DapOrderHistoryModel* model = static_cast<DapOrderHistoryModel*>(sourceModel());
    if(!model)
    {
        return true;
    }
    DapOrderHistoryModel::Item item = model->getItem(source_row);
    bool isType = true;
    if(m_typeOrder != DEX::TypeSide::BOTH)
    {
        if(item.side != m_typeOrderTypeToStr[m_typeOrder])
        {
            isType = false;
        }
    }

    bool isAffilation = true;
    if(m_affilationOrder != DEX::AffilationOrder::ALL)
    {

    }

    return isType && isAffilation;
}

void OrdersHistoryProxyModel::setFilterSide(const QString& type)
{
    Q_ASSERT_X(m_typeOrderStrToType.contains(type), "setTypeOrderFilter", "There is no such type of orders");
    m_typeOrder = m_typeOrderStrToType[type];
    invalidateFilter();
}

void OrdersHistoryProxyModel::setAffilationOrderFilter(const QString& type)
{
    Q_ASSERT_X(m_typeAffilationOrderStrToType.contains(type), "setAffilationOrderFilter", "There is no such type of orders");
    m_affilationOrder = m_typeAffilationOrderStrToType[type];
    invalidateFilter();
}

void OrdersHistoryProxyModel::setOrderFilter(const QString& type, const QString& affilation)
{
    Q_ASSERT_X(m_typeOrderStrToType.contains(type), "setOrderFilter", "There is no such type of orders");
    m_typeOrder = m_typeOrderStrToType[type];
    Q_ASSERT_X(m_typeAffilationOrderStrToType.contains(affilation), "setOrderFilter", "There is no such type affilation of orders");
    m_affilationOrder = m_typeAffilationOrderStrToType[affilation];
    invalidateFilter();
}
