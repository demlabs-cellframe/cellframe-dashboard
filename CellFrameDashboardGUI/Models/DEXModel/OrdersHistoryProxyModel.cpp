#include "OrdersHistoryProxyModel.h"
#include <QDateTime>

OrdersHistoryProxyModel::OrdersHistoryProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
{
}

//QVariant OrdersHistoryProxyModel::getItem(const QString& hash) const
//{
//    if(hash.isEmpty())
//    {
//        return QVariant::fromValue (new ItemOrderHistoryBridge ());
//    }
//    const DapOrderHistoryModel* model = static_cast<DapOrderHistoryModel*>(sourceModel());
//    if(!model)
//    {
//        return QVariant::fromValue (new ItemOrderHistoryBridge ());
//    }
//    for(auto& item: model->getListModel())
//    {
//        if(item.hash == hash)
//        {
//            return QVariant::fromValue (&item);
//        }
//    }
//    return QVariant::fromValue (new ItemOrderHistoryBridge ());
//}

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

    bool isAffilation = false;
    if(m_affilationOrder != DEX::AffilationOrder::ALL)
    {
        if(m_isHashCallback)
        {
            if(m_affilationOrder == DEX::AffilationOrder::MY_ORDERS)
            {
                isAffilation = m_isHashCallback(item.hash);
            }
            else if(m_affilationOrder == DEX::AffilationOrder::OTHER_ORDERS)
            {
                isAffilation = !m_isHashCallback(item.hash);
            }
        }
    }
    else
    {
        isAffilation = true;
    }

    bool isStatus = m_statusOrder == "Both" || item.status == m_statusOrder;

    bool isPair = m_pair.isEmpty() || m_pair == item.pair;

    bool isPeriod = true;
    if(m_period > 0)
    {
        qint64 currentTime = QDateTime::currentDateTime().toSecsSinceEpoch();
        isPeriod = (currentTime - m_period) < item.unixDate.toLongLong();
    }

    bool isNetwork = m_network.isEmpty() || m_network == item.network;

    return isType && isAffilation && isStatus && isPeriod && isPair && isNetwork;
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

void OrdersHistoryProxyModel::setStatusOrderFilter(const QString& type)
{
    Q_ASSERT_X(m_testStatusOrder.contains(type), "setStatusOrderFilter", "There is no such type of orders");
    m_statusOrder = type;
    invalidateFilter();
}

void OrdersHistoryProxyModel::setPeriodOrderFilter(const QString& period)
{
    Q_ASSERT_X(m_periodContainer.contains(period), "setPeriodOrderFilter", "There is no such period of orders");
    m_period = m_periodContainer[period];
    invalidateFilter();
}

void OrdersHistoryProxyModel::setPairOrderFilter(const QString& pair)
{
    if(pair == "All pairs")
    {
        m_pair.clear();
    }
    else
    {
        m_pair = pair;
    }
    invalidateFilter();
}

void OrdersHistoryProxyModel::setNetworkOrderFilter(const QString& network)
{
    if(network == "All")
    {
        m_network.clear();
    }
    else
    {
        m_network = network;
    }
    invalidateFilter();
}

void OrdersHistoryProxyModel::setPairAndNetworkOrderFilter(const QString& pair, const QString& network)
{
    if(network == "All")
    {
        m_network.clear();
    }
    else
    {
        m_network = network;
    }

    if(pair == "All pairs")
    {
        m_pair.clear();
    }
    else
    {
        m_pair = pair;
    }
    invalidateFilter();
}

void OrdersHistoryProxyModel::setOrderFilter(const QString& type, const QString& affilation, const QString status,
                                             const QString period, const QString& pair, const QString& network)
{
    Q_ASSERT_X(m_typeOrderStrToType.contains(type), "setOrderFilter", "There is no such type of orders");
    m_typeOrder = m_typeOrderStrToType[type];
    Q_ASSERT_X(m_typeAffilationOrderStrToType.contains(affilation), "setOrderFilter", "There is no such type affilation of orders");
    m_affilationOrder = m_typeAffilationOrderStrToType[affilation];
    Q_ASSERT_X(m_testStatusOrder.contains(status), "setOrderFilter", "There is no such status of orders");
    m_statusOrder = status;
    Q_ASSERT_X(m_periodContainer.contains(period), "setPeriodOrderFilter", "There is no such period of orders");
    m_period = m_periodContainer[period];

    //TODO: These parameters are still fixed and we do not touch them with a general change.
//    if(pair == "All pairs")
//    {
//        m_pair.clear();
//    }
//    else
//    {
//        m_pair = pair;
//    }

//    if(network == "All")
//    {
//        m_network.clear();
//    }
//    else
//    {
//        m_network = network;
//    }
    invalidateFilter();
}
