#include "DapModuledApps.h"
#include <sys/stat.h>
#include "DapDashboardPathDefines.h"
using namespace Dap;

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

QString transformUnit(double bytes, bool isSpeed = false)
{
    const double UNIT_KB = 1024.0;
    const double UNIT_MB = UNIT_KB*UNIT_KB;
    const double UNIT_GB = UNIT_MB*UNIT_KB;

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
    //QString hash = pkeyHash(path);

    return DapZip::fileDecompression(path,pluginsFolderPath);
}

PluginManager::PluginManager(DappsNetworkManagerPtr pDapDappsNetworkManager, QObject *parent)
    : m_pDapNetworkManager(pDapDappsNetworkManager)
{
    initFilePath();
    m_pluginsByName = readPluginsFile(m_pathPluginsListFile);
    connect(m_pDapNetworkManager.data(), SIGNAL(sigPluginsListFetched()), this, SLOT(onPluginsFetched()));
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
    m_pathPluginsListFile = DashboardDefines::DApps::PLUGINS_CONFIG;

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
    connect(m_pDapNetworkManager.data(), SIGNAL(sigAborted()), this, SLOT(onAborted()));
}

DownloadManager::~DownloadManager()
{

}

void DownloadManager::startDownload(const QString& pluginName)
{
    m_pDapNetworkManager->downloadFile(pluginName);
    m_progress.timeRecord.start();
}

void DownloadManager::cancelDownload()
{
    m_pDapNetworkManager->cancelDownload(true, false);
}

void DownloadManager::reloadDownload()
{
    m_pDapNetworkManager->cancelDownload(true, true);
}

void DownloadManager::onDownloadCompleted(QString path)
{
    emit downloadCompleted(path);
}

void DownloadManager::onDownloadProgress(quint64 currDownloadedBytes, quint64 totalBytes, QString nameZip, QString statusMsg)
{
    bool isCompleted = false;
    double percent;
    QString percentStr, downloadedStr, totalStr;
    if (totalBytes != 0 && totalBytes != currDownloadedBytes)
    {
        quint64 timeNow = m_progress.timeRecord.elapsed();
        m_progress.totalBytes = totalBytes;

        percent = (currDownloadedBytes * 100.0)/(double)totalBytes;
        percentStr = QString::number(percent,'f',2);

        isCompleted = currDownloadedBytes == totalBytes;

        if (timeNow - m_progress.lastTimeInterval > m_minTimeInterval)
        {
            if(m_progress.prevDownloaded > currDownloadedBytes)
                m_progress.prevDownloaded = 0;

            quint64 deltaDownload = currDownloadedBytes - m_progress.prevDownloaded;
            double speed = deltaDownload * 1000 / (timeNow - m_progress.lastTimeInterval);
            m_progress.speedStr = transformUnit(speed, true);

            qint64 timeRemain = (totalBytes - currDownloadedBytes) / speed;
            m_progress.timeRemainStr = transformTime(timeRemain);

            m_progress.lastTimeInterval = timeNow;
            m_progress.prevDownloaded = currDownloadedBytes;
        }

        downloadedStr = transformUnit((double)currDownloadedBytes);
        totalStr = transformUnit((double)totalBytes);
    }
    else
    {
        if(statusMsg == "Error. Reconnecting")
        {
            isCompleted = false;
            m_progress.timeRemainStr = "Infinity";
            m_progress.speedStr = "0.00 B/S" ;
        }
        else
            isCompleted = true;

        percent = (m_progress.prevDownloaded * 100.0)/(double)m_progress.totalBytes;
        percentStr = QString::number(percent,'f',2);

        downloadedStr = transformUnit((double)m_progress.prevDownloaded, false);
        totalStr = transformUnit((double)m_progress.totalBytes, false);


    }

    emit downloadProgress(isCompleted, statusMsg, percentStr, nameZip, downloadedStr, totalStr, m_progress.timeRemainStr, m_progress.speedStr);
}

void DownloadManager::onAborted()
{
    emit isAborted();
}

