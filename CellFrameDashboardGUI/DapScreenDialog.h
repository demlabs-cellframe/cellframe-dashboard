#ifndef DAPSCREENDIALOG_H
#define DAPSCREENDIALOG_H

#include <QObject>
#include <QSortFilterProxyModel>

#include "DapUiQmlWidgetModel.h"

class DapScreenDialog : public QObject
{
    Q_OBJECT
    
    QSortFilterProxyModel   *m_proxyModel;
public:
    explicit DapScreenDialog(QObject *parent = nullptr);
    
    Q_PROPERTY(QSortFilterProxyModel* ProxyModel MEMBER m_proxyModel READ proxyModel WRITE setProxyModel NOTIFY proxyModelChanged)
    
    QSortFilterProxyModel *proxyModel() const;
    void setProxyModel(QSortFilterProxyModel *proxyModel);
    
signals:
    void proxyModelChanged(QSortFilterProxyModel *proxyModel);
public slots:
};

#endif // DAPSCREENDIALOG_H
