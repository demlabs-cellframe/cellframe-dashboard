#include "DapWebControll.h"

DapWebControll::DapWebControll(QObject *parent)
    : QObject{parent}
{
    s_defaultNet = "Backbone";
    s_defaultChain = "main";

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
  QString req = s_tcpSocketList[idUser]->readAll();
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
          QRegularExpression regex(R"(Origin: ([a-zA-Z\:\/\-\.]+))");
          QRegularExpressionMatch match = regex.match(req);
          emit signalConnectRequest(match.captured(1), idUser);
          return;
      }else{
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

          if(id == s_id){
              if(cmd == "GetWallets")
                  doc = getWallets();
              else if(cmd == "GetDataWallet")
                  doc = getDataWallets(name);
              else if(cmd == "SendTransaction")
                  doc = sendTransaction(name, addr, value, tokenName);
              else if(cmd == "GetTransactions")
                  doc = getTransactions(addr, net);
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

void DapWebControll::rcvAccept(bool accept, int index)
{
    QJsonDocument doc;
    if(accept){
        QJsonObject obj;
        obj.insert("id", s_id);
        doc = processingResult("ok", "", obj);
    }else
        doc = processingResult("bad", "The User declined the request");
    sendResponce(doc, s_tcpSocketList[index]);
}
