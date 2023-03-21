#include "MacDiagnostic.h"

static unsigned long long _previousTotalTicks = 0;
static unsigned long long _previousIdleTicks = 0;

MacDiagnostic::MacDiagnostic(QObject *parent)
    : QObject{parent}
{
    s_timer_update = new QTimer();

    connect(s_timer_update, &QTimer::timeout,
            this, &MacDiagnostic::info_update,
            Qt::QueuedConnection);
}

MacDiagnostic::~MacDiagnostic()
{
    delete s_timer_update;
}

void MacDiagnostic::set_timeout(int timeout){
    s_timer_update->stop();
    s_timeout = timeout;
    s_timer_update->start(s_timeout);
}

void MacDiagnostic::start_diagnostic()
{
    s_timer_update->start(s_timeout);
}

void MacDiagnostic::stop_diagnostic()
{
    s_timer_update->stop();
}

void MacDiagnostic::info_update(){

    QJsonObject proc_info;
    QJsonObject sys_info;
    QJsonObject full_info;


    sys_info = get_sys_info();
    sys_info.insert("mac_list", get_mac_array());
    QJsonObject obj = sys_info["memory"].toObject();
    int mem = obj["total_value"].toInt();

    proc_info = get_process_info(mem);

    full_info.insert("system", sys_info);
//    full_info.insert("process", proc_info);

    s_full_info.setObject(full_info);

    qDebug()<<"Tick";
    qDebug()<<s_full_info.toJson();

    emit data_updated(s_full_info);
}

QJsonArray MacDiagnostic::get_mac_array()
{
    QJsonArray mac_arr;

    QList<QNetworkInterface>list = QNetworkInterface::allInterfaces();

    foreach (QNetworkInterface interface, list)
        mac_arr.append(interface.hardwareAddress());

    return mac_arr;
}

QJsonObject MacDiagnostic::get_sys_info()
{
    QJsonObject obj_sys_data, obj_cpu, obj_memory;

    //get memory data
    //total mem
    int mib[2];
    int64_t physical_memory;
    mib[0] = CTL_HW;
    mib[1] = HW_MEMSIZE;
    size_t length = sizeof(int64_t);
    sysctl(mib, 2, &physical_memory, &length, NULL, 0);



    //use mem

    vm_size_t page_size;
    mach_port_t mach_port;
    mach_msg_type_number_t count;
    vm_statistics64_data_t vm_stats;
    long long free_memory = 0;
//    long long used_memory = 0;

    mach_port = mach_host_self();
    count = sizeof(vm_stats) / sizeof(natural_t);
    if (KERN_SUCCESS == host_page_size(mach_port, &page_size) &&
        KERN_SUCCESS == host_statistics64(mach_port, HOST_VM_INFO,
                                        (host_info64_t)&vm_stats, &count))
    {
        free_memory = (int64_t)vm_stats.free_count * (int64_t)page_size;

//        used_memory = ((int64_t)vm_stats.active_count +
//                                 (int64_t)vm_stats.inactive_count +
//                                 (int64_t)vm_stats.wire_count) *  (int64_t)page_size;
    }

    QString memtotal = get_memory_string(physical_memory/1024);
    QString memfree = get_memory_string(free_memory/1024);
//    QString memused = get_memory_string(used_memory/1024);

    QString memory_used = QString::number((physical_memory - free_memory) *100 / physical_memory);

    obj_memory.insert("total", memtotal);
    obj_memory.insert("total_value", physical_memory/1024);
    obj_memory.insert("free", memfree);
    obj_memory.insert("load", memory_used);

    //get cpu info

    host_cpu_load_info_data_t cpuinfo;
    float res = -1.0f;
    mach_msg_type_number_t counts = HOST_CPU_LOAD_INFO_COUNT;
    if (host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, (host_info_t)&cpuinfo, &count) == KERN_SUCCESS)
    {
       unsigned long long totalTicks = 0;
       for(int i=0; i<CPU_STATE_MAX; i++) totalTicks += cpuinfo.cpu_ticks[i];
       res =  calculate_cpu_load(cpuinfo.cpu_ticks[CPU_STATE_IDLE], totalTicks);
    }
    obj_cpu.insert("load", int(res*100));

    //get uptime system

    enum { NANOSECONDS_IN_SEC = 1000 * 1000 * 1000 };
    double multiply = 0;
    QString uptime = "00:00:00";
    if (multiply == 0)
    {
        mach_timebase_info_data_t s_timebase_info;
        if(mach_timebase_info(&s_timebase_info) == KERN_SUCCESS)
        {
            // multiply to get value in the nano seconds
            multiply = (double)s_timebase_info.numer / (double)s_timebase_info.denom;
            // multiply to get value in the seconds
            multiply /= NANOSECONDS_IN_SEC;
            uptime = get_uptime_string(mach_absolute_time() * multiply);
        }
    }


