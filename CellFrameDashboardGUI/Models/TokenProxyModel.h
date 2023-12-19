#pragma once

#include <QSortFilterProxyModel>
#include <QObject>
#include <QMap>
#include <QQmlContext>
#include "DapInfoWalletModel.h"

class TokenProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount NOTIFY countChanged)
public:
    explicit TokenProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void setNetworkFilter(const QString& network);
    Q_INVOKABLE void setTokenFilter(const QString& token1, const QString& token2);
    Q_INVOKABLE int getCount() {return m_count;}
    Q_INVOKABLE QVariant get(int a_index);
    void updateCount();
Q_SIGNALS:
    void countChanged();
protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

private:
    bool isValid(const DapTokensWalletModel::Item item) const;

private:
    QStringList m_filterList;
    QString m_network = "";
    int m_count = 0;

};

