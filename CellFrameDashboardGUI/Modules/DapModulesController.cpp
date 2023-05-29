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
