#include "DapLogMessage.h"

DapLogMessage::DapLogMessage(const QString &asType, const QString &asTimestamp, const QString &asFile, const QString &asMessage, QObject *parent) : QObject(parent)
{
    m_type = asType;
    m_sTimeStamp = asTimestamp;
    m_sFile = asFile;
    m_sMessage = asMessage;
}

QString DapLogMessage::getType() const
{
    return m_type;
}

void DapLogMessage::setType(const QString &asType)
{
    m_type = asType;

    emit typeChanged(m_type);
}

QString DapLogMessage::getTimeStamp() const
{
    return m_sTimeStamp;
}

void DapLogMessage::setTimeStamp(const QString &asTimeStamp)
{
    m_sTimeStamp = asTimeStamp;

    emit timeStampChanged(m_sTimeStamp);
}

QString DapLogMessage::getFile() const
{
    return m_sFile;
}

void DapLogMessage::setFile(const QString &asFile)
{
    m_sFile = asFile;

    emit fileChanged(m_sFile);
}

QString DapLogMessage::getMessage() const
{
    return m_sMessage;
}

void DapLogMessage::setMessage(const QString &asMessage)
{
    m_sMessage = asMessage;

    emit messageChanged(m_sMessage);
}
