#include "DapLogMessage.h"

DapLogMessage::DapLogMessage(const Type &type, const QString &timestamp, const QString &file, const QString &message, QObject *parent) : QObject(parent)
{
    m_type = type;
    m_sTimeStamp = timestamp;
    m_sFile = file;
    m_sMessage = message;
}

Type DapLogMessage::getType() const
{
    return m_type;
}

void DapLogMessage::setType(const Type &type)
{
    m_type = type;

    emit typeChanged(m_type);
}

QString DapLogMessage::getTimeStamp() const
{
    return m_sTimeStamp;
}

void DapLogMessage::setTimeStamp(const QString &sTimeStamp)
{
    m_sTimeStamp = sTimeStamp;

    emit timeStampChanged(m_sTimeStamp);
}

QString DapLogMessage::getFile() const
{
    return m_sFile;
}

void DapLogMessage::setFile(const QString &sFile)
{
    m_sFile = sFile;

    emit fileChanged(m_sFile);
}

QString DapLogMessage::getMessage() const
{
    return m_sMessage;
}

void DapLogMessage::setMessage(const QString &sMessage)
{
    m_sMessage = sMessage;

    emit messageChanged(m_sMessage);
}
