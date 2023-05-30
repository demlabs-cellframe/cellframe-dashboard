#include "DapModuleTest.h"

DapModuleTest::DapModuleTest(DapModulesController *modulesCtrl, DapAbstractModule *parent)
    : DapAbstractModule(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_modulesCtrl(modulesCtrl)
{
}

void DapModuleTest::test()
{
    DapModuleWallet *wal = (DapModuleWallet*)s_modulesCtrl->getListModules().find("M_wallet").value();

    qDebug()<< wal->testWal << s_modulesCtrl->testData;
}
