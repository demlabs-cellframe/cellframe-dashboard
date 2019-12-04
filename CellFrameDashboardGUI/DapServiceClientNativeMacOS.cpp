#include "DapServiceClientNativeMacOS.h"

#include <QtDebug>
#include <QMessageBox>

DapServiceClientNativeMacOS::DapServiceClientNativeMacOS()
{
    QString dapServiceNameToLower = QString(DAP_SERVICE_NAME).toLower();
    QString cmd = QString("ps -C %1 > /dev/null").arg(DAP_SERVICE_NAME);
    m_checkIsServiceRunningCommand = strdup(cmd.toLatin1().data());

    m_cmdTemplate = QString("service " + dapServiceNameToLower) + " %1";

    qDebug() << "command for check is service running: " << m_checkIsServiceRunningCommand;
}

DapServiceClientNativeMacOS::~DapServiceClientNativeMacOS()
{
    delete m_checkIsServiceRunningCommand;
}

bool DapServiceClientNativeMacOS::isServiceRunning()
{
    m_isServiceRunning =true;//  (::system(m_checkIsServiceRunningCommand) == 0);
    return m_isServiceRunning;
}

DapServiceError DapServiceClientNativeMacOS::serviceRestart()
{
    qDebug() << "Restart service name" << m_cmdTemplate.arg("restart").toLatin1().data();

    int retCode = ::system(m_cmdTemplate.arg("restart").toLatin1().data());
    qDebug() << "Restart result code:" << retCode;
    if(retCode != 0) {
        return DapServiceError::USER_COMMAND_ABORT;
    }

    return DapServiceError::NO_ERRORS;
}

/**
 * @brief SapNetworkClientNativeMacOS::serviceStart
 */
DapServiceError DapServiceClientNativeMacOS::serviceStart()
{
    // yes better use restart
    int ret = ::system(m_cmdTemplate.arg("restart").toLatin1().data());
    qDebug() << "serviceStart Result: " << ret;

    if(ret != 0) {
        return DapServiceError::USER_COMMAND_ABORT;
    }

    return DapServiceError::NO_ERRORS;
}

/**
 * @brief SapServiceClientNativeMacOS::serviceStop
 */
DapServiceError DapServiceClientNativeMacOS::serviceStop()
{
    int ret = ::system(m_cmdTemplate.arg("stop").toLatin1().data());
    qDebug() << "serviceStop result:" << ret;
    if(ret != 0) {
        return DapServiceError::USER_COMMAND_ABORT;
    }
    return DapServiceError::NO_ERRORS;
}
/**
 * @brief SapServiceClientNativeMacOS::serviceInstallAndRun
 */
DapServiceError DapServiceClientNativeMacOS::serviceInstallAndRun()
{
    return serviceStart();
}
