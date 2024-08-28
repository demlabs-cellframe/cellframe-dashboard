#include "AbstractDiagnostic.h"

#include <QNetworkAccessManager>
#include <QHttpPart>
#include <QHttpMultiPart>
#include <QNetworkReply>
#include <QJsonDocument>

#include "NodePathManager.h"

static QString group = "global.users.statistic";

AbstractDiagnostic::AbstractDiagnostic(QObject *parent)
    :QObject(parent)
    , s_timer_update(new QTimer())
    , s_timer_write(new QTimer())
#ifdef NETWORK_DIAGNOSTIC
    , m_jsonListNode(new QJsonDocument())
    , m_jsonData(new QJsonDocument())
    , m_manager(new QNetworkAccessManager())
#endif
{
    nodeCli     = NodePathManager::getInstance().nodePaths.nodePath_cli;
    nodePath    = NodePathManager::getInstance().nodePaths.nodePath;
    nodeDirPath = NodePathManager::getInstance().nodePaths.nodeDirPath;


    connect(s_timer_write, &QTimer::timeout,
            this, &AbstractDiagnostic::write_data,
            Qt::QueuedConnection);

    s_mac = get_mac();

#ifdef NETWORK_DIAGNOSTIC

    connect(m_manager, &QNetworkAccessManager::finished, this, &AbstractDiagnostic::on_reply_finished);
#endif

    qInfo() << "Current MAC" << s_mac.toString();
}

AbstractDiagnostic::~AbstractDiagnostic()
{
    delete s_timer_update;

#ifdef NETWORK_DIAGNOSTIC
    m_manager->deleteLater();
    if(m_jsonListNode) delete m_jsonListNode;
    if(m_jsonData) delete m_jsonData;
#endif

}

void AbstractDiagnostic::set_timeout(int timeout){
    s_timer_update->stop();
    s_timeout = timeout;
    s_timer_update->start(s_timeout);
}

void AbstractDiagnostic::start_diagnostic()
{
    s_timer_update->start(s_timeout);
}

void AbstractDiagnostic::stop_diagnostic()
{
    s_timer_update->stop();
}

QJsonValue AbstractDiagnostic::get_mac()
{
    QString MAC{"unknown"};
    foreach(QNetworkInterface netInterface, QNetworkInterface::allInterfaces())
    {
        // Return only the first non-loopback MAC Address
        if (!(netInterface.flags() & QNetworkInterface::IsLoopBack))
        {
            if(!netInterface.hardwareAddress().isEmpty())
            {
                MAC = netInterface.hardwareAddress();
                break;
            }
        }
    }
    return MAC;
}

QString AbstractDiagnostic::get_uptime_string(long sec)
{
    QTime time(0, 0);
    time = time.addSecs(sec);
    int fullHours = sec/3600;
    QString uptime;

    if(!fullHours)
        uptime = QString("00:") + time.toString("mm:ss");
    else if(!(int)(fullHours /10))
        uptime = QString("0%1:").arg(fullHours) + time.toString("mm:ss");
    else
        uptime = QString("%1:").arg(fullHours) + time.toString("mm:ss");

    return uptime;
}

quint64 AbstractDiagnostic::get_file_size (QString flag, QString path )
{
    if(flag == "log")
        path += "/var/log";
    else
    if (flag == "DB")
        path += "/var/lib/global_db";
    else
    if (flag == "chain")
        path += "/var/lib/network";
    else
        path += "";

    QDir currentFolder( path );

    quint64 totalsize = 0;

    currentFolder.setFilter( QDir::Dirs | QDir::Files | QDir::NoSymLinks );
    currentFolder.setSorting( QDir::Name );

    QFileInfoList folderitems( currentFolder.entryInfoList() );

    foreach ( QFileInfo i, folderitems ) {
        QString iname( i.fileName() );
        if ( iname == "." || iname == ".." || iname.isEmpty() )
            continue;
        if(flag == "log" && i.suffix() != "log" && !i.isDir())
            continue;
        else
        if(flag == "DB" && (i.suffix() != "dat" && !i.suffix().isEmpty()) && !i.isDir())
            continue;
        else
        if(flag == "chain" && i.suffix() != "dchaincell" && !i.isDir())
            continue;

        if ( i.isDir() )
            totalsize += get_file_size("", path+"/"+iname);
        else
            totalsize += i.size();
    }

    return totalsize;
}

