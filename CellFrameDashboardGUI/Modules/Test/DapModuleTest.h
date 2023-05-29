#ifndef DAPMODULETEST_H
#define DAPMODULETEST_H

#include <QObject>
#include <QDebug>
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "../Wallet/DapModuleWallet.h"

#include "DapServiceController.h"

class DapModuleTest : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleTest(DapModulesController * modulesCtrl, DapModuleWallet* moduleWallet, DapAbstractModule *parent = nullptr);


private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;
    DapModuleWallet       *m_walletModule;
};

#endif // DAPMODULETEST_H
