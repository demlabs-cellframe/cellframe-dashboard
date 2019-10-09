#include "DapChainConvertor.h"

DapChainConvertor::DapChainConvertor(QObject *parent) : QObject(parent)
{

}

DapChainConvertor& DapChainConvertor::getInstance()
{
    static DapChainConvertor instance;
    return instance;
}

QString DapChainConvertor::toConvertCurrency(const QString& aMoney)
{
    QString money;

    QStringList major = aMoney.split(".");
    if(!major.isEmpty()) money = major.at(0);
    else money = aMoney;

    for (int i = money.size() - 3; i >= 1; i -= 3)
        money.insert(i, ' ');

    if(major.count() > 1) money.append("." + major.at(1));

    return money;
}
