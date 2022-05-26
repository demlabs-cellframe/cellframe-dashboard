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

class DapWebControll : public QObject
{
    Q_OBJECT
public:
    explicit DapWebControll(QObject *parent = nullptr);

public slots:
    void handleRequest(QHttpRequest *req, QHttpResponse *resp);

private:
    QJsonObject getWallets();
    QJsonObject getTokenBalances(QString addr);
    QJsonObject sendTransaction(QString from, QString to, QString value);

private:
    QString s_defaultNet;
    QString s_defaultChain;

signals:

};

#endif // DAPWEBCONTROLL_H
