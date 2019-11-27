#include "DapServiceClientNativeAbstract.h"

DapServiceClientNativeAbstract::DapServiceClientNativeAbstract()
{
    m_isServiceRunning = false;
}

DapServiceError DapServiceClientNativeAbstract::init()
{
    qInfo() << "DapServiceClientNativeAbstract::init()";
    DapServiceError result = DapServiceError::NO_ERRORS;
    if(!isServiceRunning())
    {
        qInfo() << "Install the service in the system";

        result = serviceInstallAndRun();

        if(result != DapServiceError::NO_ERRORS)
            return result;

        if(isServiceRunning())
        {
            onServiceStarted();
        }
        else
        {
            qCritical() << "Service not started after "
                           "'serviceInstallAndRun' operation!";
        }
    }
    else
    {
        onServiceStarted();
    }
    return result;
}

void DapServiceClientNativeAbstract::onServiceInstalled()
{
    qInfo() << "DapServiceClientNativeAbstract::onServiceInstalled()";
    if(isServiceRunning())
        onServiceStarted();
}

void DapServiceClientNativeAbstract::onServiceStarted()
{

}

void DapServiceClientNativeAbstract::onServiceStopped()
{

}
