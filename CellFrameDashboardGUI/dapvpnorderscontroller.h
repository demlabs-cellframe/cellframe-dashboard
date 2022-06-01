#ifndef DAPVPNORDERSCONTROLLER_H
#define DAPVPNORDERSCONTROLLER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

class DapVPNOrdersController : public QObject
{
    Q_OBJECT

    QNetworkAccessManager *manager;
    QNetworkReply *reply;
public:
    DapVPNOrdersController();

public slots:
    void VPNOrdersReplyFinished();

signals:
    void vpnOrdersReceived(QJsonDocument doc);
};

#endif // DAPVPNORDERSCONTROLLER_H
