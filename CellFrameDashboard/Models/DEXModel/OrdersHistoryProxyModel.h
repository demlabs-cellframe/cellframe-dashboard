#ifndef ORDERSHISTORYPROXYMODEL_H
#define ORDERSHISTORYPROXYMODEL_H

#include <QSortFilterProxyModel>
#include <QObject>
#include <QMap>
#include "DEXTypes.h"
#include "DapOrderHistoryModel.h"

class OrdersHistoryProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT

    using Callback = std::function<bool(const QString&)>;
public:
    explicit OrdersHistoryProxyModel(QObject *parent = nullptr);

    Q_INVOKABLE void setFilterSide(const QString& type);
    Q_INVOKABLE void setAffilationOrderFilter(const QString& type);
    Q_INVOKABLE void setPeriodOrderFilter(const QString& period);
    Q_INVOKABLE void setNetworkOrderFilter(const QString& network = "All");
    Q_INVOKABLE void setPairAndNetworkOrderFilter(const QString& pair = "All pairs", const QString& network = "All");
    Q_INVOKABLE void setOrderFilter(const QString& type, const QString& affilation = "All"
                                    , const QString status = "Both", const QString period = "All"
                                    , const QString& pair = "All pairs"
                                    , const QString& network = "All");

    Q_PROPERTY (bool isSellFilter        READ isSellFilter       NOTIFY isSellFilterChanged)
    bool isSellFilter() {return m_typeOrder == DEX::TypeSide::SELL;}

    void setIsRegularType(bool isRegular);

    void setIsHashCallback(Callback handler) {m_isHashCallback = handler;}
    void setCurrentTokenPair(const QString& tokenSell, const QString& tokenBuy);
signals:
    void isSellFilterChanged();

public slots:

    void tryUpdateFilter();

protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;

private:
    Callback m_isHashCallback = nullptr;

    const QMap<QString, DEX::TypeSide> m_typeOrderStrToType = {{"Both", DEX::TypeSide::BOTH},
                                                                {"Buy", DEX::TypeSide::BUY},
                                                                {"Sell", DEX::TypeSide::SELL}};
    const QMap<DEX::TypeSide, QString> m_typeOrderTypeToStr = {{DEX::TypeSide::BUY, "Buy"}, {DEX::TypeSide::SELL, "Sell"}};
    const QMap<QString, DEX::AffilationOrder> m_typeAffilationOrderStrToType = {{"My_orders", DEX::AffilationOrder::MY_ORDERS},
                                                                                {"Other", DEX::AffilationOrder::OTHER_ORDERS},
                                                                                {"All", DEX::AffilationOrder::ALL}};
    // "OPENED" "CLOSED" "Both"
    QStringList m_testStatusOrder = {"OPENED", "CLOSED", "Both"};
    QString m_statusOrder = "BOTH";

    QMap<QString, qint64> m_periodContainer = {{"Day", 86400},
                                               {"Week", 604800},
                                               {"Month", 2678400},
                                               {"3 Month", 7776000},
                                               {"6 Month", 15638400},
                                               {"All", 0}};
    qint64 m_period = 0;

    QString m_pair = "";

    QString m_network = "";

    DEX::AffilationOrder m_affilationOrder = DEX::AffilationOrder::ALL;
    DEX::TypeSide m_typeOrder = DEX::TypeSide::BOTH;

    bool m_isRegular = false;
    QString m_tokenSell = "";
    QString m_tokenBuy = "";
};

#endif // ORDERSHISTORYPROXYMODEL_H
