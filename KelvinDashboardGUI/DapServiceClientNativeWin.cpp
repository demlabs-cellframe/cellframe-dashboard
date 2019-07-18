#include "DapServiceClientNativeWin.h"

DapServiceClientNativeWin::DapServiceClientNativeWin()
{
}

bool DapServiceClientNativeWin::isServiceRunning()
{
    return true;
}

DapServiceError DapServiceClientNativeWin::serviceInstallAndRun() {
    return DapServiceError::NO_ERRORS;
}

DapServiceError DapServiceClientNativeWin::serviceStart() {
    return DapServiceError::NO_ERRORS;
}

DapServiceError DapServiceClientNativeWin::serviceRestart() {
    return DapServiceError::NO_ERRORS;
}

DapServiceError DapServiceClientNativeWin::serviceStop() {
    return DapServiceError::NO_ERRORS;
}

DapServiceClientNativeWin::~DapServiceClientNativeWin() {

}
