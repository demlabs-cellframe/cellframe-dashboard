#ifndef LINUXDIAGNOSTIC_H
#define LINUXDIAGNOSTIC_H

#include <QObject>
#include "qtimer.h"
#include <QDebug>
#include <QDesktopServices>
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

#include <unistd.h>
#include <fcntl.h>
#include <vector>

#include <fstream>
#include <numeric>
#include <vector>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <locale.h>
#include <signal.h>
#include <dirent.h>

#include <sys/sysinfo.h>

using namespace std;


class LinuxDiagnostic : public QObject
{
    Q_OBJECT
public:
    explicit LinuxDiagnostic(QObject * parent = nullptr);
    ~LinuxDiagnostic();

//    QMap<QString,QStringList>  get_proc_info();
//    QMap<QString,QStringList> process_info;

    //----------------

private:
    QString get_memory_string(int num);
    QJsonObject get_sys_info();
    bool get_cpu_times(size_t &idle_time, size_t &total_time);
    std::vector<size_t> get_cpu_times();
    QString get_running(char* pid);
    QString get_proc_path(long pid);
    QJsonObject get_process_info(long pid, int totalRam);

    quint64 get_file_size(QString flag, QString path);
    QJsonArray get_mac_array();

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

#endif // LINUXDIAGNOSTIC_H
