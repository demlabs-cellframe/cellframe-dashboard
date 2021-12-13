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

class DapNetworkManager : public QWidget
{
    Q_OBJECT
public:
    explicit DapNetworkManager(QString path, QString pathPlugins, QWidget *parent = nullptr);

public:
    void downloadFile(QString name);
    void uploadFile();
    void getFiles();

signals:
    void downloadCompleted(QString path);
    void uploadCompleted();
    void filesReceived();

private slots:
    void onDownloadCompleted();
    void onUploadCompleted(QNetworkReply *reply);
    void onFilesReceived();

public:

    QNetworkAccessManager * m_networkManager;
    QString m_path;
    QString m_pathPlugins;
    QString m_fileName;
    QStringList m_bufferFiles;

    QFile * m_fileUpload;

};

#endif // DAPNETWORKMANAGER_H
