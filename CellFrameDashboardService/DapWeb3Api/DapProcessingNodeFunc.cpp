#include "DapWebControll.h"

QString DapWebControll::send_cmd(QString cmd)
{
    QProcess process;
    qDebug() << "command:" << cmd;
    process.start(cmd);
    process.waitForFinished(-1);
    QString result = process.readAll();
    result.replace("\t", "");
    qDebug() << "result:" << result;
    return result;
}

QJsonDocument DapWebControll::processingResult(QString status, QString errorMsg, QJsonObject data)
{
    QJsonObject obj;
    obj.insert("status", status);
    obj.insert("errorMsg", errorMsg);
    obj.insert("data", data);
    QJsonDocument doc(obj);
    return doc;
}

QJsonDocument DapWebControll::processingResult(QString status, QString errorMsg, QJsonArray data)
{
    QJsonObject obj;
    obj.insert("status", status);
    obj.insert("errorMsg", errorMsg);
    obj.insert("data", data);
    QJsonDocument doc(obj);
    return doc;
}

QJsonDocument DapWebControll::processingResult(QString status, QString errorMsg, QString data)
{
    QJsonObject obj;
    obj.insert("status", status);
    obj.insert("errorMsg", errorMsg);
    obj.insert("data", data);
    QJsonDocument doc(obj);
    return doc;
}

QJsonDocument DapWebControll::processingResult(QString status, QString errorMsg)
{
    QJsonObject obj;
    obj.insert("status", status);
    obj.insert("errorMsg", errorMsg);
    obj.insert("data", "");
    QJsonDocument doc(obj);
    return doc;
}

QJsonDocument DapWebControll::getWallets()
{
    QString command = QString("%1 wallet list")
            .arg(CLI_PATH);

    QString result = send_cmd(command);
    QJsonDocument docResult;

    if(!result.isEmpty())
    {

        QJsonArray jsonArr;

        QRegularExpression rx("wallet:\\s(.+)\\s", QRegularExpression::MultilineOption);
        QRegularExpressionMatchIterator itr = rx.globalMatch(result);
        if(itr.hasNext()){
            while (itr.hasNext()){
                QRegularExpressionMatch match = itr.next();
                QString walletName = match.captured(1);
                walletName = walletName.split("\r")[0];
                jsonArr.append(QJsonValue(walletName));
            }
            docResult = processingResult("ok", "", jsonArr);
        }else{
            qWarning() << "Can't parse result" << result;
            docResult = processingResult("bad", "Can't parse result. " + result);
        }
    }else{
        docResult = processingResult("bad", "", QString("Node is offline"));
    }
    return docResult;
}

QJsonDocument DapWebControll::getNetworks()
{
    QString command = QString("%1 net list")
            .arg(CLI_PATH);

    QString result = send_cmd(command);

    QJsonDocument docResult;
    QJsonArray jsonArr;
    QStringList list;

    result.remove(' ');
    result.remove('\r');
    result.remove('\t');
    result.remove("Networks:");

    if(!(result.isEmpty() || result.isNull() || result.contains('\'')))
    {
        list = result.split('\n', QString::SkipEmptyParts);
        for(int i = 0; i < list.length(); i++)
            jsonArr.append(list[i]);

        docResult = processingResult("ok", "", jsonArr);
    }
    else
    {
        qWarning() << "Can't parse result" << result;
        docResult = processingResult("bad", "Can't parse result. " + result);
    }
    return docResult;
}

