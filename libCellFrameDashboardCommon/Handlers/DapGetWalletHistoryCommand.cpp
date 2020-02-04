#include "DapGetWalletHistoryCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
/// @param asCliPath The path to cli nodes.
DapGetWalletHistoryCommand::DapGetWalletHistoryCommand(const QString &asServicename, QObject *parent, const QString &asCliPath)
    : DapAbstractCommand(asServicename, parent), m_sCliPath(asCliPath)
{

}

/// Send a response to the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapGetWalletHistoryCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3, const QVariant &arg4, const QVariant &arg5, const QVariant &arg6, const QVariant &arg7, const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
{
    Q_UNUSED(arg1)
    Q_UNUSED(arg2)
    Q_UNUSED(arg3)
    Q_UNUSED(arg4)
    Q_UNUSED(arg5)
    Q_UNUSED(arg6)
    Q_UNUSED(arg7)
    Q_UNUSED(arg8)
    Q_UNUSED(arg9)
    Q_UNUSED(arg10)

    QList<QVariant> data;
    QProcess process;
    process.start(QString("%1 tx_history -net %2 -chain gdb -addr %3").arg(m_sCliPath).arg(arg1.toString()).arg(arg2.toString()));
    process.waitForFinished(-1);
    QByteArray result = process.readAll();
    if(!result.isEmpty())
    {
        QRegularExpression regular("((\\w{3}\\s+){2}\\d{1,2}\\s+(\\d{1,2}:*){3}\\s+\\d{4})\\s+(\\w+)\\s+(\\d+)\\s(\\w+)\\s+\\w+\\s+([\\w\\d]+)", QRegularExpression::MultilineOption);
        QRegularExpressionMatchIterator matchItr = regular.globalMatch(result);
        while (matchItr.hasNext())
        {
            if(data.count() >= 100) break;
            QRegularExpressionMatch match = matchItr.next();
            QStringList dataItem = QStringList()
                                   << match.captured(1)
                                   << match.captured(4)
                                   << match.captured(5)
                                   << match.captured(6)
                                   << match.captured(7);
            data << dataItem;
        }
    }

    return data;
}
