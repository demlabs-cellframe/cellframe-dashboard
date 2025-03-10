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
#include <QtConcurrent/QtConcurrent>
#include <QMutex>

class DapDappsNetworkManager : public QWidget
{
    Q_OBJECT

public:
    explicit DapDappsNetworkManager(QString path, QString pathPlugins, QWidget *parent = nullptr);
    ~DapDappsNetworkManager();
    void downloadFile(QString name);
    // void uploadFile();
    void fetchPluginsList();

    void cancelDownload(bool ok, bool reload);

    QString repoAddress() const;

private slots:
    void onReconnect();
    void onReload();

private:
    QMutex mtx;

public:

    QNetworkAccessManager * m_networkManager = nullptr;
    QString m_path;
    QString m_pathPlugins;
    QString m_fileName;
    QStringList m_bufferFiles;

    bool m_reload{false};
    bool m_cancelDownload{false};

    quint64 m_bytesReceived = 0;
    QString m_error;

    QFile * m_file;
    QNetworkReply * m_currentReply {nullptr};

    QTimer * m_reconnectTimer;

signals:
    void sigDownloadCompleted(QString path);
    void sigDownloadProgress(quint64,quint64,QString,QString);

    void sigAborted();
    void sigPluginsListFetched();

    void sigReload();
};

#endif // DAPDAPPSNETWORKMANAGER_H
