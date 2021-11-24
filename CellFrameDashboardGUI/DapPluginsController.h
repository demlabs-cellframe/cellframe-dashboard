#ifndef DAPPLUGINSCONTROLLER_H
#define DAPPLUGINSCONTROLLER_H

#include <QObject>
#include <QSettings>
#include <QFile>
#include <QDebug>

class DapPluginsController : public QObject
{
    Q_OBJECT
public:
    explicit DapPluginsController(QString pathPluginsConfigFile, QObject *parent = nullptr);

private:

    void readPluginsFile(QString *path);
    void updateFileConfig();
    void sortList();

public slots:

    void getListPlugins(){sortList(); emit rcvListPlugins(m_pluginsList);};
    void addPlugin(QVariant, QVariant, QVariant);
    void setStatusPlugin(int, QString);
    void deletePlugin(int);

signals:

    void rcvListPlugins(QList <QVariant> m_pluginsList);

private:

    QString m_pathPluginsConfigFile;
    QList <QVariant> m_pluginsList;

};

#endif // DAPPLUGINSCONTROLLER_H
