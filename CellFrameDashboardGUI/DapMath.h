#ifndef DAPMATH_H
#define DAPMATH_H

#include <QObject>
#include <QDebug>

#include <dap_chain_common.h>

class DapMath : public QObject
{
    Q_OBJECT

public:
    DapMath(QObject *parent = nullptr);

    Q_INVOKABLE QVariant multCoins(QVariant arg1, QVariant arg2,  QVariant getDatoshi);
    Q_INVOKABLE QVariant multDatoshi(QVariant arg1, QVariant arg2,   QVariant getDatoshi);

    Q_INVOKABLE QVariant divDatoshi(QVariant arg1, QVariant arg2,   QVariant getDatoshi);
    Q_INVOKABLE QVariant divCoins(QVariant arg1, QVariant arg2,   QVariant getDatoshi);

    Q_INVOKABLE QVariant sumCoins(QVariant arg1, QVariant arg2,   QVariant getDatoshi);
    Q_INVOKABLE QVariant subCoins(QVariant arg1, QVariant arg2,   QVariant getDatoshi);

    Q_INVOKABLE QVariant isEqual(QVariant arg1, QVariant arg2);

    Q_INVOKABLE QVariant coinsToBalance(QVariant coins);
    Q_INVOKABLE QVariant balanceToCoins(QVariant balance);

    void test();

};

#endif // DAPMATH_H
