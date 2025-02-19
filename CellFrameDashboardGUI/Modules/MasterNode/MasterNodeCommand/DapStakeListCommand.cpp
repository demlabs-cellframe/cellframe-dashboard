#include "DapStakeListCommand.h"

DapStakeListCommand::DapStakeListCommand(DapServiceController *serviceController)
    :DapAbstractMasterNodeCommand(serviceController)
{
    connect(m_serviceController, &DapServiceController::rcvGetListKeysCommand, this, &DapStakeListCommand::respondListKeys);
}

DapStakeListCommand::~DapStakeListCommand()
{
}

void DapStakeListCommand::getListKeys(const QString &network, const QString &nodeAddr)
{
    m_requiredNode = nodeAddr;
    m_networkName = network;
    m_serviceController->requestToService("DapGetListKeysCommand", QStringList() << network);
}

void DapStakeListCommand::respondListKeys(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    if(replyObj.contains("error"))
    {
        qWarning() << "[DapStakeListCommand] [respondListKeys] Error message. " << replyObj["error"].toString();
        errorReceived(14, "[respondListKeys]" + replyObj["error"].toString());
        return;
    }
    if(replyObj["result"].isNull())
    {
        errorReceived(14, "[respondListKeys] The result is empty in the response.");
        return;
    }
    QJsonObject result = replyObj["result"].toObject();

    QString networkName = result.value("networkName").toString();

    if(networkName != m_networkName)
    {
        qDebug() << "[Master node] result network: " << networkName << "\tcurrent network: " << m_networkName;
        return;
    }
    if(!result.contains("keys"))
    {
        qWarning() << "[DapModuleMasterNode] Unexpected problem, key -keys- was not found.";
        errorReceived(14, "Other problems.");
        return;
    }

    auto keys = result["keys"].toArray();
    for(const auto& itemValue: keys)
    {
        auto item = itemValue.toObject();
        QString nodeAddr;
        if(item.contains("node addr"))
        {
            nodeAddr = item["node addr"].toString();
        }
        else
        {
            qWarning() << "[DapStakeListCommand] Unexpected problem, key -node addr- was not found.";
        }

        if(nodeAddr != m_requiredNode)
        {
            continue;
        }
        nodeFound(item);
        return;
    }

    nodeNotFound();
}

void DapStakeListCommand::nodeNotFound()
{
    qInfo() << QString("The node with address %1 was not found in the list.").arg(m_requiredNode);
}

void DapStakeListCommand::nodeFound(const QJsonObject& nodeInfo)
{
    emit responseRequest(nodeInfo);
}

void DapStakeListCommand::errorReceived(int errorNumber, const QString& message)
{
    emit errorResponse(errorNumber, message);
}
