#include "TokenPairsProxyModel.h"
#include "DapTokenPairModel.h"


TokenPairsProxyModel::TokenPairsProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
{
}

bool TokenPairsProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    Q_UNUSED(source_parent)
    if(source_row == 0)
    {
        m_currentList.clear();
    }
    const DapTokenPairModel* model = static_cast<DapTokenPairModel*>(sourceModel());
    if(!model)
    {
        return true;
    }
    DapTokenPairModel::Item item = model->getItem(source_row);
    bool isNetwork = m_network.isEmpty() || m_network == item.network;
    bool isStr = m_currentStr.isEmpty() || item.displayText.contains(m_currentStr);

    bool result = isStr && isNetwork;
    if(result)
    {
        m_currentList.append({item.displayText, item.network});
    }
    return result;
}

QString TokenPairsProxyModel::getFirstItem() const
{
    if(m_currentList.isEmpty())
    {
        return QString();
    }
    return m_currentList[0].first;
}

void TokenPairsProxyModel::setNetworkFilter(const QString& network)
{
    m_network = network == "All" ? QString() : network;
    invalidateFilter();
}

void TokenPairsProxyModel::setDisplayTextFilter(const QString& str)
{
    m_currentStr = str;
    invalidateFilter();
}

bool TokenPairsProxyModel::isFilter()
{
    return !m_network.isEmpty() || !m_currentStr.isEmpty();
}
