#include "DapAbstractDataManager.h"
#include "Modules/DapModulesController.h"

DapAbstractDataManager::DapAbstractDataManager(DapModulesController *moduleController)
    : QObject{}
    , m_modulesController(moduleController)
{}
