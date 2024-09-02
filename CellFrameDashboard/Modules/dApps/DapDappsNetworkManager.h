#ifndef DAPDAPPSNETWORKMANAGER_H
#define DAPDAPPSNETWORKMANAGER_H

#include <QWidget>
#include <QDebug>
#include <QTextCodec>
#include <QFile>
#include <QFileDialog>
#include <QRegularExpression>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QTimer>

class DapDappsNetworkManager : public QWidget
{
    Q_OBJECT

public:
    explicit DapDappsNetworkManager(QString path, QString pathPlugins, QWidget *parent = nullptr);

    void downloadFile(QString name);
    void uploadFile();
    void getFiles();

    void cancelDownload(bool ok, bool reload);

private slots:
    void onDownloadCompleted();
    void onReadyRead();
    void onDownloadProgress(quint64,quint64);
    void onDownloadError(QNetworkReply::NetworkError);

    void onUploadCompleted(QNetworkReply *reply);
    void onFilesReceived();

    void onReconnect();


public:

    QNetworkAccessManager * m_networkManager;
    QString m_path;
    QString m_pathPlugins;
    QString m_fileName;
    QStringList m_bufferFiles;

    bool m_reload;

    quint64 m_bytesReceived = 0;
    QString m_error;

    QFile * m_file;
    QNetworkReply * m_currentReply {nullptr};

    QTimer * m_reconnectTimer;

signals:
    void sigDownloadCompleted(QString path);
    void sigDownloadProgress(quint64,quint64,QString,QString);

    void sigAborted();
    void sigUploadCompleted();
    void sigFilesReceived();

};

#endif // DAPDAPPSNETWORKMANAGER_H
