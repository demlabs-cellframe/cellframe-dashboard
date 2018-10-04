#ifndef DAPSCREENDIALOGCHANGEWIDGET_H
#define DAPSCREENDIALOGCHANGEWIDGET_H

#include <QObject>
#include <QSortFilterProxyModel>

#include "DapUiQmlWidgetModel.h"

class DapScreenDialogChangeWidget : public QObject
{
    Q_OBJECT
    
    QSortFilterProxyModel   *m_proxyModel;
public:
    explicit DapScreenDialogChangeWidget(QObject *parent = nullptr);
    
    Q_PROPERTY(QSortFilterProxyModel* ProxyModel MEMBER m_proxyModel READ proxyModel WRITE setProxyModel NOTIFY proxyModelChanged)
    
    QSortFilterProxyModel *proxyModel() const;
    void setProxyModel(QSortFilterProxyModel *proxyModel);
signals:
    void proxyModelChanged(QSortFilterProxyModel *proxyModel);
public slots:
};

#endif // DAPSCREENDIALOGCHANGEWIDGET_H
