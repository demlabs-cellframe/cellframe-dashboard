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

    Q_PROPERTY(QString buyTokenCount READ getBuyTokenCount WRITE setBuyTokenCount NOTIFY buyTokenCountChanged)
    QString getBuyTokenCount() {return m_buyTokenCount;}
    void setBuyTokenCount(const QString& value);

    Q_PROPERTY(QString sellTokenCount READ getSellTokenCount WRITE setSellTokenCount NOTIFY sellTokenCountChanged)
    QString getSellTokenCount() {return m_sellTokenCount;}
    void setSellTokenCount(const QString& value);

    Q_PROPERTY(QString network READ getNetwork WRITE setNetwork NOTIFY networkChanged)
    QString getNetwork() {return m_network;}
    void setNetwork(const QString& value);

    bool isCompatibleToken();
public slots:
    void currentPairChanged(const DEX::InfoTokenPair& pair);

signals:
    void sellTokenChanged();
    void buyTokenChanged();
    void networkChanged();
    void buyTokenCountChanged();
    void sellTokenCountChanged();
private:
    QList<DEX::InfoTokenPair>& m_tokensPair;

    QString m_sellToken = "";
    QString m_network = "";
    QString m_buyToken = "";
    QString m_buyTokenCount = "";
    QString m_sellTokenCount = "";
};