//    //-------

    obj_sys_data.insert("uptime", uptime);
    obj_sys_data.insert("CPU", obj_cpu);
    obj_sys_data.insert("memory", obj_memory);

    return obj_sys_data;
}

float MacDiagnostic::calculate_cpu_load(unsigned long long idleTicks, unsigned long long totalTicks)
{
    unsigned long long totalTicksSinceLastTime = totalTicks-_previousTotalTicks;
    unsigned long long idleTicksSinceLastTime  = idleTicks-_previousIdleTicks;
    float ret = 1.0f-((totalTicksSinceLastTime > 0) ? ((float)idleTicksSinceLastTime)/totalTicksSinceLastTime : 0);
    _previousTotalTicks = totalTicks;
    _previousIdleTicks  = idleTicks;
    return ret;

}

QString MacDiagnostic::get_memory_string(int num)
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

QString MacDiagnostic::get_uptime_string(int sec)
{
    QTime time(0, 0);
    time = time.addSecs(sec);
    int fullHours = sec/3600;

    QString uptime = QString("%1:").arg(fullHours) + time.toString("mm:ss");

    return uptime;
}

/// ---------------------------------------------------------------
///        Process info
/// ---------------------------------------------------------------
QJsonObject MacDiagnostic::get_process_info(int totalRam)
{
    QJsonObject process_info;

    QProcess proc;
    QString program = "ps";
    QStringList arguments;
    arguments << "-axm" << "-o" << "rss,pid,etime,comm";
    proc.start(program, arguments);
    proc.waitForFinished(1000);
    QString res = proc.readAll();

    QString string="";

    for(QString str : res.split("\n"))
    {
        if(str.contains("cellframe-node"))
        {
            string = str;
            break;
        }
    }

    QString status = "Offline";
    QString node_dir = QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/").arg(getenv("USER")); //todo: create define

    QString log_size, db_size, chain_size;
    log_size = get_memory_string(get_file_size("log", node_dir) / 1024);
    db_size = get_memory_string(get_file_size("DB", node_dir) / 1024);
    chain_size = get_memory_string(get_file_size("chain", node_dir) / 1024);

    if(log_size.isEmpty()) log_size = "0 Kb";
    if(db_size.isEmpty()) db_size = "0 Kb";
    if(chain_size.isEmpty()) chain_size = "0 Kb";

    process_info.insert("log_size", log_size);
    process_info.insert("DB_size", db_size);
    process_info.insert("chain_size", chain_size);


    if(string.isEmpty())
    {
        process_info.insert("memory_use","0");
        process_info.insert("memory_use_value","0 Kb");
        process_info.insert("uptime","00:00:00");
    }
    else
    {
        status = "Online";

        int pid, rss;
        QString uptime, path;

        QStringList parseString = string.split(" ");
        parseString.removeAll("");

        rss = parseString[0].toInt();
        pid = parseString[1].toInt();
        uptime = parseString[2];
        path = parseString[3];

        QString memory_use_value = get_memory_string(rss);
        int precentUseRss = rss *100 / totalRam;

        process_info.insert("memory_use",precentUseRss);
        process_info.insert("memory_use_value",memory_use_value);
        process_info.insert("uptime",uptime);
        process_info.insert("name","cellframe-node");
        process_info.insert("path", path);
    }

    process_info.insert("status", status);


   return process_info;
}

quint64 MacDiagnostic::get_file_size (QString flag, QString path ) {

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
