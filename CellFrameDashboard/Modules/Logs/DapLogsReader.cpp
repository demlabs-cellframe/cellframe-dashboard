#include "DapLogsReader.h"
#include <QFile>
#include <QDebug>
#include <QStringView>

DapLogsReader::DapLogsReader(QObject *parent)
    : QObject{parent}
    , m_timerLogUpdate(new QTimer(this))
{
    connect(m_timerLogUpdate, &QTimer::timeout, [this] {
        updateLogList();
    });
}

void DapLogsReader::setStatusUpdate(bool status)
{
    if(status && !m_timerLogUpdate->isActive())
        m_timerLogUpdate->start(5000);
    else if(!status)
        m_timerLogUpdate->stop();
}

void DapLogsReader::setLogType(QString path)
{
    m_timerLogUpdate->stop();
    m_logList.clear();
    m_path = path;
    updateLogList();
    m_timerLogUpdate->start(5000);
}

void DapLogsReader::updateLogList()
{
    QFile logFile(m_path);
    if(!logFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        qWarning() << "The node log file does not open";
    }

    m_logList.clear();

    long long bytes = 250000; // ~1700 str

    if(logFile.size() > bytes)
        logFile.seek(logFile.size() - bytes);

    while (!logFile.atEnd()) {

        m_logList.insert(0, QString::fromLocal8Bit(logFile.readLine()));

        if(m_logList.length() > m_bufferSize)
        {
            m_logList.removeLast();
        }
    }

    logFile.close();

    emit sigLogUpdated();
}


