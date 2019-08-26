#include "DapHistoryType.h"

const QMap<DapTransactionStatus, QStringList> DapTransactionStatusConvertor::m_statusMap =
{
    {stSent, QStringList() << "send" << "Sent" << "#959CA6"},
    {stReceived, QStringList() << "recv" << "Received" << "#454E63"},
};

QString DapTransactionStatusConvertor::getShortStatus(const DapTransactionStatus aStatus)
{
    if(!m_statusMap.contains(aStatus)) return QString();
    return m_statusMap[aStatus].at(0);
}

QString DapTransactionStatusConvertor::getLongStatus(const DapTransactionStatus aStatus)
{
    if(!m_statusMap.contains(aStatus)) return QString();
    return m_statusMap[aStatus].at(1);
}

DapTransactionStatus DapTransactionStatusConvertor::getStatusByShort(const QString& aShortStatus)
{
    for(auto item = m_statusMap.constBegin(); item != m_statusMap.constEnd(); item++)
    {
        if(item.value().at(0) == aShortStatus)
            return item.key();
    }

    return stUnknow;
}

DapTransactionStatus DapTransactionStatusConvertor::getStatusByLong(const QString& aLongStatus)
{
    for(auto item = m_statusMap.constBegin(); item != m_statusMap.constEnd(); item++)
    {
        if(item.value().at(1) == aLongStatus)
            return item.key();
    }

    return stUnknow;
}

QColor DapTransactionStatusConvertor::getStatusColor(const DapTransactionStatus aStatus)
{
    if(!m_statusMap.contains(aStatus)) return QColor();
    return QColor(m_statusMap[aStatus].at(2));
}
