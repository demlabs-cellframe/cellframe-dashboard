#ifndef WINDIAGNOSTIC_H
#define WINDIAGNOSTIC_H

#include <windows.h>
#include <psapi.h>
#include <tlhelp32.h>
#include "registry.h"
#include "pdh.h"

#include <QDebug>
#include <QDesktopServices>
#include <QDir>
#include <QFileInfo>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkInterface>+
#include <QObject>
#include <QProcess>
#include <QRegularExpression>
#include <QString>
#include <QTime>
#include <QTimer>
#include <QUrl>


enum PLATFORM { WINNT1, WIN2K_XP1, WIN9X1, UNKNOWN1 };

class WinDiagnostic : public QObject {
    Q_OBJECT
    public:
    explicit WinDiagnostic(QObject* parent = nullptr);
    ~WinDiagnostic();

private:
    QJsonObject get_sys_info();
    QJsonArray get_mac_array();
    QJsonObject get_process_info(int totalRam);

    quint64 get_file_size (QString flag, QString path );
    long get_memory_size(HANDLE hProc);
    ULONGLONG ft2ull(FILETIME &ft);
    BOOL SetPrivilege(    HANDLE hToken,          // access token handle
                          LPCTSTR lpszPrivilege,  // name of privilege to enable/disable
                          BOOL bEnablePrivilege);

private:
    QTimer* s_timer_update;
    int s_timeout{1000};
    QJsonDocument s_full_info;

    HANDLE hProcessSnapShot;
    PROCESSENTRY32 ProcessEntry;
    FILETIME s_prev_idle, s_prev_kernel, s_prev_user;



private slots:
    void refresh_win_snapshot();
    void info_update();

signals:
    void data_updated(QJsonDocument);

public:
    QString get_uptime_string(int sec);
    QString get_memory_string(int num);

public:
    void start_diagnostic();
    void stop_diagnostic();
    void set_timeout(int timeout);

    QJsonDocument get_full_info(){return s_full_info;};
};

#endif  // WINDIAGNOSTIC_H
