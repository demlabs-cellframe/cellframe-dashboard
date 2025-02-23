#ifndef ORDERBOOKWORKER_H
#define ORDERBOOKWORKER_H

#include <QObject>
#include <QVector>
#include <QQmlContext>
#include "Models/DEXModel/DEXTypes.h"
#include "ChartTypes.h"

class OrderBookWorker : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int sellOrderModelSize READ sellOrderModelSize)
    Q_PROPERTY(int buyOrderModelSize READ buyOrderModelSize)

    Q_PROPERTY(QString sellMaxTotal READ sellMaxTotal NOTIFY sellMaxTotalChanged)
    Q_PROPERTY(QString buyMaxTotal READ buyMaxTotal NOTIFY buyMaxTotalChanged)

    Q_PROPERTY(int bookRoundPower READ bookRoundPower NOTIFY bookRoundPowerChanged)
    Q_PROPERTY(int bookRoundPowerMinimum READ bookRoundPowerMinimum)

public:
    explicit OrderBookWorker(QQmlContext *cont, QObject *parent = nullptr);

    Q_INVOKABLE void resetBookModel();

    Q_INVOKABLE void generateBookModel(double price, int length, double step);

    Q_INVOKABLE void setBookModel(const QByteArray &json);

    Q_INVOKABLE void setBookRoundPower(const QString &text);

    Q_INVOKABLE double getfilledForPrice(bool isSell, const QString& price);

    int sellOrderModelSize() const { return sellOrderModel.size(); }
    int buyOrderModelSize() const  { return buyOrderModel.size(); }

    QString sellMaxTotal() const { return m_sellMaxTotal; }
    QString buyMaxTotal() const  { return m_buyMaxTotal; }

    int bookRoundPower() const { return m_bookRoundPower; }
    int bookRoundPowerMinimum() const { return m_bookRoundPowerMinimum; }

public slots:
    void checkBookRoundPower(double currentTokenPrice);

    void setTokenPair(const QString &tok1, const QString &tok2, const QString &net);
    void setTokenPair(const DEX::InfoTokenPair& info);

    void setCurrentRate(const QString& rate);
signals:
    void sellMaxTotalChanged(QString max);
    void buyMaxTotalChanged(QString max);

    void bookRoundPowerChanged(int power);

    void setNewBookRoundPowerMinimum(int power);

private:
    QString roundDoubleValue(const QString& value);

    void updateBookModels();

    void insertBookOrder(const FullOrderInfo& item);

    void getVariantBookModels();

    void sendCurrentBookModels();

    inline QString invertValue(const QString& price);
    inline QString sumCoins(const QString& val1, const QString& val2);
    inline QString multCoins(const QString& val1, const QString& val2);
    inline QString divCoins(const QString& val1, const QString& val2);
    inline double roundCoinsToDouble(const QString& value, int round = 3);
    inline int compareCoins(const QString& val1, const QString& val2);
private:
    QString m_token1 {""};
    QString m_token2 {""};
    QString m_network {""};

    Dap::Coin m_currentRate;

    QVector <OrderInfo> sellOrderModel;
    QVector <OrderInfo> buyOrderModel;

    QVector <FullOrderInfo> m_allOrders;

    QVariantList buyModel;
    QVariantList sellModel;

    int m_bookRoundPower {0};

    int m_bookRoundPowerMinimum {5};

    QString m_sellMaxTotal {""};
    QString m_buyMaxTotal {""};

    QQmlContext *context;

    const QRegularExpression REGULAR_ZERO_VALUE = QRegularExpression(R"(^[0.]*$|\.$)");
};

#endif // ORDERBOOKWORKER_H
