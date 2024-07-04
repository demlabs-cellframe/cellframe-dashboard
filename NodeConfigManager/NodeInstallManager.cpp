#include "NodeInstallManager.h"

NodeInstallManager::NodeInstallManager(bool flag_RK, QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager())
{
    QString branch = flag_RK ? "release-5.3" : "master";

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)

    m_latest = "latest-amd64";
    m_url = QUrl(QString("https://pub.cellframe.net/linux/cellframe-node/%1/%2/").arg(branch).arg(m_latest));
    m_suffix =  QString(".deb");

#elif defined (Q_OS_MACOS)

    m_url = QUrl(QString("https://pub.cellframe.net/macos/cellframe-node/%1/%2/").arg(branch).arg(m_latest));//todo: need branch
    m_suffix =  QString(".pkg");

#elif defined (Q_OS_WIN)

    m_url = QUrl(QString("https://pub.cellframe.net/windows/cellframe-node/%1/%2/").arg(branch).arg(m_latest)); //todo: need branch
    m_suffix =  QString(".exe");

#elif defined Q_OS_ANDROID
    m_url = QUrl("");
    m_suffix =  QString(".apk");
    qDebug()<<"No pack for platform";
#else
    m_url = QUrl("");
    qDebug()<<"No pack for platform";
#endif
}

NodeInstallManager::~NodeInstallManager()
{

}

QString NodeInstallManager::getUrlForDownload()
{
    return m_url.toString();
}

void NodeInstallManager::checkUpdateNode(QString currentNodeVersion)
{
    //todo: this func receive install-pack name and fill m_fileName
    QNetworkRequest request;
    request.setUrl(QUrl(m_url));

    QNetworkReply *reply = m_networkManager->get(request);
    connect(reply, &QNetworkReply::finished, this, &NodeInstallManager::onGetFileName);
}

void NodeInstallManager::onGetFileName()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply->error() == QNetworkReply::NoError){
        QByteArray content = reply->readAll();
        QTextCodec *codec = QTextCodec::codecForName("utf8");
        QString str = codec->toUnicode(content.data());
        QRegExp rw("[\\w+\\s+-\\.]+" + m_suffix);

        rw.indexIn(str);
        m_fileName = rw.cap(0);

        emit singnalReadyUpdateToNode(true);
    }else{
        qWarning()<<reply->errorString();
        m_fileName = "";

        emit singnalReadyUpdateToNode(false);
    }

    reply->deleteLater();
}
