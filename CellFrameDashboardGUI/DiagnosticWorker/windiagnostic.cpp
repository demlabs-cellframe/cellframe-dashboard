#include "windiagnostic.h"

WinDiagnostic::WinDiagnostic(QObject *parent)
    : QObject{parent}
{
    s_timer_update = new QTimer();

    connect(s_timer_update, &QTimer::timeout,
            this, &WinDiagnostic::info_update,
            Qt::QueuedConnection);
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

void WinDiagnostic::info_update(){

    QJsonObject proc_info;
    QJsonObject sys_info;
    QJsonObject full_info;


//    sys_info = get_sys_info();
//    sys_info.insert("mac_list", get_mac_array());
//    QJsonObject obj = sys_info["memory"].toObject();
//    int mem = obj["total_value"].toInt();

//    proc_info = get_process_info(get_pid(), mem);

//    full_info.insert("system", sys_info);
//    full_info.insert("process", proc_info);

//    s_full_info.setObject(full_info);

//    emit data_updated(s_full_info);
}

QString WinDiagnostic::get_uptime_string(int sec)
{
    QTime time(0, 0);
    time = time.addSecs(sec);
    int fullHours = sec/3600;

    QString uptime = QString("%1:").arg(fullHours) + time.toString("mm:ss");

    return uptime;
}

