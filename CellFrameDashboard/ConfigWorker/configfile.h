#ifndef CONFIGFILE_H
#define CONFIGFILE_H

#include <QVector>

class ConfigFile
{
public:
    ConfigFile(const QString &file_name);

    QString readConfigValue(const QString &key) const;

    void writeConfigValue(const QString &key, const QString &value);

    QString readGroupValue(const QString &group,
                           const QString &key) const;

    void writeGroupValue(const QString &group,
                         const QString &key, const QString &value);

    void saveFile();

    void resetChanges();

    bool checkUpdate();

    bool updateFile();

    bool getNetworkStatus();

    void setNetworkStatus(bool status);

private:
    QVector <QByteArray> lines;

    QString fileName;
};

#endif // CONFIGFILE_H
