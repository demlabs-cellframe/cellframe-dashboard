#include "DapUpdateVersionController.h"

DapUpdateVersionController::DapUpdateVersionController(QObject *parent)
    : QObject{parent}
{
#ifdef Q_OS_WIN
#define DOWNLOAD_PATH QString("%1/").arg(regGetUsrPath())
#define SCRIPT_PATH QString("%1/").arg(regGetUsrPath())
    s_urlPath = QString("https://pub.cellframe.net/windows/Dashboard-latest/");
    s_suffix =  QString(".exe");

#elif defined Q_OS_LINUX
#define DOWNLOAD_PATH QString("/opt/")
#define SCRIPT_PATH QString("/opt/")
    s_urlPath = QString("https://pub.cellframe.net/linux/cellframe-dashboard-latest/");
    s_suffix =  QString(".deb");

#elif defined Q_OS_MAC
#define DOWNLOAD_PATH QString("/Users/%1/Applications/").arg(getenv("USER"))
#define SCRIPT_PATH QString("/Users/%1/Applications/").arg(getenv("USER"))
    s_urlPath = QString("https://pub.cellframe.net/macos/Dashboard-latest/");
    s_suffix =  QString(".pkg");

#elif defined Q_OS_ANDROID
    s_urlPath = QString("https://pub.cellframe.net/android/Cellframe-Dashboard-arm64-v8a-latest/");
    s_suffix =  QString(".apk");
#endif

    s_netManager = new QNetworkAccessManager(this);
    checkUpdate();
}

void DapUpdateVersionController::checkUpdate()
{
    QNetworkRequest request;
    request.setUrl(QUrl(s_urlPath));

    QNetworkReply *reply = s_netManager->get(request);
    connect(reply, SIGNAL(finished()), this, SLOT(rcvVersion()));
}

void DapUpdateVersionController::rcvVersion()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply->error() == QNetworkReply::NoError){
        QByteArray content= reply->readAll();
        QTextCodec *codec = QTextCodec::codecForName("utf8");
        QString str = codec->toUnicode(content.data());
        QRegExp rw("[\\w+\\s+-\\.]+" + s_suffix);
        QString fileName;
        rw.indexIn(str);
        fileName = rw.cap(0);

        if(fileName != ""){
            s_lastVersion = fileName;
            s_hasUpdate = compareVersion();
//            installPack();
//            downloadPack();
        }
    }else
        qWarning()<<reply->errorString();

    reply->deleteLater();
}


bool DapUpdateVersionController::compareVersion()
{
    QString lastVersion = s_lastVersion.toString().split("_").at(1);
    QString currVersion = DAP_VERSION;

    return lastVersion > currVersion ? true : false;
}

void DapUpdateVersionController::downloadPack()
{
    QString name = s_lastVersion.toString();

    QNetworkRequest request;
    request.setUrl(QUrl(s_urlPath + "../" + name));

    QString path = DOWNLOAD_PATH + name;
    m_file = new QFile(path);

    if(m_file->exists())
    {
        m_file->remove();
        m_file->deleteLater();
        m_file = new QFile(path);
    }
    m_file->open(QIODevice::ReadWrite | QIODevice::Append);
    QNetworkReply *reply = s_netManager->get(request);
    connect(reply, &QNetworkReply::finished,this, &DapUpdateVersionController::downloadFinish);

}

void DapUpdateVersionController::downloadFinish()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
    QVariant statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    QString path = DOWNLOAD_PATH + s_lastVersion.toString();

    if (reply->error() == QNetworkReply::NoError)
    {
        m_file->write(reply->readAll());
        m_file->close();
    }
    else
        qWarning()<<"Download error.";

    qInfo()<<"Reply finished. Status code: " << statusCode.toInt();

    reply->deleteLater();
    m_file->deleteLater();
}

void DapUpdateVersionController::installPack()
{
#ifdef Q_OS_LINUX
    createInstallScript();
    system("chmod 777 /opt/installScript.sh");
    system("/opt/installScript.sh &");
#endif
}

void DapUpdateVersionController::createInstallScript()
{
    QString path = SCRIPT_PATH + "installScript.sh";
    m_installScript = new QFile(path);

    if(m_installScript->exists())
    {
        m_installScript->remove();
        m_installScript->deleteLater();
        m_installScript = new QFile(path);
    }
    if(m_installScript->open(QIODevice::ReadWrite | QIODevice::Append))
    {
        QTextStream out(m_installScript);
        out <<" tty -s || exec x-terminal-emulator -e /opt/installScript.sh" << endl;
        out <<"  I=$( wget -O cellframe-dashboard.deb "+s_urlPath + "../" + s_lastVersion.toString()+ ")"<< endl;
        out <<" P='cellframe-dashboard.deb'" << endl;
        out <<" sudo dpkg -i $P" << endl;
        out <<"J=`dpkg -s cellframe-dashboard | grep \"/Status\"/ `"<< endl;
        out <<"if [ -n \"/$J\"/ ]"<< endl;
        out <<"then" << endl;
        out <<"    echo \"/==============================================================\"/"<< endl;
        out <<"    echo                            $J                                  "<< endl;
        out <<"    echo \"/==============================================================\"/"<< endl;
        out <<"else"<< endl;
        out <<"    echo \"/==============================================================\"/"<< endl;
        out <<"    echo                            $J                                  "<< endl;
        out <<"    echo \"/==============================================================\"/"<< endl;
        out <<"fi"<< endl;
        out <<"rm $P"<< endl;
        out <<"cd /opt/cellframe-dashboard/bin/"<<endl;
        out <<"nohup  ./Cellframe-Dashboard"<<endl;
        m_installScript->close();
    }
}
