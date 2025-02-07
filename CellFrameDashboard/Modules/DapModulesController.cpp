#include "DapModulesController.h"

#include <QQmlContext>
#include <QDebug>
#include <QSettings>

//***Modules***//
#include "Wallet/DapModuleWalletAddition.h"
#include "Dex/DapModuleDexLightPanel.h"
#include "TxExplorer/DapModuleTxExplorerAddition.h"
#include "Certificates/DapModuleCertificates.h"
#include "Tokens/DapModuleTokens.h"
#include "Console/DapModuleConsole.h"
#include "Logs/DapModuleLogs.h"
#include "Settings/DapModuleSettings.h"
#include "dApps/DapModuledApps.h"
#include "Diagnostics/DapModuleDiagnostics.h"
#include "Orders/DapModuleOrders.h"
#include "MasterNode/DapModuleMasterNode.h"
#include "Networks/DapModuleNetworks.h"
#include "DapDataManagerController.h"

#include "Models/DapWalletListModel.h"

static DapAbstractWalletList * m_walletListModel = DapWalletListModel::global();

DapModulesController::DapModulesController(QQmlApplicationEngine *appEngine, DapServiceController* serviceController, int countRestart, QObject *parent)
    : QObject(parent)
    , s_serviceCtrl(serviceController)
    , m_managerController(new DapDataManagerController(this))
    , s_appEngine(appEngine)
    , s_settings(new QSettings(this))
    , m_countRestart(countRestart)
{
    connect(m_managerController, &DapDataManagerController::networkListChanged, this, &DapModulesController::readyReceiveData);

    if(DapNodeMode::getNodeMode() == DapNodeMode::REMOTE)
    {
        connect(s_serviceCtrl, &DapServiceController::onServiceStarted, this, &DapModulesController::readyReceiveData);
    }

    initWorkers();
    initModules();
    s_appEngine->rootContext()->setContextProperty("managerController", m_managerController);
}

DapModulesController::~DapModulesController()
{
    QMap<QString, DapAbstractModule*>::iterator it = m_listModules.begin();
    for(;it != m_listModules.end(); ++it)
        delete it.value();

    QMap<QString, QObject*>::iterator it_w = m_listWorkers.begin();
    for(;it_w != m_listWorkers.end(); ++it_w)
        delete it_w.value();

    delete s_settings;
}

void DapModulesController::readyReceiveData()
{
    if(!m_firstDataLoad)
    {
        m_firstDataLoad = true;
        emit initDone();
    }
}

void DapModulesController::initModules()
{
    addModule("walletModule", m_skinWallet ? new DapModuleWalletAddition(this) : new DapModuleWallet(this));
    addModule("dexModule", new DapModuleDexLightPanel(this));
    addModule("txExplorerModule", m_skinWallet ? new DapModuleTxExplorerAddition(this) : new DapModuleTxExplorer(this));
    addModule("settingsModule", new DapModuleSettings(this));
    addModule("networksModule", new DapModuleNetworks(this));
    addModule("dAppsModule", new DapModuledApps(this));

    if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL)
    {
        //    addModule("tokensModule", new DapModuleTokens(s_modulesCtrl));
        addModule("certificatesModule", new DapModuleCertificates(this));
        addModule("consoleModule", new DapModuleConsole(this));
        addModule("logsModule", new DapModuleLog(this));
        addModule("diagnosticsModule", new DapModuleDiagnostics(this));
        addModule("ordersModule", new DapModuleOrders(this));
        addModule("nodeMasterModule", new DapModuleMasterNode(this));
    }

    s_appEngine->rootContext()->setContextProperty("diagnosticNodeModel", DapDiagnosticModel::global());

    s_appEngine->rootContext()->setContextProperty("modulesController", this);
}

void DapModulesController::initWorkers()
{
    addWorker("dateWorker", new DateWorker(this));
    addWorker("stringWorker", new StringWorker(this));
    addWorker("mathWorker", new MathWorker(this));
}

void DapModulesController::addModule(const QString &key, DapAbstractModule *p_module)
{
    m_listModules.insert(key, p_module);
    s_appEngine->rootContext()->setContextProperty(key, p_module);
    p_module->setName(key);
}

void DapModulesController::addWorker(const QString &key, QObject *p_worker)
{
    m_listWorkers.insert(key, p_worker);
    s_appEngine->rootContext()->setContextProperty(key, p_worker);
}

DapAbstractModule *DapModulesController::getModule(const QString &key)
{
    if (!m_listModules.contains(key))
        return nullptr;
    else
        return m_listModules.value(key);
}

void DapModulesController::cleareProgressInfo()
{
    m_networksLoadProgress.clear();
    nodeLoadProgressJson = QJsonArray();
    setNodeLoadProgress(0);
}

void DapModulesController::setIsNodeWorking(bool isWorking)
{
    if(m_isNodeWorking == isWorking)
        return;

    if(isWorking)
    {
        cleareProgressInfo();
        qInfo()<<"[NODE LOADED]";
    }
    m_isNodeWorking = isWorking;

    emit nodeWorkingChanged();
}

void DapModulesController::setNodeLoadProgress(int progress)
{
    if(m_nodeLoadProgress != progress && !m_isNodeWorking)
        qInfo()<<"[NODE LOADING PERCENT] - " << m_nodeLoadProgress << " %";

    m_nodeLoadProgress = progress;
    emit nodeLoadProgressChanged();
}

void DapModulesController::setCurrentNetwork(const QString& name)
{
    m_currentNetworkName = name;
    this->getSettings()->setValue("networkName", name);
    emit currentNetworkChanged(name);
}

///----NOTIFY DATA----///

void DapModulesController::setNotifyCtrl(DapNotifyController *notifyController)
{
    m_notifyCtrl = notifyController;

    emit sigNotifyControllerIsInit();
}

//Wallets
void DapModulesController::slotRcvNotifyWalletList(QJsonDocument doc)
{

}

void DapModulesController::slotRcvNotifyWalletInfo(QJsonDocument doc)
{

}

void DapModulesController::slotRcvNotifyWalletsInfo(QJsonDocument doc)
{

}
