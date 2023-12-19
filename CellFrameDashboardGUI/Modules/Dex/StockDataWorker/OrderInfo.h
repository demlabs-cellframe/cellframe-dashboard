#ifndef ORDERINFO_H
#define ORDERINFO_H

#include <QGuiApplication>

struct OrderInfo
{
    Q_GADGET
    Q_PROPERTY(double price MEMBER price)
    Q_PROPERTY(double amount MEMBER amount)
    Q_PROPERTY(double total MEMBER total)

public:
    double price;
    double amount;
    double total;

    OrderInfo(double price = 0.0,
         double amount = 0.0,
         double total = 0.0)
    {
        this->price = price;
        this->amount = amount;
        this->total = total;
    }
};
Q_DECLARE_METATYPE(OrderInfo)

enum class OrderType
{
    sell, buy
};

struct FullOrderInfo
{
public:
    OrderType type;
    double price;
    double amount;
    double total;
};

#endif // ORDERINFO_H
