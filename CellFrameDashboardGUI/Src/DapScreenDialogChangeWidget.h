#ifndef DAPSCREENDIALOGCHANGEWIDGET_H
#define DAPSCREENDIALOGCHANGEWIDGET_H

#include <QObject>
#include <QSortFilterProxyModel>

#include "DapUiQmlWidgetModel.h"

/// Class of dialog change widget
class DapScreenDialogChangeWidget : public QObject
{
    Q_OBJECT
    /// Pointer to current filter proxy model
    QSortFilterProxyModel   *m_proxyModel;
public:
    /// Standard constructor
    explicit DapScreenDialogChangeWidget(QObject *parent = nullptr);
    
    Q_PROPERTY(QSortFilterProxyModel* ProxyModel MEMBER m_proxyModel READ proxyModel WRITE setProxyModel NOTIFY proxyModelChanged)
    /// Get current filter of proxy model
    /// @return Pointer to current filter of proxy model
    QSortFilterProxyModel *proxyModel() const;
    /// Setn new proxy model
    /// @param proxyModel New current filter of proxy model
    void setProxyModel(QSortFilterProxyModel *proxyModel);
signals:
    /// The signal is emitted when filter of proxy model was changed
    /// @param proxyModel New current filter of proxy model
    void proxyModelChanged(QSortFilterProxyModel *proxyModel);
public slots:
};

#endif // DAPSCREENDIALOGCHANGEWIDGET_H
