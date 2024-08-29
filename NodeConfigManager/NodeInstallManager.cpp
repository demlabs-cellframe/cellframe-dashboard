#include "NodeInstallManager.h"

NodeInstallManager::NodeInstallManager(bool flag_RK, QObject *parent)
    : QObject(parent)
    , m_networkManager(new QNetworkAccessManager())
{
    QString branch = "master";

    QString procArch = QSysInfo::currentCpuArchitecture();
    QString latest = "latest-"+procArch;
    if(procArch == "x86_64")
        latest = "latest-amd64";


#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)

    m_url = QUrl(QString("https://pub.cellframe.net/linux/cellframe-node/%1/%2/").arg(branch).arg(latest));
    m_suffix =  QString(".deb");
    m_labelUrlFile = "-amd64";
    m_baseUrl = QString("https://pub.cellframe.net/linux/cellframe-node/%1").arg(branch);

#elif defined (Q_OS_MACOS)

    m_url = QUrl(QString("https://pub.cellframe.net/macos/cellframe-node/%1/%2/").arg(branch).arg(latest));//todo: need branch
    m_suffix =  QString(".pkg");
    m_labelUrlFile = "-amd64";
    m_baseUrl = QString("https://pub.cellframe.net/macos/cellframe-node/%1").arg(branch);

#elif defined (Q_OS_WIN)

    m_url = QUrl(QString("https://pub.cellframe.net/windows/cellframe-node/%1/%2/").arg(branch).arg(latest)); //todo: need branch
    m_suffix =  QString(".exe");
    m_labelUrlFile = "-installer";
    m_baseUrl = QString("https://pub.cellframe.net/windows/cellframe-node/%1").arg(branch);

#elif defined Q_OS_ANDROID
    m_url = QUrl("");
    m_suffix =  QString(".apk");
    m_labelUrlFile = "";
    m_baseUrl = QString("");
    qDebug()<<"No pack for platform";
#else
    m_url = QUrl("");
    m_baseUrl = QString("");
    m_labelUrlFile = "";
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

QString NodeInstallManager::getUrl(const QString& ver)
{
    return QString("%1/cellframe-node-%2%3%4").arg(m_baseUrl).arg(ver).arg(m_labelUrlFile).arg(m_suffix);
}

void NodeInstallManager::checkUpdateNode(const QString& url)
{
    //todo: this func receive install-pack name and fill m_fileName
    QNetworkAccessManager *manager = new QNetworkAccessManager(this);
    QNetworkRequest request((QUrl(url)));

    qDebug() << "[Test url] Try check url. URL: " << url;
    connect(manager, &QNetworkAccessManager::finished, this, &NodeInstallManager::onGetFileName);
    manager->get(request);
}

void NodeInstallManager::onGetFileName(QNetworkReply *reply)
{
    qDebug() << "[NodeInstallManager] [onGetFileName] ";
    if(!reply)
    {
        emit singnalReadyUpdateToNode(false);
        return;
    }
    auto url = reply->url();
    if (reply->error() == QNetworkReply::NoError)
    {
        qDebug() << "[Test url] Check url, no errors. URL: " << url;
        QByteArray content = reply->readAll();
        QTextCodec *codec = QTextCodec::codecForName("utf8");
        QString str = codec->toUnicode(content.data());
        QRegExp rw("[\\w+\\s+-\\.]+" + m_suffix);
        qDebug() << "[TEST] NodeInstallManager Test key 1";
        rw.indexIn(str);
        m_fileName = rw.cap(0);
        qDebug() << "[TEST] NodeInstallManager Test key 2";
        emit singnalReadyUpdateToNode(true);
        qDebug() << "[TEST] NodeInstallManager Test key 3";
    }
    else
    {
        qDebug() << "[Test url] Check url, Have a error. URL: " << url;
        qWarning()<<reply->errorString();
        m_fileName = "";

        emit singnalReadyUpdateToNode(false);
    }
    qDebug() << "[TEST] NodeInstallManager Test key 4";
    reply->deleteLater();
    qDebug() << "[TEST] NodeInstallManager Test key 5";
}
