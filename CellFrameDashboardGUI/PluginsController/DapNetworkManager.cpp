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
    QNetworkReply *reply;
    reply = m_networkManager->get(QNetworkRequest(QUrl(m_path + name)));
    m_fileName = name;

    connect(reply, SIGNAL(finished()),this,SLOT(onDownloadCompleted()));
}

void DapNetworkManager::onDownloadCompleted()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply->error() == QNetworkReply::NoError)
    {
        QString path = m_pathPlugins + "/download/" + m_fileName;
        QFile fileDownload(path);

        if(fileDownload.open(QIODevice::WriteOnly))
        {
            fileDownload.write(reply->readAll());
            fileDownload.close();
        }
        else
            qWarning()<< "Failed Download Plugin. " << fileDownload.errorString();

        emit downloadCompleted(path);
    }
    else
        qWarning()<<reply->errorString();

    disconnect(reply, SIGNAL(finished()),this,SLOT(onDownloadCompleted()));
    reply->deleteLater();
    m_fileName = "";
}

void DapNetworkManager::uploadFile()
{
    QString fileName = QFileDialog::getOpenFileName(this, "Get Any file");
    m_fileUpload = new QFile(fileName);

    QFileInfo fileInfo (*m_fileUpload);

    QUrl url(m_path + fileInfo.fileName());
    url.setUserName("ftpuser");
    url.setPassword("sGpawUJeC");
    url.setPort(21);

    if(m_fileUpload->open(QIODevice::ReadOnly))
    {
        m_networkManager->put(QNetworkRequest(url),m_fileUpload);
    }
}

void DapNetworkManager::onUploadCompleted(QNetworkReply *reply)
{
    if (!reply->error())
        qDebug()<< "good";
    else
        qDebug()<< reply->errorString();

    m_fileUpload->close();
    m_fileUpload->deleteLater();
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

    disconnect(reply, SIGNAL(finished()),this,SLOT(onFilesReceived()));
    reply->deleteLater();

    emit filesReceived();
}
