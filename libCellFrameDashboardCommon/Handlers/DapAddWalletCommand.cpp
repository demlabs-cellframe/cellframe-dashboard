#include "DapAddWalletCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
DapAddWalletCommand::DapAddWalletCommand(const QString &asServicename, QObject *parent)
    : DapAbstractCommand(asServicename, parent)
{

}

/// Send a response to the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapAddWalletCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                              const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                              const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                              const QVariant &arg10)
{
    Q_UNUSED(arg5)
    Q_UNUSED(arg6)
    Q_UNUSED(arg7)
    Q_UNUSED(arg8)
    Q_UNUSED(arg9)
    Q_UNUSED(arg10)

    QProcess process;
    QJsonArray result;
    process.start(QString("%1 wallet new -w %2 -sign %3 -net %4 -restore %5").arg(CLI_PATH).arg(arg1.toString()).arg(arg2.toString()).arg(arg3.toString()).arg(arg4.toString()));
    process.waitForFinished(-1);
    QString res = QString::fromLatin1(process.readAll());
    if(res.contains("already exists"))
    {
        result.append(QJsonValue(false));
        result.append(QJsonValue("Wallet already exists"));
    }
    else
    {
        result.append(QJsonValue(true));
        result.append(QJsonValue(arg1.toString()));
        result.append(QJsonValue("Wallet successfully created"));
    }
    return result.toVariantList();
}
