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
    Q_INVOKABLE void setNewPairFilter(const QString& token1, const QString& token2, const QString& network);
    Q_INVOKABLE int getCount() {return m_count;}
    Q_INVOKABLE QVariant get(int a_index);
    Q_INVOKABLE QString getFirstToken() const;
    void updateCount();

    const QStringList& getDEXCurrentTokens() const {return m_filterList;}
    const QString& getCurrentNetwork() const {return m_network;}
Q_SIGNALS:
    void countChanged();
    void listTokenChanged();
protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

private:
    bool isValid(const DapTokensWalletModel::Item item) const;

private:
    mutable QStringList m_tokenList;
    QStringList m_filterList;
    QString m_network = "";
    int m_count = 0;
};

