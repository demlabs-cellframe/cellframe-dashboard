#include "configfile.h"

#include <QFile>

#include <QDebug>

const QString update_extention = ".new";

ConfigFile::ConfigFile(const QString &file_name) :
    fileName(file_name)
{
//    qDebug() << "ConfigFile::ConfigFile" << file_name;

    QFile file(file_name);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    while (!file.atEnd())
    {
        lines.append(file.readLine());
    }

    file.close();

//    qDebug() << lines;
}

QString ConfigFile::readConfigValue(const QString &key) const
{
//    qDebug() << "ConfigFile::readConfigValue";

    for (QByteArray line : lines)
    {
        if (line.left(key.size()) == key)
        {
//            qDebug() << key << line.mid(key.size()+1, line.size() - key.size()-2);

            return line.mid(key.size()+1, line.size() - key.size()-2);
        }
    }

    return QString();
}

void ConfigFile::writeConfigValue(const QString &key, const QString &value)
{
//    qDebug() << "ConfigFile::writeConfigValue";

    for (auto i = 0; i < lines.size(); ++i)
    {
        if (lines.at(i).left(key.size()) == key)
        {
//            qDebug() << lines.at(i);

            QByteArray newLine = QString(key + "=" + value + "\n").toUtf8();

//            qDebug() << newLine;

            lines[i] = newLine;

            break;
        }
    }
}

QString ConfigFile::readGroupValue(
        const QString &group, const QString &key) const
{
    if (group.isEmpty() || key.isEmpty())
        return QString();

    QString currentGroup = "";

    for (QByteArray line : lines)
    {
        if (line.left(1) == "[")
        {
            currentGroup = line.mid(1, line.size()-3);

            continue;
        }

        if (currentGroup == group && line.left(key.size()) == key)
        {
            qDebug() << "readGroupValue" << currentGroup
                     << key << line.mid(key.size()+1, line.size() - key.size()-2);

            return line.mid(key.size()+1, line.size() - key.size()-2);
        }
    }

    return QString();
}

void ConfigFile::writeGroupValue(
        const QString &group, const QString &key, const QString &value)
{
    qDebug() << "ConfigFile::writeGroupValue" << group << key << value;

    if (group.isEmpty() || key.isEmpty())
        return;

    QString currentGroup = "";

    bool keyExists = false;
    bool groupExists = false;

    for (auto i = 0; i < lines.size(); ++i)
    {
        if (lines.at(i).left(1) == "[")
        {
            currentGroup = lines.at(i).mid(1, lines.at(i).size()-3);

            if (currentGroup == group)
                groupExists = true;

            continue;
        }

        if (currentGroup == group && lines.at(i).left(key.size()) == key)
        {
            QByteArray newLine = QString(key + "=" + value + "\n").toUtf8();

            lines[i] = newLine;

            keyExists = true;

            qDebug() << "writeGroupValue" << currentGroup << newLine;

            break;
        }
    }

    if (!keyExists && groupExists)
    {
        for (auto i = 0; i < lines.size(); ++i)
        {
            if (lines.at(i).left(1) == "[")
            {
                currentGroup = lines.at(i).mid(1, lines.at(i).size()-3);

                if (currentGroup == group)
                {
                    QByteArray newLine = QString(key + "=" + value + "\n").toUtf8();

                    lines.insert(i+1, newLine);

                    break;
                }

                continue;
            }
        }
    }

    if (!groupExists)
    {
        QByteArray newGroup = QString("[" + group + "]\n").toUtf8();
        QByteArray newLine = QString(key + "=" + value + "\n").toUtf8();

        lines.append(newGroup);
        lines.append(newLine);
    }


//    qDebug() << lines;
}

void ConfigFile::saveFile()
{
    qDebug() << "ConfigFile::saveFile" << fileName;

    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    for (QByteArray line : lines)
    {
        file.write(line);
    }

    file.close();

    qDebug() << "SAVED";
}

void ConfigFile::resetChanges()
{
    QFile file(fileName);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    lines.clear();

    while (!file.atEnd())
    {
        lines.append(file.readLine());
    }

    file.close();
}

bool ConfigFile::checkUpdate()
{
    QFile file(fileName+update_extention);

    return file.exists();
}

bool ConfigFile::updateFile()
{
    qDebug() << "ConfigFile::updateFile" << fileName+update_extention;

    QFile file(fileName+update_extention);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return false;

    lines.clear();

    while (!file.atEnd())
    {
        lines.append(file.readLine());
    }

    file.remove();

    saveFile();

    return true;
}

bool ConfigFile::getNetworkStatus()
{
    QString key("id");

    for (auto i = 0; i < lines.size(); ++i)
    {
        if (lines.at(i).left(key.size()) == key)
            return true;
    }

    return false;
}

void ConfigFile::setNetworkStatus(bool status)
{
    QString keyOn("id");
    QString keyOff("#id");

    if (status)
    {
        for (auto i = 0; i < lines.size(); ++i)
        {
            if (lines.at(i).left(keyOff.size()) == keyOff)
            {
                QString value = lines.at(i).mid(keyOff.size()+1,
                                                lines.at(i).size() - keyOff.size()-2);
                QByteArray newLine = QString(keyOn + "=" + value + "\n").toUtf8();

                lines[i] = newLine;

                break;
            }
        }
    }
    else
    {
        for (auto i = 0; i < lines.size(); ++i)
        {
            if (lines.at(i).left(keyOn.size()) == keyOn)
            {
                QString value = lines.at(i).mid(keyOn.size()+1,
                                                lines.at(i).size() - keyOn.size()-2);
                QByteArray newLine = QString(keyOff + "=" + value + "\n").toUtf8();

                lines[i] = newLine;

                break;
            }
        }
    }

}
