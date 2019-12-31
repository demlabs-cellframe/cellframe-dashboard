#include "DapAbstractCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param apSocket Client connection socket with service.
/// @param parent Parent.
DapAbstractCommand::DapAbstractCommand(const QString &asServiceName, DapRpcSocket* apSocket, QObject *parent)
    : DapCommand(asServiceName, parent), m_pSocket(apSocket)
{

}

/// Send request to client.
/// @param arg1...arg10 Parameters.
void DapAbstractCommand::requestToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
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
}

/// Reply from client.
/// @return Client reply.
QVariant DapAbstractCommand::replyFromClient()
{
    emit clientResponded(QVariant());
    return QVariant();
}

/// Send request to service.
/// @param arg1...arg10 Parameters.
void DapAbstractCommand::requestToService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                              const QVariant &arg4, const QVariant &arg5,
                                              const QVariant &arg6, const QVariant &arg7,
                                              const QVariant &arg8, const QVariant &arg9,
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

    DapRpcServiceReply *reply = m_pSocket->invokeRemoteMethod(QString("%1.%2").arg(this->getName()).arg("respondToClient"),
                                            arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
    connect(reply, SIGNAL(finished()), this, SLOT(replyFromService()));
}

/// Reply from service.
/// @return Service reply.
void DapAbstractCommand::replyFromService()
{
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    emit serviceResponded(reply->response().toJsonValue().toVariant());
}
