#include "configworker.h"

#include <QDir>
#include <QFile>

#include <QDebug>

#include <dapconfigreader.h>

#include "DapDashboardPathDefines.h"

#if defined (Q_OS_MACOS)
#include "dap_common.h"
#endif

#ifdef Q_OS_WIN
#include "registry.h"
#endif

ConfigWorker::ConfigWorker(QObject *parent) :
    QObject(parent)
{
//    qDebug() << "ConfigWorker::ConfigWorker";

    initNetworkPaths();

    initConfigFiles();

    QString config_path = QDir::toNativeSeparators(getConfigPath() + "/cellframe-node.cfg");

    nodeConfig = new ConfigFile(config_path);

//    qDebug() << "readNodeGroupValue"
//             << "server, listen_address"
//             << readNodeGroupValue("server", "listen_address");

//    writeNodeGroupValue("server", "listen_address", "1.1.1.1");

//    nodeConfig->saveFile();

//    getNetworkList();

    qDebug() << "ConfigWorker::getNetworkList" << getNetworkList();
}

ConfigWorker::~ConfigWorker()
{
    for (auto value : configFiles.values())
        delete value;

    delete nodeConfig;
}

QString ConfigWorker::getConfigPath()
{
    return Dap::DashboardDefines::CellframeNode::CONFIGWORKER_PATH;
}

QStringList ConfigWorker::getNetworkList()
{
/*    QStringList list;

    for (auto config : configFiles.values())
    {
        QString name = config->readConfigValue("name");

        if (!name.isEmpty())
            list.append(name);
    }

    qDebug() << "ConfigWorker::getNetworkList" << list;*/

    return configFiles.keys();
}

QString ConfigWorker::readConfigValue(
        const QString &network, const QString &group, const QString &key) const
{
    qDebug() << "ConfigWorker::readConfigValue" << network;

    if (!configFiles.contains(network))
        return QString();

    QString value = configFiles[network]->readGroupValue(group, key);

    qDebug() << "ConfigWorker::readConfigValue" << network << key << value;

    return value;
}

void ConfigWorker::writeConfigValue(
        const QString &network, const QString &group,
        const QString &key, const QString &value)
{
    if (!configFiles.contains(network))
        return;

    configFiles[network]->writeGroupValue(group, key, value);
}

QString ConfigWorker::readNodeValue(
        const QString &group, const QString &key) const
{
    return nodeConfig->readGroupValue(group, key);
}

void ConfigWorker::writeNodeValue(
        const QString &group, const QString &key, const QString &value)
{
    nodeConfig->writeGroupValue(group, key, value);
}

void ConfigWorker::writeNodePyhonPath()
{
    QString py_path = getConfigPath().remove("/etc") + "/var/lib/plugins";
    py_path = QDir::toNativeSeparators(py_path);

    nodeConfig->writeGroupValue("plugins", "py_path", py_path);
}

bool ConfigWorker::getNetworkStatus(const QString &network)
{
    if (!configFiles.contains(network))
        return false;

    qDebug() << "ConfigWorker::getNetworkStatus"
             << network
             << configFiles[network]->getNetworkStatus();

    return configFiles[network]->getNetworkStatus();
}

void ConfigWorker::setNetworkStatus(const QString &network, bool status)
{
    if (!configFiles.contains(network))
        return;

    configFiles[network]->setNetworkStatus(status);
}

bool ConfigWorker::checkUpdate(bool node, const QString &network)
{
    if (node)
        return nodeConfig->checkUpdate();
    else
    {
        if (!configFiles.contains(network))
            return false;

        return configFiles[network]->checkUpdate();
    }
}

bool ConfigWorker::updateFile(bool node, const QString &network)
{
    if (node)
        return nodeConfig->updateFile();
    else
    {
        if (!configFiles.contains(network))
            return false;

        return configFiles[network]->updateFile();
    }
}

void ConfigWorker::saveAllChanges()
{
    for (auto config : configFiles.values())
    {
        config->saveFile();
    }

    nodeConfig->saveFile();
}

void ConfigWorker::resetAllChanges()
{
    for (auto config : configFiles.values())
    {
        config->resetChanges();
    }

    nodeConfig->resetChanges();
}

void ConfigWorker::initNetworkPaths()
{
    QString config_path = getConfigPath() + "/network/";
    config_path = QDir::toNativeSeparators(config_path);

//    qDebug() << "config_path" << config_path;

    QDir dir(config_path);
    QStringList cfglist = dir.entryList(QStringList("*.cfg"));

    netPaths.clear();

    for (auto file_name : cfglist)
    {
        netPaths.insert(file_name.chopped(4), config_path + file_name);
    }

//    qDebug() << netPaths;
}

void ConfigWorker::initConfigFiles()
{
    QMapIterator<QString, QString> iter(netPaths);

    while (iter.hasNext())
    {
        iter.next();

//        qDebug() << iter.key() << ":" << iter.value();

        configFiles.insert(iter.key(), new ConfigFile(iter.value()));
    }

//    qDebug() << "readConfigValue" << "seed_nodes_addrs" <<
//        configFiles["subzero"]->readConfigValue("seed_nodes_addrs");

//    configFiles["mileena"]->writeConfigValue("node-role", "full");

//    readConfigValue("subzero", "seed_nodes_addrs");

//    writeConfigValue("mileena", "node-role", "master");

//    saveAllChanges();
//    configFiles["mileena"]->saveFile();
}
