#pragma once

#include <QObject>
#include <QString>
#include <QList>
#include "Models/DEXModel/DEXTypes.h"

class DapRegularTokenType : public QObject
{
    Q_OBJECT
public:
    explicit DapRegularTokenType(QList<DEX::InfoTokenPair> &pairsInfo, QObject *parent = nullptr);

    Q_PROPERTY(QString sellToken READ getSellToken WRITE setSellToken NOTIFY sellTokenChanged)
    QString getSellToken() {return m_sellToken;}
    void setSellToken(const QString& value);

    Q_PROPERTY(QString buyToken READ getBuyToken WRITE setBuyToken NOTIFY buyTokenChanged)
    QString getBuyToken() {return m_buyToken;}
    void setBuyToken(const QString& value);

    Q_PROPERTY(QString sellNetwork READ getSellNetwork WRITE setSellNetwork NOTIFY sellNetworkChanged)
    QString getSellNetwork() {return m_sellNetwork;}
    void setSellNetwork(const QString& value);

    Q_PROPERTY(QString buyNetwork READ getBuyNetwork WRITE setBuyNetwork NOTIFY buyNetworkChanged)
    QString getBuyNetwork() {return m_buyNetwork;}
    void setBuyNetwork(const QString& value);

    bool isCompatibleToken();
public slots:
    void currentPairChanged(const DEX::InfoTokenPair& pair);

signals:
    void sellTokenChanged();
    void buyTokenChanged();
    void sellNetworkChanged();
    void buyNetworkChanged();
private:
    QList<DEX::InfoTokenPair>& m_tokensPair;

    QString m_sellToken = "";
    QString m_sellNetwork = "";
    QString m_buyToken = "";
    QString m_buyNetwork = "";
};

