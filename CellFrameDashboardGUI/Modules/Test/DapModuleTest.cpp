#include "DapModuleTest.h"

DapModuleTest::DapModuleTest(DapModulesController *modulesCtrl, DapModuleWallet* moduleWallet, DapAbstractModule *parent)
    : DapAbstractModule(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_modulesCtrl(modulesCtrl)
    , m_walletModule(moduleWallet)
{
    setName("testModule");

    qDebug()<<m_walletModule->testWal;
}
