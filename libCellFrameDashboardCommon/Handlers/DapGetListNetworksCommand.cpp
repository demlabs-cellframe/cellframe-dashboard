#include "DapGetListNetworksCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
DapGetListNetworksCommand::DapGetListNetworksCommand(const QString &asServicename, QObject *parent)
    : DapAbstractCommand(asServicename, parent)
{

}

/// Send a response to the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapGetListNetworksCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3, const QVariant &arg4, const QVariant &arg5, const QVariant &arg6, const QVariant &arg7, const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
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

    QStringList networkList;
    QProcess process;
    process.start(QString("%1 net list").arg(CLI_PATH));
    process.waitForFinished(-1);
    QString result = QString::fromLatin1(process.readAll());
    result.remove(' ');
    if(!(result.isEmpty() || result.isNull()))
    {
        QStringList str = result.remove("\n").remove("\r").split(":").at(1).split(",");
        return str;
    }
    return QString();
}
