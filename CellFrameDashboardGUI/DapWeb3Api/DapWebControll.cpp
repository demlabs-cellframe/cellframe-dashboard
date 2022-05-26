#include "DapWebControll.h"

DapWebControll::DapWebControll(QObject *parent)
    : QObject{parent}
{

    s_defaultNet = "Backbone";
    s_defaultChain = "main";

    QHttpServer *server = new QHttpServer(this);
    connect(server, SIGNAL(newRequest(QHttpRequest*, QHttpResponse*)),
            this, SLOT(handleRequest(QHttpRequest*, QHttpResponse*)));

    server->listen(QHostAddress::Any, 8085);

    //FOR TEST

//    getWallets(); //OK
//    getDataWallets("tokenWallet"); //OK
//    sendTransaction("tokenWallet", "mWNv7A43YnqRHCWVFHQJXMgc5QZhbEFDqvWouBUAtowyRBwWgAFNkt3SNZLniGuPZPrX6koNsTUMj43abbcTp8Dx2UVESfbGSTtCYZPj", "1", "tMIL"); //OK
//    getTransactions("tokenWallet");
}

void DapWebControll::handleRequest(QHttpRequest *req, QHttpResponse *resp)
{
    qDebug()<<req->headers();
    qDebug()<<req->body();

    // TODO: parse request
    // TODO: request users for WEB permission

    QString name;
    QString net;
    QString addr;
    QString to;
    QString value;
    QString tokenName;

    QJsonDocument doc;

    doc = getWallets();
    doc = getDataWallets(name);
    doc = sendTransaction(name, to, value, tokenName);
    doc = getTransactions(name);

    QByteArray body = doc.toJson();

    qDebug() << body;

    resp->setHeader("result", QString::number(body.size()));
    resp->writeHead(200);
    resp->end(body);
}

