#include "DapModuleTest.h"

#include <QDebug>
#include "../Wallet/DapModuleWallet.h"

DapModuleTest::DapModuleTest(DapModulesController *parent)
    : DapAbstractModule(parent)
    , modules(parent)
{
}

void DapModuleTest::test()
{
    DapModuleWallet *wal = static_cast<DapModuleWallet*>
            (modules->getModule("walletModule"));

    if (wal == nullptr)
        qDebug() << "ERROR nullptr";

    qDebug()<< wal->testWal;
}
