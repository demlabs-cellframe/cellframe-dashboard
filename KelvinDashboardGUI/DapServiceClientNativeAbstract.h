#ifndef DAPSERVICECLIENTNATIVEABSTRACT_H
#define DAPSERVICECLIENTNATIVEABSTRACT_H

#include <QTimer>
#include <QDebug>

enum class DapServiceError {
    NO_ERRORS,
    USER_COMMAND_ABORT,
    UNABLE_START_SERVICE,
    UNABLE_STOP_SERVICE,
    SERVICE_NOT_FOUND,
    UNKNOWN_ERROR
};

class DapServiceClientNativeAbstract
{
public:
    DapServiceClientNativeAbstract();
    virtual ~DapServiceClientNativeAbstract() { }
    
    virtual bool isServiceRunning() = 0;
    
    virtual DapServiceError serviceInstallAndRun() = 0;
    virtual DapServiceError serviceStart() = 0;
    virtual DapServiceError serviceStop() = 0;
    virtual DapServiceError serviceRestart() = 0;
    
public slots:
    virtual DapServiceError init();
protected:
    bool m_isServiceRunning;

protected slots:
    virtual void onServiceInstalled();
    virtual void onServiceStarted();
    virtual void onServiceStopped();
};

#endif // DAPSERVICECLIENTNATIVEABSTRACT_H
