#include "DapWebControll.h"
#include "CellframeNodeConfig.h"
#include <QFile>
#include <QFileInfo>
#include <QFileInfoList>
#include <QDir>

class DapCertificateType
{
    Q_GADGET
public:
    //certificate type access
    enum AccessKeyType{
        Public = 0,
        PublicAndPrivate = 1, // this type is called "Private" !!!
        Both = 2, // used only for filtering !!!
        Error = -1
    };
    Q_ENUM(AccessKeyType);

    //certificate location dir
    enum DirType{
        DefaultDir = 0,
        ShareDir
    };
    Q_ENUM(DirType);


protected:
    explicit DapCertificateType() {  }
};

QString DapWebControll::send_cmd(QString cmd)
{
    QProcess process;
    qDebug() << "command:" << cmd;
    process.start(cmd);
    process.waitForFinished(-1);
    QString result = process.readAll();
    result.replace("\t", "");
//    qDebug() << "result:" << result;
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

QJsonDocument DapWebControll::getLedgetTxHash(QString hash, QString net)
{
    QString command = QString("%1 ledger tx -tx %2 -net %3")
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
    else if(result.contains("No valid items"))
        docResult = processingResult("bad", result);
    else
        docResult = processingResult("ok", "", result);

    return docResult;
}

QJsonDocument DapWebControll::getLedgetTxListAll(QString net)
{
    QString command = QString("%1 ledger tx -net %2 -all")
            .arg(CLI_PATH).arg(net);

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

QJsonDocument DapWebControll::getMempoolList(QString net)
{
    QString command = QString("%1 mempool_list -net %2")
            .arg(CLI_PATH).arg(net);

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

QJsonDocument DapWebControll::getCertificates()
{
    QJsonDocument docResult;
    QJsonArray result;

    auto parseDir =
        [&result](const QString& dirPath, const DapCertificateType::DirType& dirType) -> bool
        {
            QDir dir(dirPath);

            if (!dir.exists()) {
                qWarning() << "The directory does not exist:" << dirPath;
                return false;
            }

            dir.setFilter(QDir::Files | QDir::Hidden);      //only files in derictory
            dir.setSorting(QDir::Name);      //set sort by name

            QFileInfoList list = dir.entryInfoList();   // get all QFileInfo for files in dir

            foreach (const QFileInfo& info, list) {
                if (info.suffix() == "dcert" && dirType == DapCertificateType::DefaultDir) {       //выбираем только файлы сертификатов с расширением dcert
                    result.append(info.completeBaseName());
                }

            }
            return true;
        };


    //предполагаем что в разных папках лежат, разные ключи.
    parseDir(CellframeNodeConfig::instance()->getDefaultCADir(), DapCertificateType::DefaultDir );

    for(int i = 0; i < result.count(); i++)
    {
        for(int j = 0; j < result.count(); j++)
        {

            if(result.at(i).toObject().value("fileName").toString() == result.at(j).toObject().value("fileName").toString())
            {
                if(result.at(i).toObject().value("dirType").toInt() != result.at(j).toObject().value("dirType").toInt())
                {
                    if(result.at(i).toObject().value("dirType").toInt())
                        result.removeAt(i);
                    else
                        result.removeAt(j);
                    i--;
                    j--;
                }

                QString names = result.at(j).toObject().value("fileName").toString();
                QRegExp exp("[А-Яа-я\\d]*");
                exp.indexIn(names);
                auto check = exp.cap(0);

                if(check.isEmpty())
                    continue;
                else
                    result.removeAt(i);
                i--;
                j--;
            }
        }
    }

    if(result.count())
        return docResult = processingResult("ok", "", result);
    else
        return docResult = processingResult("bad", "Certificates not found" );
}

QJsonDocument DapWebControll::createCertificate(QString type, QString name)
{
    QFileInfo info(CellframeNodeConfig::instance()->getDefaultCADir() + QString("/%1.dcert").arg(name) );

    QJsonDocument docResult;


    if (info.exists())
        return docResult = processingResult("bad", "Certificate is exists" );

    QProcess process;
    auto args = QString("%1 cert create %2 %3").arg(TOOLS_PATH).arg(name).arg(type);
    qInfo() << "command:" << args;
    process.start(args);
    process.waitForFinished(-1);
    qInfo() << "result:" << process.readAll();
    process.close();

    //QString processResult = QString::fromLatin1(process.readAll());

    info.refresh();

    if (info.exists()) {       //existsCertificate(certName, s_toolPath)
        QJsonObject obj{{"name",name},
                        {"type",type}};
        return docResult = processingResult("ok", "", obj);

    }else
        return docResult = processingResult("bad", "Certificate not created" );

}

QJsonDocument DapWebControll::stakeLockHold(QString tokenName, QString walletName,  QString time_staking,  QString net, QString coins, QString reinvest, QString noBaseFlag)
{
    QString command = QString("%1 stake_lock hold -net %2 -wallet %3 -time_staking %4 "
                              "-coins %5 -token %6 -reinvest %7 %8").arg(CLI_PATH);

    command = command.arg(net);
    command = command.arg(walletName);
    command = command.arg(time_staking);
    command = command.arg(coins);
    command = command.arg(tokenName);
    command = command.arg(reinvest);
    command = command.arg(noBaseFlag);

    QString result = send_cmd(command);
    QJsonDocument docResult;

    if(!result.isEmpty())
    {
        QJsonObject res;

        QRegularExpression rx(R"(Successfully hash=(.+)\n(.+)\nBASE_TX_DATUM_HASH=(.+))");
        QRegularExpressionMatch match = rx.match(result);

        if(result.contains("successfully"))
        {
            res.insert("Successfully hash", match.captured(1));
            res.insert("BASE_TX_DATUM_HASH", match.captured(3));
            docResult = processingResult("ok", "", res);
        }
        else
            docResult = processingResult("bad", result);

    }else{
        docResult = processingResult("bad", "", QString("Node is offline"));
    }

    return docResult;
}

QJsonDocument DapWebControll::stakeLockTake(QString walletName, QString net, QString hash)
{
    QString command = QString("%1 stake_lock take -net %2 -tx %3 -wallet %4").arg(CLI_PATH);

    command = command.arg(net);
    command = command.arg(hash);
    command = command.arg(walletName);

    QString result = send_cmd(command);
    QJsonDocument docResult;

    if(!result.isEmpty())
    {
        QJsonObject res;

        QRegularExpression rx(R"(BURNING_TX_DATUM_HASH=(.+)\nTAKE_TX_DATUM_HASH=(.+))");
        QRegularExpressionMatch match = rx.match(result);

        if(result.contains("successfully"))
        {
            res.insert("BURNING_TX_DATUM_HASH", match.captured(1));
            res.insert("TAKE_TX_DATUM_HASH", match.captured(2));
            docResult = processingResult("ok", "", res);
        }
        else
            docResult = processingResult("bad", result);

    }else{
        docResult = processingResult("bad", "", QString("Node is offline"));
    }
    return docResult;
}