QJsonDocument DapWebControll::getDataWallets(QString walletName)
{
    QString command = QString("%1 net list")
            .arg(CLI_PATH);
    QString result = send_cmd(command);

    result.remove(' ');
    result.remove('\r');
    result.remove("Networks:");
    result.remove(':');

    QJsonDocument docResult;
    QJsonArray arrObj;
    QStringList netlist;

    if(!(result.isEmpty() || result.isNull() || result.contains('\'')))
        netlist = result.split('\n', QString::SkipEmptyParts);
    else
    {
        qWarning() << "Can't parse result" << result;
        docResult = processingResult("bad", "Can't parse result. " + result);
        return docResult;
    }

    for (QString net: netlist)
    {
        QString command = QString("%1 wallet info -w %2 -net %3")
                .arg(CLI_PATH)
                .arg(walletName)
                .arg(net);

        QString result = send_cmd(command);

#ifdef Q_OS_WIN
        QRegularExpression regex(R"(^wallet: (\S+)\r\naddr: (\S+)\r\nnetwork: (\S+)\r\nbalance:)");
        QRegularExpression regex2(R"(^wallet: (\S+)\r\naddr: (\S+)\r\nnetwork: (\S+)\r\nbalance: (\S+))");
#else
        QRegularExpression regex(R"(^wallet: (\S+)\naddr: (\S+)\nnetwork: (\S+)\nbalance: (\S+))");
        QRegularExpression regex2(R"(^wallet: (\S+)\naddr: (\S+)\nnetwork: (\S+)\nbalance:)");
#endif
        QRegularExpressionMatch match = regex.match(result).hasMatch()?regex.match(result): regex2.match(result);

        if (!match.hasMatch()){
            qWarning() << "Can't parse result" << result;
            QString str = QString("Can't parse result. Wallet name: %1 . %2").arg("' " + walletName + " '").arg(result);
            return docResult = processingResult("bad", str);
        }else{
            QString addr, balance;
            addr = match.captured(2);
            balance = match.captured(4);
            QJsonArray arrJson;

            if(balance != "0"){
                QRegularExpression balanceRegex1(R"((\d+.\d+) \((\d+)\) (\w+))");
                QRegularExpression balanceRegex2(R"((\d+.) \((\d+)\) (\w+))");
                QRegularExpressionMatchIterator matchIt1 = balanceRegex1.globalMatch(result);
                QRegularExpressionMatchIterator matchIt2 = balanceRegex2.globalMatch(result);
                QRegularExpressionMatchIterator matchIt = matchIt1.hasNext() ? matchIt1 : matchIt2;
                while (matchIt.hasNext()){
                    QRegularExpressionMatch match = matchIt.next();
                    auto data = QJsonObject({
                        qMakePair(QString("balance"),    QJsonValue(match.captured(1))),
                        qMakePair(QString("datoshi"),    QJsonValue(match.captured(2))),
                        qMakePair(QString("tokenName"),  QJsonValue(match.captured(3))),
                    });
                    arrJson.push_back(data);
                }
            }else{
                auto data = QJsonObject({
                    qMakePair(QString("balance"),   QJsonValue(balance)),
                    qMakePair(QString("datoshi"),   QJsonValue("0")),
                    qMakePair(QString("tokenName"), QJsonValue("0")),
                });
                arrJson.push_back(data);
            }
            QJsonObject obj;
            obj.insert("network", net);
            obj.insert("address", addr);
            obj.insert("tokens", arrJson);
            arrObj.push_back(obj);
        }
    }
    return docResult = processingResult("ok", "", arrObj);
}

QJsonDocument DapWebControll::sendTransaction(QString walletName, QString to, QString value, QString tokenName, QString net)
{
    QString txCommand = QString("%1 tx_create -net %2 -chain %3 -from_wallet %4 "
                              "-to_addr %5 -token %6 -value %7").arg(CLI_PATH);

    QString chain;

    if(net != "private")
    {
        if(net != "subzero")
            chain = "main";
        else
            chain = "support";
    }
    else
        chain = "zero";

    txCommand = txCommand.arg(net);
    txCommand = txCommand.arg(chain);
    txCommand = txCommand.arg(walletName);
    txCommand = txCommand.arg(to);
    txCommand = txCommand.arg(tokenName);
    txCommand = txCommand.arg(value);

    QString resultTx = send_cmd(txCommand);
    QJsonDocument docResult;

    if(!resultTx.isEmpty())
    {
        QJsonObject res;

        QRegExp rx("transfer=(\\w+)");
        rx.indexIn(resultTx, 0);

        if(rx.cap(1) == "Ok"){
            QRegExp rxHash("tx_hash=0x(\\w+)");
            rxHash.indexIn(resultTx, 0);
            res.insert("transfer", rx.cap(1));
            res.insert("hash", rxHash.cap(1));
            docResult = processingResult("ok", "", res);
        }else{
            docResult = processingResult("bad", resultTx, res);
        }
    }else{
        docResult = processingResult("bad", "", QString("Node is offline"));
    }

    return docResult;
}

