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
    m_listModules.insert("M_wallet",       m_wallet       = new DapModuleWallet(s_modulesCtrl));
    m_listModules.insert("M_dex",          m_dex          = new DapModuleDex(s_modulesCtrl));
    m_listModules.insert("M_txExplorer",   m_txExplorer   = new DapModuleTxExplorer(s_modulesCtrl));
    m_listModules.insert("M_certificates", m_certificates = new DapModuleCertificates(s_modulesCtrl));
    m_listModules.insert("M_tokens",       m_tokens       = new DapModuleTokens(s_modulesCtrl));
    m_listModules.insert("M_console",      m_console      = new DapModuleConsole(s_modulesCtrl));
    m_listModules.insert("M_logs",         m_logs         = new DapModuleLogs(s_modulesCtrl));
    m_listModules.insert("M_settings",     m_settings     = new DapModuleSettings(s_modulesCtrl));
    m_listModules.insert("M_dApps",        m_dApps        = new DapModuledApps(s_modulesCtrl));
    m_listModules.insert("M_diagnostics",  m_diagnostics  = new DapModuleDiagnostics(s_modulesCtrl));

    m_listModules.insert("M_test",         m_test         = new DapModuleTest(s_modulesCtrl));
    //-----

    //Set context in qml
    s_appEngine->rootContext()->setContextProperty("M_wallet",       m_wallet);
    s_appEngine->rootContext()->setContextProperty("M_dex",          m_dex);
    s_appEngine->rootContext()->setContextProperty("M_txExplorer",   m_txExplorer);
    s_appEngine->rootContext()->setContextProperty("M_certificates", m_certificates);
    s_appEngine->rootContext()->setContextProperty("M_tokens",       m_tokens);
    s_appEngine->rootContext()->setContextProperty("M_console",      m_console);
    s_appEngine->rootContext()->setContextProperty("M_logs",         m_logs);
    s_appEngine->rootContext()->setContextProperty("M_settings",     m_settings);
    s_appEngine->rootContext()->setContextProperty("M_dApps",        m_dApps);
    s_appEngine->rootContext()->setContextProperty("M_diagnostics",  m_diagnostics);

    s_appEngine->rootContext()->setContextProperty("M_test",         m_test);
    //-----

    //Set name modules
    QMap<QString, DapAbstractModule*>::iterator it = m_listModules.begin();
    for(;it != m_listModules.end(); ++it)
        it.value()->setName(it.key());
    //-----
}
