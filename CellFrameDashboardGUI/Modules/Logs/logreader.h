#ifndef LOGREADER_H
#define LOGREADER_H

#include <QStringList>
#include <QMap>

class LogReader
{
public:
    LogReader(const QString &file_path,
              const QString &file_name, bool with_data = false);

    void updateLog();

    void updateLines(qint64 begin, qint64 size);

    qint64 getLength()
    {
        return m_logLength;
    }

    const QStringList &getLines()
    {
        return logLines;
    }

private:
    void getFileNames();

    void getFullLength();

    qint64 getLogLength(const QString &file_name);

    void readFile(const QString &file_name);

    void readLines(const QString &file_name);

    QStringList logLines;

    QVector <qint64> linePosition;

    QMap <QString, qint64> fileSize;

    QString m_fileName;
    QString m_filePath;
    bool m_withData;

    QStringList fileNames;

    qint64 m_logLength{0};
    qint64 m_begin{0};
    qint64 m_size{0};
    qint64 m_current{0};
};

#endif // LOGREADER_H
