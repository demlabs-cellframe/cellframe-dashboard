#include "dapvpnorderscontroller.h"

DapVPNOrdersController::DapVPNOrdersController()
{
    manager = new QNetworkAccessManager(this);
    request.setUrl(QUrl("http://cdb0.kelvpn.com/nodelist"));
    retryConnection();
}

void DapVPNOrdersController::VPNOrdersReplyFinished()
{
    disconnect(reply, &QNetworkReply::finished, this, &DapVPNOrdersController::VPNOrdersReplyFinished);
    this->disconnect(reply, SIGNAL(error(QNetworkReply::NetworkError)));

    QNetworkReply *replyAns = qobject_cast<QNetworkReply *>(sender());
    QByteArray arr = replyAns->readAll();

    emit vpnOrdersReceived(arr);
    ordersModel = arr;

    replyAns->deleteLater();
}

void DapVPNOrdersController::connectionError(QNetworkReply::NetworkError code)
{
    isError = true;
    disconnect(reply, &QNetworkReply::finished, this, &DapVPNOrdersController::VPNOrdersReplyFinished);
    this->disconnect(reply, SIGNAL(error(QNetworkReply::NetworkError)));
    qDebug() << "QNetworkReply::NetworkError " << code << "received";
    emit connectionError();
}

void DapVPNOrdersController::retryConnection()
{
    isError = false;
    reply = manager->get(request);

    connect(reply, &QNetworkReply::finished, this, &DapVPNOrdersController::VPNOrdersReplyFinished);
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), SLOT(connectionError(QNetworkReply::NetworkError)));
}

QByteArray DapVPNOrdersController::getOrdersModel()
{
    return ordersModel;
}

bool DapVPNOrdersController::getIsError()
{
    return isError;
}

bool DapVPNOrdersController::isTokenInOrders(const QString &tokenName)
{
    QString s = ordersModel;

    return s.contains(tokenName);
}
