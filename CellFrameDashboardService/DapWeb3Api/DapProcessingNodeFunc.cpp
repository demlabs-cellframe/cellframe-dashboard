#include "DapWebControll.h"
#include "CellframeNodeConfig.h"
#include <QFile>
#include <QFileInfo>
#include <QFileInfoList>
#include <QDir>
#include <iostream>

#include <QString>
#include "dap_cert.h"
#include "dap_cert_file.h"

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


public:
    explicit DapCertificateType() {  }
    AccessKeyType getAccessKeyType(const QString &certFile);
    QJsonObject getSimpleCertificateInfo(const QFileInfo &info, const DapCertificateType::DirType& dirType);
};

DapCertificateType::AccessKeyType DapCertificateType::getAccessKeyType(const QString &certFilePath)
{
    dap_cert_t* certFile = dap_cert_file_load(qPrintable(certFilePath));
    if (certFile == nullptr){
        qCritical() << "file not open" << certFilePath;
        return DapCertificateType::Error;
        //WARNING нужна более продвинутая обработка ошибок, но по умолчанию вызов этой функции проиходит сразу после получение списка файлов
    }

    AccessKeyType result;

    int privateKeySize = certFile->enc_key->priv_key_data_size;
    int publicKeySize = certFile->enc_key->pub_key_data_size;

    if (privateKeySize == 0 && publicKeySize > 0)
        result =  DapCertificateType::Public;
    else
    if (privateKeySize > 0 && publicKeySize > 0)
        result =  DapCertificateType::PublicAndPrivate;
    else
        result = DapCertificateType::Error;

    dap_cert_delete(certFile);

    return result;
}

QJsonObject DapCertificateType::getSimpleCertificateInfo(const QFileInfo &info, const DapCertificateType::DirType& dirType)
{
    return QJsonObject({
                            { "fileName", info.fileName() }
                          , { "completeBaseName", info.completeBaseName() }
                          , { "filePath", info.filePath() }
                          , { "dirType", dirType }
                          , { "accessKeyType", getAccessKeyType(info.filePath()) }
                      });
}

