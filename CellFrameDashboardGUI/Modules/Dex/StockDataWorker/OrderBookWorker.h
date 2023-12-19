#ifndef ORDERBOOKWORKER_H
#define ORDERBOOKWORKER_H

#include <QObject>
#include <QVector>
#include <QQmlContext>
#include "Models/DEXModel/DEXTypes.h"
#include "OrderInfo.h"

class OrderBookWorker : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int sellOrderModelSize READ sellOrderModelSize)
    Q_PROPERTY(int buyOrderModelSize READ buyOrderModelSize)

    Q_PROPERTY(double sellMaxTotal READ sellMaxTotal NOTIFY sellMaxTotalChanged)
    Q_PROPERTY(double buyMaxTotal READ buyMaxTotal NOTIFY buyMaxTotalChanged)

    Q_PROPERTY(int bookRoundPower READ bookRoundPower NOTIFY bookRoundPowerChanged)
    Q_PROPERTY(int bookRoundPowerMinimum READ bookRoundPowerMinimum)

public:
    explicit OrderBookWorker(QQmlContext *cont, QObject *parent = nullptr);

//    void setContext(QQmlContext *cont);

//    Q_INVOKABLE void setTokenPair(const QString &tok1,
//        const QString &tok2, const QString &net);

    Q_INVOKABLE void resetBookModel();

    Q_INVOKABLE void generateBookModel(double price, int length, double step);

    Q_INVOKABLE void setBookModel(const QByteArray &json);

    Q_INVOKABLE void generateNewBookState();

    Q_INVOKABLE void setBookRoundPower(const QString &text);

    int sellOrderModelSize() const
        { return sellOrderModel.size(); }
    int buyOrderModelSize() const
        { return buyOrderModel.size(); }

    double sellMaxTotal() const
        { return m_sellMaxTotal; }
    double buyMaxTotal() const
        { return m_buyMaxTotal; }

    int bookRoundPower() const
        { return m_bookRoundPower; }
    int bookRoundPowerMinimum() const
        { return m_bookRoundPowerMinimum; }

public slots:
    void checkBookRoundPower(double currentTokenPrice);

    void setTokenPair(const QString &tok1,
        const QString &tok2, const QString &net);
    void setTokenPair(const DEX::InfoTokenPair& info, const QString &net);
signals:
    void sellMaxTotalChanged(double max);
    void buyMaxTotalChanged(double max);

    void bookRoundPowerChanged(int power);

    void setNewBookRoundPowerMinimum(int power);

private:
    double roundDoubleValue(double value, int round);

//    void checkNewRoundPower(double currentTokenPrice);

    void updateBookModels();

    void insertBookOrder(const OrderType& type, double price, double amount, double total);

    void getVariantBookModels();

    void sendCurrentBookModels();


private:
    QString token1 {""};
    QString token2 {""};
    QString network {""};

    QVector <OrderInfo> sellOrderModel;
    QVector <OrderInfo> buyOrderModel;

    QVector <FullOrderInfo> allOrders;

    QVariantList buyModel;
    QVariantList sellModel;

    int m_bookRoundPower {5};

    int m_bookRoundPowerMinimum {5};

    double m_sellMaxTotal {0.0};
    double m_buyMaxTotal {0.0};

    QQmlContext *context;
};

#endif // ORDERBOOKWORKER_H
