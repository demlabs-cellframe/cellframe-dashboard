#include "TokensProxyModel.h"
#include "DapTokensModel.h"

TokensProxyModel::TokensProxyModel (QObject *parent)
    : QSortFilterProxyModel{parent}
{
}

bool TokensProxyModel::filterAcceptsRow(int source_row, const QModelIndex &source_parent) const
{
    const DapTokensModel* model = static_cast<DapTokensModel*>(sourceModel());
    if(!model)
    {
        return true;
    }
    DapTokensModel::Item item = model->getItem(source_row);
    bool isType = item.type == m_type;

    return isType;
}

void TokensProxyModel::setParmsModel(const QString& type)
{
    if(type != m_type)
    {
        Q_ASSERT_X(TYPE_LIST.contains(type), "type filter", "the type is specified incorrectly");
        m_type = type;
    }


    invalidateFilter();
}