QString DapWebControll::send_cmd(QString cmd)
{
    QProcess process;
    qDebug() << "command:" << cmd;
    process.start(cmd);
    process.waitForFinished(5000);
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

        QRegularExpression rx(R"(^Wallet: (\S+)( (\S+))?)", QRegularExpression::MultilineOption);
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
    QString txCommand = QString("%1 tx_create -net %2 -from_wallet %3 "
                                "-to_addr %4 -token %5 -value %6 -fee 50000000000000000").arg(CLI_PATH);

    txCommand = txCommand.arg(net);
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
    QString txHistoryCommand = QString("%1 tx_history -net %2 -addr %3").arg(CLI_PATH);

    txHistoryCommand = txHistoryCommand.arg(net);
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
    QString command = QString("%1 ledger info -hash %2 -net %3")
            .arg(CLI_PATH).arg(hash).arg(net);

    QString result = send_cmd(command);

    QJsonDocument docResult;
    QJsonObject obj;

    if(!result.isEmpty())
    {
        if(result.contains("transaction: hash:")){
            obj.insert("string", result);
            docResult = processingResult("ok", "", obj);
        }else{
            docResult = processingResult("bad", result);
        }
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
<<<<<<< HEAD
    else if(result.contains("No valid items") || result.contains("Not found") || result.contains("error") || result.contains("Error"))
=======
    else if(result.contains("No valid items") || result.contains("Can't create") || result.contains("Not found") || result.contains("error") || result.contains("Error"))
>>>>>>> 91df5d336742da0a454a1833dd6b8e91bf8349a3
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

QJsonDocument DapWebControll::getMempoolList(QString net, QString addr, QString chain)
{
    QString command = QString("%1 mempool_list -net %2")
            .arg(CLI_PATH).arg(net);

    if(!addr.isEmpty())
        command += QString(" -addr %1").arg(addr);
    if(!chain.isEmpty())
        command += QString(" -chain %1").arg(chain);

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

QJsonDocument DapWebControll::getCertificates(QString categoryCert)
{
    QJsonDocument docResult;
    QJsonArray result;
    QJsonArray items;

    auto parseDir =
        [&result](const QString& dirPath, const DapCertificateType::DirType& dirType, const QString& categoryCert) -> bool
        {
            DapCertificateType check;
            QDir dir(dirPath);

            if (!dir.exists()) {
                qWarning() << "The directory does not exist:" << dirPath;
                return false;
            }

            dir.setFilter(QDir::Files | QDir::Hidden);      //only files in derictory
            dir.setSorting(QDir::Name);      //set sort by name

            QFileInfoList list = dir.entryInfoList();   // get all QFileInfo for files in dir

            foreach (const QFileInfo& info, list) {
                if (info.suffix() == "dcert"/* && dirType == DapCertificateType::DefaultDir*/) {       //выбираем только файлы сертификатов с расширением dcert

                    if(check.getAccessKeyType(info.filePath()) == DapCertificateType::Public && categoryCert == "public")
                        result.append(check.getSimpleCertificateInfo(info, dirType));
                    else if(check.getAccessKeyType(info.filePath()) == DapCertificateType::PublicAndPrivate && categoryCert == "private")
                        result.append(check.getSimpleCertificateInfo(info, dirType));
                    else if(categoryCert == "" || categoryCert == "all")
                        result.append(check.getSimpleCertificateInfo(info, dirType));
                }
            }
            return true;
        };
    //предполагаем что в разных папках лежат, разные ключи.
    parseDir(CellframeNodeConfig::instance()->getDefaultCADir(), DapCertificateType::DefaultDir, categoryCert);
    parseDir(CellframeNodeConfig::instance()->getShareCADir(), DapCertificateType::ShareDir, categoryCert);

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
                QRegExp exp("[А-Яа-я]*");
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

    for(auto item : result){
        QJsonObject certOjb;

        certOjb.insert("name", item.toObject().value("completeBaseName").toString());
        certOjb.insert("fileName", item.toObject().value("fileName").toString());
        certOjb.insert("path", item.toObject().value("filePath").toString());
        certOjb.insert("type", item.toObject().value("dirType").toInt());

        items.append(certOjb);
    }

    if(result.count())
        return docResult = processingResult("ok", "", items);
    else
        return docResult = processingResult("bad", "Certificates not found" );
}

QJsonDocument DapWebControll::createCertificate(QString type, QString name, QString categoryCert)
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
    QString newCertName;

    if(categoryCert == "public")
    {
        newCertName = name+"_public";
        //WARNING сертификат с публичным ключом создается в папке обычных сертификатов
        QString filePath = QString("%1/%2.dcert").arg(CellframeNodeConfig::instance()->getDefaultCADir()).arg(newCertName);
        QFileInfo info(filePath);

        if (info.exists()) {
            return docResult = processingResult("bad", "Public certificate is exists");
        }

        QProcess process;
        QString args(QString("%1 cert create_cert_pkey %2 %3").arg(TOOLS_PATH).arg(name).arg(newCertName));
        qInfo() << "command:" << args;
        process.start(args);
        process.waitForFinished(-1);

        QString result(process.readAll());
        qInfo() << "result:" << result;
        info.refresh();
    }

    //QString processResult = QString::fromLatin1(process.readAll());

    info.refresh();

    if (info.exists()) {       //existsCertificate(certName, s_toolPath)
        if(categoryCert == "public"){
            QJsonObject obj{{"name",name},
                            {"public_name", newCertName},
                            {"type",type}};
            return docResult = processingResult("ok", "", obj);
        }
        else
        {
            QJsonObject obj{{"name",name},
                            {"type",type}};
            return docResult = processingResult("ok", "", obj);
        }
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

QJsonDocument DapWebControll::getMempoolTxHash(QString net, QString hash)
{
    QString command = QString("%1 mempool_check -datum %2 -net %3")
            .arg(CLI_PATH).arg(hash).arg(net);

    QString result = send_cmd(command);

    QJsonDocument docResult;
    QJsonObject obj;

    if(!result.isEmpty())
    {
        if(result.contains("is present"))
            docResult = processingResult("ok", "", result);
        else
            docResult = processingResult("bad", result);
    }else{
        docResult = processingResult("bad", QString("Node is offline"));
    }

    return docResult;
}

QJsonDocument DapWebControll::getNodeStatus()
{
    QJsonDocument docResult;
    QJsonObject obj;

    if(s_nodeStatus != "Offline")
    {
        docResult = processingResult("ok", "", s_nodeStatus);
    }else{
        docResult = processingResult("bad", s_nodeStatus);
    }

    return docResult;
}

QJsonDocument DapWebControll::getVersions()
{
    QJsonDocument docResult;
    QJsonObject obj;

    QProcess process;
    QString command = QString("%1 version").arg(CLI_PATH);
    QString result = send_cmd(command);

    if(result.contains("cellframe-node version"))
    {
        result = result.split("version")[1];
        result = result.split('\n', QString::SkipEmptyParts).first().trimmed();
        obj.insert("cellframe-node", result);
    }
    else
        obj.insert("cellframe-node", result);

    obj.insert("cellframe-dashboard", DAP_VERSION);

    docResult = processingResult("ok", "", obj);

    return docResult;
}

QJsonDocument DapWebControll::createCondTx(QString net, QString tokenName, QString walletName, QString cert, QString value, QString unit, QString srv_uid)
{
    QString command = QString("%1 tx_cond_create -net %2 -token %3 -wallet %4 -cert %5 -value %6 -unit %7 -srv_uid %8")
            .arg(CLI_PATH).arg(net).arg(tokenName).arg(walletName).arg(cert).arg(value).arg(unit).arg(srv_uid);

    QString result = send_cmd(command);

    QJsonDocument docResult;
    QJsonObject obj;

    if(!result.isEmpty())
    {
        if(result.contains("succefully")){
            QRegExp rxHash("hash=0x(\\w+)");
            rxHash.indexIn(result, 0);
            obj.insert("hash", rxHash.cap(1));
            docResult = processingResult("ok", "", obj);
        }else{
            docResult = processingResult("bad", result);
        }
    }else{
        docResult = processingResult("bad", QString("Node is offline"));
    }

    return docResult;
}

QJsonDocument DapWebControll::getOrdersList(QString net, QString direction, QString srv_uid, QString unit, QString tokenName, QString price_min, QString price_max)
{
    QString command = QString("%1 net_srv -net %2 order find").arg(CLI_PATH).arg(net);

    if(!direction.isEmpty())
        command += QString(" -direction %1").arg(direction);
    if(!srv_uid.isEmpty())
        command += QString(" -srv_uid %1").arg(srv_uid);
    if(!unit.isEmpty())
        command += QString(" -price_unit %1").arg(unit);
    if(!tokenName.isEmpty())
        command += QString(" -price_token %1").arg(tokenName);
    if(!price_min.isEmpty())
        command += QString(" -price_min %1").arg(price_min);
    if(!price_max.isEmpty())
        command += QString(" -price_max %1").arg(price_max);

    QString result = send_cmd(command);

    QJsonDocument docResult;
    QJsonArray arrOrders;

    if(!result.isEmpty())
    {
        if(result.contains("Found 0 orders:"))
            return docResult = processingResult("ok","", QString("Found 0 orders"));
        else{

            QStringList resultSplit = result.split("== Order");

            if(resultSplit.length() < 2)
                return docResult = processingResult("bad", result);

            resultSplit.removeAt(0);

            for(QString data : resultSplit)
            {
                QStringList dataList = data.split("\n");

                QJsonObject obj;
                obj.insert("hash",dataList[0].remove(" =="));
                dataList.removeAt(0);

                for(QString str : dataList)
                {
                    str.remove("\r");
                    str.remove(" ");
                    if(str.isEmpty())
                        continue;

                    if(str.contains("node_addr"))
                    {
                        str.remove("node_addr:");
                        obj.insert("node_addr",str);
                    }
                    else
                    {
                        QStringList data = str.split(":");
                        obj.insert(data[0],data[1]);
                    }
                }
                arrOrders.append(obj);
            }
            return docResult = processingResult("ok", "", arrOrders);
        }
    }else{
        return docResult = processingResult("bad", QString("Node is offline"));
    }
}

QJsonDocument DapWebControll::createOrder(QString net, QString direction, QString srv_uid, QString price, QString unit, QString tokenName,
                                          QString node_addr, QString tx_cond,QString expires, QString certName,
                                          QString ext, QString region, QString continent)
{
    QString command = QString("%1 net_srv -net %2 order create").arg(CLI_PATH).arg(net);

    command += QString(" -direction %1").arg(direction);
    command += QString(" -srv_uid %1").arg(srv_uid);
    command += QString(" -price %1").arg(price);
    command += QString(" -price_unit %1").arg(unit);
    command += QString(" -price_token %1").arg(tokenName);
    command += QString(" -cert %1").arg(certName);


    if(!node_addr.isEmpty())
        command += QString(" -node_addr %1").arg(node_addr);
    if(!tx_cond.isEmpty())
        command += QString(" -tx_cond %1").arg(tx_cond);
    if(!expires.isEmpty())
        command += QString(" -expires %1").arg(expires);
    if(!ext.isEmpty())
        command += QString(" -ext %1").arg(ext);
    if(!region.isEmpty())
        command += QString(" -region %1").arg(region);
    if(!continent.isEmpty())
        command += QString(" -continent %1").arg(continent);

    QString result = send_cmd(command);

    QJsonDocument docResult;
    QJsonObject obj;

    if(!result.isEmpty())
    {
        if(result.contains("Error"))
            return docResult = processingResult("bad", result);

        if(result.contains("Created order")){
            QRegExp rxHash("Created order (\\w+)");
            rxHash.indexIn(result, 0);
            obj.insert("hash", rxHash.cap(1));
            return docResult = processingResult("ok", "", obj);
        }else{
            return docResult = processingResult("bad", result);
        }
    }else{
        docResult = processingResult("bad", QString("Node is offline"));
    }

    return docResult;
}

