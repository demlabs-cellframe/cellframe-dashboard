#include "DapPluginsController.h"

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
            if(checkDuplicates(lst[0], lst[3]))
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
