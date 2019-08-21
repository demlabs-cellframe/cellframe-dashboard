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
    QList<QVariant> wallets = aWallets.values();
    if(wallets.isEmpty()) return;

    QList<QVariant> data;
    for(int i = 0; i < wallets.count(); i++)
    {
        QProcess process;
        process.start(QString(CLI_PATH) + " tx_history -net private -chain gdb -addr " + wallets.at(i).toString());
        process.waitForFinished(-1);

        QString result = QString::fromStdString(process.readAll().toStdString());

        if(!result.isEmpty())
        {
            //  TODO: error with "\r\n"
            QRegExp rx("(\\w{3}\\s\\w{3}\\s\\d+\\s\\d{1,2}:\\d{2}:\\d{2}\\s\\d{4})\\r\\n"
                        "\\s(\\w+)\\s(\\d+)\\s(\\w+)\\s\\w+\\s+(\\w+)");

            int pos = 0;
            while ((pos = rx.indexIn(result, pos)) != -1)
            {
                QStringList dataItem = QStringList() << rx.cap(1) << QString::number(DapTransactionStatusConvertor::getStatusByShort(rx.cap(2))) << rx.cap(3) << rx.cap(4) << rx.cap(5) << wallets.at(i).toString();
                qDebug() << "NEW MATCH" << pos << dataItem;
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
