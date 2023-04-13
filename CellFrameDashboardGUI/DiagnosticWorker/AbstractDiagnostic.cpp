#include "AbstractDiagnostic.h"

static QString group = "global.users.statistic";

AbstractDiagnostic::AbstractDiagnostic(QObject *parent)
    :QObject(parent)
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

    QString uptime = QString("%1:").arg(fullHours) + time.toString("mm:ss");

    return uptime;
}

quint64 AbstractDiagnostic::get_file_size (QString flag, QString path ) {

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

QString AbstractDiagnostic::get_memory_string(long num)
{
    QString result;
    int gb = (num / 1024) / 1024;
    int mb = (num-gb*1024*1024) /1024;
    int kb = (num - (gb*1024*1024+mb*1024));
    if (gb > 0)
       result = QString::number(gb) + QString(" Gb ");
    else
       result = QString("");
    if (mb > 0)
       result += QString::number(mb) + QString(" Mb ");
    if (kb > 0)
       result += QString::number(kb) + QString(" Kb ");

    return result;
}

void AbstractDiagnostic::start_write(bool isStart)
{
    qDebug()<<"AbstractDiagnostic::start_write " << isStart;

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
    QString program = QString(CLI_PATH);
    QStringList arguments;
    arguments << "global_db" << "delete" << "-group" << QString(group) << "-key" << QString(key);
    proc.start(program, arguments);
    proc.waitForFinished(5000);
    QString res = proc.readAll();

    qDebug()<<res;
}

QJsonDocument AbstractDiagnostic::get_list_nodes()
{
    QJsonDocument nodes;

    qDebug()<<"AbstractDiagnostic::get_list_nodes";

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
    qDebug()<<"AbstractDiagnostic::write_data";

    QString key = s_mac.toString();

    QProcess proc;
    QString program = QString(CLI_PATH);
    QStringList arguments;
    arguments << "global_db" << "write" << "-group" << QString(group)
              << "-key" << QString(key) << "-value" << QByteArray(s_full_info.toJson());
    proc.start(program, arguments);
    proc.waitForFinished(5000);
    QString res = proc.readAll();

    qDebug()<<res;
}

QJsonDocument AbstractDiagnostic::read_data()
{
    QJsonArray nodes_array;
    QJsonDocument nodes_doc;

    qDebug()<<"AbstractDiagnostic::read_data";

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

        if(res.contains("not found"))
        {
            qWarning() << res;
            continue;
        }

        QJsonDocument doc = QJsonDocument::fromJson(res.split("data:")[1].toStdString().data());

        nodes_array.append(doc.object());
    }

    nodes_doc.setArray(nodes_array);

    return nodes_doc;
}

void AbstractDiagnostic::set_node_list(QJsonDocument arr){
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
