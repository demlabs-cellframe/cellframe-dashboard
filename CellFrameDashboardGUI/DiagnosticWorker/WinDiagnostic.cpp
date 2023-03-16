#include "WinDiagnostic.h"

WinDiagnostic::WinDiagnostic(QObject *parent)
    : QObject{parent}
{
    s_timer_update = new QTimer();

    connect(s_timer_update, &QTimer::timeout,
            this, &WinDiagnostic::info_update,
            Qt::QueuedConnection);

    GetSystemTimes(&s_prev_idle, &s_prev_kernel, &s_prev_user);
}

WinDiagnostic::~WinDiagnostic()
{
    delete s_timer_update;
}

void WinDiagnostic::set_timeout(int timeout){
    s_timer_update->stop();
    s_timeout = timeout;
    s_timer_update->start(s_timeout);
}

void WinDiagnostic::start_diagnostic()
{
    s_timer_update->start(s_timeout);
}

void WinDiagnostic::stop_diagnostic()
{
    s_timer_update->stop();
}

void WinDiagnostic::info_update()
{
    // refresh snaphot
    refresh_win_snapshot();

    QJsonObject proc_info;
    QJsonObject sys_info;
    QJsonObject full_info;


    sys_info = get_sys_info();
    sys_info.insert("mac_list", get_mac_array());
    QJsonObject obj = sys_info["memory"].toObject();
    int mem = obj["total_value"].toInt();

    proc_info = get_process_info(mem);

    full_info.insert("system", sys_info);
    full_info.insert("process", proc_info);

    s_full_info.setObject(full_info);

    emit data_updated(s_full_info);
}

QString WinDiagnostic::get_uptime_string(int sec)
{
    QTime time(0, 0);
    time = time.addSecs(sec);
    int fullHours = sec/3600;

    QString uptime = QString("%1:").arg(fullHours) + time.toString("mm:ss");

    return uptime;
}

QString WinDiagnostic::get_memory_string(int num)
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

QJsonArray WinDiagnostic::get_mac_array()
{
    QJsonArray mac_arr;

    QList<QNetworkInterface>list = QNetworkInterface::allInterfaces();

    foreach (QNetworkInterface i_face, list)
        mac_arr.append(i_face.hardwareAddress());

    return mac_arr;
}

QJsonObject WinDiagnostic::get_sys_info()
{
    QJsonObject obj_sys_data, obj_cpu, obj_memory;

    // get CPU load
    FILETIME idle;
    FILETIME kernel;
    FILETIME user;

    GetSystemTimes(&idle, &kernel, &user);

    ULONGLONG sys = (ft2ull(user) - ft2ull(s_prev_user)) +
        (ft2ull(kernel) - ft2ull(s_prev_kernel));

    QString cpu_load = QString::number(int((sys - ft2ull(idle) + ft2ull(s_prev_idle)) * 100.0 / sys));
    obj_cpu.insert("load", cpu_load);

    s_prev_idle = idle;
    s_prev_kernel = kernel;
    s_prev_user = user;

    MEMORYSTATUSEX memory_status;
    ZeroMemory(&memory_status, sizeof(MEMORYSTATUSEX));
    memory_status.dwLength = sizeof(MEMORYSTATUSEX);
    GlobalMemoryStatusEx(&memory_status);

    QString memory, memory_used, memory_free;

    memory = get_memory_string(memory_status.ullTotalPhys / 1024);
    int total_value = memory_status.ullTotalPhys / 1024;
    int available_value = memory_status.ullAvailPhys / 1024;
    memory_free = get_memory_string(memory_status.ullAvailPhys / 1024);

    memory_used = QString::number((total_value - available_value) *100 / total_value);

    obj_memory.insert("total", memory);
    obj_memory.insert("total_value", total_value);
    obj_memory.insert("free", memory_free);
    obj_memory.insert("load", memory_used);

    DWORD currentTime = GetTickCount();

    QString uptime = get_uptime_string(currentTime/1000);


    obj_sys_data.insert("uptime", uptime);
    obj_sys_data.insert("CPU", obj_cpu);
    obj_sys_data.insert("memory", obj_memory);
    return obj_sys_data;

}

long WinDiagnostic::get_memory_size(HANDLE hProc)
{
    PROCESS_MEMORY_COUNTERS pmcInfo;

    if (GetProcessMemoryInfo(hProc, &pmcInfo, sizeof(pmcInfo)))
        return pmcInfo.WorkingSetSize/1024;
    else return 0;

}

ULONGLONG WinDiagnostic::ft2ull(FILETIME &ft) {
    ULARGE_INTEGER ul;
    ul.HighPart = ft.dwHighDateTime;
    ul.LowPart = ft.dwLowDateTime;
    return ul.QuadPart;
}

void WinDiagnostic::refresh_win_snapshot()
{
    // Get the process list snapshot.
    hProcessSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);

    ProcessEntry.dwSize = sizeof( ProcessEntry );


    // Get the first process info.
    BOOL Return = FALSE;
    Return = Process32First( hProcessSnapShot,&ProcessEntry );

    // Getting process info failed.
    if( !Return )
    {
        qDebug()<<"Getting process info failed";
    }
}

