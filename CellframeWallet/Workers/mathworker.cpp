#include "mathworker.h"

MathWorker::MathWorker(QObject *parent) :
    QObject(parent)
{
//    test();
}

void MathWorker::test()
{

//    uint256_t a = dap_uint256_scan_uninteger();     //str -> uint256
//    uint256_t b = dap_chain_coins_to_balance(); //strCoins - > uint256 balance
//    QString c = dap_chain_balance_to_coins ();  //uint256 balance -> str coins
//    QString d = dap_chain_balance_print ();      //uint256 balance -> str balance

    QString testStr =  "1000000000000000000";
    QString testStr2 = "3";

//    uint64_t convertTest = 0.000000000000000013f;
//    uint256_t test = dap_chain_uint256_from(convertTest);
//    uint64_t convertTest2 = 0.5f;
//    uint256_t test2 = dap_chain_uint256_from(convertTest2);

    uint256_t test = dap_uint256_scan_uninteger(testStr.toStdString().data());
    uint256_t test2 = dap_uint256_scan_uninteger(testStr2.toStdString().data());
//    qDebug()<< dap_chain_balance_to_coins(accum)

    uint256_t accum = {};

    DIV_256(test, test2, &accum); // '*'
    QString strMult_ = dap_chain_balance_to_coins(accum);


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

QVariant MathWorker::multCoins(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty() ||
       arg1.toString() == "0" || arg2.toString() == "0") return "0";

    uint256_t arg1_256 = dap_uint256_scan_uninteger(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_uint256_scan_uninteger(arg2.toString().toStdString().data());
    uint256_t accum = {};

    MULT_256_COIN(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant MathWorker::divCoins(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty() ||
       arg1.toString() == "0" || arg2.toString() == "0") return "0";

    uint256_t arg1_256 = dap_uint256_scan_uninteger(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_uint256_scan_uninteger(arg2.toString().toStdString().data());

    uint256_t accum = {};

    DIV_256_COIN(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant MathWorker::multDatoshi(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty() ||
       arg1.toString() == "0" || arg2.toString() == "0") return "0";

    uint256_t arg1_256 = dap_uint256_scan_uninteger(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_uint256_scan_uninteger(arg2.toString().toStdString().data());
    uint256_t accum = {};

    MULT_256_256(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant MathWorker::divDatoshi(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty() ||
       arg1.toString() == "0" || arg2.toString() == "0") return "0";

    uint256_t arg1_256 = dap_uint256_scan_uninteger(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_uint256_scan_uninteger(arg2.toString().toStdString().data());

    uint256_t accum = {};

    DIV_256(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant MathWorker::sumCoins(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty()) return "0";

    uint256_t arg1_256 = dap_uint256_scan_uninteger(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_uint256_scan_uninteger(arg2.toString().toStdString().data());
    uint256_t accum = {};

    SUM_256_256(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant MathWorker::subCoins(QVariant  arg1, QVariant arg2, QVariant getDatoshi)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty()) return "0";

    uint256_t arg1_256 = dap_uint256_scan_uninteger(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_uint256_scan_uninteger(arg2.toString().toStdString().data());
    uint256_t accum = {};

    SUBTRACT_256_256(arg1_256, arg2_256, &accum);

    if(getDatoshi.toBool())
        return dap_chain_balance_print(accum);
    else
        return dap_chain_balance_to_coins(accum);
}

QVariant MathWorker::isEqual(QVariant arg1, QVariant arg2)
{
    if(arg1.toString().isEmpty() || arg2.toString().isEmpty()) return true;

    uint256_t arg1_256 = dap_uint256_scan_uninteger(arg1.toString().toStdString().data());
    uint256_t arg2_256 = dap_uint256_scan_uninteger(arg2.toString().toStdString().data());

    return EQUAL_256(arg1_256, arg2_256);
}

QVariant MathWorker::coinsToBalance(QVariant coins)
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

QVariant MathWorker::balanceToCoins(QVariant balance)
{
    if(balance.toString().isEmpty()) return "0";

    uint256_t convert =  dap_uint256_scan_uninteger(balance.toString().toStdString().data());
    return dap_chain_balance_to_coins(convert);
}

QString MathWorker::summDouble(const QString &value, const QString &step)
{
    // convert to double
    bool ok1, ok2;
    double valueNumber = value.toDouble(&ok1);
    double stepNumber = step.toDouble(&ok2);
    if (ok1 && ok2)
    {
        // get precision
        QStringList strSplit;
        int precision = 0;

        strSplit = value.split(".");
        if(strSplit.count() > 1)
        {
            precision = strSplit[1].length();
        }
        strSplit = step.split(".");
        if(strSplit.count() > 1)
        {
            if(strSplit[1].length() > precision)  precision = strSplit[1].length();
        }

        // return summ
        double summ = valueNumber + stepNumber;
        return QString::number(summ,'f', precision);
    }
    else
    {
        return QString();
    }
}
