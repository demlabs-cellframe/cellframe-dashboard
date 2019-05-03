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
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    if (!reply) {
        qWarning() << "Invalid response received";
        return;
    }
    emit sigCommandResult(reply->response().result());
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
