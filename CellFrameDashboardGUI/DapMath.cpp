#include "DapMath.h"

DapMath::DapMath(QObject *parent) :
    QObject(parent)
{
//    test();
}

void DapMath::test()
{
    QString testStr =  "1000000000000000000000999";
    QString testStr2 = "1000000000000000000000888";

//    uint256_t a = dap_cvt_str_to_uint256();     //str -> uint256
//    uint256_t b = dap_chain_coins_to_balance(); //strCoins - > uint256 balance
//    QString c = dap_chain_balance_to_coins ();  //uint256 balance -> str coins
//    QString d =dap_chain_balance_print ();      //uint256 balance -> str balance

    uint256_t test = dap_cvt_str_to_uint256(testStr.toStdString().data());
    uint256_t test2 = dap_cvt_str_to_uint256(testStr2.toStdString().data());
    uint256_t accum = {};


    QVariant resCompare = EQUAL_256(test, test2);

    QString str1 = dap_chain_balance_to_coins(test);
    QString str2 = dap_chain_balance_to_coins(test2);

    MULT_256_256(test, test2, &accum); // '*'
    QString strMult = dap_chain_balance_to_coins(accum);

    SUM_256_256(test, test2, &accum); // '+'
    QString strSum  = dap_chain_balance_to_coins(accum);

    DIV_256(test, test2, &accum); // '/'
    QString strDiv  = dap_chain_balance_to_coins(accum);

    SUBTRACT_256_256(test, test2, &accum); // '-'
    QString strSub  = dap_chain_balance_to_coins(accum);

    qDebug()<<" arg1: " << str1 <<   "\n" <<
              "arg2: " << str2 <<    "\n" <<
              "Mult: " << strMult << "\n" <<
              "Div: "  << strDiv <<  "\n" <<
              "Sum: "  << strSum <<  "\n" <<
              "Sub: "  << strSub;
}

QVariant DapMath::multCoins(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty() ||
       arg1.toString() == "0" || arg2.toString() == "0") return "0";

    uint256_t arg1_256 = dap_cvt_str_to_uint256(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_cvt_str_to_uint256(arg2.toString().toStdString().data());
    uint256_t accum = {};

    MULT_256_COIN(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant DapMath::divCoins(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty() ||
       arg1.toString() == "0" || arg2.toString() == "0") return "0";

    uint256_t arg1_256 = dap_cvt_str_to_uint256(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_cvt_str_to_uint256(arg2.toString().toStdString().data());

    uint256_t accum = {};

    DIV_256_COIN(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant DapMath::multDatoshi(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty() ||
       arg1.toString() == "0" || arg2.toString() == "0") return "0";

    uint256_t arg1_256 = dap_cvt_str_to_uint256(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_cvt_str_to_uint256(arg2.toString().toStdString().data());
    uint256_t accum = {};

    MULT_256_256(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant DapMath::divDatoshi(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty() ||
       arg1.toString() == "0" || arg2.toString() == "0") return "0";

    uint256_t arg1_256 = dap_cvt_str_to_uint256(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_cvt_str_to_uint256(arg2.toString().toStdString().data());

    uint256_t accum = {};

    DIV_256(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant DapMath::sumCoins(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty()) return "0";

    uint256_t arg1_256 = dap_cvt_str_to_uint256(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_cvt_str_to_uint256(arg2.toString().toStdString().data());
    uint256_t accum = {};

    SUM_256_256(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant DapMath::subCoins(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty()) return "0";

    uint256_t arg1_256 = dap_cvt_str_to_uint256(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_cvt_str_to_uint256(arg2.toString().toStdString().data());
    uint256_t accum = {};

    SUBTRACT_256_256(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant DapMath::isEqual(QVariant arg1, QVariant arg2)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty()) return true;

    uint256_t arg1_256 = dap_cvt_str_to_uint256(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_cvt_str_to_uint256(arg2.toString().toStdString().data());

    return EQUAL_256(arg1_256, arg2_256);
}

QVariant DapMath::coinsToBalance(QVariant coins)
{
    if(coins.toString().isEmpty()) return "0";

    QString cointStr = coins.toString();
    QString value;
    if(cointStr.contains(".") && cointStr[cointStr.length() - 1] != ".")
        value = cointStr;
    else
        value = QString::number(coins.toDouble(), 'f', 1);

    uint256_t convert = dap_chain_coins_to_balance(value.toStdString().data());
    return dap_chain_balance_print(convert);
}

QVariant DapMath::balanceToCoins(QVariant balance)
{
    if(balance.toString().isEmpty()) return "0";

    uint256_t convert =  dap_cvt_str_to_uint256(balance.toString().toStdString().data());
    return dap_chain_balance_to_coins(convert);
}