BOOL WinDiagnostic::SetPrivilege(
    HANDLE hToken,          // access token handle
    LPCTSTR lpszPrivilege,  // name of privilege to enable/disable
    BOOL bEnablePrivilege   // to enable or disable privilege
    )
{
    TOKEN_PRIVILEGES tp;
    LUID luid;

    if ( !LookupPrivilegeValue(
            NULL,            // lookup privilege on local system
            lpszPrivilege,   // privilege to lookup
            &luid ) )        // receives LUID of privilege
    {
        printf("LookupPrivilegeValue error: %u\n", GetLastError() );
        return FALSE;
    }

    tp.PrivilegeCount = 1;
    tp.Privileges[0].Luid = luid;
    if (bEnablePrivilege)
        tp.Privileges[0].Attributes = SE_PRIVILEGE_ENABLED;
    else
        tp.Privileges[0].Attributes = 0;

    // Enable the privilege or disable all privileges.

    if ( !AdjustTokenPrivileges(
           hToken,
           FALSE,
           &tp,
           sizeof(TOKEN_PRIVILEGES),
           (PTOKEN_PRIVILEGES) NULL,
           (PDWORD) NULL) )
    {
          printf("AdjustTokenPrivileges error: %u\n", GetLastError() );
          return FALSE;
    }

    if (GetLastError() == ERROR_NOT_ALL_ASSIGNED)

    {
          printf("The token does not have the specified privilege. \n");
          return FALSE;
    }

    return TRUE;
}

QJsonObject WinDiagnostic::get_process_info(int totalRam)
{
    // refresh snaphot
    refresh_win_snapshot();

    hProcessSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);

    // vars for get process time
    FILETIME lpCreation, lpExit, lpKernel, lpUser;
    SYSTEMTIME stCreation, stExit, stKernel, stUser;
    long memory_size;

    HANDLE hSnapshot;
    PROCESSENTRY32 pe;
    long pid = 0;
    BOOL hResult;

    // snapshot of all processes in the system
    hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);

    // initializing size: needed for using Process32First
    pe.dwSize = sizeof(PROCESSENTRY32);

    // info about first process encountered in a system snapshot
    hResult = Process32First(hSnapshot, &pe);


    QString proc_name = "cellframe-node.exe";
    while (hResult) {
        // if we find the process: return process ID

        std::wstring string(pe.szExeFile);
        std::string str(string.begin(), string.end());
        QString s = QString::fromStdString(str);


        if(!proc_name.compare(s)){
            pid = pe.th32ProcessID;

            HANDLE hToken = NULL;

            if (!OpenProcessToken(GetCurrentProcess(),
              TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, &hToken))
              printf("OpenProcessToken error: %u\n", GetLastError() );


            if(SetPrivilege(&hToken, SE_DEBUG_NAME, TRUE))
            {
                // get process descriptor
                HANDLE hProcess = OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION  | PROCESS_VM_READ, FALSE, pe.th32ProcessID);

                printf("OpenProcess error: %u\n", GetLastError() );

                SetPrivilege(&hToken, SE_DEBUG_NAME, FALSE);

                // get process times info
                bool ok = GetProcessTimes(hProcess,&lpCreation, &lpExit, &lpKernel, &lpUser);
                if(ok)
                {
                      FileTimeToSystemTime(&lpCreation, &stCreation);
                      FileTimeToSystemTime(&lpExit, &stExit);
                      FileTimeToSystemTime(&lpUser, &stUser);
                      FileTimeToSystemTime(&lpKernel, &stKernel);
                }
                memory_size = get_memory_size(hProcess);

                //TODO CPU processing

    //            wchar_t* a="C:\Program Files\Cellframe-Dashboard\cellframe-node.exe";
    //            wchar_t test = PrintVersionStringInfo((wchar_t)("C:\\Program Files\\Cellframe-Dashboard\\cellframe-node.exe"));

                CloseHandle(hProcess);
            }

            break;
        }
        hResult = Process32Next(hSnapshot, &pe);
    }

    CloseHandle( hProcessSnapShot );

    QJsonObject process_info;

    QString status = "Offline";
//    QString path = NODE_PATH;
    QString node_dir = QString("%1/cellframe-node/").arg(regGetUsrPath());

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


    if(pid){

//        stUser.wSecond; //Work time
//        stCreation.wSecond; //Create time
//        memory_size;
//        totalRam;

//        int uptime_sec = rx.match(res).captured(0).toInt();
//        QString uptime= get_uptime_string(uptime_sec);
//        QString memory_use_value = get_memory_string(resident_set);

        process_info.insert("memory_use",0);
        process_info.insert("memory_use_value","---");
        process_info.insert("uptime","---");
        process_info.insert("name","cellframe-node");

        status = "Online";

    }else{

        process_info.insert("memory_use",0);
        process_info.insert("memory_use_value","0 Kb");
        process_info.insert("uptime","00:00:00");
    }

    process_info.insert("status", status);
//    process_info.insert("path", path);


    return process_info;
}

quint64 WinDiagnostic::get_file_size (QString flag, QString path ) {

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

