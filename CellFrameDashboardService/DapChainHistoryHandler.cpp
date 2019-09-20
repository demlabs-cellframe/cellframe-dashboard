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
        process.start(QString(CLI_PATH) + " tx_history -net " + m_CurrentNetwork + " -chain gdb -addr " + wallets.at(i).toString());
        process.waitForFinished(-1);

        QByteArray result = process.readAll();

        if(!result.isEmpty())
        {
            QRegExp rx("((\\w{3}\\s+){2}\\d{1,2}\\s+(\\d{1,2}:*){3}\\s+\\d{4})\\s+(\\w+)\\s+(\\d+)\\s(\\w+)\\s+\\w+\\s+([\\w\\d]+)");

            int pos = 0;
            while ((pos = rx.indexIn(result, pos)) != -1)
            {
                QStringList dataItem = QStringList() << rx.cap(1) << QString::number(DapTransactionStatusConvertor::getStatusByShort(rx.cap(4))) << rx.cap(5) << rx.cap(6) << rx.cap(7) << wallets.at(i).toString();
                data << dataItem;
                pos += rx.matchedLength();
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
    if(aNetwork == m_CurrentNetwork) return;
    m_CurrentNetwork = aNetwork;
}
