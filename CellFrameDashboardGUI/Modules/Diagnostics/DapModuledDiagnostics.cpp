#include "DapModuledDiagnostics.h"

DapModuledDiagnostics::DapModuledDiagnostics(DapModulesController *modulesCtrl, DapAbstractModule *parent)
    : DapAbstractModule(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_modulesCtrl(modulesCtrl)
{
}

