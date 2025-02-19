#include "DapAbstractMasterNodeCommand.h"

DapAbstractMasterNodeCommand::DapAbstractMasterNodeCommand(DapServiceController *serviceController)
    :m_serviceController(serviceController)
{}

DapAbstractMasterNodeCommand::~DapAbstractMasterNodeCommand()
{}

void DapAbstractMasterNodeCommand::addDataMasterNodeInfo(const QString& key, const QVariant& data)
{
    m_masterNodeInfo.insert(key, data);
    if(m_newDataCallback)
    {
        m_newDataCallback(key, data);
    }
}

void DapAbstractMasterNodeCommand::stopCreationMasterNode(int code, const QString& message)
{
    if(m_stopCreationCallback)
    {
        m_stopCreationCallback(code, message);
    }
}

void DapAbstractMasterNodeCommand::stageComplated()
{
    if(m_stageComplatedCallback)
    {
        m_stageComplatedCallback();
    }
}

void DapAbstractMasterNodeCommand::cencelRegistration()
{
    m_masterNodeInfo.clear();
}
