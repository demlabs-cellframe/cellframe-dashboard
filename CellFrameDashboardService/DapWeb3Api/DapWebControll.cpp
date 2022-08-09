#include "DapWebControll.h"

#ifdef Q_OS_WIN
#include "registry.h"
#endif

DapWebControll::DapWebControll(QObject *parent)
    : QObject{parent}
{
    s_connectFrontendStatus = false;
    _tcpServer = new QTcpServer(this);
    connect(_tcpServer, &QTcpServer::newConnection, this, &DapWebControll::onNewConnetion);
    startServer(8045);

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    s_pathJsonCmd =  QString("/opt/%1/data/").arg(DAP_BRAND_LO);
#elif defined(Q_OS_MACOS)
    s_pathJsonCmd =  QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/data/").arg(getenv("USER"));
#elif defined (Q_OS_WIN)
    s_pathJsonCmd =  QString("%1/%2/data/").arg(regWGetUsrPath()).arg(DAP_BRAND);
#endif


    //FOR TEST


//    {
//      "net" : "kelvin-testnet",
//      "chain" : "zerochain",
//      "items" : [ {
//        "type" : "in",
//        "prev_hash" : "0xB5A01C52D6AFAFD4860172F4057A9BDF5E7AAB5A5AD9BE574EA919DB27EFBC0B",
//        "out_prev_idx" : 2
//      }, {
//        "type" : "out",
//        "value" : "12345",
//        "addr" : "RpiDC8c1SxrTF3aSu2VL4Pwu8beWMY8ur71TeiR6ViBdnvMQCKudoWkvT8BGFN2ycKnHSaGm5WrNccex2qiZjA4PoEicUmWJNvRQQJYN"
//      },{
//        "type" : "sign",
//        "wallet" : "myk2",
//      } ]
//    }




//    QJsonObject obj3;
//    obj3.insert("type", "in");
//    obj3.insert("prev_hash", "0xB5A01C52D6AFAFD4860172F4057A9BDF5E7AAB5A5AD9BE574EA919DB27EFBC0B");
//    obj3.insert("out_prev_idx", "2");

//    QJsonObject obj4;
//    obj4.insert("type", "out");
//    obj4.insert("value", "12345");
//    obj4.insert("addr", "RpiDC8c1SxrTF3aSu2VL4Pwu8beWMY8ur71TeiR6ViBdnvMQCKudoWkvT8BGFN2ycKnHSaGm5WrNccex2qiZjA4PoEicUmWJNvRQQJYN");

//    QJsonObject obj2;
//    obj2.insert("type", "sign");
//    obj2.insert("wallet", "tokenWallet");


//    QJsonArray arr;
//    arr.push_back(obj3);
//    arr.push_back(obj4);
//    arr.push_back(obj2);

//    QJsonObject obj;
//    obj.insert("net", "mileena");
//    obj.insert("chain", "main");
//    obj.insert("items", arr);



//    QJsonDocument doc(obj);

//    sendJsonTransaction(doc);


//    getNetworks(); //OK
//    getWallets(); //OK
//    getDataWallets("tokenWallet"); //OK
//    sendTransaction("tokenWallet", "mWNv7A43YnqRHCWVFHQJXMgc5QZhbEFDqvWouBUAtowyRBwWgAFNkt3SNZLniGuPZPrX6koNsTUMj43abbcTp8Dx2UVESfbGSTtCYZPj", "1", "tMIL", "mileena"); //OK
//    getTransactions("tokenWallet", "mileena"); //OK

//    QJsonDocument doc = createCertificate("sig_dil", "testCert");
//    doc = getCertificates(); // OK

//    QJsonDocument doc = getLedgetTxListAll("subzero");
//    doc = getCertificates(); // OK

//    QString date = "\"Fri, 05 Aug 22 03:35:41\"";

//    QJsonDocument doc = stakeLockHold("tRUB", "myCert", "tokenWallet", date, "subzero", "10000");
//    qDebug()<<"";
}

