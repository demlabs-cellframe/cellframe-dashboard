#include "DapChainHistoryHandler.h"

DapChainHistoryHandler::DapChainHistoryHandler(QObject *parent) :
    QObject(parent)
{
    m_timoutRequestHistory = new QTimer(this);
    QObject::connect(m_timoutRequestHistory, &QTimer::timeout, this, &DapChainHistoryHandler::requsetWallets, Qt::QueuedConnection);
    m_timoutRequestHistory->start(3000);
}

QVariant DapChainHistoryHandler::getHistory() const
{
//    qDebug() << "get story" << m_history;

    return m_history;
}

void DapChainHistoryHandler::onRequestNewHistory(const QMap<QString, QVariant>& aWallets)
{
    if(m_wallets != aWallets.values())
        m_wallets = aWallets.values();

    if(m_wallets.isEmpty()) return;

    QList<QVariant> data;
    for(int i = 0; i < m_wallets.count(); i++)
    {
        QProcess process;
        process.start(QString(CLI_PATH) + " tx_history -net private -chain gdb -addr " + m_wallets.at(i).toString());
        process.waitForFinished(-1);

        QByteArray result = process.readAll();

        if(!result.isEmpty())
        {
            QRegExp reg("(\\w{3}\\s\\w{3}\\s\\d+\\s\\d{1,2}:\\d{2}:\\d{2}\\s\\d{4}).+"
                        "\\s(\\w+)\\s(\\d+)\\s(\\w+)\\s\\w+\\s+(\\w+)");

            int pos = 0;
            while ((pos = reg.indexIn(result, pos)) != -1)
            {
                QStringList dataItem = QStringList() << reg.cap(1) << QString::number(DapTransactionStatusConvertor::getStatusByShort(reg.cap(2))) << reg.cap(3) << reg.cap(4) << reg.cap(5) << m_wallets.at(i).toString();
                data.append(dataItem);
                pos += reg.matchedLength();
            }
        }
    }


    if(m_history != data)
    {
        m_history = data;
        emit changeHistory(m_history);
    }
}
