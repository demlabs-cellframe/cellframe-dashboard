#include "DapAbstractCommand.h"

/// Overloaded constructor.
/// @param asServiceName Service name.
/// @param parent Parent.
/// @details The parent must be either DapRPCSocket or DapRPCLocalServer.
/// @param asCliPath The path to cli nodes.
DapAbstractCommand::DapAbstractCommand(const QString &asServiceName, QObject *parent, const QString &asCliPath)
    : DapCommand(asServiceName, parent), m_parent(parent), m_sCliPath(asCliPath)
{

}

/// Send a notification to the client. At the same time, you should not expect a response from the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
void DapAbstractCommand::notifyToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                        const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                        const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                        const QVariant &arg10)
{
    QVariantList params;
    if (arg1.isValid()) params.append(arg1);
    if (arg2.isValid()) params.append(arg2);
    if (arg3.isValid()) params.append(arg3);
    if (arg4.isValid()) params.append(arg4);
    if (arg5.isValid()) params.append(arg5);
    if (arg6.isValid()) params.append(arg6);
    if (arg7.isValid()) params.append(arg7);
    if (arg8.isValid()) params.append(arg8);
    if (arg9.isValid()) params.append(arg9);
    if (arg10.isValid()) params.append(arg10);

    DapRpcLocalServer * server = dynamic_cast<DapRpcLocalServer *>(m_parent);

    Q_ASSERT(server);

    DapRpcMessage request = DapRpcMessage::createNotification(QString("%1.%2").arg(this->getName()).arg("notifedFromService"), QJsonArray::fromVariantList(params));
    server->notifyConnectedClients(request);
}

/// Process the notification from the service on the client side.
/// @details Performed on the client side.
/// @param arg1...arg10 Parameters.
void DapAbstractCommand::notifedFromService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
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

    emit clientNotifed(QVariant());
}

/// Send request to client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
void DapAbstractCommand::requestToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                         const QVariant &arg4, const QVariant &arg5, const QVariant &arg6, 
                                         const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                         const QVariant &arg10)
{
    QVariantList params;
    if (arg1.isValid()) params.append(arg1);
    if (arg2.isValid()) params.append(arg2);
    if (arg3.isValid()) params.append(arg3);
    if (arg4.isValid()) params.append(arg4);
    if (arg5.isValid()) params.append(arg5);
    if (arg6.isValid()) params.append(arg6);
    if (arg7.isValid()) params.append(arg7);
    if (arg8.isValid()) params.append(arg8);
    if (arg9.isValid()) params.append(arg9);
    if (arg10.isValid()) params.append(arg10);

    DapRpcLocalServer * server = dynamic_cast<DapRpcLocalServer *>(m_parent);

    Q_ASSERT(server);

    DapRpcMessage request = DapRpcMessage::createRequest(QString("%1.%2").arg(this->getName()).arg("respondToService"), QJsonArray::fromVariantList(params));
    DapRpcServiceReply * reply = server->notifyConnectedClients(request);
    connect(reply, SIGNAL(finished()), this, SLOT(replyFromClient()));
}

/// Send a response to the service.
/// @details Performed on the client side.
/// @param arg1...arg10 Parameters.
/// @return Reply to service.
QVariant DapAbstractCommand::respondToService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
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

/// Reply from client.
/// @details Performed on the service side.
/// @return Client reply.
QVariant DapAbstractCommand::replyFromClient()
{
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    emit clientResponded(reply->response().toJsonValue().toVariant());
    return QVariant();
}

/// Send a notification to the service. At the same time, you should not expect a response from the service.
/// @details Performed on the client side.
/// @param arg1...arg10 Parameters.
void DapAbstractCommand::notifyToService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                         const QVariant &arg4, const QVariant &arg5, const QVariant &arg6,
                                         const QVariant &arg7, const QVariant &arg8, const QVariant &arg9,
                                         const QVariant &arg10)
{
    QVariantList params;
    if (arg1.isValid()) params.append(arg1);
    if (arg2.isValid()) params.append(arg2);
    if (arg3.isValid()) params.append(arg3);
    if (arg4.isValid()) params.append(arg4);
    if (arg5.isValid()) params.append(arg5);
    if (arg6.isValid()) params.append(arg6);
    if (arg7.isValid()) params.append(arg7);
    if (arg8.isValid()) params.append(arg8);
    if (arg9.isValid()) params.append(arg9);
    if (arg10.isValid()) params.append(arg10);

    DapRpcSocket * socket = dynamic_cast<DapRpcSocket *>(m_parent);

    Q_ASSERT(socket);

    DapRpcMessage notify = DapRpcMessage::createNotification(QString("%1.%2").arg(this->getName()).arg("notifedFromClient"), QJsonArray::fromVariantList(params));
    socket->notify(notify);
}

/// Process the notification from the client on the service side.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
void DapAbstractCommand::notifedFromClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3, const QVariant &arg4, const QVariant &arg5, const QVariant &arg6, const QVariant &arg7, const QVariant &arg8, const QVariant &arg9, const QVariant &arg10)
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

    emit serviceNotifed(QVariant());
}

/// Send request to service.
/// @details Performed on the client side.
/// @param arg1...arg10 Parameters.
void DapAbstractCommand::requestToService(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
                                              const QVariant &arg4, const QVariant &arg5,
                                              const QVariant &arg6, const QVariant &arg7,
                                              const QVariant &arg8, const QVariant &arg9,
                                              const QVariant &arg10)
{
    QVariantList params;
    if (arg1.isValid()) params.append(arg1);
    if (arg2.isValid()) params.append(arg2);
    if (arg3.isValid()) params.append(arg3);
    if (arg4.isValid()) params.append(arg4);
    if (arg5.isValid()) params.append(arg5);
    if (arg6.isValid()) params.append(arg6);
    if (arg7.isValid()) params.append(arg7);
    if (arg8.isValid()) params.append(arg8);
    if (arg9.isValid()) params.append(arg9);
    if (arg10.isValid()) params.append(arg10);

    DapRpcServiceReply *reply = dynamic_cast<DapRpcSocket *>(m_parent)->invokeRemoteMethod(QString("%1.%2").arg(this->getName()).arg("respondToClient"),
                                            arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
    connect(reply, SIGNAL(finished()), this, SLOT(replyFromService()));
}

/// Send a response to the client.
/// @details Performed on the service side.
/// @param arg1...arg10 Parameters.
/// @return Reply to client.
QVariant DapAbstractCommand::respondToClient(const QVariant &arg1, const QVariant &arg2, const QVariant &arg3,
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

/// Reply from service.
/// @details Performed on the service side.
/// @return Service reply.
QVariant DapAbstractCommand::replyFromService()
{
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());

    emit serviceResponded(reply->response().toJsonValue().toVariant());

    return reply->response().toJsonValue().toVariant();
}
