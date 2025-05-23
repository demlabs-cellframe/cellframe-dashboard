#include "DapModuleTokens.h"

DapModuleTokens::DapModuleTokens(DapModulesController *modulesCtrl, DapAbstractModule *parent)
    : DapAbstractModule(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_modulesCtrl(modulesCtrl)
{
}
