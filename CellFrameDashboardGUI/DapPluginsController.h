#ifndef DAPPLUGINSCONTROLLER_H
#define DAPPLUGINSCONTROLLER_H

#include <QObject>
#include <QSettings>
#include <QFile>
#include <QDebug>

#include <QtGui/private/qzipreader_p.h>
#include <QtGui/private/qzipwriter_p.h>
#include <QCryptographicHash>
#include <dap_hash.h>

#include "JlCompress.h"

class DapPluginsController : public QObject
{
    Q_OBJECT
public:
    explicit DapPluginsController(QString pathPluginsConfigFile, QString pathPlugins, QObject *parent = nullptr);

private:

    void readPluginsFile(QString *path);
    void updateFileConfig();
    void sortList();
    bool zipManage(QString &path);

    QByteArray fileChecksum(const QString &fileName, QCryptographicHash::Algorithm hashAlgorithm);
    QString pkeyHash(QString &path);

public slots:

    void getListPlugins(){sortList(); emit rcvListPlugins(m_pluginsList);};
    void addPlugin(QVariant, QVariant);
    void setStatusPlugin(int, QString);
    void deletePlugin(int);

signals:

    void rcvListPlugins(QList <QVariant> m_pluginsList);

private:

    QString m_pathPluginsConfigFile;
    QString m_pathPlugins;
    QList <QVariant> m_pluginsList;

};

#endif // DAPPLUGINSCONTROLLER_H
