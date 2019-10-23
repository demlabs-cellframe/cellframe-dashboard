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
    return m_history;
}

void DapChainHistoryHandler::onRequestNewHistory(const QMap<QString, QVariant>& aWallets)
{
    QList<QVariant> wallets = aWallets.values();
    if(wallets.isEmpty()) return;

    QList<QVariant> data;
    for(int i = 0; i < wallets.count(); i++)
    {
        QProcess process;
        process.start(QString("%1 tx_history -net %2 -chain gdb -addr %3").arg(CLI_PATH).arg(m_CurrentNetwork).arg(wallets.at(i).toString()));
        process.waitForFinished(-1);

        QByteArray result = process.readAll();

        if(!result.isEmpty())
        {
            QRegularExpression regular("((\\w{3}\\s+){2}\\d{1,2}\\s+(\\d{1,2}:*){3}\\s+\\d{4})\\s+(\\w+)\\s+(\\d+)\\s(\\w+)\\s+\\w+\\s+([\\w\\d]+)", QRegularExpression::MultilineOption);
            QRegularExpressionMatchIterator matchItr = regular.globalMatch(result);
            while (matchItr.hasNext())
            {
                QRegularExpressionMatch match = matchItr.next();
                QStringList dataItem = QStringList()
                                       << match.captured(1)
                                       << QString::number(DapTransactionStatusConvertor::getStatusByShort(match.captured(4)))
                                       << match.captured(5)
                                       << match.captured(6)
                                       << match.captured(7)
                                       << wallets.at(i).toString();
                data << dataItem;

            }
        }
    }


    if(m_history != data)
    {
        m_history = data;
        emit changeHistory(m_history);
    }
}

void DapChainHistoryHandler::setCurrentNetwork(const QString& aNetwork)
{
    if(aNetwork == m_CurrentNetwork)
        return;
    m_CurrentNetwork = aNetwork;
}
