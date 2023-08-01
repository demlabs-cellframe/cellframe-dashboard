#ifndef DAPTXWORKER_H
#define DAPTXWORKER_H

#include <QObject>
#include <QDebug>
#include <QVariantMap>
#include <QVariant>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include "Workers/stringworker.h"
#include "Workers/mathworker.h"

class DapTxWorker : public QObject
{
    Q_OBJECT
public:
    explicit DapTxWorker(QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap getFee(QString net);
    Q_INVOKABLE QVariantMap getAvailableBalance(QVariantMap);
    Q_INVOKABLE QVariant calculatePrecentAmount(QVariantMap);
    Q_INVOKABLE QVariantMap approveTx(QVariantMap);
    Q_INVOKABLE void sendTx(QVariantMap);

    QJsonDocument m_feeBuffer;
    QJsonDocument m_walletBuffer;


    enum Errors{
        NO_ERROR = 0,
        RCV_FEE_ERROR = 1,
        NOT_ENOUGHT_TOKENS,
        NOT_ENOUGHT_TOKENS_FOR_PAY_FEE,
        NO_TOKENS,
        UNKNOWN_ERROR
    };


private:
    QVariantMap getBalanceInfo(QString name, QString network, QString feeTicker, QString sendTicker);

signals:

    void sigSendTx(QStringList);

};

#endif // DAPTXWORKER_H
