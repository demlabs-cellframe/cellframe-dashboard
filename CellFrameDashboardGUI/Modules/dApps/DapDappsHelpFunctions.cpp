#include "DapModuledApps.h"

#define UNIT_KB 1024            //KB
#define UNIT_MB 1024*1024       //MB
#define UNIT_GB 1024*1024*1024  //GB

void DapModuledApps::readPluginsFile(QString *path)
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

void DapModuledApps::updateFileConfig()
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
        qWarning() << "dApps Config not open. " << file.errorString();
}

QString DapModuledApps::transformUnit(double bytes, bool isSpeed)
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

QString DapModuledApps::transformTime(quint64 seconds)
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
