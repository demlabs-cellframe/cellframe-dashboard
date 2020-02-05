#include "DapGetHistoryExecutedCmdCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
/// @param asCliPath The path to cli nodes.
DapGetHistoryExecutedCmdCommand::DapGetHistoryExecutedCmdCommand(const QString &asServicename, QObject *parent, const QString &asCliPath)
    : DapAbstractCommand(asServicename, parent, asCliPath)
{
    DapRpcLocalServer * server = dynamic_cast<DapRpcLocalServer *>(m_parent);
    if(server)
    {
        QDir().mkpath(QFileInfo(asCliPath).path());
        m_File = new QFile(asCliPath, this);
    }
}

/// Send a response to the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapGetHistoryExecutedCmdCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3, const QVariant &arg4, const QVariant &arg5, const QVariant &arg6, const QVariant &arg7, const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
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

    QJsonArray historyExecutedCmd;

    if(!m_File->open(QIODevice::ReadOnly | QIODevice::Text))
        return historyExecutedCmd;

    while (!m_File->atEnd())
    {
        historyExecutedCmd.append(QJsonValue(QString::fromLatin1(m_File->readLine()).trimmed()));
    }
    m_File->close();

    return historyExecutedCmd;
}
