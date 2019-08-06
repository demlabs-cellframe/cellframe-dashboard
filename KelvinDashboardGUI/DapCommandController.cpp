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

void DapCommandController::clearLogModel()
{
    emit onClearLogModel();
}

/// Get node logs.
void DapCommandController::getNodeLogs()
{
    qInfo() << QString("getNodeLogs()");
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.getNodeLogs");
    connect(reply, SIGNAL(finished()), this, SLOT(processGetNodeLogs()));
}

void DapCommandController::processChangedLog()
{
//    QStringList tempLogModel;
//    for(int x{0}; x < aLogModel.count(); ++x)
//        tempLogModel.append(aLogModel.at(x).toString());
    emit onLogModel();
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
    auto name = reply->response().result().toVariant().toStringList().at(0);
    auto address = reply->response().result().toVariant().toStringList().at(1);
    emit sigWalletAdded(name, address);
}

void DapCommandController::processSendToken()
{
    qInfo() << "processSendToken()";
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    if (!reply) {
        qWarning() << "Invalid response received";
        return;
    }
    qInfo() << reply->response();
    emit sigCommandResult(reply->response().result());
    auto answer = reply->response().result().toVariant().toString();
    emit onTokenSended(answer);
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

void DapCommandController::processGetWalletInfo()
{
    qInfo() << "processGetWalletInfo()";
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    if (!reply || reply->response().result().toVariant().toStringList().count() <= 0) {
        qWarning() << "Invalid response received";
        return;
    }
    emit sigCommandResult(reply->response().result());
    QString name = reply->response().result().toVariant().toStringList().at(0);
    QString address = reply->response().result().toVariant().toStringList().at(1);
    QStringList temp = reply->response().result().toVariant().toStringList();
    QStringList tokens;
    QStringList balance;
    for(int x{2}; x < temp.count(); x++)
    {
        if(x%2)
        {
           tokens.append(temp[x]); 
           qDebug() << "TOKKEN " << temp[x];
        }
        else
        {
            balance.append(temp[x]);
            qDebug() << "BALANCE " << temp[x];
        }
    }
    
    emit sigWalletInfoChanged(name, address, balance, tokens);
}

void DapCommandController::processGetNodeNetwork()
{
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    emit sendNodeNetwork(reply->response().result().toVariant());
}

void DapCommandController::processGetNodeStatus()
{
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    emit sendNodeStatus(reply->response().result().toVariant());
}

void DapCommandController::processExecuteCommand()
{
    qInfo() << "processGetWalletInfo()";
    DapRpcServiceReply *reply = static_cast<DapRpcServiceReply *>(sender());
    if (!reply || reply->response().result().toVariant().toStringList().isEmpty()) {

        QString result = "Invalid response received";
        qWarning() << result;
        emit executeCommandChanged(result);
        return;
    }
    emit sigCommandResult(reply->response().result());
    QString result = reply->response().result().toVariant().toStringList().at(0);
    emit executeCommandChanged(result);
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

void DapCommandController::removeWallet(const QString &asWalletName)
{
    qInfo() << QString("removeWallet(%1)").arg(asWalletName);
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.removeWallet", asWalletName);
}

void DapCommandController::sendToken(const QString &asSendWallet, const QString &asAddressReceiver, const QString &asToken, const QString &aAmount)
{
    qInfo() << QString("sendToken(%1, %2, %3, %4)").arg(asSendWallet).arg(asAddressReceiver).arg(asToken).arg(aAmount);
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.sendToken", asSendWallet, asAddressReceiver, asToken, aAmount);
    connect(reply, SIGNAL(finished()), this, SLOT(processSendToken()));
}

void DapCommandController::getWallets()
{
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.getWallets");
    connect(reply, SIGNAL(finished()), this, SLOT(processGetWallets()));
}

void DapCommandController::getWalletInfo(const QString& asWalletName)
{
    qInfo() << QString("getWalletInfo(%1)").arg(asWalletName);
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.getWalletInfo", asWalletName);
    connect(reply, SIGNAL(finished()), this, SLOT(processGetWalletInfo()));
}

void DapCommandController::getNodeNetwork()
{
    qInfo() << QString("getNodeNetwork()");
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.getNodeNetwork");
    connect(reply, SIGNAL(finished()), this, SLOT(processGetNodeNetwork()));
}

void DapCommandController::setNodeStatus(const bool aIsOnline)
{
    /*DapRpcServiceReply *reply =*/ m_DAPRpcSocket->invokeRemoteMethod("RPCServer.setNodeStatus", aIsOnline);
//    connect(reply, SIGNAL(finished()), this, SLOT(processGetNodeStatus()));
}

void DapCommandController::executeCommand(const QString &command)
{
    qInfo() << QString("rpc executeCommand(%1)").arg(command);
    DapRpcServiceReply *reply = m_DAPRpcSocket->invokeRemoteMethod("RPCServer.executeCommand", command);
    connect(reply, SIGNAL(finished()), this, SLOT(processExecuteCommand()));
}
