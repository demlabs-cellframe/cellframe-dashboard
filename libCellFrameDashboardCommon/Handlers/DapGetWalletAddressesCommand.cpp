#include "DapGetWalletAddressesCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
DapGetWalletAddressesCommand::DapGetWalletAddressesCommand(const QString &asServicename, QObject *parent)
    : DapAbstractCommand(asServicename, parent)
{

}

/// Send request to service.
/// @details Performed on the client side.
/// @param arg1...arg10 Parameters.
void DapGetWalletAddressesCommand::requestToService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                              const QVariant &arg4, const QVariant &arg5,
                                              const QVariant &arg6, const QVariant &arg7,
                                              const QVariant &arg8, const QVariant &arg9,
                                              const QVariant &arg10)
{

    DapAbstractCommand::requestToService(arg1, arg2.toStringList(), arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
}

/// Send a response to the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapGetWalletAddressesCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3, const QVariant &arg4, const QVariant &arg5, const QVariant &arg6, const QVariant &arg7, const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
{
    Q_UNUSED(arg2)
    Q_UNUSED(arg3)
    Q_UNUSED(arg4)
    Q_UNUSED(arg5)
    Q_UNUSED(arg6)
    Q_UNUSED(arg7)
    Q_UNUSED(arg8)
    Q_UNUSED(arg9)
    Q_UNUSED(arg10)

    QStringList walletAddress;
    QStringList networkList = arg2.toStringList();
    if(!networkList.isEmpty())
    {
        for(int i{0}; i < networkList.count(); ++i)
        {
            QProcess process;
            process.start(QString("%1 wallet info -w %2 -net %3").arg(CLI_PATH).arg(arg1.toString()).arg(networkList[i]));
            process.waitForFinished(-1);
            QByteArray result = process.readAll();
            QRegExp regex("wallet: (.+)\\s+addr:\\s+(.+)\\s+(balance)|(\\d+.\\d+)\\s\\((\\d+)\\)\\s(\\w+)");

            int pos = 0;
            while((pos = regex.indexIn(result, pos)) != -1)
            {
                if(!regex.cap(2).isEmpty())
                {
                    walletAddress.append(networkList[i]);
                    walletAddress.append(regex.cap(2));
                }
                pos += regex.matchedLength();
            }
        }
    }

    return walletAddress;
}
