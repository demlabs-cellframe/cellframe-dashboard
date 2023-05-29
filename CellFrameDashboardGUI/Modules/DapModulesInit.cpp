#include "DapModulesInit.h"

static DapModulesController * s_modulesCtrl = &DapModulesController::getInstance();

DapModulesInit::DapModulesInit(QQmlApplicationEngine *appEngine, QObject *parent)
    : QObject(parent)
    , s_appEngine(appEngine)
{
    initModules();
    s_modulesCtrl->setListModules(m_listModules);

    m_test->test();
}

void DapModulesInit::initModules()
{
    //Create modules
    m_listModules.insert("wallet",       m_wallet       = new DapModuleWallet(s_modulesCtrl));
    m_listModules.insert("dex",          m_dex          = new DapModuleDex(s_modulesCtrl));
    m_listModules.insert("txExplorer",   m_txExplorer   = new DapModuleTxExplorer(s_modulesCtrl));
    m_listModules.insert("certificates", m_certificates = new DapModuleCertificates(s_modulesCtrl));
    m_listModules.insert("tokens",       m_tokens       = new DapModuleTokens(s_modulesCtrl));
    m_listModules.insert("console",      m_console      = new DapModuleConsole(s_modulesCtrl));
    m_listModules.insert("logs",         m_logs         = new DapModuleLogs(s_modulesCtrl));
    m_listModules.insert("settings",     m_settings     = new DapModuleSettings(s_modulesCtrl));
    m_listModules.insert("dApps",        m_dApps        = new DapModuledApps(s_modulesCtrl));
    m_listModules.insert("diagnostics",  m_diagnostics  = new DapModuledDiagnostics(s_modulesCtrl));

    m_listModules.insert("test",         m_test         = new DapModuleTest(s_modulesCtrl));
    //-----

    //Set context in qml
    s_appEngine->rootContext()->setContextProperty("wallet",       m_wallet);
    s_appEngine->rootContext()->setContextProperty("dex",          m_dex);
    s_appEngine->rootContext()->setContextProperty("txExplorer",   m_txExplorer);
    s_appEngine->rootContext()->setContextProperty("certificates", m_certificates);
    s_appEngine->rootContext()->setContextProperty("tokens",       m_tokens);
    s_appEngine->rootContext()->setContextProperty("console",      m_console);
    s_appEngine->rootContext()->setContextProperty("logs",         m_logs);
    s_appEngine->rootContext()->setContextProperty("settings",     m_settings);
    s_appEngine->rootContext()->setContextProperty("dApps",        m_dApps);
    s_appEngine->rootContext()->setContextProperty("diagnostics",  m_diagnostics);

    s_appEngine->rootContext()->setContextProperty("test",         m_test);
    //-----

    //Set name modules
    QMap<QString, DapAbstractModule*>::iterator it = m_listModules.begin();
    for(;it != m_listModules.end(); ++it)
        it.value()->setName(it.key());
    //-----
}
