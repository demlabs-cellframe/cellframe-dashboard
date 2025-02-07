#include "DapModuledApps_rework.h"

#define UNIT_KB 1024            //KB
#define UNIT_MB 1024*1024       //MB
#define UNIT_GB 1024*1024*1024  //GB

//namespace DApps {

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

QMap<QString, DapModuledAppsRework::PluginInfo> readPluginsFile(QString path) // needs to be reworked
{
    QFile file(path);
    QString readFile;
    QMap<QString, DapModuledAppsRework::PluginInfo> result;

    if(file.open(QIODevice::ReadOnly))
    {
        while(!file.atEnd())
        {
            QString plName;
            DapModuledAppsRework::PluginInfo plInfo;

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

                    plInfo.repoUrl = readFile.trimmed();
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
            if (result.contains(plName))
                result[plName] = std::move(plInfo);
        }
        file.close();
    }
}






DapModuledAppsRework::DapModuledAppsRework(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
{
    setStatusInit(true);
    initPaths();

    m_dapNetworkManager = new DapDappsNetworkManager(m_repoPlugins, m_pathPlugins);

    connect(m_dapNetworkManager, SIGNAL(sigFilesReceived()), this, SLOT(onFilesReceived()));
    connect(m_dapNetworkManager, SIGNAL(sigDownloadCompleted(QString)), this, SLOT(onDownloadCompleted(QString)));
    connect(m_dapNetworkManager, SIGNAL(sigDownloadProgress(quint64,quint64,QString,QString)), this, SLOT(onDownloadProgress(quint64,quint64,QString,QString)));
    connect(m_dapNetworkManager, SIGNAL(sigAborted()), this, SLOT(onAborted()));

    m_pluginsByName = readPluginsFile(m_pathPluginsConfigFile);
    m_dapNetworkManager->getFiles();
}

DapModuledAppsRework::~DapModuledAppsRework()
{

}

void DapModuledAppsRework::initPaths()
{
#ifdef Q_OS_LINUX
    m_pathPluginsConfigFile = QString("/opt/%1/dapps/config_dApps.ini").arg(DAP_BRAND_LO);
    m_pathPlugins = QString("/opt/%1/dapps").arg(DAP_BRAND_LO);
#elif defined Q_OS_MACOS
    mkdir("/tmp/Cellframe-Dashboard_dapps",0777);
    m_pathPluginsConfigFile = QString("/tmp/Cellframe-Dashboard_dapps/config_dApps.ini");
    m_pathPlugins = QString("/tmp/Cellframe-Dashboard_dapps");
#elif defined Q_OS_WIN
    m_pathPluginsConfigFile = QString("%1/%2/dapps/config_dApps.ini").arg(regGetUsrPath()).arg(DAP_BRAND);
    m_pathPlugins = QString("%1/%2/dapps").arg(regGetUsrPath()).arg(DAP_BRAND);
#endif

    QFile filePlugin(m_pathPluginsConfigFile);
    if(!filePlugin.exists())
    {
        if(filePlugin.open(QIODevice::WriteOnly))
            filePlugin.close();
    }
}

void DapModuledAppsRework::onFilesReceived()
{
    if (m_dapNetworkManager->m_bufferFiles.empty())
        qWarning()<<"No dApps in repository";

    for(const auto& repoPlugin : m_dapNetworkManager->m_bufferFiles)
    {
        m_pluginsByName[repoPlugin] = PluginInfo{m_repoPlugins, false, true};
    }
    m_dapNetworkManager->m_bufferFiles.clear();

    updateFileConfig();
    getListPlugins();
}

void DapModuledAppsRework::updateFileConfig()
{
    QFile file(m_pathPluginsConfigFile);

    if(file.open(QIODevice::WriteOnly))
    {
        QTextStream out(&file);
        for (auto it = m_pluginsByName.keyValueBegin(); it != m_pluginsByName.keyValueEnd(); ++it)
        {
            const auto& pluginName = it->first;
            const auto& pluginInfo = it->second;
            if(!checkHttps(pluginInfo.repoUrl))
            {
                out<< "[" << pluginName << "]" << "\n";
                out<< "path = " << it->second.repoUrl << "\n";
                out<< "status = " <<  QVariant(pluginInfo.isActivated).toString() << "\n";
                out<< "verifed = " << QVariant(pluginInfo.isVerified).toString() << "\n";
            }
        }
        file.close();
    }
    else
        qWarning() << "dApps Config not open. " << file.errorString();
}

void DapModuledAppsRework::getListPlugins()
{
    emit rcvListPlugins(m_pluginsByName.keys());
}

void DapModuledAppsRework::onDownloadProgress(quint64 prog, quint64 total, QString name, QString error)
{

}

//} // DApps
