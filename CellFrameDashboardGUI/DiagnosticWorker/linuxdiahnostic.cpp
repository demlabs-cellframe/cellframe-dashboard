#include "linuxdiahnostic.h"


LinuxDiahnostic::LinuxDiahnostic(QObject *parent)
    : QObject{parent}
{
    s_timer_update = new QTimer();

    connect(s_timer_update, &QTimer::timeout,
            this, &LinuxDiahnostic::info_update,
            Qt::QueuedConnection);
}

LinuxDiahnostic::~LinuxDiahnostic()
{
    delete s_timer_update;
}

void LinuxDiahnostic::set_timeout(int timeout){
    s_timer_update->stop();
    s_timeout = timeout;
    s_timer_update->start(s_timeout);
}

void LinuxDiahnostic::start_diagnostic()
{
    s_timer_update->start(s_timeout);
}

void LinuxDiahnostic::stop_diagnostic()
{
    s_timer_update->stop();
}

void LinuxDiahnostic::info_update(){

    QJsonObject proc_info;
    QJsonObject sys_info;
    QJsonObject full_info;

//    // open proc dir
//    DIR* proc = opendir("/proc");
//    struct dirent* ent=0;
//    long pid;

//    // if open error
//    if(proc == NULL) {
//        qWarning()<<"opendir(/proc) error";
//        return;
//    }

//    // read proc dir
//    while((ent = readdir(proc)))
//    {
//        // read proc ids
//        if(!isdigit(*ent->d_name))
//            continue;

//        // process id
//        pid = strtol(ent->d_name, NULL, 10);
//        pid = get_pid();

//        double vm, rss;

//        proc_info = get_process_info(vm, rss,pid);

//        if(proc_info.isEmpty())
//            continue;
//        else
//            break;
//    }
//    closedir(proc);

    proc_info = get_process_info(get_pid());

    sys_info = get_sys_info();
    sys_info.insert("mac_list", get_mac_array());

    full_info.insert("system", sys_info);
    full_info.insert("process", proc_info);

    s_full_info.setObject(full_info);

    emit data_updated(s_full_info);
}

long LinuxDiahnostic::get_pid()
{
    long pid;
    QString path = QString("%1/var/run/cellframe-node.pid").arg(NODE_DIR_PATH);

    QFile file(path);
    QByteArray data;
    if (!file.open(QIODevice::ReadOnly))
        return 0;
    data = file.readAll();
    pid = data.toLong();

    return pid;
}

QJsonArray LinuxDiahnostic::get_mac_array()
{
    QJsonArray mac_arr;

    QList<QNetworkInterface>list = QNetworkInterface::allInterfaces();

    foreach (QNetworkInterface interface, list)
        mac_arr.append(interface.hardwareAddress());

    return mac_arr;
}

QJsonObject LinuxDiahnostic::get_sys_info()
{
    QJsonObject obj_sys_data, obj_cpu, obj_memory;

    ifstream stat_stream;
    string buff;

    //-------

    //get cpu info
    size_t idle_time, total_time;
    get_cpu_times(idle_time, total_time);

    const float idle_time_delta = idle_time - previous_idle_time;
    const float total_time_delta = total_time - previous_total_time;
    const float utilization = 100.0 * (1.0 - idle_time_delta / total_time_delta);

    previous_idle_time = idle_time;
    previous_total_time = total_time;

    stat_stream.open("/proc/cpuinfo");
    for(int i = 0; i < 16;i++) stat_stream >> buff;
    getline(stat_stream,buff);

    obj_cpu.insert("load", (int)utilization);
    obj_cpu.insert("model", QString::fromStdString(buff));
    stat_stream.close();

    //get uptime system
    stat_stream.open("/proc/uptime");
    stat_stream >> buff;
    QString uptime = get_uptime_string(atoi(buff.c_str()));
    stat_stream.close();

    //get memory data
    stat_stream.open("/proc/meminfo");
    QString memory, memory_used, memory_free;
    string total,free,available;
    stat_stream >> buff >> total >> buff >> buff >> free >> buff >> buff >> available;
    stat_stream.close();

    int total_value = atoi(total.c_str());
    int available_value = atoi(available.c_str());

    memory = get_memory_string(total_value);
    memory_used = QString::number((total_value - available_value) *100 / total_value);
    memory_free = get_memory_string(available_value);

    obj_memory.insert("total", memory);
    obj_memory.insert("free", memory_free);
    obj_memory.insert("load", memory_used);

    //-------

    obj_sys_data.insert("uptime", uptime);
    obj_sys_data.insert("CPU", obj_cpu);
    obj_sys_data.insert("memory", obj_memory);

    return obj_sys_data;
}

