#include "DapWebControllerForService.h"
#include "handlers/DapAbstractCommand.h"
#include <QMetaEnum>

DapWebControllerForService::DapWebControllerForService(QObject *parent)
    : DapWebControll{parent}
{

}

void DapWebControllerForService::respondFromServise(const QVariant& result)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(result.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    if(!replyObj.contains(WEB3_KEY))
    {
        return;
    }
    QString strId = replyObj[WEB3_KEY].toString();
    int id = strId.toInt();
    QJsonDocument doc;
    if(replyObj.contains(ERROR_KEY))
    {
        QString message = replyObj[ERROR_KEY].toString();
        qDebug() << "[Web3] The response came with an error id: " << strId << " message: " << message;
        doc = _cmdController->processingResult("bad", message);
    }
    else if(replyObj[RESULT_KEY].isArray())
    {
        qDebug() << "[Web3] Status OK id: " << strId;
        doc = _cmdController->processingResult("ok", "", replyObj[RESULT_KEY].toArray());
    }
    else if(replyObj[RESULT_KEY].isObject())
    {
        qDebug() << "[Web3] Status OK id: " << strId;
        doc = _cmdController->processingResult("ok", "", replyObj[RESULT_KEY].toObject());
    }

    _tcpServer->sendResponce(doc.toJson(), id);
}

void DapWebControllerForService::sendSignalToService(const QString& commandName, const QVariant& args)
{
    if(!m_servicePool)
    {
        qWarning() << "[Web3] An error occurred while initializing the service";
        return;
    }
    if(!m_serviceSignals.contains(commandName))
    {
        return;
    }
    for(auto& service: *m_servicePool)
    {
        if(m_serviceSignals[commandName] != service->getName())
        {
            continue;
        }
        DapAbstractCommand* command = dynamic_cast<DapAbstractCommand*>(service);
        emit command->toDataSignal(args);
    }
}

void DapWebControllerForService::setCommandList(QList<DapRpcService*>* commanList)
{
    m_servicePool = commanList;

    if(m_servicePool->isEmpty())
    {
        qWarning() << "[Web3] An error occurred while initializing the service";
    }
    for(auto& service: *m_servicePool)
    {
        if(!m_listCommand.contains(service->getName()))
        {
            continue;
        }
        DapAbstractCommand* command = dynamic_cast<DapAbstractCommand*>(service);
        connect(command, &DapAbstractCommand::dataGetedSignal, this, &DapWebControllerForService::respondFromServise);
    }
}

