#ifndef STRINGWORKER_H
#define STRINGWORKER_H

#include <QObject>

class StringWorker : public QObject
{
    Q_OBJECT

public:
    explicit StringWorker(QObject *parent = nullptr);

    Q_INVOKABLE bool testAmount(
            const QString &balance, const QString &amount) const;
    Q_INVOKABLE QString clearZeros(const QString &str) const;
    Q_INVOKABLE int compareStringNumbers1(
            const QString &str1, const QString &str2) const;
    Q_INVOKABLE int compareStringNumbers2(
            const QString &str1, const QString &str2) const;
    Q_INVOKABLE QString toDatoshi(const QString &str) const;

};

#endif // STRINGWORKER_H
