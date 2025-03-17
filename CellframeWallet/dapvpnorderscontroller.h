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
    QNetworkRequest request;

    QByteArray ordersModel;
    bool isError = false;

public:
    DapVPNOrdersController();

public slots:
    void VPNOrdersReplyFinished();
    void connectionError(QNetworkReply::NetworkError);
    void retryConnection();
    QByteArray getOrdersModel();
    bool getIsError();
    bool isTokenInOrders(const QString &tokenName);

signals:
    void vpnOrdersReceived(QByteArray doc);
    void connectionError();
};

#endif // DAPVPNORDERSCONTROLLER_H
