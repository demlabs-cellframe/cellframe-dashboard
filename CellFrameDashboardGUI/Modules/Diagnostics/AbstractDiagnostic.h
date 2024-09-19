#ifndef ABSTRACTDIAGNOSTIC_H
#define ABSTRACTDIAGNOSTIC_H

#include <QObject>
#include <QDebug>
#include <QTimer>
#include <QTime>
#include <QElapsedTimer>
#include <QtMath>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>

#include <QUrl>
#include <QTcpSocket>
#include <QHostAddress>
#include <QNetworkInterface>
#include <QNetworkAccessManager>
#include <QHttpPart>
#include <QHttpMultiPart>
#include <QNetworkReply>

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

private:
    QJsonObject get_diagnostic_data_item(const QJsonDocument& jsonDoc);
    QElapsedTimer *s_elapsed_timer;
    QString s_uptime{"00:00:00"};

public:
    QJsonArray s_selected_nodes_list;
    QJsonDocument s_all_nodes_list;
    QJsonDocument s_full_info;


public slots:
    void on_reply_finished(QNetworkReply *reply);
    void update_full_data(/*Callback hendler = nullptr*/);

protected:
    const QString NETWORK_ADDR_GET_VIEW = "https://engine-minkowski.kelvpn.com/diag?method=view";
    const QString NETWORK_ADDR_GET_KEYS = "https://engine-minkowski.kelvpn.com/diag?method=keys";

    QJsonDocument* m_jsonListNode;
    QJsonDocument* m_jsonData;

    QNetworkAccessManager* m_manager = nullptr;

/// ---------------------------------------------------------------
///        Diagtool connect
/// ---------------------------------------------------------------

private:
    void initConnections();
private slots:
    void slotError();
    void slotConnected();
    void slotReconnect();
    void slotDisconnected();
    void slotReadyRead();
    void slotStateChanged(QTcpSocket::SocketState socketState);

    void reconnectFunc();

private:
    QTcpSocket *m_socket;

public:
    QTimer *m_reconnectTimerDiagtool;
    bool m_connectStatus{false};

signals:
    void signalSocketChangeStatus(bool status);
    void data_updated(QJsonDocument);

/// ---------------------------------------------------------------
};

#endif // ABSTRACTDIAGNOSTIC_H
