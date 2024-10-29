#ifndef CONFIGWORKER_H
#define CONFIGWORKER_H

#include <QObject>
#include <QMap>

#include "configfile.h"

class ConfigWorker : public QObject
{
    Q_OBJECT

public:
    explicit ConfigWorker(QObject *parent = nullptr);

    ~ConfigWorker();

    static QString getConfigPath();

    Q_INVOKABLE QStringList getNetworkList();

    Q_INVOKABLE QString readConfigValue(
            const QString &network, const QString &group, const QString &key) const;

    Q_INVOKABLE void writeConfigValue(
            const QString &network, const QString &group,
            const QString &key, const QString &value);

    Q_INVOKABLE QString readNodeValue(const QString &group,
                                      const QString &key) const;

    Q_INVOKABLE void writeNodeValue(const QString &group,
                                    const QString &key, const QString &value);

    Q_INVOKABLE void writeNodePyhonPath();

    Q_INVOKABLE bool getNetworkStatus(const QString &network);

    Q_INVOKABLE void setNetworkStatus(const QString &network, bool status);

    Q_INVOKABLE bool checkUpdate(bool node, const QString &network);

    Q_INVOKABLE bool updateFile(bool node, const QString &network);

    Q_INVOKABLE void saveAllChanges();

    Q_INVOKABLE void resetAllChanges();

private:
    void initNetworkPaths();

    void initConfigFiles();

    QMap<QString, QString> netPaths;

    QMap<QString, ConfigFile*> configFiles;

    ConfigFile* nodeConfig;
};

#endif // CONFIGWORKER_H
