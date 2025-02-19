#include "DapAbstractDataManager.h"
#include "Modules/DapModulesController.h"

DapAbstractDataManager::DapAbstractDataManager(DapModulesController *moduleController)
    : QObject{}
    , m_modulesController(moduleController)
{
    connect(m_modulesController, &DapModulesController::initDone, this, &DapAbstractDataManager::initManager);
}

void DapAbstractDataManager::initManager() {}
