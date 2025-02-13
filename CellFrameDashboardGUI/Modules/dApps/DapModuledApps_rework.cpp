#include "DapModuledApps_rework.h"

#define UNIT_KB 1024            //KB
#define UNIT_MB 1024*1024       //MB
#define UNIT_GB 1024*1024*1024  //GB

namespace DApps {

QString pkeyHash(QString &path)
{
    QFile file(path);
    QByteArray fileData;

    if (file.open(QFile::ReadOnly)) {

        fileData = file.readAll();
        file.close();
    }

    dap_chain_hash_fast_t l_hash_cert_pkey;
    //dap_hash_fast(fileData.constData(), fileData.size(), &l_hash_cert_pkey);
    char *l_cert_pkey_hash_str = dap_chain_hash_fast_to_str_new(&l_hash_cert_pkey);
    QString ret = QString::fromLatin1(l_cert_pkey_hash_str);
    DAP_DEL_Z(l_cert_pkey_hash_str)
    return ret;
}

bool checkHttps(QString path)
{
    QStringList findWord = {"https://"};
    QString findReg = '(' + findWord.join('|') + ')';
    QRegularExpression re(findReg);
    QString endStr = re.match(path).capturedTexts().join(' ');

    return !endStr.isEmpty();
}

QString transformUnit(double bytes, bool isSpeed)
{
    QString strUnit = " B";

    if (bytes <= 0)
    {
        bytes = 0;
    }
    else if (bytes < UNIT_KB)
    {
    }
    else if (bytes < UNIT_MB)
    {
        bytes /= UNIT_KB;
        strUnit = " KB";
    }
    else if (bytes < UNIT_GB)
    {
        bytes /= UNIT_MB;
        strUnit = " MB";
    }
    else if (bytes > UNIT_GB)
    {
        bytes /= UNIT_GB;
        strUnit = " GB";
    }

    if (isSpeed)
    {
        strUnit += "/S";
    }
    return QString("%1%2").arg(QString::number(bytes, 'f',2)).arg(strUnit);
}

QString transformTime(quint64 seconds)
{
    QString strValue;
    QString strSpacing(" ");
    if (seconds <= 0)
    {
        strValue = QString("%1s").arg(0);
    }
    else if (seconds < 60)
    {
        strValue = QString("%1s").arg(seconds);
    }
    else if (seconds < 60 * 60)
    {
        int nMinute = seconds / 60;
        int nSecond = seconds - nMinute * 60;

        strValue = QString("%1m").arg(nMinute);

        if (nSecond > 0)
            strValue += strSpacing + QString("%1s").arg(nSecond);
    }
    else if (seconds < 60 * 60 * 24)
    {
        int nHour = seconds / (60 * 60);
        int nMinute = (seconds - nHour * 60 * 60) / 60;
        int nSecond = seconds - nHour * 60 * 60 - nMinute * 60;

        strValue = QString("%1h").arg(nHour);

        if (nMinute > 0)
            strValue += strSpacing + QString("%1m").arg(nMinute);

        if (nSecond > 0)
            strValue += strSpacing + QString("%1s").arg(nSecond);
    }
    else
    {
        int nDay = seconds / (60 * 60 * 24);
        int nHour = (seconds - nDay * 60 * 60 * 24) / (60 * 60);
        int nMinute = (seconds - nDay * 60 * 60 * 24 - nHour * 60 * 60) / 60;
        int nSecond = seconds - nDay * 60 * 60 * 24 - nHour * 60 * 60 - nMinute * 60;

        strValue = QString("%1d").arg(nDay);

        if (nHour > 0)
            strValue += strSpacing + QString("%1h").arg(nHour);

        if (nMinute > 0)
            strValue += strSpacing + QString("%1m").arg(nMinute);

        if (nSecond > 0)
            strValue += strSpacing + QString("%1s").arg(nSecond);
    }

    return strValue;
}

PluginManager::PluginsList readPluginsFile(QString path)
{
    QFile file(path);
    QString readFile;
    PluginManager::PluginsList result;

    if(file.open(QIODevice::ReadOnly))
    {
        while(!file.atEnd())
        {
            QString plName;
            PluginManager::PluginInfo plInfo;

            for(int i = 0; i < 4 ; i++ )
            {
                readFile = file.readLine();

                if (readFile.size() == 0)
                {
                    qWarning() << "[dApps] config file is not correct";
                    break;
                }

                if(i == 0)
                {
                    readFile = readFile.split('[')[1];
                    readFile = readFile.split(']')[0];

                    plName = readFile.trimmed();
                }
                else if(i == 1)
                {
                    readFile = readFile.split("path")[1];
                    readFile = readFile.split('=')[1];

                    plInfo.pluginPath = readFile.trimmed();
                }
                else if(i == 2)
                {
                    readFile = readFile.split("status")[1];
                    readFile = readFile.split('=')[1];

                    plInfo.isActivated = QVariant(readFile.trimmed()).toBool();
                }
                else if(i == 3)
                {
                    readFile = readFile.split("verifed")[1];
                    readFile = readFile.split('=')[1];

                    plInfo.isVerified = QVariant(readFile.trimmed()).toBool();
                }
            }
            result.insert(plName, plInfo);
        }
        file.close();
    }
    return result;
}

bool zipManage(QString &path, QString pluginsFolderPath)
{
    //TODO: Make a request to the node to confirm the hash
    QString hash = pkeyHash(path);

    //    bool result = DapZip::fileDecompression(path,m_pathPlugins);

    return DapZip::fileDecompression(path,pluginsFolderPath);
}

PluginManager::PluginManager(DappsNetworkManagerPtr pDapDappsNetworkManager, QObject *parent)
    : m_pDapNetworkManager(pDapDappsNetworkManager)
{
    initFilePath();
    m_pluginsByName = readPluginsFile(m_pathPluginsListFile);
    connect(m_pDapNetworkManager.data(), SIGNAL(sigPluginsListFetched()), this, SLOT(onPluginsFetched()));
    m_pDapNetworkManager->fetchPluginsList();
}

PluginManager::~PluginManager()
{

}

void PluginManager::onPluginsFetched()
{
    addFetchedPlugins();
    savePluginsToFile();
    emit isFetched();
}

void PluginManager::addFetchedPlugins()
{
    if (m_pDapNetworkManager->m_bufferFiles.empty())
        qWarning()<<"No dApps in repository";

    for(auto repoPlugin : m_pDapNetworkManager->m_bufferFiles)
    {
        QString nameWithoutZip = repoPlugin.split(".zip").first();
        const bool isAlreadyInstalled = m_pluginsByName.contains(nameWithoutZip) &&
                                  m_pluginsByName.value(nameWithoutZip).isActivated &&
                                  m_pluginsByName.value(nameWithoutZip).isVerified;
        if (isAlreadyInstalled)
            continue;

        bool isVerified = true;
        m_pluginsByName[repoPlugin] = PluginInfo{m_pDapNetworkManager->repoAddress(), false, isVerified};
    }
    m_pDapNetworkManager->m_bufferFiles.clear();
}

void PluginManager::savePluginsToFile()
{
    initFilePath();
    QFile file(m_pathPluginsListFile);

    if(file.open(QIODevice::WriteOnly))
    {
        QTextStream out(&file);
        for (auto it = m_pluginsByName.keyValueBegin(); it != m_pluginsByName.keyValueEnd(); ++it)
        {
            const auto& pluginName = it->first;
            const auto& pluginInfo = it->second;
            if(!checkHttps(pluginInfo.pluginPath))
            {
                out << "[" << pluginName << "]" << "\n";
                out << "path = " << pluginInfo.pluginPath << "\n";
                out << "status = " <<  QVariant(pluginInfo.isActivated).toString() << "\n";
                out << "verifed = " << QVariant(pluginInfo.isVerified).toString() << "\n";
            }
        }
        file.close();
    }
    else
        qWarning() << "dApps Config not open. " << file.errorString();
}

void PluginManager::initFilePath()
{
#ifdef Q_OS_LINUX
    m_pathPluginsListFile = QString("/opt/%1/dapps/config_dApps.ini").arg(DAP_BRAND_LO);
#elif defined Q_OS_MACOS
    mkdir("/tmp/Cellframe-Dashboard_dapps",0777);
    m_pathPluginsListFile = QString("/tmp/Cellframe-Dashboard_dapps/config_dApps.ini");
#elif defined Q_OS_WIN
    m_pathPluginsListFile = QString("%1/%2/dapps/config_dApps.ini").arg(regGetUsrPath()).arg(DAP_BRAND);
#endif
    QFile filePlugin(m_pathPluginsListFile);
    if(!filePlugin.exists())
    {
        if(filePlugin.open(QIODevice::WriteOnly))
            filePlugin.close();
    }
}

QList<QVariant> PluginManager::getPluginsList() const
{
    QList<QVariant> result;
    for (auto it = m_pluginsByName.keyValueBegin(); it != m_pluginsByName.keyValueEnd(); ++it)
    {
        const auto& pluginName = it->first;
        const auto& pluginInfo = it->second;

        QStringList item;
        item.append(pluginName);
        item.append(pluginInfo.pluginPath);
        item.append(QVariant(static_cast<int>(pluginInfo.isActivated)).toString());
        item.append(QVariant(static_cast<int>(pluginInfo.isVerified)).toString());

        result.append(item);
    }
    return result;
}

std::optional<PluginManager::PluginInfo> PluginManager::pluginByName(const QString& name) const
{
    if (m_pluginsByName.contains(name))
        return m_pluginsByName.value(name);

    return std::nullopt;
}

void PluginManager::addLocalPlugin(QString name, QString localPath)
{
    m_pluginsByName[name] = PluginInfo{localPath, false, false};
    savePluginsToFile();
}

void PluginManager::changePath(QString name, QString newPath)
{
    if (m_pluginsByName.contains(name))
    {
        m_pluginsByName[name].pluginPath = newPath;
        savePluginsToFile();
    }
}

void PluginManager::changeActivation(QString name, bool isActivated)
{
    if (m_pluginsByName.contains(name))
    {
        m_pluginsByName[name].isActivated = isActivated;
        savePluginsToFile();
    }
}

void PluginManager::changeName(QString oldName, QString newName)
{
    if (m_pluginsByName.contains(oldName))
    {
        auto plInfo = m_pluginsByName[oldName];
        m_pluginsByName.remove(oldName);
        m_pluginsByName.insert(newName, plInfo);
        savePluginsToFile();
    }
}

void PluginManager::removePlugin(QString name)
{
    if (m_pluginsByName.contains(name))
    {
        m_pluginsByName.remove(name);
        savePluginsToFile();
        m_pDapNetworkManager->fetchPluginsList();
    }
}

DownloadManager::DownloadManager(DappsNetworkManagerPtr pDapDappsNetworkManager, QObject *parent)
    : m_pDapNetworkManager(pDapDappsNetworkManager)
{
    connect(m_pDapNetworkManager.data(), SIGNAL(sigDownloadCompleted(QString)), this, SLOT(onDownloadCompleted(QString)));
    connect(m_pDapNetworkManager.data(), SIGNAL(sigDownloadProgress(quint64,quint64,QString,QString)), this, SLOT(onDownloadProgress(quint64,quint64,QString,QString)));
    //connect(m_pDapNetworkManager.data(), SIGNAL(sigAborted()), this, SLOT(onAborted()));
}

DownloadManager::~DownloadManager()
{

}

void DownloadManager::startDownload(const QString& pluginName)
{
    m_pDapNetworkManager->downloadFile(pluginName);
    m_progress.timeRecord.start();
    m_progress.timeInterval = 0;
    m_progress.bytesDownload = 0;
    m_progress.time = "";
    m_progress.speed = "";
}

void DownloadManager::onDownloadCompleted(QString path)
{
    emit downloadCompleted(path);
}

void DownloadManager::onDownloadProgress(quint64 progress, quint64 total, QString name, QString error)
{
    emit downloadProgress(progress, total, name, error);
}

DapModuledAppsRework::DapModuledAppsRework(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
{
    setStatusInit(true);
    initPlatformPaths();

    auto pDapNetworkManager = QSharedPointer<DapDappsNetworkManager>::create(m_repoPlugins, m_pluginsDownloadFolder);
    m_pPluginManager = PluginManagerPtr::create(pDapNetworkManager);
    m_pDownloadManager = DownloadManagerPtr::create(pDapNetworkManager);

    connect(m_pPluginManager.data(), SIGNAL(isFetched()), this, SLOT(onPluginManagerInit()));
    connect(m_pDownloadManager.data(), SIGNAL(downloadCompleted(QString)), this, SLOT(onDownloadCompleted(QString)));
    connect(m_pDownloadManager.data(), SIGNAL(downloadProgress(quint64,quint64,QString,QString)), this, SLOT(onDownloadProgress(quint64,quint64,QString,QString)));
}

DapModuledAppsRework::~DapModuledAppsRework()
{

}

void DapModuledAppsRework::onDownloadCompleted(QString pluginFullPathToZip)
{
    if (zipManage(pluginFullPathToZip, m_pluginsDownloadFolder))
    {
        QString nameWithZip = pluginFullPathToZip.split("/").last();
        QString nameWithoutZip = nameWithZip.split(".zip").first();
        QString pathMainFileQml = QString(m_filePrefix + m_pluginsDownloadFolder + "/" + nameWithoutZip + "/" + nameWithoutZip +".qml") ;
        m_pPluginManager->changePath(nameWithZip, pathMainFileQml);
        m_pPluginManager->changeActivation(nameWithZip, true);
        m_pPluginManager->changeName(nameWithZip, nameWithoutZip);
        emit pluginsUpdated(m_pPluginManager->getPluginsList());
    }
}

void DapModuledAppsRework::onDownloadProgress(quint64 progress, quint64 total, QString name, QString error)
{
    //rcvProgressDownload(completed, error, progress, name, download, total, time, speed)
    emit rcvProgressDownload(false, "no error", 50, "name", 500, 1000, 10, 2);
}

void DapModuledAppsRework::addLocalPlugin(QVariant path)
{
    QString fullPathToZipFile = path.toString();
    fullPathToZipFile.remove(m_filePrefix);
    QStringList splitPath = path.toString().split("/");
    QString nameWithoutZip = splitPath.last().remove(".zip");

    if (!m_pPluginManager->pluginByName(nameWithoutZip).has_value())
    {
        if (zipManage(fullPathToZipFile, m_pluginsDownloadFolder))
        {
            QString pathMainFileQml = QString(m_filePrefix + m_pluginsDownloadFolder + "/" + nameWithoutZip + "/" + nameWithoutZip +".qml") ;
            m_pPluginManager->addLocalPlugin(nameWithoutZip, pathMainFileQml);

            emit pluginsUpdated(m_pPluginManager->getPluginsList());
        }
    }
}

void DapModuledAppsRework::activatePlugin(QString pluginName)
{
    auto pluginOpt = m_pPluginManager->pluginByName(pluginName);
    if (pluginOpt.has_value())
    {
        if (checkHttps(pluginOpt->pluginPath))
            m_pDownloadManager->startDownload(pluginName);
        else
        {
            m_pPluginManager->changeActivation(pluginName, true);
            emit pluginsUpdated(m_pPluginManager->getPluginsList());
        }
    }
    else
    {
        qWarning()<< "Extension search error";
    }
}

void DapModuledAppsRework::deactivatePlugin(QString pluginName)
{
    m_pPluginManager->changeActivation(pluginName, false);
    emit pluginsUpdated(m_pPluginManager->getPluginsList());
}

void DapModuledAppsRework::deletePlugin(QString pluginName)
{
    auto plOpt = m_pPluginManager->pluginByName(pluginName);
    if (plOpt.has_value())
    {
        auto zipFilePath = QString(m_pluginsDownloadFolder + "/download/" + pluginName + ".zip");
        auto pluginFolderPath = plOpt->pluginPath.remove(QString("/" + pluginName + ".qml"));
        pluginFolderPath.remove(m_filePrefix);

        QFile file(zipFilePath);
        if(file.exists())
            file.remove();

        QDir dir(pluginFolderPath);
        dir.removeRecursively();

        m_pPluginManager->removePlugin(pluginName);
    }
}

void DapModuledAppsRework::initPlatformPaths()
{
#if !defined(Q_OS_WIN)
    m_filePrefix = "file://";
#else
    m_filePrefix = "file:///";
#endif

#ifdef Q_OS_LINUX
    m_pluginsDownloadFolder = QString("/opt/%1/dapps").arg(DAP_BRAND_LO);
#elif defined Q_OS_MACOS
    mkdir("/tmp/Cellframe-Dashboard_dapps",0777);
    m_pluginsDownloadFolder = QString("/tmp/Cellframe-Dashboard_dapps");
#elif defined Q_OS_WIN
    m_pluginsDownloadFolder = QString("%1/%2/dapps").arg(regGetUsrPath()).arg(DAP_BRAND);
#endif
}

void DapModuledAppsRework::onPluginManagerInit()
{
    emit pluginsUpdated(m_pPluginManager->getPluginsList());
}

} // DApps
