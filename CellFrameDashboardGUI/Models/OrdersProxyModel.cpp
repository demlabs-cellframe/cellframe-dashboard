#include "OrdersProxyModel.h"
#include <QDebug>

OrdersProxyModel::OrdersProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
{
}

bool OrdersProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    Q_UNUSED(source_parent)

    const DapOrdersModel* model = static_cast<DapOrdersModel*>(sourceModel());
    if(!model)
    {
        return true;
    }
    DapOrdersModel::Item item = model->getItem(source_row);

    if(m_uidOrder != item.srv_uid)
    {
        return false;
    }

    bool isPKey = m_pkey == "All" || m_pkey == item.pkey;

    bool isNodeAddr = m_nodeAddr.isEmpty() || m_nodeAddr == item.node_addr;

    return isPKey && isNodeAddr;
}

void OrdersProxyModel::setPkeyFilter(const QString& data)
{
    m_pkey = data == "All" ? "All" : data;
    invalidateFilter();
}

void OrdersProxyModel::setNodeAddrFilter(const QString& data)
{
    m_nodeAddr = data == "All" ? QString() : data;
    invalidateFilter();
}

bool OrdersProxyModel::isFilter()
{
    return !m_pkey.isEmpty() || !m_nodeAddr.isEmpty();
}
