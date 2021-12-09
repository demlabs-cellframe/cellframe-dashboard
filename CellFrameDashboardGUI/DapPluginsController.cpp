#include "DapPluginsController.h"

DapPluginsController::DapPluginsController(QString pathPluginsConfigFile, QString pathPlugins,  QWidget *parent) : QWidget(parent)
{
    m_pathPluginsConfigFile = pathPluginsConfigFile;
    m_pathPlugins = pathPlugins;

    m_networkManager = new QNetworkAccessManager(this);
    m_repoPlugins = "https://plugins.cellframe.net/dashboard/";

#if !defined(Q_OS_WIN)
    m_filePrefix = "file://";
#else
    m_filePrefix = "file:///";
#endif
//    connect(m_networkManager, &QNetworkAccessManager::finished, this, &DapPluginsController::uploadFinished);
//    uploadFile();

    connect(this, SIGNAL(completedParseReply()),this, SLOT(appendReplyToListPlugins()));

    readPluginsFile(&m_pathPluginsConfigFile);
    getListPluginsByUrl();
}

void DapPluginsController::readPluginsFile(QString *path)
{
    QFile file(*path);

    QString readFile;

    if(file.open(QIODevice::ReadOnly))
    {
        while(!file.atEnd())
        {
            QStringList lst;
            for(int i = 0; i < 4 ; i++ )
            {
                readFile = file.readLine();
                if(i == 0)
                {
                    readFile = readFile.split('[')[1];
                    readFile = readFile.split(']')[0];
                }
                else if(i == 1)
                {
                    readFile = readFile.split("path")[1];
                    readFile = readFile.split('=')[1];
                }
                else if(i == 2)
                {
                    readFile = readFile.split("status")[1];
                    readFile = readFile.split('=')[1];
                }
                else if(i == 3)
                {
                    readFile = readFile.split("verifed")[1];
                    readFile = readFile.split('=')[1];
                }
                readFile = readFile.trimmed();
                lst.append(readFile);
            }
            if(checkDuplicates(lst[0]))
                m_pluginsList.append(lst);
        }
        file.close();
    }
}

void DapPluginsController::getListPluginsByUrl()
{
    QNetworkReply *reply;
    reply = m_networkManager->get(QNetworkRequest(QUrl(m_repoPlugins)));

    connect(reply, SIGNAL(finished()),this,SLOT(replyFinished()));
}

void DapPluginsController::replyFinished()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());

    if (reply->error() == QNetworkReply::NoError)
    {
        QByteArray content= reply->readAll();
        QTextCodec *codec = QTextCodec::codecForName("utf8");
        QString str = codec->toUnicode(content.data());
        QRegExp rw("[\\w+|\\s+]{,}.zip");

        int lastPos = 0;
        while((lastPos = rw.indexIn(str,lastPos)) != -1)
        {
            lastPos += rw.matchedLength();
            m_buffPluginsByUrl.append(rw.cap(0));
        }
        m_buffPluginsByUrl.removeDuplicates();
    }
    else
        qWarning()<<reply->errorString();

    disconnect(reply, SIGNAL(finished()),this,SLOT(replyFinished()));
    reply->deleteLater();

    emit completedParseReply();
}

// no uses --------
void DapPluginsController::uploadFile()
{
    QString fileName = QFileDialog::getOpenFileName(this, "Get Any file");
    m_fileUpload = new QFile(fileName);

    QFileInfo fileInfo (*m_fileUpload);

    QUrl url(m_repoPlugins + fileInfo.fileName());
    url.setUserName("ftpuser");
    url.setPassword("sGpawUJeC");
    url.setPort(21);

    if(m_fileUpload->open(QIODevice::ReadOnly))
        m_networkManager->put(QNetworkRequest(url),m_fileUpload);
}

void DapPluginsController::uploadFinished(QNetworkReply* reply)
{
    if (!reply->error())
        qDebug()<< "good";
    else
        qDebug()<< reply->errorString();

    m_fileUpload->close();
    m_fileUpload->deleteLater();
    reply->deleteLater();
}
//---------------

void DapPluginsController::appendReplyToListPlugins()
{
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
            m_pluginsList.append(appendList[i]);
        }
        m_buffPluginsByUrl.erase(m_buffPluginsByUrl.begin(), m_buffPluginsByUrl.end());
    }
    else
        qWarning()<<"No Plugins in repository";

    sortList();
    updateFileConfig();
    getListPlugins();
}

void DapPluginsController::updateFileConfig()
{
    QFile file(m_pathPluginsConfigFile);

    if(file.open(QIODevice::WriteOnly))
    {
        QTextStream out(&file);
        for(int i = 0; i < m_pluginsList.length(); i++)
        {
            QStringList str = m_pluginsList.value(i).toStringList();

            if(!checkHttps(str[1]))
            {
                out<<"["<<str[0]<<"]"<<"\n";
                out<<"path = "<<str[1]<<"\n";
                out<<"status = "<<str[2]<<"\n";
                out<<"verifed = " <<str[3]<<"\n";
            }
        }
        file.close();
    }
    else
        qWarning() << "Plugins Config not open. " << file.errorString();

}

void DapPluginsController::addPlugin(QVariant path, QVariant status)
{

    QString path_plug = path.toString();
    QStringList splitPath = path.toString().split("/");
    QString name_mainFilePlugin = splitPath.last().remove(".zip");

    path_plug.remove(m_filePrefix);

    if(checkDuplicates(name_mainFilePlugin) && zipManage(path_plug))
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

        getListPlugins();

//        qDebug()<<name_mainFilePlugin<< " " <<path<< " " <<status;
    }
}

QByteArray DapPluginsController::fileChecksum(const QString &file, QCryptographicHash::Algorithm hashAlgorithm)
{
    QFile f(file);
    if (f.open(QFile::ReadOnly)) {
        QCryptographicHash hash(hashAlgorithm);
        if (hash.addData(&f)) {
            return hash.result();
        }
    }
    return QByteArray();
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

bool DapPluginsController::zipManage(QString &path)
{
    QString file =  path;

    //TODO: Make a request to the node to confirm the hash
//    QByteArray hash = fileChecksum(file, QCryptographicHash::Sha256).toHex();
    QString hash = pkeyHash(file);

    QStringList result = JlCompress::extractDir(file,m_pathPlugins);

    return !result.isEmpty();
}

bool DapPluginsController::checkDuplicates(QString name)
{
    for(int i = 0; i < m_pluginsList.length(); i++)
    {
        QStringList str = m_pluginsList[i].toStringList();

        if(name == str[i])
            return false;
    }
    return true;
}

bool DapPluginsController::checkHttps(QString path)
{

    QStringList findWord = {"https://"};
    QString findReg = '(' + findWord.join('|') + ')';
    QRegularExpression re(findReg);
    QString endStr = re.match(path).capturedTexts().join(' ');

    if(endStr.isEmpty())
        return false;
    else
        return true;
}

void DapPluginsController::setStatusPlugin(int number, QString status)
{
    QStringList str = m_pluginsList.value(number).toStringList();

    if(checkHttps(str[1]))
    {
        downloadPlugin(str[0]);
    }
    else
    {
        m_pluginsList.removeAt(number);
        str[2] = status;
        m_pluginsList.append(str);
    }

    updateFileConfig();
    getListPlugins();
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
    getListPlugins();
}

void DapPluginsController::downloadPlugin(QString name)
{

}

void DapPluginsController::downloadFinished()
{

}