QJsonDocument DapWebControll::getWallets()
{
    QProcess process;
    QString command = QString("%1 wallet list")
            .arg(CLI_PATH);

    QByteArray result = send_cmd(command);

    QJsonDocument docResult;
    QJsonArray jsonArr;

    QRegularExpression rx("wallet:\\s(.+)\\s", QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator itr = rx.globalMatch(result);
    if(itr.hasNext()){
        while (itr.hasNext()){
            QRegularExpressionMatch match = itr.next();
            QString walletName = match.captured(1);
            jsonArr.append(QJsonValue(walletName));
        }
        docResult = processingResult("ok", "", jsonArr);
    }else{
        qWarning() << "Can't parse result" << result;
        docResult = processingResult("bad", "Can't parse result. " + result);
    }
    return docResult;
}

QJsonDocument DapWebControll::getDataWallets(QString walletName)
{
    QProcess process;
    QString command = QString("%1 wallet info -w %2 -net %3")
            .arg(CLI_PATH)
            .arg(walletName)
            .arg(s_defaultNet);

    QByteArray result = send_cmd(command);

#ifdef Q_OS_WIN
    QRegularExpression regex(R"(^addr: (\S+)\r\nnetwork: (\S+)\r\nbalance: (\S+))");
    QRegularExpression regex2(R"(^addr: (\S+)\r\nnetwork: (\S+)\r\nbalance:)");
#else
    QRegularExpression regex(R"(^wallet: (\S+)\naddr: (\S+)\nnetwork: (\S+)\nbalance: (\S+))");
    QRegularExpression regex2(R"(^wallet: (\S+)\naddr: (\S+)\nnetwork: (\S+)\nbalance:)");
#endif

    QRegularExpressionMatch match = regex.match(result).hasMatch()?regex.match(result): regex2.match(result);
    QJsonDocument docResult;

    if (!match.hasMatch()){
        qWarning() << "Can't parse result" << result;
        docResult = processingResult("bad", "Can't parse result. " + result);
    }else{
        QString name, addr, balance, network;

        name = match.captured(1);
        addr = match.captured(2);
        network = match.captured(3);
        balance = match.captured(4);
        QJsonObject res;

        res.insert("wallet_name", QJsonValue(name));
        res.insert("wallet_addr", QJsonValue(addr));
        res.insert("wallet_network", QJsonValue(network));

        if(balance != "0"){
            QRegularExpression balanceRegex1(R"((\d+.\d+) \((\d+)\) (\w+))");
            QRegularExpression balanceRegex2(R"((\d+.) \((\d+)\) (\w+))");
            QRegularExpressionMatchIterator matchIt1 = balanceRegex1.globalMatch(result);
            QRegularExpressionMatchIterator matchIt2 = balanceRegex2.globalMatch(result);
            QRegularExpressionMatchIterator matchIt = matchIt1.hasNext() ? matchIt1 : matchIt2;

            QJsonArray arrJson;
            while (matchIt.hasNext()){
                QRegularExpressionMatch match = matchIt.next();
                auto data = QJsonObject({
                    qMakePair(QString("balance"),    QJsonValue(match.captured(1))),
                    qMakePair(QString("datoshi"),    QJsonValue(match.captured(2))),
                    qMakePair(QString("tokenName"),  QJsonValue(match.captured(3))),
                });
                arrJson.push_back(data);
            }
            res.insert("tokens", arrJson);



        }else{
            QJsonArray arrJson;
            auto data = QJsonObject({
                qMakePair(QString("balance"),   QJsonValue(balance)),
                qMakePair(QString("datoshi"),   QJsonValue("0")),
                qMakePair(QString("tokenName"), QJsonValue("0")),
            });
            arrJson.push_back(data);
            res.insert("tokens", arrJson);
        }
        docResult = processingResult("ok", "", res);
    }
    return docResult;
}

QJsonDocument DapWebControll::sendTransaction(QString walletName, QString to, QString value, QString tokenName)
{
    QString txCommand = QString("%1 tx_create -net %2 -chain %3 -from_wallet %4 "
                              "-to_addr %5 -token %6 -value %7").arg(CLI_PATH);

    txCommand = txCommand.arg(s_defaultNet);
    txCommand = txCommand.arg(s_defaultChain);
    txCommand = txCommand.arg(walletName);
    txCommand = txCommand.arg(to);
    txCommand = txCommand.arg(tokenName);
    txCommand = txCommand.arg(value);

    QByteArray resultTx = send_cmd(txCommand);

    QRegExp txHash("tx_hash=0x(\\w+)");
    txHash.indexIn(resultTx, 0);

    QJsonObject res;
    QJsonDocument docResult;

    QRegExp rx("transfer=(\\w+)");
    rx.indexIn(resultTx, 0);

    res.insert("transfer", rx.cap(1));

    if(rx.cap(1) == "Ok"){
        QRegExp rxHash("tx_hash=0x(\\w+)");
        rxHash.indexIn(resultTx, 0);
        res.insert("hash", rxHash.cap(1));
        docResult = processingResult("ok", "", res);
    }else{
        docResult = processingResult("bad", resultTx, res);
    }

    return docResult;
}

QJsonDocument DapWebControll::getTransactions(QString walletName)
{
    QProcess process;

    QString txHistoryCommand = QString("%1 tx_history -net %2 -chain %3 -w %4").arg(CLI_PATH);
    txHistoryCommand = txHistoryCommand.arg(s_defaultNet);
    txHistoryCommand = txHistoryCommand.arg(s_defaultChain);
    txHistoryCommand = txHistoryCommand.arg(walletName);

    QByteArray result = send_cmd(txHistoryCommand);
    result.replace("\t", "");

    QJsonDocument docResult;

    if(!result.isEmpty())
    {
        QRegularExpression regular("\\w*\\s+\\w*((\\w{3}\\s+){2}\\d{1,2}\\s+(\\d{1,2}:*){3}\\s+\\d{4})\\s+(\\w+)\\s+(\\d+)\\s(\\w+)\\s+\\w+\\s+([\\w\\d]+)", QRegularExpression::MultilineOption);
        QRegularExpressionMatchIterator matchItr = regular.globalMatch(result);
        QJsonArray arrJson;

        if(matchItr.hasNext()){
            while (matchItr.hasNext()){

                QRegularExpressionMatch match = matchItr.next();
                QLocale setLocale  = QLocale(QLocale::English, QLocale::UnitedStates);
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
                    qMakePair(QString("date"),           QJsonValue(setLocale.toDateTime(match.captured(1), "ddd MMM d hh:mm:ss yyyy").toString("yyyy-MM-dd"))),
                    qMakePair(QString("status"),         QJsonValue(match.captured(4) == "send" ? "Sent" : "Received")),
                    qMakePair(QString("amountDatoshi"),  QJsonValue(match.captured(5))),
                    qMakePair(QString("amount"),         QJsonValue(amountWithoutZeros)),
                    qMakePair(QString("tokenName"),      QJsonValue(match.captured(6))),
                    qMakePair(QString("walletName"),     QJsonValue(walletName)),
                    qMakePair(QString("network"),        QJsonValue(s_defaultNet)),
                    qMakePair(QString("secsSinceEpoch"), QJsonValue(setLocale.toDateTime(match.captured(1), "ddd MMM d hh:mm:ss yyyy").toSecsSinceEpoch())),
                    qMakePair(QString("hash"),           QJsonValue(txHash))
                });
                arrJson.push_back(data);
            }
            docResult = processingResult("ok", "", arrJson);
        }else{
            docResult = processingResult("bad", result);
        }
    }else{
        docResult = processingResult("bad", result);
    }

    return docResult;
}

QByteArray DapWebControll::send_cmd(QString cmd)
{
    QProcess process;
    qInfo() << "command:" << cmd;
    process.start(cmd);
    process.waitForFinished(-1);
    QByteArray result = process.readAll();
    qInfo() << "result:" << result;
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

QJsonDocument DapWebControll::processingResult(QString status, QString errorMsg)
{
    QJsonObject obj;
    obj.insert("status", status);
    obj.insert("errorMsg", errorMsg);
    obj.insert("data", "");
    QJsonDocument doc(obj);
    return doc;
}

