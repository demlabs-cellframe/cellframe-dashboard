#include "DapAbstractModule.h"

DapAbstractModule::DapAbstractModule(QObject *parent)
    :QObject(parent)
{

}

void DapAbstractModule::setStatusProcessing(bool status)
{
    m_statusProcessing = status;
}

bool DapAbstractModule::getStatusProcessing()
{
    return m_statusProcessing;
}

void DapAbstractModule::setName(QString name)
{
    m_name = name;
}

QString DapAbstractModule::getName()
{
    return m_name;
}
