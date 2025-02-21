#ifndef ABSTRACTDIAGNOSTIC_H
#define ABSTRACTDIAGNOSTIC_H

#include <QObject>
#include <QtMath>
#include <QtConcurrent/QtConcurrent>

#include "DiagtoolConnectCotroller.h"
#include "httplib.h"

class AbstractDiagnostic : public QObject
{
    Q_OBJECT
    void initJsonTmpl();
public:
    explicit AbstractDiagnostic(QObject * parent = nullptr);
    ~AbstractDiagnostic();

    QString get_uptime_string(long sec);
    QString get_memory_string(size_t num);

    using Callback = std::function<void()>;

    const QJsonDocument get_list_keys(QJsonArray &listNoMacInfo);
    const QJsonDocument get_list_data(QJsonArray &listNoMacInfo);
    QJsonDocument get_full_info(){return s_full_info;}
    QJsonDocument get_list_nodes();
    QJsonDocument read_data();

    void set_node_list(QJsonDocument);
    bool check_contains(QJsonArray array, QString item, QString flag);
    void changeDataSending(bool flagSendData);

    bool getConnectDiagStatus(){return m_diagConnectCtrl->getConncetState();}
    void update_full_data();
    void send_http_request(QString method);

private:
    QJsonObject get_diagnostic_data_item(const QJsonDocument& jsonDoc);
    QElapsedTimer *s_elapsed_timer;
    QString s_uptime{"00:00:00"};

    std::atomic<bool> s_wait_http_req{false};

    DiagtoolConnectCotroller *m_diagConnectCtrl;

public:
    QJsonArray s_selected_nodes_list;
    QJsonDocument s_all_nodes_list;
    QJsonDocument s_full_info;



private slots:
    void rcv_diag_data(QJsonDocument diagData);
    void on_telemetry_data_rcv(QString method, QByteArray result);

protected:
    const QString NETWORK_ADDR = "https://telemetry.cellframe.net";
    const QString GET_VIEW     = "/diag?method=view";
    const QString GET_KEYS     = "/diag?method=keys";

    QJsonDocument* m_jsonListNode;
    QJsonDocument* m_jsonData;

signals:
    void data_updated(QJsonDocument);
    void diagtool_socket_change_status(bool status);
    void sig_telemetry_data_rcv(QString method, QByteArray result);
};

#endif // ABSTRACTDIAGNOSTIC_H
