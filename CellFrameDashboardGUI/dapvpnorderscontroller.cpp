#include "dapvpnorderscontroller.h"

DapVPNOrdersController::DapVPNOrdersController()
{
    manager = new QNetworkAccessManager(this);
    request.setUrl(QUrl("http://cdb0.kelvpn.com/nodelist"));
}

void DapVPNOrdersController::VPNOrdersReplyFinished()
{
    disconnect(reply, &QNetworkReply::finished, this, &DapVPNOrdersController::VPNOrdersReplyFinished);
    this->disconnect(reply, SIGNAL(error(QNetworkReply::NetworkError)));

    QNetworkReply *replyAns = qobject_cast<QNetworkReply *>(sender());
    QByteArray arr = replyAns->readAll();

    emit vpnOrdersReceived(arr);

    replyAns->deleteLater();
}

void DapVPNOrdersController::connectionError(QNetworkReply::NetworkError code)
{
    disconnect(reply, &QNetworkReply::finished, this, &DapVPNOrdersController::VPNOrdersReplyFinished);
    this->disconnect(reply, SIGNAL(error(QNetworkReply::NetworkError)));
    qDebug() << "QNetworkReply::NetworkError " << code << "received";
    emit connectionError();
}

void DapVPNOrdersController::retryConnection()
{
    reply = manager->get(request);

    connect(reply, &QNetworkReply::finished, this, &DapVPNOrdersController::VPNOrdersReplyFinished);
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), SLOT(connectionError(QNetworkReply::NetworkError)));
}
