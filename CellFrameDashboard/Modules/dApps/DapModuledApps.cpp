#include "DapModuledApps.h"
#include <sys/stat.h>
#include "DapDashboardPathDefines.h"

#define TIME_INTERVAL 500

DapModuledApps::DapModuledApps(DapModulesController *parent)
    : DapAbstractModule(parent)
{
//    connect(m_modulesCtrl, &DapModulesController::initDone, [this] ()
//    {
        setStatusInit(true);
        init();

//    });
}

DapModuledApps::~DapModuledApps()
{
    if(m_dapNetworkManager) delete m_dapNetworkManager;
}

void DapModuledApps::init()
{
    m_repoPlugins = "https://dapps.cellframe.net/dashboard/";

#if !defined(Q_OS_WIN)
    m_filePrefix = "file://";
#else
    m_filePrefix = "file:///";
#endif

#if defined Q_OS_MACOS
    mkdir("/tmp/Cellframe-Dashboard_dapps",0777);
#endif
    //dApps config file
    m_pathPluginsConfigFile = Dap::DashboardDefines::DApps::PLUGINS_CONFIG;
    m_pathPlugins = Dap::DashboardDefines::DApps::PLUGINS_PATH;

    QFile filePlugin(m_pathPluginsConfigFile);
    if(!filePlugin.exists())
    {
        if(filePlugin.open(QIODevice::WriteOnly))
            filePlugin.close();
    }

    m_dapNetworkManager = new DapDappsNetworkManager(m_repoPlugins, m_pathPlugins);

    connect(m_dapNetworkManager, SIGNAL(sigFilesReceived()), this, SLOT(onFilesReceived()));
    connect(m_dapNetworkManager, SIGNAL(sigDownloadCompleted(QString)), this, SLOT(onDownloadCompleted(QString)));
    connect(m_dapNetworkManager, SIGNAL(sigDownloadProgress(quint64,quint64,QString,QString)), this, SLOT(onDownloadProgress(quint64,quint64,QString,QString)));
    connect(m_dapNetworkManager, SIGNAL(sigAborted()), this, SLOT(onAborted()));

    readPluginsFile(&m_pathPluginsConfigFile);
    m_dapNetworkManager->getFiles();
}


void DapModuledApps::onFilesReceived()
{
    m_buffPluginsByUrl = m_dapNetworkManager->m_bufferFiles;

    m_dapNetworkManager->m_bufferFiles.erase(
        m_dapNetworkManager->m_bufferFiles.begin(),
        m_dapNetworkManager->m_bufferFiles.end());

    if(m_buffPluginsByUrl.count())
    {
        QList <QStringList> appendList;
        for(int i = 0; i < m_buffPluginsByUrl.length(); i++)
        {
            if(m_pluginsList.count())
            {
                for(int j = 0; j < m_pluginsList.length(); j++)
                {
                    QStringList str = m_pluginsList[j].toStringList();

                    if(str[0] == m_buffPluginsByUrl[i])
                    {
                        if(!str[3].toInt())
                        {
                            str[3] = "1";
                            m_pluginsList.removeAt(j);
                            m_pluginsList.append(str);
                        }
                    }
                    else
                    {
                        QStringList list;
                        list.append(m_buffPluginsByUrl[i]);
                        list.append(m_repoPlugins);
                        list.append("0");
                        list.append("1");
                        appendList.append(list);
                    }
                }
            }
            else
            {
                QStringList list;
                list.append(m_buffPluginsByUrl[i]);
                list.append(m_repoPlugins);
                list.append("0");
                list.append("1");
                appendList.append(list);
            }
        }

        for(int i = 0; i < appendList.length(); i++)
        {
            bool ok = true;
            for(int j = 0; j < m_pluginsList.length(); j++)
            {
                QStringList str = m_pluginsList[j].toStringList();
                QStringList str2 = appendList[i];

                if(str[0].remove(".zip") == str2[0].remove(".zip") && str[3].toInt())
                {
                    ok = false;
                    break;
                }
            }
            if(ok)
                m_pluginsList.append(appendList[i]);
        }
        m_buffPluginsByUrl.erase(m_buffPluginsByUrl.begin(), m_buffPluginsByUrl.end());
    }
    else
        qWarning()<<"No dApps in repository";

    updateFileConfig();
    getListPlugins();
}

void DapModuledApps::onDownloadProgress(quint64 prog, quint64 total, QString name, QString error)
{
    if(total)
    {
        double percent_progress = ((double)prog * 100.0)/(double)total;
        QString progress = QString::number(percent_progress,'f',2);

        int completed = progress == "100.00"? 1 : 0;

        quint64 deltaDownload = prog - m_bytesDownload;
        m_bytesDownload = prog;
        m_bytesTotal = total;
        uint timeNow = m_timeRecord.elapsed();

        if(timeNow - m_timeInterval > TIME_INTERVAL)
        {
            //speed
            qint64 ispeed = deltaDownload * 1000 / (timeNow - m_timeInterval);
            m_speed = transformUnit((double)ispeed, true);
            // time;
            qint64 timeRemain = (total - prog) / ispeed;
            m_time = transformTime(timeRemain);

            m_timeInterval = timeNow;
        }

        QString downloadTransform, totalTransform;
        downloadTransform = transformUnit((double)m_bytesDownload,false);
        totalTransform = transformUnit((double)m_bytesTotal,false);

        //    qDebug()<< progress << " - " << completed << " - " << downloadTransform << " - " << totalTransform << " - " << time << " - " << speed;

        emit rcvProgressDownload(progress, completed, downloadTransform, totalTransform, m_time, m_speed, name, error);
    }
    else
    {
        double percent_progress = ((double)m_bytesDownload * 100.0)/(double)m_bytesTotal;
        QString progress = QString::number(percent_progress,'f',2);

        QString downloadTransform, totalTransform;
        downloadTransform = transformUnit((double)m_bytesDownload,false);
        totalTransform = transformUnit((double)m_bytesTotal,false);

        emit rcvProgressDownload(progress, 0, downloadTransform, totalTransform, "0", "0", name, error);
    }

    //    qDebug()<<total << " - " << progress << "%" << " - "  <<completed;
}


