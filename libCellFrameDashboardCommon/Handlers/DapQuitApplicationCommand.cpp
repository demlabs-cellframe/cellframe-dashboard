#include "DapQuitApplicationCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
DapQuitApplicationCommand::DapQuitApplicationCommand(const QString &asServicename, QObject *parent)
    : DapAbstractCommand(asServicename, parent)
{

}

/// Send a notification to the client. At the same time, you should not expect a response from the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
void DapQuitApplicationCommand::notifyToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                        const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                        const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                        const QVariant &arg10)
{
    DapAbstractCommand::notifyToClient(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

    DapRpcLocalServer * server = dynamic_cast<DapRpcLocalServer *>(m_parent);

    Q_ASSERT(server);

    connect(server, SIGNAL(onClientDisconnected()), qApp, SLOT(quit()));
}

/// Process the notification from the service on the client side.
/// @details Performed on the client side.
/// @param arg1...arg10 Parameters.
void DapQuitApplicationCommand::notifedFromService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                            const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                            const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                            const QVariant &arg10)
{
    Q_UNUSED(arg1);
    Q_UNUSED(arg2);
    Q_UNUSED(arg3);
    Q_UNUSED(arg4);
    Q_UNUSED(arg5);
    Q_UNUSED(arg6);
    Q_UNUSED(arg7);
    Q_UNUSED(arg8);
    Q_UNUSED(arg9);
    Q_UNUSED(arg10);

    qApp->quit();
}
