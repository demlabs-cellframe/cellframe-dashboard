#ifndef DAPSERVICECLIENTNATIVEWIN_H
#define DAPSERVICECLIENTNATIVEWIN_H

#include "DapServiceClientNativeAbstract.h"

class DapServiceClientNativeWin : public DapServiceClientNativeAbstract
{
public:
    DapServiceClientNativeWin();
    ~DapServiceClientNativeWin() override;
    bool isServiceRunning() override;
    DapServiceError serviceStart() override;
    DapServiceError serviceRestart() override;

    DapServiceError serviceStop() override;
    DapServiceError serviceInstallAndRun() override;
};

#endif // DAPSERVICECLIENTNATIVEWIN_H
