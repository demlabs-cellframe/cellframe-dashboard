#ifndef DAPWEBCONTROLL_H
#define DAPWEBCONTROLL_H

#include <QObject>
#include "httpServer/qhttpserver.h"
#include "httpServer/qhttprequest.h"
#include "httpServer/qhttpresponse.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QProcess>
#include <QRegularExpression>
#include <QJsonArray>
#include <QDate>

class DapWebControll : public QObject
{
    Q_OBJECT
public:
    explicit DapWebControll(QObject *parent = nullptr);

public slots:
    void handleRequest(QHttpRequest *req, QHttpResponse *resp);

private:
    QJsonDocument getWallets();
    QJsonDocument getDataWallets(QString walletName);
    QJsonDocument sendTransaction(QString walletName, QString to, QString value, QString tokenName);
    QJsonDocument getTransactions(QString walletName);

    QJsonDocument processingResult(QString status, QString errorMsg, QJsonObject data);
    QJsonDocument processingResult(QString status, QString errorMsg, QJsonArray data);
    QJsonDocument processingResult(QString status, QString errorMsg);

    QByteArray send_cmd(QString cmd);

private:
    QString s_defaultNet;
    QString s_defaultChain;

signals:

};

#endif // DAPWEBCONTROLL_H
