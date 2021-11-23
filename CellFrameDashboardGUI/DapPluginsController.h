#ifndef DAPPLUGINSCONTROLLER_H
#define DAPPLUGINSCONTROLLER_H

#include <QObject>

class DapPluginsController : public QObject
{
    Q_OBJECT
public:
    explicit DapPluginsController(QString pathPluginsConfigFile, QObject *parent = nullptr);

private:

    void readPluginsFile(QString *path);

public slots:

//    void getListPlugins();

signals:

//    void rcvListPlugins(QStringList rcvList);

private:

    QString m_pathPluginsConfigFile;
    QStringList m_pluginsList;

};

#endif // DAPPLUGINSCONTROLLER_H
