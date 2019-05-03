#ifndef DAPSERVICECLIENTNATIVELINUX_H
#define DAPSERVICECLIENTNATIVELINUX_H

#include "DapServiceClientNativeAbstract.h"

class DapServiceClientNativeLinux : public DapServiceClientNativeAbstract
{
    const char* m_checkIsServiceRunningCommand;
    QString m_cmdTemplate;
public:
    DapServiceClientNativeLinux();
    ~DapServiceClientNativeLinux() override;
    bool isServiceRunning() override;
    DapServiceError serviceStart() override;
    DapServiceError serviceRestart() override;

    DapServiceError serviceStop() override;
    DapServiceError serviceInstallAndRun() override;
};

#endif // DAPSERVICECLIENTNATIVELINUX_H
