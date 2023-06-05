#include "DapModulesController.h"

#include <QQmlContext>
#include <QDebug>
#include <QSettings>

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

DapModulesController::DapModulesController(QQmlApplicationEngine *appEngine, QObject *parent)
    : QObject(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_appEngine(appEngine)
    , s_settings(new QSettings(this))
{

    initModules();

    m_timerUpdateData = new QTimer(this);
    connect(m_timerUpdateData, &QTimer::timeout, this, &DapModulesController::getWalletList);
    connect(m_timerUpdateData, &QTimer::timeout, this, &DapModulesController::getNetworkList);
    connect(s_serviceCtrl, &DapServiceController::walletsListReceived, this, &DapModulesController::rcvWalletList);
    connect(s_serviceCtrl, &DapServiceController::networksListReceived, this, &DapModulesController::rcvNetList);
    m_timerUpdateData->start(10);
    m_timerUpdateData->start(5000);

//    DapModuleTest *test = static_cast<DapModuleTest*>(getModule("testModule"));

//    test->test();
}


DapModulesController::~DapModulesController()
{
    QMap<QString, DapAbstractModule*>::iterator it = m_listModules.begin();
    for(;it != m_listModules.end(); ++it)
        delete it.value();

    delete m_timerUpdateData;
    delete s_settings;
}

void DapModulesController::initModules()
{
    addModule("walletModule", new DapModuleWallet(this));
//    addModule("dexModule", new DapModuleDex(s_modulesCtrl));
    addModule("txExplorerModule", new DapModuleTxExplorer(this));
//    addModule("certificatesModule", new DapModuleCertificates(s_modulesCtrl));
//    addModule("tokensModule", new DapModuleTokens(s_modulesCtrl));
//    addModule("consoleModule", new DapModuleConsole(s_modulesCtrl));
//    addModule("logsModule", new DapModuleLogs(s_modulesCtrl));
//    addModule("settingsModule", new DapModuleSettings(s_modulesCtrl));
//    addModule("dAppsModule", new DapModuledApps(s_modulesCtrl));
//    addModule("diagnosticsModule", new DapModuleDiagnostics(s_modulesCtrl));
    addModule("testModule", new DapModuleTest(this));

    s_appEngine->rootContext()->setContextProperty("modulesController", this);
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

void DapModulesController::getWalletList()
{
    s_serviceCtrl->requestToService("DapGetListNetworksCommand","");
}

void DapModulesController::getNetworkList()
{
    s_serviceCtrl->requestToService("DapGetListWalletsCommand","");
}

void DapModulesController::rcvWalletList(const QVariant &rcvData)
{
//    qDebug()<<"rcvWalletList";
    if(rcvData.toList().isEmpty() || m_walletList != rcvData.toList())
    {
        if(m_walletList.isEmpty() && m_currentWalletName.isEmpty())
        {
            m_walletList = rcvData.toList();

            //--------------------------------------//
            /* The first load of the settings.
             * As long as there is no wallet data,
             * initialization is not necessary
             */

            if(!m_firstDataLoad)
            {
                restoreIndex();
                m_firstDataLoad = true;
                emit initDone();
            }
            //--------------------------------------//
        }
        else
            m_walletList = rcvData.toList();

        restoreIndex();
        static_cast<DapModuleWallet*>(m_listModules.value("walletModule"))
            ->getWalletsInfo(QStringList()<<"true");

        emit walletsListUpdated();
    }
}

void DapModulesController::rcvNetList(const QVariant &rcvData)
{
    m_netList = rcvData.toList();
    emit netListUpdated(); //todo
}

void DapModulesController::setCurrentWalletIndex(int newIndex)
{
//    qDebug()<<"setCurrentWalletIndex";
    if(m_walletList.count() - 1 < newIndex
        || m_walletList.isEmpty()
        || newIndex == m_currentWalletIndex)
        return ;

    m_currentWalletIndex = newIndex;
    m_currentWalletName = m_walletList.at(newIndex).toString();

    s_settings->setValue("walletName", m_currentWalletName);
    emit currentWalletIndexChanged();
    emit currentWalletNameChanged();
}


void DapModulesController::restoreIndex()
{
//    qDebug()<<"restoreIndex";
    QString prevName = s_settings->value("walletName", "").toString();

    if(!prevName.isEmpty())
    {
        for(int i = 0; i < m_walletList.count(); i++)
        {
            if(m_walletList.at(i).toString() == prevName)
            {
                setCurrentWalletIndex(i);
                return ;
            }
        }
    }

    setCurrentWalletIndex(0);
}

QString DapModulesController::getComission(QString token, QString network)
{
//    qDebug()<<"get comisson" << token << network;
    return "0.05";
}
