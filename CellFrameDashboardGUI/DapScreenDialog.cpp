#include "DapScreenDialog.h"

DapScreenDialog::DapScreenDialog(QObject *parent) : QObject(parent)
{
    m_proxyModel = new QSortFilterProxyModel;
    m_proxyModel->setFilterRegExp(QRegExp("true"));
}

QSortFilterProxyModel *DapScreenDialog::proxyModel() const
{
    return m_proxyModel;
}

void DapScreenDialog::setProxyModel(QSortFilterProxyModel *proxyModel)
{
    m_proxyModel = proxyModel;
}
