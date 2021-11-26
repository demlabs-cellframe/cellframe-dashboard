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

void DapPluginsController::sortList()
{
//    int n;
//    int i;
//    for (n=0; n < m_pluginsList.count(); n++)
//    {
//        for (i=n+1; i < m_pluginsList.count(); i++)
//        {
//            QStringList valorN=m_pluginsList.at(n).toStringList();
//            QStringList valorI=m_pluginsList.at(i).toStringList();

//            if (valorN[0].toUpper() > valorI[0].toUpper())
//            {
//                m_pluginsList.move(i, n);
//                n=0;
//            }
//        }
//    }
    std::sort(m_pluginsList.begin(), m_pluginsList.end());
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

void DapPluginsController::addPlugin(QVariant name, QVariant path, QVariant status)
{

    QString path_plug = path.toString();
    QStringList splitPath = path.toString().split("/");
    QString name_mainFilePlugin = "/" + splitPath.last();

    if(zipManage(&path_plug))
    {
        QStringList list;

        list.append(name.toString());

        //TODO: release
//        list.append(QString("file://" + m_pathPlugins + name_mainFilePlugin));
        list.append(path.toString());

        list.append(status.toString());

        m_pluginsList.append(list);

        QFile file(m_pathPluginsConfigFile);

        if(file.open(QIODevice::Append))
        {
            QTextStream out(&file);
            out<<"["<<list[0]<<"]"<<"\n";
            out<<"path = "<<list[1]<<"\n";
            out<<"status = "<<list[2]<<"\n";
            out<<"verifed = " << "0" <<"\n";
            file.close();
        }

        getListPlugins();

        qDebug()<<name<< " " <<path<< " " <<status;
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

bool DapPluginsController::zipManage(QString *path)
{
    QString file = "/home/denis/Proj/Cellframe_master/asd.zip";

    //TODO: Make a request to the node to confirm the hash
    QByteArray hash = fileChecksum(file, QCryptographicHash::Sha256).toHex();

    //TODO: If the hash passed, then unpack the plugin
    QZipReader zip_reader(file);

    if(zip_reader.exists())
    {
        qDebug() << "Number of items in the zip archive =" << zip_reader.count();
        foreach (QZipReader::FileInfo info, zip_reader.fileInfoList()) {
            if(info.isFile)
                qDebug() << "File:" << info.filePath << info.size;
            else if (info.isDir)
                qDebug() << "Dir:" << info.filePath;
            else
                qDebug() << "SymLink:" << info.filePath;
        }
        zip_reader.extractAll(m_pathPlugins);
        return true;
    }
    else
        return false;

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
    m_pluginsList.removeAt(number);

    updateFileConfig();
    getListPlugins();
}
