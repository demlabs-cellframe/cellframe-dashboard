#include "AbstractDiagnostic.h"

#include <QNetworkAccessManager>
#include <QHttpPart>
#include <QHttpMultiPart>
#include <QNetworkReply>

static QString group = "global.users.statistic";

AbstractDiagnostic::AbstractDiagnostic(QObject *parent)
    :QObject(parent)
#ifdef NETWORK_DIAGNOSTIC
    , m_manager(new QNetworkAccessManager())
#endif
{
    s_timer_update = new QTimer();
    s_timer_write = new QTimer();

    connect(s_timer_write, &QTimer::timeout,
            this, &AbstractDiagnostic::write_data,
            Qt::QueuedConnection);

    s_mac = get_mac();
}

AbstractDiagnostic::~AbstractDiagnostic()
{
    delete s_timer_update;

#ifdef NETWORK_DIAGNOSTIC
    m_manager->deleteLater();
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
//    qInfo()<<"AbstractDiagnostic::get_mac ";
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
//    qInfo()<<"AbstractDiagnostic::get_uptime_string " << sec;

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
//    qInfo()<<"AbstractDiagnostic::get_file_size " << flag << path;

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
//    qInfo()<<"AbstractDiagnostic::get_memory_string " << num;
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


//    QString result;
//    int gb = (num / 1024) / 1024;
//    int mb = (num-gb*1024*1024) /1024;
//    int kb = (num - (gb*1024*1024+mb*1024));
//    if (gb > 0)
//       result = QString::number(gb) + QString(" Gb ");
//    else
//       result = QString("");
//    if (mb > 0)
//       result += QString::number(mb) + QString(" Mb ");
//    if (kb > 0)
//       result += QString::number(kb) + QString(" Kb ");

//    return result;
}

void AbstractDiagnostic::start_write(bool isStart)
{
//    qInfo()<<"AbstractDiagnostic::start_write " << isStart;

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
//    qInfo()<<"AbstractDiagnostic::remove_data";

    QString key = s_mac.toString();
    QProcess proc;
    QString program = QString(CLI_PATH);
    QStringList arguments;
    arguments << "global_db" << "delete" << "-group" << QString(group) << "-key" << QString(key);
    proc.start(program, arguments);
    proc.waitForFinished(5000);
    QString res = proc.readAll();

    //    qDebug()<<res;
}

#ifdef NETWORK_DIAGNOSTIC
QVector<QJsonDocument*> AbstractDiagnostic::get_list_and_data_json()
{
    QVector<QJsonDocument*> result;
    result.append(&m_jsonListNode);
    result.append(&m_jsonData);
    return result;
}

void AbstractDiagnostic::clearData()
{
    m_jsonListNode = QJsonDocument();
    m_jsonData = QJsonDocument();
}


void AbstractDiagnostic::send_data()
{
    if(m_jsonListNode.isEmpty() || m_jsonData.isEmpty())
    {
        return;
    }

    if(full_data_loaded_callback)
    {
        full_data_loaded_callback();
    }
}

void AbstractDiagnostic::read_full_data(Callback hendler)
{
    full_data_loaded_callback = hendler;
    clearData();
    read_list_nodes_from_network();
    read_data_from_network();
}

void AbstractDiagnostic::read_list_nodes_from_network()
{
    QUrl url(NETWORK_ADDR_GET_KEYS);
    if(m_reply_list)
    {
        m_reply_list = nullptr;
    }
    m_reply_list = m_manager->get(QNetworkRequest(url));

    QObject::connect(m_reply_list, &QNetworkReply::finished, [this]() {
        QByteArray data = m_reply_list->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
        if(!jsonDoc.isEmpty())
        {
            QJsonArray list = jsonDoc.array();
            QJsonArray resultList;
            for(int i = 0; i < list.count(); ++i)
            {
                QJsonObject tmpData;
                tmpData["mac"] = list[i];
                resultList.append(tmpData);
            }
            m_jsonListNode.setArray(std::move(resultList));

            send_data();
            m_reply_list->deleteLater();
        }
    });
}

void AbstractDiagnostic::read_data_from_network()
{
    QUrl url(NETWORK_ADDR_GET_VIEW);
    if(m_reply_data)
    {
        m_reply_data = nullptr;
    }
    m_reply_data = m_manager->get(QNetworkRequest(url));

    QObject::connect(m_reply_data, &QNetworkReply::finished, [this]() {
        QByteArray data = m_reply_data->readAll();
        QJsonDocument jsonDoc = QJsonDocument::fromJson(data);
        if(!jsonDoc.isEmpty())
        {
            QJsonArray list = jsonDoc.array();
            QVector<QString> macList;
            for(QJsonValue mac : s_selected_nodes_list)
            {
                macList.append(mac["mac"].toString());
            }
            QJsonArray nodesArray;
            for(int i = 0; i< list.count(); ++i)
            {
                QJsonObject object = list[i].toObject();
                if(!object.contains("mac"))
                {
                    continue;
                }
                QString mac = object["mac"].toString();
                if(!macList.contains(mac))
                {
                    continue;
                }
                QJsonObject resultObj = get_diagnostic_data_item(QJsonDocument(object));

                nodesArray.append(resultObj);
            }
            m_jsonData.setArray(nodesArray);
            send_data();
            m_reply_data->deleteLater();
        }
    });
}
#endif

QJsonDocument AbstractDiagnostic::get_list_nodes()
{
    //    qInfo()<<"AbstractDiagnostic::get_list_nodes";

    QJsonDocument nodes;
    QProcess proc;
    QString program = QString(CLI_PATH);
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
#ifdef NETWORK_DIAGNOSTIC

    QUrl url = QUrl(NETWORK_ADDR_SENDER);
    auto req = QNetworkRequest(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");

    QString key = s_mac.toString();
    QJsonDocument docBuff = s_full_info;
    QJsonObject obj = docBuff.object();
    obj.insert("mac",key);
    docBuff.setObject(obj);

    if(m_reply_post)
    {
        m_reply_post = nullptr;
    }

    m_reply_post = m_manager->post(req, docBuff.toJson());
    QObject::connect(m_reply_post, &QNetworkReply::finished, [this]{
        qDebug() << "data sent " << m_reply_post->url() << " " << m_reply_post->error();
        m_reply_post->deleteLater();
    });

#else
    if(s_full_info.isEmpty() || s_full_info.isNull())
        return;

    QJsonDocument docBuff = s_full_info;

    QString key = s_mac.toString();

    QProcess proc;
    QString program = QString(CLI_PATH);
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

    if(sys_mem["total"].toString() != "blocked")
        sys_mem.insert("total", get_memory_string(sys_mem["total"].toString().toUInt()));
    if(sys_mem["free"].toString() != "blocked")
        sys_mem.insert("free", get_memory_string(sys_mem["free"].toString().toUInt()));

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
        QString program = QString(CLI_PATH);
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
//    qInfo()<<"AbstractDiagnostic::set_node_list" << arr;
    s_selected_nodes_list = arr.array();
}

bool AbstractDiagnostic::check_contains(QJsonArray array, QString item, QString flag)
{
//    qInfo()<<"AbstractDiagnostic::check_contains" << array << item << flag;
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
//    qInfo()<<"AbstractDiagnostic::roles_processing";
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