void DapWebControllerForService::clientRequest(QString req, int idUser)
{
    QJsonDocument doc;

    QStringList questionList = req.split("/?");
    if(questionList.length() <= 1)
    {
        qWarning() << "[Web3] Can't parse request" << req;
        doc = _cmdController->processingResult("bad", "Invalid reqeust");
        _tcpServer->sendResponce(doc.toJson(), idUser);
        return;
    }
    QString url_string = questionList[1].split(" HTTP")[0];

    /// block fo log
    {
        QStringList listForLog = questionList[1].split("\n");
        QStringList listRequest = url_string.split("&");
        QString queryLog = "Query:";
        for(auto& str: listRequest)
        {
            if(!str.contains("id"))
            {
                queryLog += QString(" " + str);
            }
        }
        qDebug() << queryLog;

        for(auto& str: listForLog)
        {
            if(str.contains("Host") || str.contains("User-Agent"))
            {
                qDebug() << "[Web3] Call Details " << str;
            }
        }
    }

    QUrlQuery query(url_string);

    QString method = query.queryItemValue("method");

    QStringList list = req.split("\n", QString::SkipEmptyParts);

    if(query.isEmpty())
    {
        qWarning() << "[Web3] Empty request" << list.at(0);
        doc = _cmdController->processingResult("ok", "","Empty request. That is all right. I am here.");
    }
    else if (method.isEmpty())
    {
        qWarning() << "[Web3] Method not specified" << list.at(0);
        doc = _cmdController->processingResult("bad", "","You must specify the method");
    }
    else
    {
        // get site name
        QRegularExpression regex(R"(Origin: ([a-zA-Z\:\/\-\.]+))");
        QRegularExpressionMatch match = regex.match(req);
        QString site = match.captured(1);

        if(site.isEmpty()) {
            if(_tcpServer->isLoopback(idUser) == true)
                site = "localhost";
            else {
                site = "undefined";
                qDebug() << "[Web3] Request with unknown site name: " << req;
            }
        }

        // check site in the blocklist
        bool blocked = isBlocked(site);
        if(blocked == true) {
            qDebug() << "request from " << site << " was blocked";
            _tcpServer->ignoreIt(idUser);
            return;
        }

        if(method == "Connect"){
            if(s_connectFrontendStatus){
                emit signalConnectRequest(site, idUser);
                return;
            }else{
                doc = _cmdController->processingResult("bad", "The request cannot be processed. User is offline.");
                return;
            }
        }else{

            QString walletName, net, addr, value, tokenName, id, hashTx, certType,
                certName, timeStaking, reinvest, stakeNoBaseFlag = "", srv_uid, unit,
                categoryCert, direction, price_min, price_max, expires, ext, region, continent,
                chain, ip, jsonArray, port, units, pr_hash, cl_hash;

            id              = query.queryItemValue("id");

            walletName      = query.queryItemValue("walletName").isEmpty() ? query.queryItemValue("nameWallet")
                                                                      : query.queryItemValue("walletName");
            addr            = query.queryItemValue("toAddr").isEmpty() ? query.queryItemValue("addr")
                                                            : query.queryItemValue("toAddr");
            net             = query.queryItemValue("net");
            value           = query.queryItemValue("value");
            tokenName       = query.queryItemValue("tokenName");
            hashTx          = query.queryItemValue("hashTx");
            certType        = query.queryItemValue("certType");
            certName        = query.queryItemValue("certName");
            timeStaking     = query.queryItemValue("timeStaking");
            reinvest        = query.queryItemValue("reinvest");
            stakeNoBaseFlag = query.queryItemValue("-no_base_tx");
            srv_uid         = query.queryItemValue("srv_uid");
            unit            = query.queryItemValue("unit");
            categoryCert    = query.queryItemValue("categoryCert");
            direction       = query.queryItemValue("direction");
            price_min       = query.queryItemValue("price_min");
            price_max       = query.queryItemValue("price_max");
            expires         = query.queryItemValue("expires");
            ext             = query.queryItemValue("ext");
            region          = query.queryItemValue("region");
            continent       = query.queryItemValue("continent");
            chain           = query.queryItemValue("chain");
            ip              = query.queryItemValue("ip");
            jsonArray       = query.queryItemValue("jsonArray");
            port            = query.queryItemValue("port");
            units           = query.queryItemValue("units");
            pr_hash         = query.queryItemValue("pr_hash");
            cl_hash         = query.queryItemValue("cl_hash");

            if(!s_id.isEmpty() && (s_id.indexOf(id) != -1))
            {
                QStringList args;
                switch (MetaEnum.keyToValue(method.toUtf8()))
                {
                case GetNetworks:
                case GetWallets:
                case GetVersions:
                    break;
                case GetMempoolList:
                    args << net << addr << chain;
                    break;
                case GetTransactions:
                    args << net << addr;
                    break;
                case GetDataWallet:
                    args << walletName;
                    break;
                case CondTxCreate:
                    args << net << tokenName << walletName << certName << value << unit << srv_uid;
                    break;
                case SendTransaction:
                    args << net << walletName << addr << tokenName << value;
                    break;

//                case TxCreateJson:       doc = _cmdController->sendJsonTransaction(list); break;
//                case GetLedgerTxHash:    doc = _cmdController->getLedgetTxHash(hashTx, net); break;
//                case GetLedgerTxListAll: doc = _cmdController->getLedgetTxListAll(net); break;
//                case GetCertificates:    doc = _cmdController->getCertificates(categoryCert); break;
//                case CreateCertificate:  doc = _cmdController->createCertificate(certType, certName,categoryCert); break;
//                case StakeLockTake:      doc = _cmdController->stakeLockTake(walletName, net, hashTx); break;
//                case StakeLockHold:      doc = _cmdController->stakeLockHold(tokenName, walletName, timeStaking, net, value, reinvest, stakeNoBaseFlag); break;
//                case GetMempoolTxHash:   doc = _cmdController->getMempoolTxHash(net, hashTx); break; //need datum hash
//                case GetOrdersList:      doc = _cmdController->getOrdersList(net, direction, srv_uid, unit, tokenName, price_min, price_max); break;
//                case CreateOrder:        doc = _cmdController->createOrder(net, direction, srv_uid, value, unit, tokenName, addr, hashTx, expires, certName, ext, region, continent, units); break;
//                case GetNodeStatus:      doc = _cmdController->getNodeStatus(); break;
//                case NodeAdd:            doc = _cmdController->nodeAdd(net, addr, ip, port); break;
//                case GetNodeIP:          doc = _cmdController->getNodeIP(net, addr, jsonArray); break;
//                case NodeDump:           doc = _cmdController->nodeDump(net); break;
//                case GetNodeNetState:    doc = _cmdController->getNodeNetState(net); break;
//                case GetFee:             doc = _cmdController->getFee(net); break;
//                case GetListKeys:        doc = _cmdController->getListKeys(net); break;
//                case GetNetId:           doc = _cmdController->getNetId(net); break;
//                case GetServiceLimits:   doc = _cmdController->getServiceLimits(net, pr_hash, cl_hash, srv_uid); break;
                default:
                    qWarning()<<"Unknown request";
                    doc = _cmdController->processingResult("bad", "Unknown request: " + method);
                    break;
                }
                args << WEB3_KEY << QString::number(idUser);

                qDebug() << "[Web3] Responce method: " + method + " id: " + QString::number(idUser);

                sendSignalToService(method, args);
                return;
            }
            else
            {
                qWarning()<<"[Web3] Incorrect id";
                doc = _cmdController->processingResult("bad", "Incorrect id");
            }
        }
    }

    {
        QJsonObject object = doc.object();
        if(object.contains("status"))
        {
            qDebug() << "[Web3] Responce method: " + method + " status: " + object["status"].toString();
        }

        if(object.contains("errorMsg"))
        {
            qDebug() << "[Web3] Responce method: " + method + " errorMsg: " + object["errorMsg"].toString();
        }
    }
}