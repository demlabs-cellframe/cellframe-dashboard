#include "DapChainLogHandler.h"

#include <QRegularExpression>

DapChainLogHandler::DapChainLogHandler(QObject *parent) : QObject(parent)
{
    m_fileSystemWatcher.addPath(LOG_FILE);

    connect(&m_fileSystemWatcher, &QFileSystemWatcher::fileChanged, this, [=] (const QString& asFile) {
        Q_UNUSED(asFile)
        m_fileSystemWatcher.addPath(LOG_FILE);
        emit onChangedLog();
    });
}

QStringList DapChainLogHandler::request()
{
    QFile file(LOG_FILE);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qWarning() << "Failed to open file " << file.fileName();
        return QStringList();
    }
    else
    {
        QTextStream in(&file);
        in.seek(m_currentCaretPosition);
        const QRegularExpression re("(\\[\\d\\d\\/\\d\\d\\/\\d\\d\\-\\d\\d\\:\\d\\d\\:\\d\\d])\\s(\\[\\w+\\])\\s(\\[\\w+\\])(.+)");

        QStringList listLogs;
        while (!in.atEnd()) {
            const QString line = in.readLine();
            const auto match = re.match(line);
            if(!match.hasMatch())
                continue;

            const QString matchedLog = match.captured();
            listLogs.append(matchedLog);
            m_currentCaretPosition += matchedLog.length();
        }

        return listLogs;

    }
}
