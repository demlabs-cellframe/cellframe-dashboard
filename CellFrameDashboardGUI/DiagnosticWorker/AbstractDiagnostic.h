#ifndef ABSTRACTDIAGNOSTIC_H
#define ABSTRACTDIAGNOSTIC_H

#include <QObject>
#include "qtimer.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QDesktopServices>
#include <QUrl>
#include <QFileInfo>
#include <QCoreApplication>
#include <QProcess>
#include <QString>
#include <QRegularExpression>

#include <QDir>
#include <QNetworkInterface>

class AbstractDiagnostic : public QObject
{
    Q_OBJECT
public:
    explicit AbstractDiagnostic(QObject * parent = nullptr);
    ~AbstractDiagnostic();

public:
    void start_diagnostic();
    void stop_diagnostic();
    void set_timeout(int timeout);
    quint64 get_file_size(QString flag, QString path);
    QString get_uptime_string(long sec);
    QString get_memory_string(long num);
    QJsonArray get_mac_array();

    QJsonDocument get_full_info(){return s_full_info;};

public:
    QTimer * s_timer_update;
    int s_timeout{1000};
    QJsonDocument s_full_info;
    QJsonArray s_mac_list;

signals:
    void data_updated(QJsonDocument);


/// ---------------------------------------------------------------
///        Npde process
/// ---------------------------------------------------------------
public:

    void start_write(bool isStart);

private slots:
    void write_data();
    QJsonDocument read_data();

    QJsonArray get_list_nodes();

public:
    QTimer *s_timer_write, *s_timer_read;

    QJsonArray s_selected_nodes_list;
    QJsonArray s_all_nodes_list;

/// ---------------------------------------------------------------

};

#endif // ABSTRACTDIAGNOSTIC_H
