#include "DapPluginsController.h"

DapPluginsController::DapPluginsController(QString pathPluginsConfigFile, QObject *parent) : QObject(parent)
{
    m_pathPluginsConfigFile = pathPluginsConfigFile;

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
            for(int i = 0; i < 3 ; i++ )
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
        }
        file.close();
    }
}

void DapPluginsController::addPlugin(QVariant name, QVariant path, QVariant status)
{
    QStringList list;

    list.append(name.toString());
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
        file.close();
    }

    getListPlugins();

//    qDebug()<<name<< " " <<path<< " " <<status;

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