QString DapWebControll::getRandomString()
{
   QString possibleCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
   int randomStringLength = 8;
   QString randomString;
   for(int i=0; i<randomStringLength; ++i)
   {
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
  qInfo()<<"Http server is started";
  return true;
}

void DapWebControll::onNewConnetion()
{
  qDebug()<<"New connection...";
  QTcpSocket * _socket = _tcpServer->nextPendingConnection();
  s_tcpSocketList[_socket->socketDescriptor()] = _socket;
  connect(_socket, &QTcpSocket::readyRead, this, &DapWebControll::onClientSocketReadyRead);
}

void DapWebControll::onClientSocketReadyRead()
{
  QTcpSocket* _socket = dynamic_cast<QTcpSocket*>(sender());
  if ( _socket == nullptr ) { return; }

  int idUser = _socket->socketDescriptor();

  QByteArray encodedString = s_tcpSocketList[idUser]->readAll();
  QString req = QUrl::fromPercentEncoding(encodedString);

  if(req.contains("OPTIONS") || req.contains("Access-Control-Request-Method") || req.contains("Access-Control-Request-Private-Network"))
  {
      qDebug()<<"Preflight web request";

      QTextStream answer(s_tcpSocketList[idUser]);
      answer.setAutoDetectUnicode(true);
      answer
        <<"HTTP/1.1 204 No Content\r\n"
        <<"Connection: keep-alive\r\n"
        <<"Access-Control-Allow-Origin: *\r\n"
        <<"Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE\r\n"
        <<"\r\n";
      s_tcpSocketList[idUser]->flush();
      s_tcpSocketList[idUser]->close();
      s_tcpSocketList.remove(s_tcpSocketList[idUser]->socketDescriptor());
      return;
  }

  QStringList list = req.split("\n", QString::SkipEmptyParts);
  QRegularExpression regex(R"(method=([a-zA-Z]+))");
  QRegularExpressionMatch match = regex.match(list.at(0));

  QJsonDocument doc;

  if (!match.hasMatch()){
      qWarning() << "Can't parse request" << list.at(0);
      doc = processingResult("bad", "Can't parse request");
  }else{
      QString cmd = match.captured(1);
      qDebug()<<"request = " << cmd;

      if(cmd == "Connect"){
          if(s_connectFrontendStatus){
              QRegularExpression regex(R"(Origin: ([a-zA-Z\:\/\-\.]+))");
              QRegularExpressionMatch match = regex.match(req);
              emit signalConnectRequest(match.captured(1), idUser);
              return;
          }else{
              doc = processingResult("bad", "The request cannot be processed. User is offline.");
              return;
          }
      }else{

          QRegularExpression regex(R"(&([a-zA-Z]+)=(\w*))");
          QRegularExpressionMatchIterator matchIt = regex.globalMatch(list.at(0));
          QString name, net, addr, value, tokenName, id, hashTx, certType,
                  certName, timeStaking;

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
              else if(match.captured(1) == "hashTx")
                  hashTx = match.captured(2);
              else if(match.captured(1) == "certName")
                  certName = match.captured(2);
              else if(match.captured(1) == "timeStaking")
                  timeStaking = match.captured(2);
              else if(match.captured(1) == "certType")
                  certType = match.captured(2);
          }
          if(!s_id.isEmpty() && s_id.filter(id).length()){
              if(cmd == "GetWallets")
                  doc = getWallets();
              else if(cmd == "GetNetworks")
                  doc = getNetworks();
              else if(cmd == "GetDataWallet")
                  doc = getDataWallets(name);
              else if(cmd == "SendTransaction")
                  doc = sendTransaction(name, addr, value, tokenName, net);
              else if(cmd == "GetTransactions")
                  doc = getTransactions(addr, net);
              else if(cmd == "GetLedgerTxHash")
                  doc = getLedgetTxHash(hashTx, net);
              else if(cmd == "GetLedgerTxListAll")
                  doc = getLedgetTxListAll(net);
              else if(cmd == "GetCertificates")
                  doc = getCertificates();
              else if(cmd == "CreateCertificate")
                  doc = createCertificate(certType, certName);
              else if(cmd == "StakeLockTake")
                  doc = stakeLockTake(name, net, hashTx);
              else if(cmd == "StakeLockHold")
                  doc = stakeLockHold(tokenName, certName, name, timeStaking, net, value);
              else if(cmd == "TxCreateJson")
              {
//                 all simbols -       &([a-zA-Z]+)=(([\s\S]*)$)
//                 all symbols in {} - {((?>[^{}]+|(?R))*)}
//                 json parser -       (&([a-zA-Z]+)=(?<o>{((?<s>\"([^\0-\x1F\"\\]|\\[\"\\\/bfnrt]|\\u[0-9a-fA-F]{4})*\"):(?<v>\g<s>|(?<n>-?(0|[1-9]\d*)(.\d+)?([eE][+-]?\d+)?)|\g<o>|\g<a>|true|false|null))?\s*((?<c>,\s*)\g<s>(?<d>:\s*)\g<v>)*})|(?<a>\[\g<v>?(\g<c>\g<v>)*\]))

                  QRegularExpression regex("{((?>[^{}]+|(?R))*)}");
                  QRegularExpressionMatch match = regex.match(list.at(0));

                  if (!match.hasMatch())
                      qWarning() << "Incorrect json data";
                  else
                  {
                      QJsonDocument document = QJsonDocument::fromJson(match.captured(0).toStdString().data());
                      doc = sendJsonTransaction(document);
                  }
              }
              else{
                  qWarning()<<"Unknown request";
                  doc = processingResult("bad", "Unknown request: " + cmd);
              }
          }else{
              qWarning()<<"Incorrect id";
              doc = processingResult("bad", "Incorrect id");
          }
      }
  }
  sendResponce(doc, s_tcpSocketList[idUser]);
}

void DapWebControll::sendResponce(QJsonDocument data, QTcpSocket* socket)
{
    QTextStream answer(socket);
    answer.setAutoDetectUnicode(true);
    answer
      <<"HTTP/1.1 200 OK\r\n"
      <<"Content-Type: application/json; charset=\"UTF-8\"\r\n"
      <<"Access-Control-Allow-Origin: *\r\n"
      <<"\r\n"
      <<data.toJson();
    socket->flush();
    socket->close();
    s_tcpSocketList.remove(socket->socketDescriptor());
}

void DapWebControll::rcvAccept(QString accept, int index)
{
    if(s_tcpSocketList.contains(index))
    {
        QJsonDocument doc;
        if(accept == "true"){
            QString newId = getNewId();
            s_id.append(newId);
            QJsonObject obj;
            obj.insert("id", newId);
            doc = processingResult("ok", "", obj);
        }else
            doc = processingResult("bad", "The User declined the request");

        sendResponce(doc, s_tcpSocketList[index]);
    }
}
