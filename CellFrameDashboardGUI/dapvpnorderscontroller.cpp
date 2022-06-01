#include "dapvpnorderscontroller.h"

DapVPNOrdersController::DapVPNOrdersController()
{
    manager = new QNetworkAccessManager(this);
    QNetworkRequest request;
    request.setUrl(QUrl("http://cdb0.kelvpn.com/nodelist"));

    reply = manager->get(request);

    connect(reply, &QNetworkReply::finished, this, &DapVPNOrdersController::VPNOrdersReplyFinished);
    //connect(reply, &QNetworkReply::readyRead, this, &DapNetworkManager::onReadyRead);
    //connect(reply, &QNetworkReply::downloadProgress, this, &DapNetworkManager::onDownloadProgress);
    //connect(reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onDownloadError(QNetworkReply::NetworkError)));
}

void DapVPNOrdersController::VPNOrdersReplyFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QString arr = reply->readAll();

    //QJsonDocument doc = QJsonDocument::fromJson(arr);

    QJsonObject obj;
    obj.insert("key", arr);
    QJsonDocument doc(obj);


    qDebug() << "ddddddddddddddddddddddddddddddddddddd" << doc;

    emit vpnOrdersReceived(doc);

    reply->deleteLater();

    //qDebug() << "iiiiiiiiiiiiiiiiiiiiiiiiiiiii" << arr;

    /*QStringList list = arr.split('}');

    for (int i = 0; i < list.length(); ++i)
    {
        list[i] = list[i].remove(QChar('{'), Qt::CaseInsensitive);



        if (i == 0)
            list[i] = list[i].remove('[');

        if (i == list.length() - 1)
            list[i] = list[i].remove(']');

        QStringList listVal = list[i].split(',');

        QVariantMap map;

        listVal.removeAll("");

        //qDebug() << "iiiiiiiiiiiiiiiiiiiiiiiiiiiii" << listVal;

        for (int j = 0; j < listVal.length(); ++j)
        {
            QStringList l = listVal[j].split(':');
            map[l[0]] = l[1];
        }



        //qDebug() << "iiiiiiiiiiiiiiiiiiiiiiiiiiiii222222222222222222" << map;
    }*/
}
