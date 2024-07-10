#ifndef ABSTRACTDIAGNOSTIC_H
#define ABSTRACTDIAGNOSTIC_H

#define NETWORK_DIAGNOSTIC

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
#include <QtMath>
#include <QSettings>
#include <QTime>

#include <QDir>
#include <QNetworkInterface>
#include <QNetworkAccessManager>

#include "NodePathManager.h"

class AbstractDiagnostic : public QObject
{
    Q_OBJECT
public:
    explicit AbstractDiagnostic(QObject * parent = nullptr);
    ~AbstractDiagnostic();

    QString nodeCli{""};
    QString nodePath{""};
    QString nodeDirPath{""};

public:
    void start_diagnostic();
    void stop_diagnostic();
    void set_timeout(int timeout);
    quint64 get_file_size(QString flag, QString path);
    QString get_uptime_string(long sec);
    QString get_memory_string(size_t num);
    QJsonValue get_mac();

    QJsonDocument get_full_info(){return s_full_info;}

    QJsonObject roles_processing();

public:
    QTimer * s_timer_update;
    int s_timeout{1000};
    QJsonDocument s_full_info;
    QJsonValue s_mac;

signals:
    void data_updated(QJsonDocument);


/// ---------------------------------------------------------------
///        Node process
/// ---------------------------------------------------------------
public:
    void start_write(bool isStart);
    QJsonDocument get_list_nodes();
    QJsonDocument read_data();

    void set_node_list(QJsonDocument);
    bool check_contains(QJsonArray array, QString item, QString flag);

private:
    QJsonObject get_diagnostic_data_item(const QJsonDocument& jsonDoc);

private slots:
    void write_data();
    void remove_data();


public:
    QTimer *s_timer_write, *s_timer_read;

    QJsonArray s_selected_nodes_list;
    QJsonDocument s_all_nodes_list;

#ifdef NETWORK_DIAGNOSTIC
public:
    using Callback = std::function<void()>;

    const QJsonDocument get_list_keys(QJsonArray &listNoMacInfo);
    const QJsonDocument get_list_data(QJsonArray &listNoMacInfo);

public slots:
    void on_reply_finished(QNetworkReply *reply);
    void update_full_data(/*Callback hendler = nullptr*/);

protected:
    const QString NETWORK_ADDR_SENDER = "https://engine-minkowski.kelvpn.com/diag_report";
    const QString NETWORK_ADDR_GET_VIEW = "https://engine-minkowski.kelvpn.com/diag?method=view";
    const QString NETWORK_ADDR_GET_KEYS = "https://engine-minkowski.kelvpn.com/diag?method=keys";

    QJsonDocument* m_jsonListNode;
    QJsonDocument* m_jsonData;

    QNetworkAccessManager* m_manager = nullptr;
#endif

/// ---------------------------------------------------------------

};

#endif // ABSTRACTDIAGNOSTIC_H
