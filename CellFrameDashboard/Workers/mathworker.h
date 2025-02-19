#ifndef MATHWORKER_H
#define MATHWORKER_H

#include <QObject>
#include <QDebug>
#include <QString>


#include <dap_chain_common.h>

class MathWorker : public QObject
{
    Q_OBJECT

public:
    MathWorker(QObject *parent = nullptr);

    Q_INVOKABLE QVariant multCoins(QVariant arg1, QVariant arg2,  QVariant getDatoshi);
    Q_INVOKABLE QVariant multDatoshi(QVariant arg1, QVariant arg2,   QVariant getDatoshi);

    Q_INVOKABLE QVariant divDatoshi(QVariant arg1, QVariant arg2,   QVariant getDatoshi);
    Q_INVOKABLE QVariant divCoins(QVariant arg1, QVariant arg2,   QVariant getDatoshi);

    Q_INVOKABLE QVariant sumCoins(QVariant arg1, QVariant arg2,   QVariant getDatoshi);
    Q_INVOKABLE QVariant subCoins(QVariant arg1, QVariant arg2,   QVariant getDatoshi);

    Q_INVOKABLE QVariant isEqual(QVariant arg1, QVariant arg2);

    Q_INVOKABLE QVariant coinsToBalance(QVariant coins);
    Q_INVOKABLE QVariant balanceToCoins(QVariant balance);

    Q_INVOKABLE QString summDouble(const QString &value, const QString &step);

    void test();

};

#endif // MATHWORKER_H
