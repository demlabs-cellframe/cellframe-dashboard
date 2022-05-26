#include "DapWebControll.h"

DapWebControll::DapWebControll(QObject *parent)
    : QObject{parent}
{

    s_defaultNet = "Backbone";
    s_defaultChain = "main";

    QHttpServer *server = new QHttpServer(this);
    connect(server, SIGNAL(newRequest(QHttpRequest*, QHttpResponse*)),
            this, SLOT(handleRequest(QHttpRequest*, QHttpResponse*)));

    server->listen(QHostAddress::Any, 8090);

    //FOR TEST
    getWallets(); //OK
    getTokenBalances("Rj7J7MiX2bWy8sNyY55eNdUgNwp5AEERxW5N8mVKybe7RzxcvtYyA5duV6tC33DunPSatKe6YDhRPF32VzDsQWVrCbtGgiBUDAbpmhJM"); //OK
}

void DapWebControll::handleRequest(QHttpRequest *req, QHttpResponse *resp)
{
    qDebug()<<req->headers();
    qDebug()<<req->body();

    // TODO: parse request

    QString net;
    QString addr;
    QString to;
    QString value;

    QJsonObject resultJson;

    resultJson = getWallets();
    resultJson = getTokenBalances(addr);

    resultJson = sendTransaction(addr, to, value);



    QJsonDocument doc(resultJson);
    QByteArray body = doc.toJson();

    qDebug() << body;

    resp->setHeader("result", QString::number(body.size()));
    resp->writeHead(200);
    resp->end(body);

}

QJsonObject DapWebControll::getWallets()
{
    QProcess process;
    QString command = QString("%1 wallet list")
            .arg(CLI_PATH);

    qInfo() << "command:" << command;
    process.start(command);

    process.waitForFinished(-1);
    QByteArray result = process.readAll();
    qInfo() << "result:" << result;

    QJsonObject resultJson;
    QJsonArray jsonArr;

    QRegularExpression rx("wallet:\\s(.+)\\s", QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator itr = rx.globalMatch(result);
    if(itr.hasNext()){
        while (itr.hasNext()){
            QRegularExpressionMatch match = itr.next();
            QString walletName = match.captured(1);
            jsonArr.append(QJsonValue(walletName));
        }
        resultJson.insert("wallets", jsonArr);
    }else{
        qWarning() << "Can't parse result" << result;
        resultJson.insert("Error", QJsonValue(QString("Can't parse result. " + result)));
    }
    return resultJson;
}

QJsonObject DapWebControll::getTokenBalances(QString addr)
{
    QProcess process;
    QString command = QString("%1 wallet info -addr %2 -net %3")
            .arg(CLI_PATH)
            .arg(addr)
            .arg(s_defaultNet);

    qInfo() << "command:" << command;
    process.start(command);

    process.waitForFinished(-1);
    QByteArray result = process.readAll();
    qInfo() << "result:" << result;

#ifdef Q_OS_WIN
    QRegularExpression regex(R"(^addr: (\S+)\r\nnetwork: (\S+)\r\nbalance: (\S+))");
#else
    QRegularExpression regex(R"(^addr: (\S+)\nnetwork: (\S+)\nbalance: (\S+))");
#endif

    QRegularExpressionMatch match = regex.match(result);

    QJsonObject resultJson;

    if (!match.hasMatch())
    {
        qWarning() << "Can't parse result" << result;
        resultJson.insert("Error", QJsonValue(QString("Can't parse result. " + result)));
    }
    else
    {
        QString addr;
        QString balance;

        addr = match.captured(1);
        balance = match.captured(3);

        resultJson.insert("wallet_addr", QJsonValue(addr));

        QRegularExpression balanceRegex1(R"((\d+.\d+) \((\d+)\) (\w+))");
        QRegularExpression balanceRegex2(R"((\d+.) \((\d+)\) (\w+))");
        QRegularExpressionMatchIterator matchIt1 = balanceRegex1.globalMatch(result);
        QRegularExpressionMatchIterator matchIt2 = balanceRegex2.globalMatch(result);
        QRegularExpressionMatchIterator matchIt = matchIt1.hasNext() ? matchIt1 : matchIt2;

        if(matchIt.hasNext()){
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
            resultJson.insert("tokens", arrJson);
        }else{
            QJsonArray arrJson;
            auto data = QJsonObject({
                qMakePair(QString("balance"),   QJsonValue(balance)),
                qMakePair(QString("datoshi"),   QJsonValue("0")),
                qMakePair(QString("name"),      QJsonValue("0")),
            });
            arrJson.push_back(data);
            resultJson.insert("tokens", arrJson);
        }
    }
    return resultJson;
}

QJsonObject DapWebControll::sendTransaction(QString from, QString to, QString value)
{

}
