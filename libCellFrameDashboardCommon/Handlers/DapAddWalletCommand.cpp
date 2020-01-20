#include "DapAddWalletCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param apSocket Client connection socket with service.
/// @param parent Parent.
DapAddWalletCommand::DapAddWalletCommand(const QString &asServicename, DapRpcSocket *apSocket, QObject *parent)
    : DapAbstractCommand(asServicename, apSocket, parent)
{

}

/// Send a response to the service.
/// @param arg1...arg10 Parameters.
/// @return Reply to service.
QVariant DapAddWalletCommand::respondToService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                               const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                               const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                               const QVariant &arg10)
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

    return QVariant();
}

/// Send a response to the client.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapAddWalletCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                              const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                              const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                              const QVariant &arg10)
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

    QByteArray result;
    QProcess process;
    process.start(QString("%1 wallet new -w %2").arg(CLI_PATH).arg(arg1.toString()));
    process.waitForFinished(-1);
    result = process.readAll();
    QStringList res = QString::fromLatin1(result).split(" ");
    QStringList list;
    list.append(arg1.toString());
    list.append(res.at(res.size()-1).trimmed());
    return result.isEmpty() ? QStringList() : list;
}
