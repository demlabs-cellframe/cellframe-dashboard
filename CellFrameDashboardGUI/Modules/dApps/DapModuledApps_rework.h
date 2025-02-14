#ifndef DAPMODULEDAPPS_REWORK_H
#define DAPMODULEDAPPS_REWORK_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "DapDappsNetworkManager.h"

#include <QCryptographicHash>
#include <dap_hash.h>
#include <optional>
#include "zip/unpackzip.h"

namespace DApps {

using DappsNetworkManagerPtr = QSharedPointer<DapDappsNetworkManager>;

class PluginManager : public QObject
{
    Q_OBJECT
public:
    struct PluginInfo
    {
        QString pluginPath;
        bool isActivated;
        bool isVerified;
    };
    using PluginsList = QMap<QString, PluginInfo>;

    explicit PluginManager(DappsNetworkManagerPtr pDapDappsNetworkManager, QObject *parent = nullptr);
    ~PluginManager();

    QList<QVariant> getPluginsList() const;

    std::optional<PluginInfo> pluginByName(const QString& name) const;

    void addLocalPlugin(QString name, QString localPath);
    void changePath(QString name, QString newPath);
    void changeActivation(QString name, bool isActivated);
    void changeName(QString oldName, QString newName);
    void removePlugin(QString name);

private slots:
    void onPluginsFetched();

signals:
    void isFetched();

private:
    void addFetchedPlugins();
    void savePluginsToFile();
    void initFilePath();

    PluginsList m_pluginsByName;
    DappsNetworkManagerPtr m_pDapNetworkManager;
    QString m_pathPluginsListFile;
};

class DownloadManager : public QObject
{
    Q_OBJECT
public:
    explicit DownloadManager(DappsNetworkManagerPtr pDapDappsNetworkManager, QObject *parent = nullptr);
    ~DownloadManager();

    void startDownload(const QString& pluginName);
    void cancelDownload();
    void reloadDownload();

private slots:

    void onDownloadCompleted(QString path);
    void onDownloadProgress(quint64 currDownloadedBytes, quint64 totalBytes, QString nameZip, QString statusMsg);
    void onAborted();

signals:

    void downloadCompleted(QString path);
    void downloadProgress(bool isCompleted, QString error, QString progressPercent, QString fileName, QString downloaded, QString total, QString timeRemain, QString speed);
    void isAborted();

private:
    struct Progress
    {
        quint64 lastTimeInterval = 0;
        quint64 prevDownloaded = 0;
        quint64 totalBytes = 0;
        QTime timeRecord;
        QString speedStr;
        QString timeRemainStr;
    };

    DappsNetworkManagerPtr m_pDapNetworkManager;
    Progress m_progress;
    const quint64 m_minTimeInterval = 500;
};

class DapModuledAppsRework : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuledAppsRework(DapModulesController *parent = nullptr);
    ~DapModuledAppsRework();

public slots:
    void addLocalPlugin(QVariant path);
    void activatePlugin(QString pluginName);
    void deactivatePlugin(QString pluginName);
    void deletePlugin(QString pluginName);

    void cancelDownload();
    void reloadDownload();

private slots:
    void onPluginManagerInit();
    void onDownloadCompleted(QString pluginFullPathToZip);
    void onDownloadProgress(bool isCompleted, QString error, QString progressPercent, QString fileName, QString downloaded, QString total, QString timeRemain, QString speed);
    void onAborted();

signals:
    void pluginsUpdated(QList<QVariant> pluginsList);
    void rcvProgressDownload(bool isCompleted, QString error, QString progressPercent, QString fileName, QString downloaded, QString total, QString timeRemain, QString speed);
    void rcvAbort();

private:
    void initPlatformPaths();

    QString m_dappsFolder;
    QString m_filePrefix;
    const QString m_repoPlugins = "https://dapps.cellframe.net/dashboard/";

    DapModulesController * m_modulesCtrl;

    using PluginManagerPtr = QSharedPointer<PluginManager>;
    PluginManagerPtr m_pPluginManager;

    using DownloadManagerPtr = QSharedPointer<DownloadManager>;
    DownloadManagerPtr m_pDownloadManager;
};



} // DApps

#endif // DAPMODULEDAPPS_REWORK_H
