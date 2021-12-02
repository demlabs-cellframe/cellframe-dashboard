#include "DapPluginsController.h"

DapPluginsController::DapPluginsController(QString pathPluginsConfigFile, QString pathPlugins,  QObject *parent) : QObject(parent)
{
    m_pathPluginsConfigFile = pathPluginsConfigFile;
    m_pathPlugins = pathPlugins;

    readPluginsFile(&m_pathPluginsConfigFile);
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
                else if(i == 2)
                {
                    readFile = readFile.split("verifed")[1];
                    readFile = readFile.split('=')[1];
                }
                readFile = readFile.trimmed();
                lst.append(readFile);
            }
            m_pluginsList.append(lst);
        }
        file.close();
    }
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

            out<<"["<<str[0]<<"]"<<"\n";
            out<<"path = "<<str[1]<<"\n";
            out<<"status = "<<str[2]<<"\n";
            out<<"verifed = " << "0" <<"\n";
        }
        file.close();
    }
}

void DapPluginsController::addPlugin(QVariant path, QVariant status)
{

    QString path_plug = path.toString();
    QStringList splitPath = path.toString().split("/");
    QString name_mainFilePlugin = splitPath.last().remove(".zip");

#if !defined(Q_OS_WIN)
    path_plug.remove("file://");
#else
    path_plug.remove("file:///");
#endif

    if(zipManage(path_plug))
    {
        QStringList list;

        QString pathMainFileQml;

#if !defined(Q_OS_WIN)
    pathMainFileQml = QString("file://" + m_pathPlugins + "/" + name_mainFilePlugin + "/" + name_mainFilePlugin +".qml") ;
#else
    pathMainFileQml = QString("file:///" + m_pathPlugins + "/" + name_mainFilePlugin + "/" + name_mainFilePlugin +".qml");
#endif


        list.append(name_mainFilePlugin); //name plugin
        list.append(pathMainFileQml); //path main.qml
        list.append(status.toString()); //instal or not install
        list.append(0); // verefied

        m_pluginsList.append(list);
        qInfo()<<list[1];

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

void DapPluginsController::setStatusPlugin(int number, QString status)
{
    QStringList str = m_pluginsList.value(number).toStringList();
    m_pluginsList.removeAt(number);
    str[2] = status;
    m_pluginsList.append(str);

    updateFileConfig();
    getListPlugins();
}

void DapPluginsController::deletePlugin(int number)
{
    QStringList str = m_pluginsList.value(number).toStringList();
    str[1].remove(QString("/" + str[0] + ".qml"));
    str[1].remove("file://");

    QDir dir(str[1]);
    dir.removeRecursively();

    m_pluginsList.removeAt(number);

    updateFileConfig();
    getListPlugins();
}
