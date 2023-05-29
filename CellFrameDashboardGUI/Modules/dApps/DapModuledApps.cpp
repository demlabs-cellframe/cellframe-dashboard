#include "DapModuledApps.h"

DapModuledApps::DapModuledApps(DapModulesController *modulesCtrl, DapAbstractModule *parent)
    : DapAbstractModule(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_modulesCtrl(modulesCtrl)
{
}
