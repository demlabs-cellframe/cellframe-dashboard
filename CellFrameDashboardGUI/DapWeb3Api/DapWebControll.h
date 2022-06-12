#ifndef DAPWEBCONTROLL_H
#define DAPWEBCONTROLL_H

#include <QObject>
#include <QJsonObject>
#include <QJsonDocument>
#include <QProcess>
#include <QRegularExpression>
#include <QJsonArray>
#include <QDateTime>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QRegularExpressionMatchIterator>
#include <QTcpServer>
#include <QTcpSocket>
#include <QTextStream>
#include <QString>
#include <QRandomGenerator>
#include <dap_hash.h>

class DapWebControll : public QObject
{
    Q_OBJECT
public:
    explicit DapWebControll(QObject *parent = nullptr);
    bool startServer(int port);

private slots:
  void onNewConnetion();
  void onClientSocketReadyRead();

private:
    QJsonDocument getWallets();
    QJsonDocument getNetworks();
    QJsonDocument getDataWallets(QString walletName);
    QJsonDocument sendTransaction(QString walletName, QString to, QString value, QString tokenName, QString net);
    QJsonDocument getTransactions(QString addr, QString net);

    QJsonDocument processingResult(QString status, QString errorMsg, QJsonObject data);
    QJsonDocument processingResult(QString status, QString errorMsg, QJsonArray data);
    QJsonDocument processingResult(QString status, QString errorMsg);

    QString send_cmd(QString cmd);

    QString getRandomString();
    QString getNewId();

    void sendResponce(QJsonDocument data, QTcpSocket* socket);

private:
//    QMap <int,QString> s_id;
    QStringList s_id;

    QTcpServer * _tcpServer;

    QMap <int,QTcpSocket*> s_tcpSocketList;

signals:
    void signalConnectRequest(QString site, int index);

public slots:
    void rcvAccept(bool accept, int index);

};

#endif // DAPWEBCONTROLL_H