QString AbstractDiagnostic::get_memory_string(size_t num)
{
    size_t bytes = num * 1024;
    if (bytes == 0) return "0 KB";
    int k = 1024,
        dm = 2,
        i = qFloor(qLn(bytes) / qLn(k));

    QStringList sizes = QStringList()<< "Bytes"<< "KB"<< "MB"<< "GB"<< "TB"<< "PB"<< "EB"<< "ZB"<< "YB";

    QString res_val = QString::number((bytes / qPow(k, i)), 'f', dm);
    QString res_m = sizes[i];

    if (res_val.isEmpty())
        return "Unknown";

    return QString(res_val + " " + res_m);
}

void AbstractDiagnostic::start_write(bool isStart)
{
    if(isStart && !s_timer_write->isActive()){
        write_data();
        s_timer_write->start(5000);
    }else{
        s_timer_write->stop();
        remove_data();
    }
}

void AbstractDiagnostic::remove_data()
{
    QString key = s_mac.toString();
    QProcess proc;
    QString program = QString(nodeCli);
    QStringList arguments;
    arguments << "global_db" << "delete" << "-group" << QString(group) << "-key" << QString(key);
    proc.start(program, arguments);
    proc.waitForFinished(5000);
    QString res = proc.readAll();
}

#ifdef NETWORK_DIAGNOSTIC

void AbstractDiagnostic::update_full_data()
{
    m_manager->get(QNetworkRequest(QUrl(NETWORK_ADDR_GET_KEYS)));
    m_manager->get(QNetworkRequest(QUrl(NETWORK_ADDR_GET_VIEW)));
}

const QJsonDocument AbstractDiagnostic::get_list_keys(QJsonArray& listNoMacInfo)
{
    if(!m_jsonListNode || m_jsonListNode->isEmpty())
    {
        return {};
    }
    QJsonArray list = m_jsonListNode->array();
    QJsonArray resultList;

    auto isContains = [this](const QString& mac) -> bool
    {
        for(const auto &item: s_selected_nodes_list)
        {
            if(item.toObject()["mac"].toString() == mac)
            {
                return true;
            }
        }
        return false;
    };
    for(int i = 0; i < list.count(); ++i)
    {
        if(isContains(list[i].toString()))
        {
            continue;
        }
        QJsonObject tmpData;
        tmpData["mac"] = list[i];
        if(!listNoMacInfo.isEmpty())
        {
            if(listNoMacInfo.contains(isContains(list[i].toString())))
            {
                tmpData["noInfoMac"] = list[i];
            }
        }

        resultList.append(std::move(tmpData));
    }
    return QJsonDocument(std::move(resultList));
}

const QJsonDocument AbstractDiagnostic::get_list_data(QJsonArray& listNoMacInfo)
{
    if(!m_jsonData || m_jsonData->isEmpty())
    {
        return {};
    }

    QJsonObject list = m_jsonData->object();
    QJsonArray nodesArray;
    for(const QJsonValue mac : s_selected_nodes_list)
    {
        if(list.contains(mac["mac"].toString()))
        {
            QJsonObject resultObj = get_diagnostic_data_item(QJsonDocument(list[mac["mac"].toString()].toObject()));
            nodesArray.append(resultObj);
        }
        else
        {
            listNoMacInfo.append(mac["mac"].toString());
        }
    }

    return QJsonDocument(std::move(nodesArray));
}

void AbstractDiagnostic::on_reply_finished(QNetworkReply *reply)
{
    if(reply->url() == NETWORK_ADDR_GET_VIEW)
    {
        QByteArray data = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
        if(!jsonDoc.isEmpty())
        {
            QJsonArray list = jsonDoc.array();
            QJsonObject resultObject;
            for(int i = 0; i < list.count(); ++i)
            {
                QJsonObject tmpObject = list[i].toObject();
                resultObject.insert(tmpObject["mac"].toString(), tmpObject);
            }

            m_jsonData->setObject(std::move(resultObject));// setArray(std::move(jsonDoc.array()));
        }
    }
    else if(reply->url() == NETWORK_ADDR_GET_KEYS)
    {
        QByteArray data = reply->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
        if(!jsonDoc.isEmpty())
        {
            m_jsonListNode->setArray(std::move(jsonDoc.array()));
        }
    }
}
#endif

