#include "DapModulesController.h"

DapModulesController::DapModulesController(QObject *parent)
    : QObject(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
{
}

DapModulesController &DapModulesController::getInstance()
{
    static DapModulesController instance;
    return instance;
}

void DapModulesController::setListModules(QMap<QString, DapAbstractModule*> &list)
{
    m_listModules = list;
}

QMap<QString, DapAbstractModule*> DapModulesController::getListModules()
{
    return m_listModules;
}
