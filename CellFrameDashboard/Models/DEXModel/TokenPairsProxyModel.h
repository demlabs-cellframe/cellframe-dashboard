#pragma once

#include <QSortFilterProxyModel>
#include <QObject>
#include <QMap>
#include "DEXTypes.h"

class TokenPairsProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
public:
    explicit TokenPairsProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void setNetworkFilter(const QString& network);
    Q_INVOKABLE void setDisplayTextFilter(const QString& str);
    Q_INVOKABLE void setNewPairFilter(const QString& pair, const QString& network);

    Q_INVOKABLE bool isFilter();
    Q_INVOKABLE QString getFirstItem() const;
    Q_INVOKABLE int getSize() const { return m_currentList.size();}
    const QList<QPair<QString,QString>>& getCurrantList() const { return m_currentList; }
protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

private:
    QString m_network = "";
    QString m_currentDisplayText = "";
    mutable QList<QPair<QString,QString>> m_currentList;
};
