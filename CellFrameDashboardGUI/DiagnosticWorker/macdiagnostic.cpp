#include "macdiagnostic.h"

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

