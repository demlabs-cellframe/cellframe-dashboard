#include "stringworker.h"

#include <QDebug>

StringWorker::StringWorker(QObject *parent) :
    QObject(parent)
{
//    toDatoshi("0.001234");
//    toDatoshi("12340");
//    qDebug() << compareStringNumbers1("12.345", "12.34567");
//    qDebug() << compareStringNumbers1("12.445", "12.345");
//    qDebug() << compareStringNumbers2("12.345", "12.34567");
//    qDebug() << compareStringNumbers2("12.445", "12.345");
//    qDebug() << clearZeros("00012.4450000");
//    qDebug() << clearZeros("000124450000");

//    qDebug() << testAmount("12.345", "12.34567");
//    qDebug() << testAmount("12.445", "12.345");
//    qDebug() << testAmount("00012.345", "12.3456700");
//    qDebug() << testAmount("00012.445", "12.34500");
}

bool StringWorker::testAmount(const QString &balance, const QString &amount) const
{
    qDebug() << "testAmount" << balance << amount;

    QStringList balanceArray = clearZeros(balance).split('.');
    QStringList amountArray = clearZeros(amount).split('.');

    if (balanceArray.size() < 1 || amountArray.size() < 1)
        return false;

    if (compareStringNumbers1(balanceArray[0], amountArray[0]) > 0)
        return true;

    if (compareStringNumbers1(balanceArray[0], amountArray[0]) < 0)
        return false;

    if (amountArray.size() < 2)
        return true;

    if (balanceArray.size() < 2)
        return false;

    if (compareStringNumbers2(balanceArray[1], amountArray[1]) > 0)
        return true;

    if (compareStringNumbers2(balanceArray[1], amountArray[1]) < 0)
        return false;

    return true;
}

QString StringWorker::clearZeros(const QString &str) const
{
//    qDebug() << "clearZeros" << str;

    QString newStr = str;

    auto i = 0;
    while (i < newStr.size() && newStr[i] == '0')
        ++i;
    newStr = newStr.right(newStr.size() - i);

    if (newStr.indexOf('.') == -1)
        return newStr;

    i = newStr.size()-1;
    while (i >= 0 && newStr[i] == '0')
        --i;
    newStr = newStr.left(i+1);

    return newStr;
}

int StringWorker::compareStringNumbers1(
        const QString &str1, const QString &str2) const
{
//    qDebug() << "compareStringNumbers1" << str1 << str2;

    if (str1 == str2)
        return 0;

    if (str1.size() < str2.size())
        return -1;

    if (str1.size() > str2.size())
        return 1;

    if (str1 < str2)
        return -1;

    if (str1 > str2)
        return 1;

    return 0;
}

int StringWorker::compareStringNumbers2(
        const QString &str1, const QString &str2) const
{
//    qDebug() << "compareStringNumbers2" << str1 << str2;

    if (str1 == str2)
        return 0;

    auto size = str1.size();

    if (str1.size() > str2.size())
        size = str2.size();

    for (auto i = 0; i < size; ++i)
    {
        if (str1[i] < str2[i])
            return -1;
        if (str1[i] > str2[i])
            return 1;
    }

    if (str1.size() < str2.size())
        return -1;

    if (str1.size() > str2.size())
        return 1;

    return 0;
}

const int afterDot = 18;

QString StringWorker::toDatoshi(const QString &str) const
{
//    qDebug() << "toDatoshi" << str;

    QString newStr = str;

    auto dotIndex = newStr.indexOf('.');

    if (dotIndex == -1)
        newStr += QString("0").repeated(afterDot);
    else
    {
        auto shift = afterDot + 1 - newStr.size() + dotIndex;

        newStr += QString("0").repeated(shift);

        qDebug() << newStr.left(dotIndex)
                 << newStr.right(newStr.size() - dotIndex-1);

        newStr = newStr.left(dotIndex) + newStr.right(newStr.size() - dotIndex-1);
    }

    auto i = 0;

    while (i < newStr.size() && newStr[i] == '0')
        ++i;
    newStr = newStr.right(newStr.size() - i);

//    qDebug() << "newStr" << newStr;

    return newStr;
}
