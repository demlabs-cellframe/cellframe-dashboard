#ifndef DAPNETWORKMANAGER_H
#define DAPNETWORKMANAGER_H

#include <QObject>
#include <QDebug>
#include <QTextCodec>
#include <QFile>
#include <QFileDialog>
#include <QRegularExpression>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QTimer>

class DapNetworkManager : public QWidget
{
    Q_OBJECT
public:
    explicit DapNetworkManager(QString path, QString pathPlugins, QWidget *parent = nullptr);

public:
    void downloadFile(QString name);
    void uploadFile();
    void getFiles();

    void cancelDownload(bool ok);

signals:
    void downloadCompleted(QString path);
    void downloadProgress(quint64,quint64,QString,QString);

    void aborted();
    void uploadCompleted();
    void filesReceived();

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

    quint64 m_bytesReceived = 0;
    QString m_error;

    QFile * m_file;
    QNetworkReply * m_currentReply {nullptr};

    QTimer * m_reconnectTimer;

};

#endif // DAPNETWORKMANAGER_H
