#ifndef DAPSERVICECLIENTNATIVEMACOS_H
#define DAPSERVICECLIENTNATIVEMACOS_H

#include "DapServiceClientNativeAbstract.h"

class DapServiceClientNativeMacOS : public DapServiceClientNativeAbstract
{
    const char* m_checkIsServiceRunningCommand;
    QString m_cmdTemplate;
public:
    DapServiceClientNativeMacOS();
    ~DapServiceClientNativeMacOS() override;
    bool isServiceRunning() override;
    DapServiceError serviceStart() override;
    DapServiceError serviceRestart() override;

    DapServiceError serviceStop() override;
    DapServiceError serviceInstallAndRun() override;
};

#endif // DAPSERVICECLIENTNATIVEMACOS_H
