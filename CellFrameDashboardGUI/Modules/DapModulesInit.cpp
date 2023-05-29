#include "DapModulesInit.h"

static DapModulesController * s_modulesCtrl = &DapModulesController::getInstance();

DapModulesInit::DapModulesInit(QQmlApplicationEngine *appEngine, QObject *parent)
    : QObject(parent),
      s_appEngine(appEngine)
{
    initModules();
}

void DapModulesInit::initModules()
{
   m_listModules.append(m_wallet = new DapModuleWallet(s_modulesCtrl));
   m_listModules.append(m_test = new DapModuleTest(s_modulesCtrl, m_wallet));
   //-----

   //Set context in qml
   for(auto module : qAsConst(m_listModules))
       s_appEngine->rootContext()->setContextProperty(module->getName(), module);


   qDebug()<<"done init";
}