DapModuledApps::DapModuledApps(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
{
    setStatusInit(true);
    initPlatformPaths();

    m_pDapNetworkManager = QSharedPointer<DapDappsNetworkManager>::create(m_repoPlugins, m_dappsDownloadFolder);
    m_pPluginManager = PluginManagerPtr::create(m_pDapNetworkManager);
    m_pDownloadManager = DownloadManagerPtr::create(m_pDapNetworkManager);

    connect(m_pPluginManager.data(), SIGNAL(isFetched()), this, SLOT(onPluginManagerInit()));
    connect(m_pDownloadManager.data(), SIGNAL(downloadCompleted(QString)), this, SLOT(onDownloadCompleted(QString)));
    connect(m_pDownloadManager.data(), SIGNAL(downloadProgress(bool, QString, QString, QString, QString, QString, QString, QString)), this, SLOT(onDownloadProgress(bool, QString, QString, QString, QString, QString, QString, QString)));
    connect(m_pDownloadManager.data(), SIGNAL(isAborted()), this, SLOT(onAborted()));

    connect(m_modulesCtrl, &DapModulesController::initDone, this, [this] ()
    {
        m_pDapNetworkManager->fetchPluginsList();
    });
}

DapModuledApps::~DapModuledApps()
{

}

void DapModuledApps::updateListdApps()
{
    m_pDapNetworkManager->fetchPluginsList();
}

void DapModuledApps::onDownloadCompleted(QString pluginFullPathToZip)
{
    if (zipManage(pluginFullPathToZip, m_dappsFolder))
    {
        QString nameWithZip = pluginFullPathToZip.split("/").last();
        QString nameWithoutZip = nameWithZip.split(".zip").first();
        QString pathMainFileQml = QString(m_filePrefix + m_dappsFolder + "/" + nameWithoutZip + "/" + nameWithoutZip +".qml") ;
        m_pPluginManager->changePath(nameWithZip, pathMainFileQml);
        m_pPluginManager->changeActivation(nameWithZip, true);
        m_pPluginManager->changeName(nameWithZip, nameWithoutZip);
        emit pluginsUpdated(m_pPluginManager->getPluginsList());
    }
}

void DapModuledApps::onDownloadProgress(bool isCompleted, QString error, QString progressPercent, QString fileName, QString downloaded, QString total, QString timeRemain, QString speed)
{
    emit rcvProgressDownload(isCompleted, error, progressPercent, fileName, downloaded, total, timeRemain, speed);
}

void DapModuledApps::onAborted()
{
    emit rcvAbort();
}

void DapModuledApps::addLocalPlugin(QVariant path)
{
    QString fullPathToZipFile = path.toString();
    fullPathToZipFile.remove(m_filePrefix);
    QStringList splitPath = path.toString().split("/");
    QString nameWithoutZip = splitPath.last().remove(".zip");

    if (!m_pPluginManager->pluginByName(nameWithoutZip).has_value())
    {
        if (zipManage(fullPathToZipFile, m_dappsFolder))
        {
            QString pathMainFileQml = QString(m_filePrefix + m_dappsFolder + "/" + nameWithoutZip + "/" + nameWithoutZip +".qml") ;
            m_pPluginManager->addLocalPlugin(nameWithoutZip, pathMainFileQml);

            emit pluginsUpdated(m_pPluginManager->getPluginsList());
        }
    }
}

void DapModuledApps::activatePlugin(QString pluginName)
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

void DapModuledApps::deactivatePlugin(QString pluginName)
{
    m_pPluginManager->changeActivation(pluginName, false);
    emit pluginsUpdated(m_pPluginManager->getPluginsList());
}

void DapModuledApps::deletePlugin(QString pluginName)
{
    auto plOpt = m_pPluginManager->pluginByName(pluginName);
    if (plOpt.has_value())
    {
        auto zipFilePath = QString(m_dappsDownloadFolder + pluginName + ".zip");
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

void DapModuledApps::cancelDownload()
{
    m_pDownloadManager->cancelDownload();
}

void DapModuledApps::reloadDownload()
{
    m_pDownloadManager->reloadDownload();
}

void DapModuledApps::initPlatformPaths()
{
#if !defined(Q_OS_WIN)
    m_filePrefix = "file://";
#else
    m_filePrefix = "file:///";
#endif

    m_dappsFolder = DashboardDefines::DApps::PLUGINS_PATH;
    m_dappsDownloadFolder = DashboardDefines::DApps::PLUGINS_DOWNLOAD_PATH;
}

void DapModuledApps::onPluginManagerInit()
{
    emit pluginsUpdated(m_pPluginManager->getPluginsList());
}

} // DApps
