#include "DapChainLogHandler.h"

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
    QStringList m_listLogs;
    QFile file(LOG_FILE);
        if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            emit onUpdateModel();
        }
        else
        {
            QTextStream in(&file);
//            QRegExp rx("(\\[|\\]|\\s)([\\w*]{1,1}[\\w\\s\\W]+)([\\n]|\\])" ); !!! DO NOT DELETE!!!
            QRegExp rx("(\\[|\\]|\\s)([\\w*]{1,1}[\\w\\s\\W]+)(\\]|$)" );
            rx.setMinimal(true);


            while (!in.atEnd()) {
                QString line = in.readLine();
                    int pos{0};
                    while((pos = rx.indexIn(line, pos)) != -1)
                    {
                        m_listLogs.append(rx.cap(2));
                        pos += rx.matchedLength();
                    }
            }
        }
        return m_listLogs;
}
