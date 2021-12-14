#include "DapPluginsController.h"

DapPluginsController::DapPluginsController(QString pathPluginsConfigFile, QString pathPlugins,  QWidget *parent) : QWidget(parent)
{
    m_pathPluginsConfigFile = pathPluginsConfigFile;
    m_pathPlugins = pathPlugins;

    m_repoPlugins = "https://plugins.cellframe.net/dashboard/";

#if !defined(Q_OS_WIN)
    m_filePrefix = "file://";
#else
    m_filePrefix = "file:///";
#endif

    init();

}

void DapPluginsController::init()
{
    m_dapNetworkManager = new DapNetworkManager(m_repoPlugins, m_pathPlugins);

    connect(m_dapNetworkManager, SIGNAL(filesReceived()), this, SLOT(onFilesReceived()));
    connect(m_dapNetworkManager, SIGNAL(downloadCompleted(QString)), this, SLOT(onDownloadCompleted(QString)));
    connect(m_dapNetworkManager, SIGNAL(downloadProgress(double,double)), this, SLOT(onDownloadProgress(double,double)));
    connect(m_dapNetworkManager, SIGNAL(aborted()), this, SLOT(onAborted()));

    readPluginsFile(&m_pathPluginsConfigFile);
    m_dapNetworkManager->getFiles();
}

void DapPluginsController::onFilesReceived()
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

                if(str[0] == str2[0].remove(".zip") && str[3].toInt())
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
        qWarning()<<"No Plugins in repository";

    updateFileConfig();
    getListPlugins();
}

void DapPluginsController::onDownloadProgress(double prog, double total)
{
    double percent_progress = (prog * 100)/total;
    QString progress = QString::number(percent_progress,'f',2);

    int completed = progress == "100"? 1 : 0;

    emit rcvProgressDownload(progress, completed);

//    qDebug()<<progress << " - " << total << " - " << percent << "%";
}


void DapPluginsController::addPlugin(QVariant path, QVariant status, QVariant verifed)
{

    QString path_plug = path.toString();
    QStringList splitPath = path.toString().split("/");
    QString name_mainFilePlugin = splitPath.last().remove(".zip");

    path_plug.remove(m_filePrefix);

    if(checkDuplicates(name_mainFilePlugin, verifed.toString()) && zipManage(path_plug))
    {
        QStringList list;

        QString pathMainFileQml = QString(m_filePrefix + m_pathPlugins + "/" + name_mainFilePlugin + "/" + name_mainFilePlugin +".qml") ;

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
            qWarning() << "Plugins Config not open. " << file.errorString();

        if(status.toInt())
            installPlugin(m_pluginsList.length()-1,status.toString(), verifed.toString());

        getListPlugins();
    }
}


void DapPluginsController::installPlugin(int number, QString status, QString verifed)
{
    QStringList str = m_pluginsList.value(number).toStringList();

    if(checkHttps(str[1]))
        m_dapNetworkManager->downloadFile(str[0]);
    else
    {
        m_pluginsList.removeAt(number);
        str[2] = status;
        str[3] = verifed;
        m_pluginsList.append(str);
        updateFileConfig();
        getListPlugins();
    } 
}

void DapPluginsController::deletePlugin(int number)
{
    QStringList str = m_pluginsList.value(number).toStringList();
    str[1].remove(QString("/" + str[0] + ".qml"));
    str[1].remove(m_filePrefix);

    QDir dir(str[1]);
    dir.removeRecursively();

    m_pluginsList.removeAt(number);

    updateFileConfig();
    m_dapNetworkManager->getFiles();
}

bool DapPluginsController::zipManage(QString &path)
{
    //TODO: Make a request to the node to confirm the hash
    QString hash = pkeyHash(path);

    QStringList result = JlCompress::extractDir(path,m_pathPlugins);

    return !result.isEmpty();
}

QString DapPluginsController::pkeyHash(QString &path)
{
    QFile file(path);
    QByteArray fileData;

    if (file.open(QFile::ReadOnly)) {

        fileData = file.readAll();
        file.close();
    }

    dap_chain_hash_fast_t l_hash_cert_pkey;
    dap_hash_fast(fileData.constData(), fileData.size(), &l_hash_cert_pkey);
    char *l_cert_pkey_hash_str = dap_chain_hash_fast_to_str_new(&l_hash_cert_pkey);
    QString ret = QString::fromLatin1(l_cert_pkey_hash_str);
    DAP_DEL_Z(l_cert_pkey_hash_str)
    return ret;
}

bool DapPluginsController::checkDuplicates(QString name, QString verifed)
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

bool DapPluginsController::checkHttps(QString path)
{

    QStringList findWord = {"https://"};
    QString findReg = '(' + findWord.join('|') + ')';
    QRegularExpression re(findReg);
    QString endStr = re.match(path).capturedTexts().join(' ');

    return !endStr.isEmpty();

}