void DapModuledApps::addPlugin(QVariant path, QVariant status, QVariant verifed)
{

    QString path_plug = path.toString();
    QStringList splitPath = path.toString().split("/");
    QString name_mainFilePlugin = splitPath.last().remove(".zip");

    path_plug.remove(m_filePrefix);

    if(checkDuplicates(name_mainFilePlugin, verifed.toString()) && zipManage(path_plug))
    {
        QStringList list;

        QString pathMainFileQml = QString(m_filePrefix + m_pathPlugins + "/" + name_mainFilePlugin + "/" + name_mainFilePlugin +".qml") ;
        pathMainFileQml = QDir::toNativeSeparators(pathMainFileQml);

        list.append(name_mainFilePlugin); //name plugin
        list.append(pathMainFileQml); //path main.qml
        list.append(status.toString()); //instal or not install
        list.append("0"); // verefied

        m_pluginsList.append(list);


        QFile file(m_pathPluginsConfigFile);

        if(file.open(QIODevice::Append))
        {
            QTextStream out(&file);
            out<<"["<<list[0]<<"]"<<"\n";
            out<<"path = "<<list[1]<<"\n";
            out<<"status = "<<list[2]<<"\n";
            out<<"verifed = " << list[3] <<"\n";
            file.close();
        }
        else
            qWarning() << "dApps Config not open. " << file.errorString();

        if(status.toInt())
            installPlugin(name_mainFilePlugin,status.toString(), verifed.toString());

        getListPlugins();
    }
}


void DapModuledApps::installPlugin(QString name, QString status, QString verifed)
{
    QStringList str;
    int i;
    bool ok = false;

    for(i = 0; i < m_pluginsList.length(); i++)
    {
        str = m_pluginsList.value(i).toStringList();
        if(str[0] == name){
            ok = true;
            break;
        }
    }
    if(!ok)
        qWarning()<< "Extension search error";
    else
    {
        if(checkHttps(str[1]))
        {
            m_dapNetworkManager->downloadFile(str[0]);
            m_timeRecord.start();
            m_timeInterval = 0;
            m_bytesDownload = 0;
            m_time = "";
            m_speed = "";
        }
        else
        {
            m_pluginsList.removeAt(i);
            str[2] = status;
            str[3] = verifed;
            m_pluginsList.append(str);
            updateFileConfig();
            getListPlugins();
        }
    }
}

void DapModuledApps::deletePlugin(QVariant url)
{
    int number;
    bool ok = false;
    for(number = 0; number < m_pluginsList.length(); number++)
    {
        if(m_pluginsList.value(number).toStringList()[1] == url.toString())
        {
            ok = true;
            break;
        }
    }
    if(ok)
    {
        QStringList str = m_pluginsList.value(number).toStringList();
        str[1].remove(QString("/" + str[0] + ".qml"));
        str[1].remove(m_filePrefix);

        QFile file(QDir::toNativeSeparators(QString(m_pathPlugins + "/download/" + str[0] + ".zip")));

        if(file.exists())
            file.remove();


        QDir dir(str[1]);
        dir.removeRecursively();

        m_pluginsList.removeAt(number);

        updateFileConfig();
        m_dapNetworkManager->getFiles();
    }
}

bool DapModuledApps::zipManage(QString &path)
{
    //TODO: Make a request to the node to confirm the hash
    QString hash = pkeyHash(path);

    //    bool result = DapZip::fileDecompression(path,m_pathPlugins);

    return DapZip::fileDecompression(path,m_pathPlugins);
}

QString DapModuledApps::pkeyHash(QString &path)
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

bool DapModuledApps::checkDuplicates(QString name, QString verifed)
{
    int ind = 10000;
    bool ok = true;
    for(int i = 0; i < m_pluginsList.length(); i++)
    {
        QStringList str = m_pluginsList[i].toStringList();
        QString checkName = m_pluginsList[i].toStringList()[0].remove(".zip");

        if(name == checkName && verifed.toInt())
            ind = i;

        if(name == str[0])
        {
            ok = false;
            break;
        }
    }

    if(ind != 10000)
    {
        m_pluginsList.removeAt(ind);
    }
    return ok;
}

bool DapModuledApps::checkHttps(QString path)
{

    QStringList findWord = {"https://"};
    QString findReg = '(' + findWord.join('|') + ')';
    QRegularExpression re(findReg);
    QString endStr = re.match(path).capturedTexts().join(' ');

    return !endStr.isEmpty();

}

