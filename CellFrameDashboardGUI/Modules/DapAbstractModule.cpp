#include "DapAbstractModule.h"

DapAbstractModule::DapAbstractModule(QObject *parent)
    :QObject(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
{

}

bool DapAbstractModule::statusProcessing()
{
    return m_statusProcessing;
}
void DapAbstractModule::setStatusProcessing(bool status)
{
    m_statusProcessing = status;
    emit statusProcessingChanged();
}


void DapAbstractModule::setName(QString name)
{
    m_name = name;
}

QString DapAbstractModule::getName()
{
    return m_name;
}

void DapAbstractModule::setStatusInit(bool status)
{
    m_statusInit = status;
    emit statusInitChanged();
}
