#include "DapScreenDialogChangeWidget.h"

DapScreenDialogChangeWidget::DapScreenDialogChangeWidget(QObject *parent) : QObject(parent)
{
    m_proxyModel = new QSortFilterProxyModel(this);
    m_proxyModel->setFilterRegExp(QRegExp("false"));
}

QSortFilterProxyModel *DapScreenDialogChangeWidget::proxyModel() const
{
    return m_proxyModel;
}

void DapScreenDialogChangeWidget::setProxyModel(QSortFilterProxyModel *proxyModel)
{
    m_proxyModel = proxyModel;
}
