#ifndef PAIRINFO_H
#define PAIRINFO_H

#include <QGuiApplication>
//#include <QString>

struct TokenPairInfo
{
    Q_GADGET
    Q_PROPERTY(QString tokenBuy MEMBER tokenBuy)
    Q_PROPERTY(QString tokenSell MEMBER tokenSell)
    Q_PROPERTY(QString network MEMBER network)
    Q_PROPERTY(double price MEMBER price)
    Q_PROPERTY(QString priceText MEMBER priceText)
    Q_PROPERTY(QString change MEMBER change)

public:
    QString tokenBuy; // token1
    QString tokenSell; // token2
    QString network;
    double price;
    QString priceText;
    QString change;

    TokenPairInfo(
            QString tokenBuy = "",
            QString tokenSell = "",
            QString network = "",
            double price = 0.0,
            QString priceText = "",
            QString change = "")
    {
        this->tokenBuy = tokenBuy;
        this->tokenSell = tokenSell;
        this->network = network;
        this->price = price;
        this->priceText = priceText;
        this->change = change;
    }
};
Q_DECLARE_METATYPE(TokenPairInfo)


/*struct TokenPairInfo
{
//    inline QVariantMap getMap() const
//    {
//        return { {"price", price}, {"time", time} };
//    }

    QString tokenBuy; // token1
    QString tokenSell; // token2
    QString network;
    double price;
    QString priceText;
    QString change;
};*/

#endif // PAIRINFO_H
