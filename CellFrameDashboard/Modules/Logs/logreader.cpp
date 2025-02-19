#include "logreader.h"

#include <QFile>
#include <QDebug>
#include <QRegularExpression>

#include <QDir>

LogReader::LogReader(const QString &file_path,
                     const QString &file_name, bool with_data) :
    m_fileName(file_name), m_filePath(file_path), m_withData(with_data)
{
    getFullLength();
}

void LogReader::updateAll()
{
    logLines.clear();
    linePosition.clear();
    fileSize.clear();

    getFullLength();
}

void LogReader::readFullLog()
{
    logLines.clear();

    getFileNames(false);

    for (auto file_name : fileNames)
        readFile(file_name);
}

void LogReader::updateLines(qint64 begin, qint64 size)
{
    m_begin = begin;
    m_size = size;
    m_current = 0;

    logLines.clear();

    getFileNames(true);

    for (auto file_name : fileNames)
        readLines(file_name);
}

void LogReader::updateLog()
{
    getFileNames(false);

    QString file_name = fileNames.last();

    QFile file(file_name);

    qint64 fileLength = 0;

    if (fileSize.contains(file_name))
        fileLength = fileSize.value(file_name);

    if (file.open(QFile::ReadOnly))
    {
        char buf[1024];
        qint64 lineLength;

//        linePosition.append(0);

        qint64 pos = file.pos();

        file.seek(linePosition.last());
        file.readLine(buf, sizeof(buf));

        forever
        {
            lineLength = file.readLine(buf, sizeof(buf));

            if (lineLength > 0 && pos != file.pos())
            {
                linePosition.append(file.pos());
                ++fileLength;
                ++m_logLength;
            }
            else
                if (lineLength == -1)
                    break;
        }

        linePosition.removeLast();

        file.close();
    }

    fileSize.insert(file_name, fileLength);

//    qDebug() << "updateLog" << file_name << fileLength;
//    qDebug() << "sizeof(linePosition)" << qtContainerSize(linePosition);
}

void LogReader::getFileNames(bool reverse)
{
    fileNames.clear();

    if (!m_withData)
    {
        fileNames.append(m_filePath + "/" + m_fileName + ".log");
    }
    else
    {
        QDir dir(m_filePath);
        QStringList cfglist = dir.entryList(QStringList(m_fileName + "*.log"));

        QMap<QString, QString> names;

        QStringList dates;

        for (auto file_name : cfglist)
        {
            QRegularExpression regex(
                "("+m_fileName+"_([0-9]+)-([0-9]+)-([0-9]+).log)");
            QRegularExpressionMatch match = regex.match(file_name);

//            qDebug() << "LogReader::getFileNames"
//                     << match.captured(4)
//                     << match.captured(3)
//                     << match.captured(2);

            QString date = match.captured(4)+"-"+
                    match.captured(3)+"-"+
                    match.captured(2);

            names.insert(date, file_name);

            if (dates.isEmpty())
                dates.append(date);
            else
            {
                auto i = 0;
                while (i < dates.size())
                {
                    if (dates.at(i) >= date)
                    {
                        dates.insert(i, date);
                        break;
                    }
                    ++i;
                }
                if (i == dates.size())
                    dates.append(date);
            }

        }

        if (reverse)
        {
            for (auto i = dates.size()-1; i >= 0; --i)
            {
                if (names.contains(dates.at(i)))
                    fileNames.append(m_filePath + "/" + names.value(dates.at(i)));
            }
        }
        else
        {
            for (auto date : dates)
            {
                if (names.contains(date))
                    fileNames.append(m_filePath + "/" + names.value(date));
            }
        }

//        qDebug() << "LogReader::getFileNames" << fileNames;


//        for (auto file_name : cfglist)
//        {
//            fileNames.append(m_filePath + "/" + file_name);
//        }
    }
}

void LogReader::getFullLength()
{
    m_logLength = 0;

    getFileNames(false);

    for (auto file_name : fileNames)
        m_logLength += getLogLength(file_name);
}

//template <class T>
//qint64 qtContainerSize(const T &container)
//{
//    return container.size() * sizeof(typename T::value_type);
//}

qint64 LogReader::getLogLength(const QString &file_name)
{
    qint64 fileLength = 0;

    QFile file(file_name);

    if (file.open(QFile::ReadOnly))
    {
        char buf[1024];
        qint64 lineLength;

        linePosition.append(0);

        forever
        {
            lineLength = file.readLine(buf, sizeof(buf));

            if (lineLength > 0)
            {
                linePosition.append(file.pos());
                ++fileLength;
            }
            else
                if (lineLength == -1)
                    break;
        }

        linePosition.removeLast();

        file.close();
    }

    fileSize.insert(file_name, fileLength);

//    qDebug() << "getLogLength" << file_name << fileLength;
//    qDebug() << "sizeof(linePosition)" << qtContainerSize(linePosition);

    return fileLength;
}

void LogReader::readFile(const QString &file_name)
{
    QFile file(file_name);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    while (!file.atEnd())
    {
        logLines.append(file.readLine());
    }

    file.close();
}

void LogReader::readLines(const QString &file_name)
{
    if (m_current >= m_begin + m_size)
        return;

    qint64 size = 0;

    if (fileSize.contains(file_name))
        size = fileSize.value(file_name);

    if (m_current + size < m_begin)
    {
        m_current += size;
        return;
    }

//    qDebug() << "LogReader::readLines"
//             << file_name
//             << m_begin << size << m_current;

    QFile file(file_name);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    if (m_current < m_begin)
        m_current = m_begin;

    QString line;

    qint64 index = linePosition.size() - m_current - 1;

    file.seek(linePosition.at(index));

    while (!file.atEnd())
    {
        line = file.readLine();

//        qDebug() << index << m_current
//                 << "linePosition" << linePosition.at(index)
//                 << "line" << line << line.isEmpty();

        if (!line.isEmpty())
        {
            if (m_current < m_begin + m_size)
                logLines.append(line);
        }

        if (linePosition.at(index) == 0)
            break;

        ++m_current;

        if (m_current >= m_begin + m_size)
            break;

        index = linePosition.size() - m_current - 1;

        if (index < 0)
            break;

        file.seek(linePosition.at(index));
    }

    file.close();
}
