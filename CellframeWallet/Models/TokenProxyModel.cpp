#include "TokenProxyModel.h"

TokenProxyModel::TokenProxyModel(QObject *parent)
    : QSortFilterProxyModel{parent}
{
}

QVariant TokenProxyModel::get(int a_index)
{
    const DapTokensWalletModel* model = static_cast<DapTokensWalletModel*>(sourceModel());
    if(!model)
    {
        return QVariant();
    }
    int index = 0;
    for(int i = 0; i < model->size(); i++)
    {
        if(isValid(model->getItem(i)))
        {
            if(a_index == index)
            {
                return model->get(i);
            }
            else
            {
                index++;
            }
        }
    }
    return QVariant();
}

void TokenProxyModel::updateCount()
{
    const DapTokensWalletModel* model = static_cast<DapTokensWalletModel*>(sourceModel());
    if(!model)
    {
        return;
    }
    int result = 0;
    QStringList list;
    for(int i = 0; i < model->size(); i++)
    {
        if(isValid(model->getItem(i)))
        {
            auto& item = model->getItem(i);
            list.append(item.tokenName);
            result++;
        }
    }

    if(m_count != result)
    {
        m_count = result;
        emit countChanged();
    }

    if(m_tokenList != list)
    {
        m_tokenList = list;
        emit listTokenChanged();
    }
}

QString TokenProxyModel::getFirstToken() const
{
    if(m_tokenList.isEmpty())
    {
        return QString();
    }
    return m_tokenList[0];
}

bool TokenProxyModel::isValid(const DapTokensWalletModel::Item item) const
{
    bool network = m_network.isEmpty() ? true : item.network == m_network;
    bool token = m_filterList.contains(item.tiker);
    return network && token;
}

bool TokenProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    Q_UNUSED(source_parent)
    const DapTokensWalletModel* model = static_cast<DapTokensWalletModel*>(sourceModel());
    if(!model)
    {
        return false;
    }
    DapTokensWalletModel::Item item = model->getItem(source_row);

    return isValid(item);
}

void TokenProxyModel::setTokenFilter(const QString& token1, const QString& token2)
{
    m_filterList.clear();
    m_filterList << token1 << token2;
    updateCount();
    invalidateFilter();
}

void TokenProxyModel::setNewPairFilter(const QString& token1, const QString& token2, const QString& network)
{
    m_network = network;
    m_filterList.clear();
    m_filterList << token1 << token2;
    updateCount();
    invalidateFilter();
}

void TokenProxyModel::setNetworkFilter(const QString& network)
{
    m_network = network;
    updateCount();
    invalidateFilter();
}
