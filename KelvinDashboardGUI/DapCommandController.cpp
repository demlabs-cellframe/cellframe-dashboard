#include "DapCommandController.h"

/// Overloaded constructor.
/// @param apIODevice Data transfer device.
/// @param apParent Parent.
DapCommandController::DapCommandController(QIODevice *apIODevice, QObject *apParent)
    :  DapRpcService(apParent)
{
    // Socket initialization
    m_DAPRpcSocket = new DapRpcSocket(apIODevice, this);
    // Signal-slot connection initiating the execution of the method called by the service
    connect(m_DAPRpcSocket, SIGNAL(messageReceived(DapRpcMessage)), SLOT(messageProcessing(DapRpcMessage)));

    addService(this);
}

/// Process incoming message.
/// @param asMessage Incoming message.
void DapCommandController::messageProcessing(const DapRpcMessage &asMessage)
{
    DapRpcSocket *socket = static_cast<DapRpcSocket*>(sender());
    if (!socket) {
        qDebug() << "Called without service socket";
        return;
    }

    processMessage(socket, asMessage);
}

/// Process the result of the command execution.
void DapCommandController::processCommandResult()
{
    qInfo() << "processCommandResult()";
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    if (!reply) {
        qWarning() << "Invalid response received";
        return;
    }
    emit sigCommandResult(reply->response().result());
}

/// Handling service response for receiving node logs.
void DapCommandController::processGetNodeLogs()
{
    qInfo() << "processGetNodeLogs()";
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    if (!reply) {
        qWarning() << "Invalid response received";
        return;
    }
    emit sigCommandResult(reply->response().result());
    emit sigNodeLogsReceived(reply->response().result().toVariant().toStringList());
}

///
void DapCommandController::processAddWallet()
{
    qInfo() << "processAddWallet()";
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    if (!reply) {
        qWarning() << "Invalid response received";
        return;
    }
    emit sigCommandResult(reply->response().result());
    emit sigWalletAdded(reply->response().result().toVariant().toString());
}

void DapCommandController::processGetWallets()
{
    qInfo() << "processGetWallets()";
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    if (!reply) {
        qWarning() << "Invalid response received";
        return;
    }
    emit sigCommandResult(reply->response().result());
    emit sigWalletsReceived(reply->response().result().toVariant().toMap());
}

/// Show or hide GUI client by clicking on the tray icon.
/// @param aIsActivated Accepts true - when requesting to 
/// display a client, falso - when requesting to hide a client.
void DapCommandController::activateClient(bool aIsActivated)
{
    emit onClientActivate(aIsActivated);
}

/// Shut down client.
void DapCommandController::closeClient()
{
    emit onClientClose();
}

/// Get node logs.
/// @param aiTimeStamp Timestamp start reading logging.
/// @param aiRowCount Number of lines displayed.
void DapCommandController::getNodeLogs(int aiTimeStamp, int aiRowCount)
{
    qInfo() << QString("getNodeLogs(%1, %2)").arg(aiTimeStamp).arg(aiRowCount);
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.getNodeLogs", aiTimeStamp, aiRowCount);
    connect(reply, SIGNAL(finished()), this, SLOT(processGetNodeLogs()));
}

void DapCommandController::addWallet(const QString &asWalletName)
{
     qInfo() << QString("addWallet(%1)").arg(asWalletName);
     DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.addWallet", asWalletName);
     connect(reply, SIGNAL(finished()), this, SLOT(processAddWallet()));
}

void DapCommandController::getWallets()
{
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.getWallets");
    connect(reply, SIGNAL(finished()), this, SLOT(processGetWallets()));
}
