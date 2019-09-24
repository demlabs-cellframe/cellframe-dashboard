#include "DapChainConsoleHandler.h"

#define MAX_COUNT_CMD 50

DapChainConsoleHandler::DapChainConsoleHandler(QObject *parent) : QObject(parent)
{
    QDir().mkpath(QFileInfo(CMD_LOG).path());
    m_File = new QFile(CMD_LOG, this);
    m_File->open(QIODevice::Append | QIODevice::ReadWrite);
}

QString DapChainConsoleHandler::getHistory() const
{
    if(!m_File->isOpen()) return QString();

    quint8 countCmd = 0;
    while (m_File->pos() > 0)
    {
        QByteArray symbol =  m_File->read(1);
        if(symbol == ">") ++countCmd;
        m_File->seek(m_File->pos() - 2);
        if(countCmd == MAX_COUNT_CMD) break;
    }

    QByteArray lastCmd = m_File->read(m_File->size() - m_File->pos());

    return QString::fromStdString(lastCmd.toStdString());
}

QString DapChainConsoleHandler::getResult(const QString& aQuery) const
{
    QProcess process;
    process.start(QString(CLI_PATH) + " " + aQuery);
    process.waitForFinished(-1);

    QByteArray returnSymbol = "\n";

#ifdef Q_OS_WIN
    returnSymbol.prepend("\r");
#endif

    QByteArray result = process.readAll();
    m_File->write("> " + aQuery.toUtf8() + returnSymbol);
    m_File->write(result + returnSymbol);
    m_File->flush();

    return QString::fromStdString(result.toStdString());
}
