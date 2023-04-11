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

    s_mac_list = get_mac_array();
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

QJsonArray AbstractDiagnostic::get_mac_array()
{
    QJsonArray mac_arr;

    QList<QNetworkInterface>list = QNetworkInterface::allInterfaces();

    foreach (QNetworkInterface interface, list)
        mac_arr.append(interface.hardwareAddress());

    return mac_arr;
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
    qDebug()<<"AbstractDiagnostic::start_write";

    if(isStart && !s_timer_write->isActive()){
        write_data();
        s_timer_write->start(5000);
    }else{
        s_timer_write->stop();
    }

}

QJsonArray AbstractDiagnostic::get_list_nodes()
{
    qDebug()<<"AbstractDiagnostic::get_list_nodes";

    QProcess proc;
    QString program = "cellframe-node-cli";
    QStringList arguments;
    arguments << "global_db" << "get_keys" << "-group" << QString(group);
    proc.start(program, arguments);
    proc.waitForFinished(5000);
    QString res = proc.readAll();

    qDebug()<<res;
}

void AbstractDiagnostic::write_data()
{
    qDebug()<<"AbstractDiagnostic::write_data";

    QString key = s_mac_list.count() > 1 ? s_mac_list.at(1).toString()
                                         : s_mac_list.at(0).toString();

    QProcess proc;
    QString program = "cellframe-node-cli";
    QStringList arguments;
    arguments << "global_db" << "write" << "-group" << group
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
        QString key = mac.toString();

        QProcess proc;
        QString program = "cellframe-node-cli";
        QStringList arguments;
        arguments << "global_db" << "read" << "-group" << QString(group)
                  << "-key" << key;
        proc.start(program, arguments);
        proc.waitForFinished(5000);
        QString res = proc.readAll();

        //TODO nodes_array insert res
    }

    nodes_doc.setArray(nodes_array);

    return nodes_doc;
}
