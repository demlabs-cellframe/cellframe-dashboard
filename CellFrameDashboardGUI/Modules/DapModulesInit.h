#ifndef DAPMODULESINIT_H
#define DAPMODULESINIT_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>
#include "qqmlcontext.h"

#include "DapAbstractModule.h"
#include "Wallet/DapModuleWallet.h"
#include "Dex/DapModuleDex.h"
#include "TxExplorer/DapModuleTxExplorer.h"
#include "Certificates/DapModuleCertificates.h"
#include "Tokens/DapModuleTokens.h"
#include "Console/DapModuleConsole.h"
#include "Logs/DapModuleLogs.h"
#include "Settings/DapModuleSettings.h"
#include "dApps/DapModuledApps.h"
#include "Diagnostics/DapModuleDiagnostics.h"

#include "Test/DapModuleTest.h"

class DapModulesInit : public QObject
{
    Q_OBJECT
public:
    DapModulesInit(QQmlApplicationEngine *appEngine, QObject *parent = nullptr);

    QQmlApplicationEngine *s_appEngine;

    //Modules
    QMap<QString, DapAbstractModule*> m_listModules;
    DapModuleWallet       * m_wallet;
    DapModuleDex          * m_dex;
    DapModuleTxExplorer   * m_txExplorer;
    DapModuleCertificates * m_certificates;
    DapModuleTokens       * m_tokens;
    DapModuleConsole      * m_console;
    DapModuleLogs         * m_logs;
    DapModuleSettings     * m_settings;
    DapModuledApps        * m_dApps;
    DapModuleDiagnostics * m_diagnostics;

    DapModuleTest * m_test;

public:
    void updateData();
    void initModules();

};

#endif // DAPMODULESINIT_H