QJsonDocument AbstractDiagnostic::get_list_nodes()
{
    QJsonDocument nodes;
    QProcess proc;
    QString program = QString(nodeCli);
    QStringList arguments;
    arguments << "global_db" << "get_keys" << "-group" << QString(group);
    proc.start(program, arguments);
    proc.waitForFinished(5000);
    QString res = proc.readAll();

    QStringList resSplit = res.split("\n", Qt::SkipEmptyParts);
    for(int i = 0; i < resSplit.count(); i++)
        resSplit[i] = resSplit[i].simplified();

    resSplit.sort();

    static QRegExp re = QRegExp(R"(^[\da-fA-F]{2}(:[\da-fA-F]{2}){5}$)");

    QJsonArray nodes_array;

    for(int i = 0; i < s_selected_nodes_list.count(); i++ )
    {
        bool isContains = false;
        for(int j = 0; j < resSplit.count(); j++)
        {
            if(re.exactMatch(resSplit[j]))
            {
                if(resSplit[j] == s_selected_nodes_list.at(i).toObject()["mac"].toString())
                {
                    isContains = true;
                    break;
                }
            }
        }
        if(!isContains)
            s_selected_nodes_list.removeAt(i);

    }

    foreach (QString node, resSplit)
    {
        if(node != s_mac.toString()
            && re.exactMatch(node)
            && !check_contains(s_selected_nodes_list, node, "mac"))
        {
            QJsonObject obj;
            obj.insert("mac", node);
            nodes_array.append(obj);
        }
    }

    nodes.setArray(nodes_array);

    return nodes;
}

