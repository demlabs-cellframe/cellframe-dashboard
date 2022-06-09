#include "DapWebControll.h"

DapWebControll::DapWebControll(QObject *parent)
    : QObject{parent}
{

    s_defaultNet = "private";
    s_defaultChain = "zero";

    _tcpServer = new QTcpServer(this);
    connect(_tcpServer, &QTcpServer::newConnection, this, &DapWebControll::onNewConnetion);

    s_id = getNewId();

    startServer(8045);

    //FOR TEST

//    getWallets(); //OK
//    getDataWallets("tokenWallet"); //OK
//    sendTransaction("tokenWallet", "mWNv7A43YnqRHCWVFHQJXMgc5QZhbEFDqvWouBUAtowyRBwWgAFNkt3SNZLniGuPZPrX6koNsTUMj43abbcTp8Dx2UVESfbGSTtCYZPj", "1", "tMIL"); //OK
//    getTransactions("tokenWallet"); //OK
}

QString DapWebControll::getRandomString()
{
   QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
   int randomStringLength = 8;
   QString randomString;
   for(int i=0; i<randomStringLength; ++i)
   {
//       int index = qrand() % possibleCharacters.length();
       int index = QRandomGenerator::global()->bounded(0, possibleCharacters.length());
       QChar nextChar = possibleCharacters.at(index);
       randomString.append(nextChar);
   }
   return randomString;
}

QString DapWebControll::getNewId()
{
    dap_chain_hash_fast_t l_hash_cert_pkey;
    QString id = getRandomString();
    dap_hash_fast(id.constData(), id.size(), &l_hash_cert_pkey);
    char *l_cert_pkey_hash_str = dap_chain_hash_fast_to_str_new(&l_hash_cert_pkey);
    QString result = QString::fromLatin1(l_cert_pkey_hash_str);
    DAP_DEL_Z(l_cert_pkey_hash_str)
    return result;
}

bool DapWebControll::startServer(int port)
{
  if( !_tcpServer->listen(QHostAddress::Any, port) ) { qWarning()<<"Unable start server"; return false; }
  qInfo()<<"Server is started";
  return true;
}

void DapWebControll::onNewConnetion()
{
  qDebug()<<"New connection...";

  QTcpSocket * _socket = _tcpServer->nextPendingConnection();
  s_tcpSocketList.append(_socket);

  connect(_socket, &QTcpSocket::readyRead, this, &DapWebControll::onClientSocketReadyRead);
  connect(_socket, &QTcpSocket::disconnected, this, &DapWebControll::onClietnSocketDisconnected);
}

void DapWebControll::onClietnSocketDisconnected()
{
    qInfo()<<"Client disconnected...";
    QTcpSocket * _socket = dynamic_cast<QTcpSocket*>(sender());
    if ( _socket==nullptr ) { return; }

    for(int i = 0; s_tcpSocketList.length(); i++)
    {
        if(_socket == s_tcpSocketList[i])
            s_tcpSocketList.removeAt(i);
    }
}

void DapWebControll::rcvAccept(bool accept)
{

}

void DapWebControll::requestProcessing()
{

}

void DapWebControll::onClientSocketReadyRead()
{
  QTcpSocket * _socket = dynamic_cast<QTcpSocket*>(sender());
  if ( _socket==nullptr ) { return; }

  QString req = _socket->readAll();
  QStringList list = req.split("\n", QString::SkipEmptyParts);
  QRegularExpression regex(R"(method=([a-zA-Z]+))");
  QRegularExpressionMatch match = regex.match(list.at(0));

  QJsonDocument doc;

  if (!match.hasMatch())
  {
      qWarning() << "Can't parse request" << list.at(0);
      doc = processingResult("bad", "Can't parse request");
  }
  else
  {
      QString cmd = match.captured(1);
      qInfo()<<"request = " << cmd;

      if(cmd == "Connect")
      {

          //TODO: need waiting function and continue requests processing

          emit signalConnectRequest(list[6].split("Origin: ")[1].split("/n")[0]);

          QJsonObject obj;
          obj.insert("id", s_id);
          doc = processingResult("ok", "", obj);
      }
      else
      {
          QRegularExpression regex(R"(&([a-zA-Z]+)=(\w*))");
          QRegularExpressionMatchIterator matchIt = regex.globalMatch(list.at(0));

          QString name, net, addr, value, tokenName, id;

          while(matchIt.hasNext())
          {
              QRegularExpressionMatch match = matchIt.next();

              if(match.captured(1) == "id")
                  id = match.captured(2);
              else if(match.captured(1) == "walletName" | match.captured(1) == "nameWallet" )
                  name = match.captured(2);
              else if(match.captured(1) == "toAddr" | match.captured(1) == "addr")
                  addr = match.captured(2);
              else if(match.captured(1) == "tokenName")
                  tokenName = match.captured(2);
              else if(match.captured(1) == "value")
                  value = match.captured(2);
              else if(match.captured(1) == "net")
                  net = match.captured(2);
          }

          if(id == s_id)
          {
              if(cmd == "GetWallets")
                  doc = getWallets();
              else if(cmd == "GetDataWallet")
                  doc = getDataWallets(name);
              else if(cmd == "SendTransaction")
                  doc = sendTransaction(name, addr, value, tokenName);
              else if(cmd == "GetTransactions")
                  doc = getTransactions(addr, net);
              else
              {
                  qWarning()<<"Unknown request";
                  doc = processingResult("bad", "Unknown request: " + cmd);
              }
          }
          else
          {
              qWarning()<<"Incorrect id";
              doc = processingResult("bad", "Incorrect id");
          }
      }

      QByteArray body = doc.toJson();

      QTextStream answer(_socket);
      answer.setAutoDetectUnicode(true);
      answer
        <<"HTTP/1.1 200 OK\r\n"
        <<"Content-Type: application/json; charset=\"UTF-8\"\r\n"
        <<"Access-Control-Allow-Origin: *\r\n"
        <<"\r\n"
        <<doc.toJson();
      _socket->flush();
  }
  _socket->close();
}



QJsonDocument DapWebControll::getWallets()
{
    QProcess process;
    QString command = QString("%1 wallet list")
            .arg(CLI_PATH);

    QString result = send_cmd(command);

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

    QString result = send_cmd(command);

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
        QString str = QString("Can't parse result. Wallet name: %1 . %2").arg("' " + walletName + " '").arg(result);
        docResult = processingResult("bad", str);
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

    QString resultTx = send_cmd(txCommand);

    QJsonObject res;
    QJsonDocument docResult;

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

    return docResult;
}

QJsonDocument DapWebControll::getTransactions(QString addr, QString net)
{
    QProcess process;

    QString txHistoryCommand = QString("%1 tx_history -net %2 -chain %3 -addr %4").arg(CLI_PATH);
    txHistoryCommand = txHistoryCommand.arg(net);
    txHistoryCommand = txHistoryCommand.arg(s_defaultChain);
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
        docResult = processingResult("bad", QString(result));
    }

    return docResult;
}

QString DapWebControll::send_cmd(QString cmd)
{
    QProcess process;
    qInfo() << "command:" << cmd;
    process.start(cmd);
    process.waitForFinished(-1);
    QString result = process.readAll();
    result.replace("\t", "");
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
