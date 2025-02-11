#ifndef DAPMODULEDAPPS_H
#define DAPMODULEDAPPS_H

#include <QObject>
#include <QDebug>

#include "DapServiceController.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "DapDappsNetworkManager.h"

#include <QCryptographicHash>
#include <dap_hash.h>
#include "zip/unpackzip.h"

class DapModuledApps : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuledApps(DapModulesController *parent = nullptr);
    ~DapModuledApps();

private:
    void init();

    //file manage work
    void readPluginsFile(QString *path);
    void updateFileConfig();
    void sortList(){std::sort(m_pluginsList.begin(), m_pluginsList.end());};
    bool zipManage(QString &path);
    bool checkDuplicates(QString name, QString verifed);
    bool checkHttps(QString path);

    QString pkeyHash(QString &path);

    QString transformUnit(double bytes, bool isSpeed);
    QString transformTime(quint64 seconds);

public slots:

    void getListPlugins(){sortList(); emit rcvListPlugins(m_pluginsList);};
    void updatePluginsRepository(){m_dapNetworkManager->getFiles();};
    void addPlugin(QVariant, QVariant, QVariant);
    void installPlugin(QString, QString, QString);
    void deletePlugin(QVariant);
    void cancelDownload(){m_dapNetworkManager->cancelDownload(1,0);};
    void reloadDownload(){m_dapNetworkManager->cancelDownload(1,1);};

signals:

    void rcvListPlugins(QList <QVariant> m_pluginsList);
    void rcvProgressDownload(QString progress, int completed, QString download, QString total, QString time, QString speed, QString name, QString error);
    void rcvAbort();

private slots:

    void onFilesReceived();
    void onDownloadCompleted(QString path){addPlugin(path,1,1);};
    void onDownloadProgress(quint64 progress, quint64 total, QString name, QString error);
    void onAborted(){emit rcvAbort();};

private:
    QString m_pathPluginsConfigFile;
    QString m_pathPlugins;
    QList <QVariant> m_pluginsList;
    QStringList m_buffPluginsByUrl;

    QString m_filePrefix;

    QString m_repoPlugins;

    uint m_timeInterval;
    quint64 m_bytesDownload;
    quint64 m_bytesTotal;
    QTime m_timeRecord;
    QString m_speed, m_time;

    DapDappsNetworkManager * m_dapNetworkManager = nullptr;
};

#endif // DAPMODULEDAPPS_H
