#include "DapDappsNetworkManager.h"

DapDappsNetworkManager::DapDappsNetworkManager(QString path, QString pathPlugins, QWidget *parent)
    : QWidget{parent}
{
    m_path = path;
    m_pathPlugins = pathPlugins;
    m_networkManager = new QNetworkAccessManager(this);
    m_reconnectTimer = new QTimer(this);
    m_reload = false;
    connect(m_reconnectTimer, SIGNAL(timeout()), this, SLOT(onReconnect()));
}

DapDappsNetworkManager::~DapDappsNetworkManager()
{
    disconnect();
    m_networkManager->disconnect();
    m_networkManager->deleteLater();
    m_currentReply->disconnect();
    m_currentReply->deleteLater();
    delete m_reconnectTimer;
}

void DapDappsNetworkManager::downloadFile(QString name)
{
    QNetworkRequest request;
    request.setUrl(QUrl(m_path + name));
    qDebug() << "[Test_build] [DapDappsNetworkManager] tryRequest";
    m_fileName = name;
    QString path = m_pathPlugins + "/download/" + m_fileName;
    m_file = new QFile(path);

    quint64 data;
    m_bytesReceived = 0;

    if(m_file->exists())
    {
        if(m_reload)
        {
            m_file->remove();
            m_file->deleteLater();
            m_file = new QFile(path);
            m_reload = 0;
        }
        else
        {
            QFileInfo fileInfo (*m_file);
            data = fileInfo.size();

            QString strRange = QString("bytes=%1-").arg(data);
            request.setRawHeader("Range", strRange.toLatin1());
            m_bytesReceived = data;
        }
    }

    m_currentReply = m_networkManager->get(request);

    m_file->open(QIODevice::ReadWrite | QIODevice::Append);
    connect(m_currentReply, &QNetworkReply::finished,this, &DapDappsNetworkManager::onDownloadCompleted);
    connect(m_currentReply, &QNetworkReply::readyRead, this, &DapDappsNetworkManager::onReadyRead);
    connect(m_currentReply, &QNetworkReply::downloadProgress, this, &DapDappsNetworkManager::onDownloadProgress);
    connect(m_currentReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onDownloadError(QNetworkReply::NetworkError)));
}

void DapDappsNetworkManager::onDownloadCompleted()
{
    qDebug() << "[Test_build] [DapDappsNetworkManager] onDownloadCompleted";
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    QVariant statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    QString path = m_pathPlugins + "/download/" + m_fileName;

    if (reply->error() == QNetworkReply::NoError ||
        reply->error() == QNetworkReply::ContentNotFoundError)
    {
        m_file->flush();
        m_file->close();
        m_fileName = "";

        emit sigDownloadCompleted(path);
    }
    else if(statusCode.toInt() == 416) // file download
        emit sigDownloadCompleted(path);

    qInfo()<<"Reply finished. Status code: " << statusCode.toInt();

    reply->deleteLater();
    m_file->deleteLater();
}

void DapDappsNetworkManager::onReadyRead()
{
    qDebug() << "[Test_build] [DapDappsNetworkManager] onReadyRead";
    m_error = "Connected";
    if(m_file->exists())
    {
        if(m_currentReply->size())
        {
            QByteArray data = m_currentReply->readAll();
            m_file->write(data);
        }
    }
    else
    {
        cancelDownload(1,0);
        downloadFile(m_fileName);
    }
}

void DapDappsNetworkManager::onDownloadProgress(quint64 load, quint64 total)
{
    quint64 prog;
    quint64 tot;
    if(total)
    {
        prog = load + m_bytesReceived;
        tot = total + m_bytesReceived;
    }
    else
    {
        prog = 0;
        tot = 0;
    }
    if(m_reload)
    {
        m_error = "Connected";
        prog = 0;
    }

    emit sigDownloadProgress(prog, tot, m_fileName, m_error);
}

void DapDappsNetworkManager::cancelDownload(bool ok, bool reload)
{
    if(m_currentReply)
    {
        m_reload = reload;

        if(m_error == "Connected")
            m_currentReply->abort();

        if(!reload)
            emit sigAborted();
        if(ok)
        {
            m_reconnectTimer->stop();

            if(reload)
                m_reconnectTimer->start(1);
        }
    }
}

void DapDappsNetworkManager::onDownloadError(QNetworkReply::NetworkError code)
{
    QVariant statusCode = m_currentReply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
    if(!(statusCode.toInt() == 416)) // !file download
    {
        qWarning()<<"Error Download dApp. Code: " << statusCode.toInt() << ". " << m_currentReply->errorString();
        m_error = "Error code: " + QString::number(statusCode.toInt()) + ". " + m_currentReply->errorString();

        if(statusCode == QNetworkReply::ContentConflictError || statusCode.toInt() == 0 || statusCode.toInt() == 200 || statusCode.toInt() == 206) // connections network errors
        {
            m_reconnectTimer->start(10000);
        }

        onDownloadProgress(0,0);
        //        else
        }
}

void DapDappsNetworkManager::onReconnect()
{
    m_reconnectTimer->stop();
    downloadFile(m_fileName);
}

void DapDappsNetworkManager::uploadFile()
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

void DapDappsNetworkManager::onUploadCompleted(QNetworkReply *reply)
{
    if (!reply->error())
        qDebug()<< "good";
    else
        qDebug()<< reply->errorString();

    m_file->close();
    m_file->deleteLater();
    reply->deleteLater();
}

void DapDappsNetworkManager::getFiles()
{
    qDebug() << "[url] [DapDappsNetworkManager] getFiles";
    m_networkManager->get(QNetworkRequest(QUrl(m_path)));
    connect(m_networkManager, &QNetworkAccessManager::finished, this, &DapDappsNetworkManager::onFilesReceived);
}

void DapDappsNetworkManager::onFilesReceived(QNetworkReply *reply)
{
    if(!reply)
    {
        return;
    }
    if(reply->url() != QUrl(m_path))
    {
        return;
    }
    qDebug() << "[url] [DapDappsNetworkManager] onFilesReceived";
    if (reply->error() == QNetworkReply::NoError ||
        reply->error() == QNetworkReply::ContentNotFoundError)
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

    emit sigFilesReceived();
}
