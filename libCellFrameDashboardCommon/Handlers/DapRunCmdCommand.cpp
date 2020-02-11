#include "DapRunCmdCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
/// @param asCliPath The path to cli nodes.
DapRunCmdCommand::DapRunCmdCommand(const QString &asServicename, QObject *parent, const QString &asCliPath)
    : DapAbstractCommand(asServicename, parent, asCliPath)
{

}

/// Send a response to the client.
/// @details Performed on the service side.
/// @param arg1 Command.
/// @param arg2...arg10 Parameters.
/// @return Reply to client.
QVariant DapRunCmdCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3, const QVariant &arg4, const QVariant &arg5, const QVariant &arg6, const QVariant &arg7, const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
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


    QProcess process;
    process.start(QString("%1 %2").arg(m_sCliPath).arg(arg1.toString()));
    process.waitForFinished(-1);
    QString result = QString::fromLatin1(process.readAll());
    QJsonArray response;
    response.append(QJsonValue(arg1.toString()));
    response.append(QJsonValue(result));

    return response;
}
