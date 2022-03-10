#include "Service.h"
#include <QtDebug>

ServiceProcClass::ServiceProcClass() {
    serviceStatus.dwServiceType      = SERVICE_WIN32_OWN_PROCESS;
    serviceStatus.dwCurrentState     = SERVICE_START_PENDING;
    serviceStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_PAUSE_CONTINUE | SERVICE_ACCEPT_SHUTDOWN;
    serviceStatus.dwWin32ExitCode   = 0;
    serviceStatus.dwServiceSpecificExitCode = 0;
    serviceStatus.dwCheckPoint     = 0;
    serviceStatus.dwWaitHint       = 0;
    for (auto &h : serviceEvents) {
        h = CreateEvent(nullptr, false, false, nullptr); //auto-reset all of 'em
    }
}

void ServiceProcClass::UpdateServiceStatus(DWORD state, DWORD err) {
    serviceStatus.dwCurrentState = state;
    serviceStatus.dwWin32ExitCode = err;
    serviceStatus.dwWaitHint = 0;
    if (state == SERVICE_START_PENDING) {
        serviceStatus.dwControlsAccepted = 0;
    } else {
        serviceStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_PAUSE_CONTINUE | SERVICE_ACCEPT_SHUTDOWN;
    }
    if ((state == SERVICE_RUNNING) || (state == SERVICE_STOPPED)) {
        serviceStatus.dwCheckPoint = 0;
    } else {
        ++serviceStatus.dwCheckPoint;
    }
    SetServiceStatus(serviceStatusHandle, &serviceStatus);
}

DWORD WINAPI ServiceProcClass::ServiceWorkerThr(void *param) {
    ServiceProcClass *dis = (ServiceProcClass*)param;
    DWORD ret;
    for ( ; (ret = WaitForMultipleObjects(4, dis->serviceEvents, false, INFINITE)); ) {
        switch (ret) {
        case WAIT_OBJECT_0:
            //pause
            dis->UpdateServiceStatus(SERVICE_PAUSED, 0);
            // TODO: implement some pause algo...
            continue;
        case WAIT_OBJECT_0 + 1:
            //continue
            dis->UpdateServiceStatus(SERVICE_RUNNING, 0);
            continue;
        case WAIT_OBJECT_0 + 2:
            //stop
            dis->UpdateServiceStatus(SERVICE_STOPPED, 0);
            break;
        case WAIT_OBJECT_0 + 3:
            //shutdown
            dis->UpdateServiceStatus(SERVICE_STOPPED, 0);
            break;
        default:
            continue;
        }
        break;
    }
    emit dis->stopService();
    return ret;
}

ServiceProcClass::~ServiceProcClass() {
    for (auto &h : serviceEvents) {
        CloseHandle(h);
    }
}

void ControlHandler(DWORD request) {
    switch(request)
    {
    case SERVICE_CONTROL_PAUSE:
        ServiceProcClass::me()->UpdateServiceStatus(SERVICE_PAUSE_PENDING, 0);
        SetEvent(ServiceProcClass::me()->serviceEvents[0]);
        return;

    case SERVICE_CONTROL_CONTINUE:
        ServiceProcClass::me()->UpdateServiceStatus(SERVICE_CONTINUE_PENDING, 0);
        SetEvent(ServiceProcClass::me()->serviceEvents[1]);
        return;

    case SERVICE_CONTROL_STOP:
        ServiceProcClass::me()->UpdateServiceStatus(SERVICE_STOP_PENDING, 0);
        SetEvent(ServiceProcClass::me()->serviceEvents[2]);

    case SERVICE_CONTROL_SHUTDOWN:
        ServiceProcClass::me()->UpdateServiceStatus(SERVICE_STOP_PENDING, 0);
        SetEvent(ServiceProcClass::me()->serviceEvents[3]);
        return;

    default:
        break;
    }
    return;
}
