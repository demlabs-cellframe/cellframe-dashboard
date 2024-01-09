#ifndef ORDERINFO_H
#define ORDERINFO_H

#include <QGuiApplication>

struct OrderInfo
{
    Q_GADGET
    Q_PROPERTY(QString price MEMBER price)
    Q_PROPERTY(QString amount MEMBER amount)
    Q_PROPERTY(QString total MEMBER total)
    Q_PROPERTY(double filled MEMBER filled)
public:
    QString price;
    QString amount;
    QString total;
    double filled;

    OrderInfo(QString price = "0.0",
         QString amount = "0.0",
         QString total = "0.0")
        : price(price)
        , amount(amount)
        , total(total)
    {}
};
Q_DECLARE_METATYPE(OrderInfo)

enum class OrderType
{
    sell, buy
};

struct FullOrderInfo
{

    OrderType type;
    QString price = "";
    QString amount = "";
    QString total = "";
};

#endif // ORDERINFO_H
