#pragma once

#include <QObject>
#include <windows.h>

class ServiceProcClass: public QObject {
    Q_OBJECT
private:
    SERVICE_STATUS          serviceStatus;
    HANDLE hWorkerThr;
    // Service manager events
public:
    constexpr static LPCWSTR serviceName = L"" DAP_BRAND "Service";
    ServiceProcClass();
    ~ServiceProcClass();
    static ServiceProcClass *me() {
        static ServiceProcClass _me;
        return &_me;
    }
    SERVICE_STATUS_HANDLE   serviceStatusHandle;
    HANDLE serviceEvents[4] = { nullptr };
    void UpdateServiceStatus(DWORD state, DWORD err);
    static DWORD WINAPI ServiceWorkerThr(void *param);
signals:
    void stopService();
    // TODO: some more flexible algo...
};

void ControlHandler(DWORD request);
