#ifndef DIAGTOOLCONNECTCOTROLLER_H
#define DIAGTOOLCONNECTCOTROLLER_H

#include <QObject>
#include <QDebug>

#include <QTimer>
#include <QTime>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QJsonParseError>
#include <QElapsedTimer>

#include <QUrl>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QHostAddress>

class DiagtoolConnectCotroller : public QObject
{
    Q_OBJECT
public:
    explicit DiagtoolConnectCotroller(QObject *parent = nullptr);

public:
    bool getConncetState(){return m_connectStatus;}
    quint64 writeSocket(QByteArray data);

private slots:
    void slotError();
    void slotReadyRead();
    void slotStateChanged(QAbstractSocket::SocketState socketState);

private:
    QTcpSocket *m_socket;
    bool m_connectStatus{false};

signals:
    void signalDataRcv(QJsonDocument);
    void signalSocketChangeStatus(bool status);
};

#endif // DIAGTOOLCONNECTCOTROLLER_H
