#include "AbstractDiagnostic.h"

AbstractDiagnostic::AbstractDiagnostic(QObject *parent)
    :QObject(parent)
    , m_jsonListNode(new QJsonDocument())
    , m_jsonData(new QJsonDocument())
    , m_manager(new QNetworkAccessManager())
{
    m_diagConnectCtrl = new DiagtoolConnectCotroller();
    initJsonTmpl();

    s_elapsed_timer = new QElapsedTimer();
    s_elapsed_timer->start();

    connect(m_manager, &QNetworkAccessManager::finished, this, &AbstractDiagnostic::on_reply_finished);

    connect(m_diagConnectCtrl,  &DiagtoolConnectCotroller::signalDataRcv, this, &AbstractDiagnostic::rcv_diag_data);
    connect(m_diagConnectCtrl,  &DiagtoolConnectCotroller::signalSocketChangeStatus, [this](bool status)
    {
        emit diagtool_socket_change_status(status);
    });
}

AbstractDiagnostic::~AbstractDiagnostic()
{
    m_manager->deleteLater();
    m_diagConnectCtrl->deleteLater();
    if(m_jsonListNode) delete m_jsonListNode;
    if(m_jsonData) delete m_jsonData;
}

void AbstractDiagnostic::initJsonTmpl()
{
    QJsonObject proc_info;
    QJsonObject sys_info;
    QJsonObject full_info;

    proc_info.insert("DB_size","0");
    proc_info.insert("chain_size","0");
    proc_info.insert("log_size","0");
    proc_info.insert("memory_use",0);
    proc_info.insert("memory_use_value","0");
    proc_info.insert("name","cellframe-node");
    proc_info.insert("status","Unknown");
    proc_info.insert("uptime","00:00:00");
    proc_info.insert("version","-");

    QJsonObject cpuObj;
    cpuObj.insert("load", "0");
    sys_info.insert("CPU", cpuObj);
    sys_info.insert("mac", "XX:XX:XX:XX:XX:XX");
    QJsonObject memObj;
    memObj.insert("load", "0");
    memObj.insert("free", "0");
    memObj.insert("total", "0");
    sys_info.insert("memory", memObj);
    sys_info.insert("time_update_unix", 0);
    sys_info.insert("uptime", "");
    sys_info.insert("uptime_diagtool", "");
    sys_info.insert("uptime_dashboard", "");


    full_info.insert("system", sys_info);
    full_info.insert("process", proc_info);

    s_full_info.setObject(full_info);
}

void AbstractDiagnostic::rcv_diag_data(QJsonDocument diagData)
{
    QJsonObject obj = diagData.object();

    QJsonObject system = diagData["system"].toObject();
    QJsonObject sys_mem = system["memory"].toObject();
    QJsonObject proc = diagData["process"].toObject();

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
    sys_mem.insert("total", get_memory_string(total.toUInt()));
    QString free = getString(sys_mem["free"]);
    sys_mem.insert("free", get_memory_string(free.toUInt()));

    proc.insert("memory_use_value", get_memory_string(proc["memory_use_value"].toString().toUInt()));
    proc.insert("log_size", get_memory_string(proc["log_size"].toString().toUInt()));
    proc.insert("DB_size", get_memory_string(proc["DB_size"].toString().toUInt()));
    proc.insert("chain_size", get_memory_string(proc["chain_size"].toString().toUInt()));

    system.insert("memory",sys_mem);

    //insert uptime dashboard into system info
    s_uptime = get_uptime_string(s_elapsed_timer->elapsed()/1000);
    system.insert("uptime_dashboard", s_uptime);

    obj.insert("system",system);
    obj.insert("process",proc);

    diagData.setObject(obj);

    s_full_info.setObject(obj);

    emit data_updated(diagData);
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

void AbstractDiagnostic::changeDataSending(bool flagSendData)
{
    if(!m_diagConnectCtrl->getConncetState()) return;

    QJsonObject obj;
    obj.insert("send_data_flag", flagSendData);
    quint64 bytes = m_diagConnectCtrl->writeSocket(QJsonDocument(obj).toJson());

    qDebug()<<"[changeDataSending] bytes written: " << bytes;
}

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
        for(const auto &item: qAsConst(s_selected_nodes_list))
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
    for(const QJsonValue &mac : qAsConst(s_selected_nodes_list))
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
