#include "DapCommonDexMethods.h"
#include "DapCoin.h"

bool DapCommonDexMethods::isCorrectAmount(const QString& value)
{
    Dap::Coin amount(value);
    Dap::Coin minAmount(QString("0.0001"));
    Dap::Coin nullAmount(QString("0.0"));
    if(amount < minAmount && amount > nullAmount)
    {
        return false;
    }
    return true;
}
