#ifndef TOKENPAIRSWORKER_H
#define TOKENPAIRSWORKER_H

#include <QObject>
#include <QVector>
#include <QQmlContext>

#include "TokenPairInfo.h"

class TokenPairsWorker : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int currentPairIndex READ currentPairIndex WRITE setCurrentPairIndex NOTIFY currentPairIndexChanged)

    Q_PROPERTY(QString tokenBuy READ tokenBuy NOTIFY tokenBuyChanged)
    Q_PROPERTY(QString tokenSell READ tokenSell NOTIFY tokenSellChanged)
    Q_PROPERTY(QString tokenNetwork READ tokenNetwork NOTIFY tokenNetworkChanged)
    Q_PROPERTY(double tokenPrice READ tokenPrice NOTIFY tokenPriceChanged)
    Q_PROPERTY(QString tokenPriceText READ tokenPriceText NOTIFY tokenPriceTextChanged)

public:
    explicit TokenPairsWorker(QQmlContext *cont, QObject *parent = nullptr);

    Q_INVOKABLE void setPairModel(const QByteArray &json);

    int currentPairIndex() const
        { return m_currentPairIndex; }

    QString tokenBuy() const
        { return m_tokenBuy; }
    QString tokenSell() const
        { return m_tokenSell; }
    QString tokenNetwork() const
        { return m_tokenNetwork; }
    double tokenPrice() const
        { return m_tokenPrice; }
    QString tokenPriceText() const
        { return m_tokenPriceText; }

public slots:
    void setCurrentPairIndex(int index);

signals:
    void currentPairIndexChanged(int index);

    void tokenBuyChanged(QString token);
    void tokenSellChanged(QString token);
    void tokenNetworkChanged(QString network);
    void tokenPriceChanged(double price);
    void tokenPriceTextChanged(QString price);

    void setTokenPair(const QString &tok1,
        const QString &tok2, const QString &net);

    void pairModelUpdated();

private:
    void sendCurrentPairModel();

private:
    QQmlContext *context;

    QVector <TokenPairInfo> pairModel;

    QVariantList model;

    int m_currentPairIndex {0};

    QString m_tokenBuy {"-"};
    QString m_tokenSell {"-"};
    QString m_tokenNetwork {"-"};
    double m_tokenPrice {0.0};
    QString m_tokenPriceText {"0.0"};
};

#endif // TOKENPAIRSWORKER_H