void AbstractDiagnostic::write_data()
{
    {
        QJsonObject mainObject = s_full_info.object();

        if(mainObject.contains("process"))
        {
            QString info;
            QJsonObject processObject = mainObject["process"].toObject();
            info = "Process info:";
            if(processObject.contains("DB_size"))
            {
                info += QString(" DB_size- " + processObject["DB_size"].toString());
            }
            if(processObject.contains("chain_size"))
            {
                info += QString(" Chain size - " + processObject["chain_size"].toString());
            }
            if(processObject.contains("log_size"))
            {
                info += QString(" Log size - " + processObject["log_size"].toString());
            }
            if(processObject.contains("status"))
            {
                info += QString(" Status - " + processObject["status"].toString());
            }
            qInfo() << info;
        }
        if(mainObject.contains("system"))
        {
            QString info;
            QJsonObject systemObject = mainObject["system"].toObject();
            info = "System info:";
            if(systemObject.contains("memory"))
            {
                QJsonObject memoryObject = systemObject["memory"].toObject();
                info += QString(" memory free - " + memoryObject["free"].toString());
                info += QString(" memory load - " + memoryObject["load"].toString());
                info += QString(" memory total - " + memoryObject["total"].toString());
            }
            qInfo() << info;
        }
    }

#ifdef NETWORK_DIAGNOSTIC

    QString urls = NETWORK_ADDR_SENDER;
    QUrl url = QUrl(urls);

    QNetworkAccessManager * mgr = new QNetworkAccessManager();

    //TODO: Crash on r ptr
//    connect(mgr, &QNetworkAccessManager::finished, this, [=](QNetworkReply*r)
//    {
//        if(QNetworkReply::NetworkError::NoError !=  r->error())
//        {
//            qWarning() << "data sent " << urls << " " << r->error();
//        }
//    });
    connect(mgr,SIGNAL(finished(QNetworkReply*)),mgr,  SLOT(deleteLater()));

    auto req = QNetworkRequest(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");
    QString key = s_mac.toString();
    QJsonDocument docBuff = s_full_info;
    QJsonObject obj = docBuff.object();
    obj.insert("mac",key);
    docBuff.setObject(obj);
    mgr->post(req, docBuff.toJson());
#else
    if(s_full_info.isEmpty() || s_full_info.isNull())
        return;

    QJsonDocument docBuff = s_full_info;

    QString key = s_mac.toString();

    QProcess proc;
    QString program = QString(nodeCli);
    QStringList arguments;
    arguments << "global_db" << "write" << "-group" << QString(group)
              << "-key" << QString(key) << "-value" << QByteArray(docBuff.toJson());
    proc.start(program, arguments);
    proc.waitForFinished(5000);

#endif
}

QJsonObject AbstractDiagnostic::get_diagnostic_data_item(const QJsonDocument& jsonDoc)
{
    if(jsonDoc.isEmpty())
    {
        return {};
    }

    QJsonObject obj = jsonDoc.object();
    QJsonObject system = jsonDoc["system"].toObject();
    QJsonObject sys_mem = system["memory"].toObject();
    QJsonObject proc = jsonDoc["process"].toObject();

    auto getString = [](const QJsonValue& value) -> QString
    {
        QString resultStr = value.toString();
        if(resultStr.isEmpty())
        {
            int totalInt = value.toInt();
            if(totalInt > 0)
            {
                resultStr = QString::number(totalInt);
            }
        }
        return resultStr;
    };
    QString total = getString(sys_mem["total"]);
    if(total != "blocked")
        sys_mem.insert("total", get_memory_string(total.toUInt()));
    QString free = getString(sys_mem["free"]);
    if(free != "blocked")
        sys_mem.insert("free", get_memory_string(free.toUInt()));

    proc.insert("memory_use_value", get_memory_string(proc["memory_use_value"].toString().toUInt()));
    proc.insert("log_size", get_memory_string(proc["log_size"].toString().toUInt()));
    proc.insert("DB_size", get_memory_string(proc["DB_size"].toString().toUInt()));
    proc.insert("chain_size", get_memory_string(proc["chain_size"].toString().toUInt()));

    system.insert("memory",sys_mem);
    obj.insert("system",system);
    obj.insert("process",proc);

    return obj;
}

QJsonDocument AbstractDiagnostic::read_data()
{
    QJsonArray nodes_array;
    QJsonDocument nodes_doc;

    for(QJsonValue mac : s_selected_nodes_list)
    {
        QString key = mac["mac"].toString();

        QProcess proc;
        QString program = QString(nodeCli);
        QStringList arguments;
        arguments << "global_db" << "read" << "-group" << QString(group)
                  << "-key" << QString(key);
        proc.start(program, arguments);
        proc.waitForFinished(5000);
        QString res = proc.readAll().simplified();

        if(res.isEmpty() || res.contains("not found") || res.contains("error") || res.contains("err"))
        {
            qWarning() << res;
            continue;
        }

        QJsonParseError err;
        QJsonDocument doc = QJsonDocument::fromJson(res.split("data:")[1].toStdString().data(), &err);
        if(err.error == QJsonParseError::NoError && !doc.isEmpty())
        {
            QJsonObject obj = get_diagnostic_data_item(doc);
            doc.setObject(obj);

            nodes_array.append(doc.object());
        }
        else
            qWarning()<<err.errorString();
    }

    nodes_doc.setArray(nodes_array);

    return nodes_doc;
}

void AbstractDiagnostic::set_node_list(QJsonDocument arr){
    qInfo()<<"AbstractDiagnostic::set_node_list" << arr;
    s_selected_nodes_list = arr.array();
}

bool AbstractDiagnostic::check_contains(QJsonArray array, QString item, QString flag)
{
    for (auto itr = array.begin(); itr != array.end(); itr++)
    {
        QJsonObject obj = itr->toObject();
        if(obj[flag].toString() == item)
            return true;
    }

    return false;
}

QJsonObject AbstractDiagnostic::roles_processing()
{
    QJsonObject rolesObject;

    QDir currentFolder("/opt/cellframe-node/etc/network");

    currentFolder.setFilter( QDir::Dirs | QDir::Files | QDir::NoSymLinks );
    currentFolder.setSorting( QDir::Name );

    QFileInfoList folderitems( currentFolder.entryInfoList() );

    foreach ( QFileInfo i, folderitems ) {
        QString iname( i.fileName() );
        if ( iname == "." || iname == ".." || iname.isEmpty() )
            continue;
        if(i.suffix() == "cfg" && !i.isDir())
        {
            QSettings config(i.absoluteFilePath(), QSettings::IniFormat);

            rolesObject.insert(i.completeBaseName(), config.value("node-role", "unknown").toString());
        }
    }

    return rolesObject;
}
