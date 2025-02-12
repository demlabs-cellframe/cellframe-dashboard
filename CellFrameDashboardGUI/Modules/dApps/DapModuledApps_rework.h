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
    void updatePlugin(QString name, QString newPath);
    void updatePlugin(QString name, bool isActivated);
    void changeName(QString oldName, QString newName);

private slots:
    void onPluginsFetched();

signals:
    void isFetched();

private:
    void addFetchedPlugins();
    void savePluginsToFile();
    void initFilePath();
    void appendLocalFile();

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

private slots:

    void onDownloadCompleted(QString path);
    //void onDownloadProgress(quint64 progress, quint64 total, QString name, QString error);
    //void onAborted();

signals:

    void downloadCompleted(QString path);

private:
    struct Progress
    {
        uint timeInterval = 0;
        quint64 bytesDownload = 0;
        quint64 bytesTotal = 0;
        QTime timeRecord;
        QString speed;
        QString time;
    };

    DappsNetworkManagerPtr m_pDapNetworkManager;
    Progress m_progress;
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

private slots:
    void onPluginManagerInit();
    void onDownloadCompleted(QString pluginFullPathToZip);

signals:
    void pluginsUpdated(QList<QVariant> pluginsList);

private:
    void initPlatformPaths();

    QString m_pluginsDownloadFolder;//to remove
    const QString m_repoPlugins = "https://dapps.cellframe.net/dashboard/";
    QString m_filePrefix;

    DapModulesController * m_modulesCtrl;

    using PluginManagerPtr = QSharedPointer<PluginManager>;
    PluginManagerPtr m_pPluginManager;

    using DownloadManagerPtr = QSharedPointer<DownloadManager>;
    DownloadManagerPtr m_pDownloadManager;
};



} // DApps

#endif // DAPMODULEDAPPS_REWORK_H