QJsonDocument DapWebControll::getTransactions(QString addr, QString net)
{
    QString txHistoryCommand = QString("%1 tx_history -net %2 -chain %3 -addr %4").arg(CLI_PATH);

    QString chain;
    if(net != "private")
    {
        if(net != "subzero")
            chain = "main";
        else
            chain = "support";
    }
    else
        chain = "zero";

    txHistoryCommand = txHistoryCommand.arg(net);
    txHistoryCommand = txHistoryCommand.arg(chain);
    txHistoryCommand = txHistoryCommand.arg(addr);

    QString result = send_cmd(txHistoryCommand);
//    result.replace("\t", "");

    QJsonDocument docResult;

    if(!result.isEmpty())
    {
        QRegularExpression regular("\\w*\\s+\\w*((\\w{3}\\s+){2}\\d{1,2}\\s+(\\d{1,2}:*){3}\\s+\\d{4})\\s+(\\w+)\\s+(\\d+)\\s(\\w+)\\s+\\w+\\s+([\\w\\d]+)", QRegularExpression::MultilineOption);
        QRegularExpressionMatchIterator matchItr = regular.globalMatch(result);
        QJsonArray arrJson;

        if(matchItr.hasNext()){
            while (matchItr.hasNext()){

                QRegularExpressionMatch match = matchItr.next();
                QStringList s = match.capturedTexts();
                QString txHash = s[0].split(" ")[0].split("\n")[0];
                QString amountWithoutZeros = match.captured(5);

                if (amountWithoutZeros.length() <= 18){
                    while (amountWithoutZeros.length() < 18)
                        amountWithoutZeros.prepend('0');
                    amountWithoutZeros.prepend("0.");
                }else{
                    amountWithoutZeros.insert(amountWithoutZeros.length()-18, '.');
                }

                while (amountWithoutZeros.back() == '0')
                    amountWithoutZeros.remove(amountWithoutZeros.length()-1, 1);
                if (amountWithoutZeros.back() == '.')
                    amountWithoutZeros.remove(amountWithoutZeros.length()-1, 1);
                auto data = QJsonObject({
                    qMakePair(QString("date"),           QJsonValue(QDateTime::fromString(match.captured(1)).toString("yyyy-MM-dd"))),
                    qMakePair(QString("status"),         QJsonValue(match.captured(4) == "send" ? "Sent" : "Received")),
                    qMakePair(QString("amountDatoshi"),  QJsonValue(match.captured(5))),
                    qMakePair(QString("amount"),         QJsonValue(amountWithoutZeros)),
                    qMakePair(QString("tokenName"),      QJsonValue(match.captured(6))),
//                    qMakePair(QString("walletName"),     QJsonValue(walletName)),
                    qMakePair(QString("network"),        QJsonValue(net)),
                    qMakePair(QString("secsSinceEpoch"), QJsonValue(QDateTime::fromString(match.captured(1)).toSecsSinceEpoch())),
                    qMakePair(QString("hash"),           QJsonValue(txHash))
                });
                arrJson.push_back(data);
            }
            docResult = processingResult("ok", "", arrJson);
        }else{
            docResult = processingResult("bad", QString(result));
        }
    }else{
        docResult = processingResult("bad", QString("Node is offline"));
    }
    return docResult;
}

QJsonDocument DapWebControll::getTxHistoryInfo(QString hash, QString net)
{
    QString command = QString("%1 ledger tx -tx %1 -net %2")
            .arg(CLI_PATH).arg(hash).arg(net);

    QString result = send_cmd(command);

    QJsonDocument docResult;
    QJsonObject obj;

    if(!result.isEmpty())
    {
        obj.insert("string", result);
        docResult = processingResult("ok", "", obj);
    }else{
        docResult = processingResult("bad", QString("Node is offline"));
    }

    return docResult;
}

QJsonDocument DapWebControll::sendJsonTransaction(QJsonDocument jsonCommand)
{
    QString path = s_pathJsonCmd + "tx_json.json";
    QFile file(path);

    if(file.open(QIODevice::WriteOnly))
    {
        file.write(jsonCommand.toJson());
        file.close();
    }

    QString txCustomCommand = QString("%1 tx_create_json -json %2").arg(CLI_PATH).arg(path);
    QString result = send_cmd(txCustomCommand);

    QJsonDocument docResult;
    if(result.isEmpty())
        docResult = processingResult("bad", QString("Node is offline"));
    else
        docResult = processingResult("ok", "", result);

    return docResult;
}
