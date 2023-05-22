#include "DapModulesController.h"


DapModulesController::DapModulesController(QQmlApplicationEngine *appEngine, DapServiceController *serviceCtrl, QObject *parent)
    : QObject(parent),
      s_appEngine(appEngine),
      s_serviceCtrl(serviceCtrl)
{

    m_wallet = new DapModuleWallet(s_appEngine, s_serviceCtrl);

}
