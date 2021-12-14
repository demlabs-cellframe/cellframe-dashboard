#include "DapNetworkManager.h"

DapNetworkManager::DapNetworkManager(QString path, QString pathPlugins, QWidget *parent)
    : QWidget{parent}
{
    m_path = path;
    m_pathPlugins = pathPlugins;
    m_networkManager = new QNetworkAccessManager(this);
}

void DapNetworkManager::downloadFile(QString name)
{
    m_currentReply = m_networkManager->get(QNetworkRequest(QUrl(m_path + name)));
    m_fileName = name;
    QString path = m_pathPlugins + "/download/" + m_fileName;

    m_file = new QFile(path);

    m_file->open(QIODevice::ReadWrite | QIODevice::Append);
    connect(m_currentReply, &QNetworkReply::finished,this, &DapNetworkManager::onDownloadCompleted);
    connect(m_currentReply, &QNetworkReply::readyRead, this, &DapNetworkManager::onReadyRead);
    connect(m_currentReply, &QNetworkReply::downloadProgress, this, &DapNetworkManager::onUploadProgress);
}

void DapNetworkManager::onDownloadCompleted()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply->error() == QNetworkReply::NoError)
    {
        QString path = m_pathPlugins + "/download/" + m_fileName;

        m_file->flush();
        m_file->close();

        emit downloadCompleted(path);
    }
    else
        qWarning()<<"Failed Download Plugin. " << reply->errorString();

    reply->deleteLater();
    m_file->deleteLater();
    m_fileName = "";
}

void DapNetworkManager::onReadyRead()
{
   if(m_currentReply->size())
   {
       QByteArray data = m_currentReply->readAll();
       m_file->write(data);
   }
}

void DapNetworkManager::onUploadProgress(quint64 load, quint64 total)
{
    double prog = load / 1024.0 / 1024.0;
    double tot = total / 1024.0 / 1024.0;

    emit downloadProgress(prog, tot);
}

void DapNetworkManager::cancelDownload()
{
    if(m_currentReply)
    {
        m_currentReply->abort();
        emit aborted();
    }
}

void DapNetworkManager::uploadFile()
{
    QString fileName = QFileDialog::getOpenFileName(this, "Get Any file");
    m_file = new QFile(fileName);
    QFileInfo fileInfo (*m_file);
    QUrl url(m_path + fileInfo.fileName());
    url.setUserName("ftpuser");
    url.setPassword("sGpawUJeC");
    url.setPort(21);

    if(m_file->open(QIODevice::ReadOnly))
    {
        m_networkManager->put(QNetworkRequest(url),m_file);
    }
}

void DapNetworkManager::onUploadCompleted(QNetworkReply *reply)
{
    if (!reply->error())
        qDebug()<< "good";
    else
        qDebug()<< reply->errorString();

    m_file->close();
    m_file->deleteLater();
    reply->deleteLater();
}

void DapNetworkManager::getFiles()
{
    QNetworkReply *reply;
    reply = m_networkManager->get(QNetworkRequest(QUrl(m_path)));
    connect(reply, SIGNAL(finished()),this,SLOT(onFilesReceived()));
}

void DapNetworkManager::onFilesReceived()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray content= reply->readAll();
        QTextCodec *codec = QTextCodec::codecForName("utf8");
        QString str = codec->toUnicode(content.data());
        QRegExp rw("[\\w+|\\s+]{,}.zip");
        int lastPos = 0;

        while((lastPos = rw.indexIn(str,lastPos)) != -1)
        {
            lastPos += rw.matchedLength();
            m_bufferFiles.append(rw.cap(0));
        }
        m_bufferFiles.removeDuplicates();
    }
    else
        qWarning()<<reply->errorString();

    reply->deleteLater();

    emit filesReceived();
}
