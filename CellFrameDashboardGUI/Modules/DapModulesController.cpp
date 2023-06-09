#include "DapModulesController.h"

#include <QQmlContext>
#include <QDebug>

#include "Wallet/DapModuleWallet.h"
#include "Dex/DapModuleDex.h"
#include "TxExplorer/DapModuleTxExplorer.h"
#include "Certificates/DapModuleCertificates.h"
#include "Tokens/DapModuleTokens.h"
#include "Console/DapModuleConsole.h"
#include "Logs/DapModuleLogs.h"
#include "Settings/DapModuleSettings.h"
#include "dApps/DapModuledApps.h"
#include "Diagnostics/DapModuledDiagnostics.h"

#include "Test/DapModuleTest.h"

DapModulesController::DapModulesController(QQmlApplicationEngine *appEngine, QObject *parent)
    : QObject(parent)
    , s_appEngine(appEngine)
{
    initModules();

    DapModuleTest *test = static_cast<DapModuleTest*>(getModule("testModule"));

    test->test();
}

DapModulesController::~DapModulesController()
{
    QMap<QString, DapAbstractModule*>::iterator it = m_listModules.begin();
    for(;it != m_listModules.end(); ++it)
        delete it.value();
}

void DapModulesController::initModules()
{
    addModule("walletModule", new DapModuleWallet(this));
    addModule("consoleModule",
              new DapModuleConsole(s_appEngine->rootContext(), this));
    addModule("logsModule",
              new DapModuleLog(s_appEngine->rootContext(), this));
//    addModule("dexModule", new DapModuleDex(s_modulesCtrl));
//    addModule("txExplorerModule", new DapModuleTxExplorer(s_modulesCtrl));
//    addModule("certificatesModule", new DapModuleCertificates(s_modulesCtrl));
//    addModule("tokensModule", new DapModuleTokens(s_modulesCtrl));
//    addModule("consoleModule", new DapModuleConsole(s_modulesCtrl));
//    addModule("logsModule", new DapModuleLogs(s_modulesCtrl));
//    addModule("settingsModule", new DapModuleSettings(s_modulesCtrl));
//    addModule("dAppsModule", new DapModuledApps(s_modulesCtrl));
//    addModule("diagnosticsModule", new DapModuledDiagnostics(s_modulesCtrl));
    addModule("testModule", new DapModuleTest(this));
}

void DapModulesController::addModule(const QString &key, DapAbstractModule *p_module)
{
    m_listModules.insert(key, p_module);
    s_appEngine->rootContext()->setContextProperty(key, p_module);
    p_module->setName(key);
}

DapAbstractModule *DapModulesController::getModule(const QString &key)
{
    if (!m_listModules.contains(key))
        return nullptr;
    else
        return m_listModules.value(key);
}
