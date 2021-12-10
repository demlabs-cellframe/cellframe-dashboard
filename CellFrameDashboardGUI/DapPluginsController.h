#ifndef DAPPLUGINSCONTROLLER_H
#define DAPPLUGINSCONTROLLER_H

#include <QObject>
#include <QSettings>
#include <QFile>
#include <QDebug>

#include <QCryptographicHash>
#include <dap_hash.h>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QFileDialog>
#include <QRegularExpression>

#include "JlCompress.h"

class DapPluginsController : public QWidget
{
    Q_OBJECT
public:
    explicit DapPluginsController(QString pathPluginsConfigFile, QString pathPlugins, QWidget *parent = nullptr);

private:

    //file manage work
    void readPluginsFile(QString *path);
    void updateFileConfig();
    void sortList(){std::sort(m_pluginsList.begin(), m_pluginsList.end());};
    bool zipManage(QString &path);
    bool checkDuplicates(QString name, QString verifed);
    bool checkHttps(QString path);
    void downloadPlugin(QString name);

    QByteArray fileChecksum(const QString &fileName, QCryptographicHash::Algorithm hashAlgorithm);
    QString pkeyHash(QString &path);

    //repository work
    void getListPluginsByUrl();
    void uploadFile();

public slots:

    void getListPlugins(){sortList(); emit rcvListPlugins(m_pluginsList);};
    void addPlugin(QVariant, QVariant, QVariant);
    void installPlugin(int, QString, QString);
    void deletePlugin(int);

    //repository work
    void replyFinished();
    void uploadFinished(QNetworkReply *reply);
    void downloadFinished();

signals:

    void completedParseReply();
    void rcvListPlugins(QList <QVariant> m_pluginsList);

private slots:

    void appendReplyToListPlugins();

private:

    QString m_pathPluginsConfigFile;
    QString m_pathPlugins;
    QList <QVariant> m_pluginsList;
    QStringList m_buffPluginsByUrl;

    QString m_filePrefix;

    QNetworkAccessManager* m_networkManager;
    QString m_repoPlugins;
    QFile* m_fileUpload;
    QString m_nameDownloadingFile;

};

#endif // DAPPLUGINSCONTROLLER_H
