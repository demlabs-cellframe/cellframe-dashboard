#ifndef MACDIAGNOSTIC_H
#define MACDIAGNOSTIC_H

#include <QObject>
#include "qtimer.h"
#include <QDebug>
#include <QUrl>
#include <QFileInfo>
#include <QCoreApplication>
#include <QProcess>
#include <QString>
#include <QRegularExpression>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDir>
#include <QNetworkInterface>

//#include <unistd.h>
//#include <fcntl.h>
//#include <vector>

//#include <fstream>
//#include <numeric>
//#include <vector>

//#include <stdio.h>
//#include <stdlib.h>
//#include <string.h>
//#include <ctype.h>
//#include <locale.h>
//#include <signal.h>
//#include <dirent.h>

#include <sys/sysctl.h>
#include <sys/types.h>
#include <mach/vm_statistics.h>
#include <mach/mach_types.h>
#include <mach/mach_init.h>
#include <mach/mach_host.h>
#include <time.h>
#include <mach/mach_time.h>

using namespace std;


class MacDiagnostic : public QObject
{
    Q_OBJECT
public:
    explicit MacDiagnostic(QObject * parent = nullptr);
    ~MacDiagnostic();

private:
    QString get_memory_string(int num);
    QJsonObject get_sys_info();
    QJsonObject get_process_info(int totalRam);

    quint64 get_file_size(QString flag, QString path);
    QJsonArray get_mac_array();


    //cpu
    float calculate_cpu_load(unsigned long long idleTick, unsigned long long totakTicks );

public:
    QString get_uptime_string(int sec);

private slots:
    void info_update();

private:
    QTimer * s_timer_update;
    int s_timeout{1000};
    size_t previous_idle_time{0}, previous_total_time{0};
    QJsonDocument s_full_info;

    long get_pid();

public:
    void start_diagnostic();
    void stop_diagnostic();
    void set_timeout(int timeout);

    QJsonDocument get_full_info(){return s_full_info;};

signals:
    void data_updated(QJsonDocument);

};

#endif // MACDIAGNOSTIC_H
