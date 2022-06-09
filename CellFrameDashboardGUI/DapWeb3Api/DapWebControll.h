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
  void onClietnSocketDisconnected();

private:
    QJsonDocument getWallets();
    QJsonDocument getDataWallets(QString walletName);
    QJsonDocument sendTransaction(QString walletName, QString to, QString value, QString tokenName);
    QJsonDocument getTransactions(QString addr, QString net);

    QJsonDocument processingResult(QString status, QString errorMsg, QJsonObject data);
    QJsonDocument processingResult(QString status, QString errorMsg, QJsonArray data);
    QJsonDocument processingResult(QString status, QString errorMsg);

    QString send_cmd(QString cmd);

    QString getRandomString();
    QString getNewId();

    void requestProcessing();

private:
    QString s_defaultNet;
    QString s_defaultChain;
    QString s_id;

    QTcpServer * _tcpServer;

    QList <QTcpSocket*> s_tcpSocketList;

signals:
    void signalConnectRequest(QString site);

private slots:
    void rcvAccept(bool rcv);

};

#endif // DAPWEBCONTROLL_H