QString LinuxDiahnostic::get_running(char* pid)
{
    char tbuf[32];
    char *cp;
    int fd;
    char c;

    sprintf(tbuf, "/proc/%s/stat", pid);
    fd = open(tbuf, O_RDONLY, 0);
    if (fd == -1) return QString("no open");

    memset(tbuf, '\0', sizeof tbuf); // didn't feel like checking read()
    read(fd, tbuf, sizeof tbuf - 1);

    cp = strrchr(tbuf, ')');
    if(!cp) return QString("no read");

    c = cp[2];
    close(fd);
    qDebug()<<c;

    if (c=='R') {
      return "running";
    }else
    if (c=='D') {
      return "blocked";
    }
    return QString("blocked");
}


QString LinuxDiahnostic::get_proc_path(long pid) // work with root
{
    char exePath[PATH_MAX];
    char arg1[20];
    sprintf( arg1, "/proc/%ld/exe", pid );
    ssize_t len = ::readlink(arg1, exePath, sizeof(exePath));
    if (len == -1 || len == sizeof(exePath))
        len = 0;
    exePath[len] = '\0';
    return QString::fromUtf8(exePath);
}

std::vector<size_t> LinuxDiahnostic::get_cpu_times() {
    std::ifstream proc_stat("/proc/stat");
    proc_stat.ignore(5, ' '); // Skip the 'cpu' prefix.
    std::vector<size_t> times;
    for (size_t time; proc_stat >> time; times.push_back(time));
    return times;
}

bool LinuxDiahnostic::get_cpu_times(size_t &idle_time, size_t &total_time) {
    const std::vector<size_t> cpu_times = get_cpu_times();
    if (cpu_times.size() < 4)
        return false;
    idle_time = cpu_times[3];
    total_time = std::accumulate(cpu_times.begin(), cpu_times.end(), 0);
    return true;
}

QString LinuxDiahnostic::get_memory_string(int num)
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

QString LinuxDiahnostic::get_uptime_string(int sec)
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
QJsonObject LinuxDiahnostic::get_process_info(long proc_id)
{
   using std::ios_base;
   using std::ifstream;
   using std::string;

//   vm_usage     = 0.0;
//   resident_set = 0.0;

   // 'file' stat seems to give the most reliable results
   char arg1[20];
   sprintf( arg1, "/proc/%ld/stat", proc_id );
   ifstream stat_stream(arg1,ios_base::in);

   // dummy vars for leading entries in stat that we don't care about
   //
   string pid, comm, state, ppid, pgrp, session, tty_nr;
   string tpgid, flags, minflt, cminflt, majflt, cmajflt;
   string utime, stime, cutime, cstime, priority, nice;
   string O, itrealvalue;

   // the two fields we want
   //
   unsigned long vsize;
   long rss;
   double starttime;

   stat_stream >> pid >> comm >> state >> ppid >> pgrp >> session >> tty_nr
               >> tpgid >> flags >> minflt >> cminflt >> majflt >> cmajflt
               >> utime >> stime >> cutime >> cstime >> priority >> nice
               >> O >> itrealvalue >> starttime >> vsize >> rss; // don't care about the rest

   stat_stream.close();

//   long page_size_kb = sysconf(_SC_PAGE_SIZE) / 1024; // in case x86-64 is configured to use 2MB pages
//   vm_usage     = (vsize/1024.0);
//   resident_set = rss * page_size_kb;

   QProcess proc;
   QString program = "ps";
   QStringList arguments;
   arguments << "-p" << pid.c_str() << "-o" << "etimes";
   proc.start(program, arguments);
   proc.waitForFinished(1000);
   QString res = proc.readAll();

   static QRegularExpression rx(R"([0-9]+)");

   QJsonObject process_info;
   process_info.insert("status", "Offline");
   if(QString::fromLocal8Bit(comm.c_str()).contains("cellframe-node"))
   {
       int uptime_sec = rx.match(res).captured(0).toInt();

       QString uptime= get_uptime_string(uptime_sec);

       QString path = NODE_PATH;
       QString node_dir = NODE_DIR_PATH;

//       process_info.insert("PPID",QString::fromLocal8Bit(ppid.c_str()));
//       process_info.insert("priory",QString::fromLocal8Bit(priority.c_str()));
//       process_info.insert("start_time",QString::number(((starttime/100)/60)));
       process_info.insert("uptime",uptime);
       process_info.insert("name","cellframe-node");
       process_info.insert("path", path);
       process_info.insert("log_size", get_memory_string(get_file_size("log", node_dir) / 1024));
       process_info.insert("DB_size", get_memory_string(get_file_size("DB", node_dir) / 1024));
       process_info.insert("chain_size", get_memory_string(get_file_size("chain", node_dir) / 1024));
       process_info.insert("status", "Online");
   }

   return process_info;
}

quint64 LinuxDiahnostic::get_file_size (QString flag, QString path ) {

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
        if(flag == "DB" && i.suffix() != "dat" && !i.isDir())
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
