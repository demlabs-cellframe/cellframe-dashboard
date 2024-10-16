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

#include "Models/DapWalletListModel.h"
#include "CellframeNode.h"

static DapAbstractWalletList * m_walletListModel = DapWalletListModel::global();

DapModulesController::DapModulesController(QQmlApplicationEngine *appEngine, QObject *parent)
    : QObject(parent)
    , s_appEngine(appEngine)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_settings(new QSettings(this))
    , m_netListModel(new DapStringListModel)
{
    auto projectSkin = s_settings->value("project_skin", "").toString();
    if(projectSkin == "wallet") m_skinWallet = true;

    initWorkers();
    initModules();
    m_netListModel->setStringList({"All"});
    s_appEngine->rootContext()->setContextProperty("netListModelGlobal", m_netListModel);
    m_timerUpdateData = new QTimer(this);

    getNetworkList();
    m_timerUpdateData->start(5000);
    connect(s_serviceCtrl, &DapServiceController::networksListReceived, this, &DapModulesController::rcvNetList, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::signalChainsLoadProgress, this, &DapModulesController::rcvChainsLoadProgress, Qt::QueuedConnection);
}

DapModulesController::~DapModulesController()
{
    QMap<QString, DapAbstractModule*>::iterator it = m_listModules.begin();
    for(;it != m_listModules.end(); ++it)
        delete it.value();

    QMap<QString, QObject*>::iterator it_w = m_listWorkers.begin();
    for(;it_w != m_listWorkers.end(); ++it)
        delete it.value();

    delete m_timerUpdateData;
    delete s_settings;
}

void DapModulesController::initModules()
{
    addModule("walletModule", m_skinWallet ? new DapModuleWalletAddition(this) : new DapModuleWallet(this));
    addModule("dexModule", new DapModuleDexLightPanel(this));
    addModule("txExplorerModule", m_skinWallet ? new DapModuleTxExplorerAddition(this) : new DapModuleTxExplorer(this));
    addModule("certificatesModule", new DapModuleCertificates(this));
//    addModule("tokensModule", new DapModuleTokens(s_modulesCtrl));
    addModule("consoleModule", new DapModuleConsole(this));
    addModule("logsModule", new DapModuleLog(this));
    addModule("settingsModule", new DapModuleSettings(this));
    addModule("dAppsModule", new DapModuledApps(this));
    addModule("diagnosticsModule", new DapModuleDiagnostics(this));
    addModule("ordersModule", new DapModuleOrders(this));
    addModule("nodeMasterModule", new DapModuleMasterNode(this));

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

void DapModulesController::setCurrentWallet(const QPair<int,QString>& dataWallet)
{
    m_currentWalletIndex = dataWallet.first;
    m_currentWalletName = dataWallet.second;
}

void DapModulesController::updateListWallets()
{
    s_serviceCtrl->requestToService("DapGetListWalletsCommand","");
}

void DapModulesController::updateListNetwork()
{
    s_serviceCtrl->requestToService("DapGetListNetworksCommand","");
}

void DapModulesController::rcvNetList(const QVariant &rcvData)
{
    QJsonDocument replyDoc = QJsonDocument::fromJson(rcvData.toByteArray());
    QJsonObject replyObj = replyDoc.object();
    QJsonArray netArray = replyObj["result"].toArray();
    QStringList netList;
    for(const auto& itemValue: netArray)
    {
        netList.append(itemValue.toString());
    }

    if(m_netList == netList)
    {
        return;
    }
    m_netList = netList;

    cleareProgressInfo();

    updateNetworkListModel();
    emit netListUpdated();
    if(m_netList.isEmpty() && m_isNodeWorking)
    {
        m_isNodeWorking = false;
        emit nodeWorkingChanged();
    }
    else if(!m_netList.isEmpty() && !m_isNodeWorking)
    {
        m_isNodeWorking = true;
        emit nodeWorkingChanged();
    }
}

void DapModulesController::cleareProgressInfo()
{
    m_networksLoadProgress.clear();
    nodeLoadProgressJson = QJsonArray();
    setNodeLoadProgress(0);
}

void DapModulesController::rcvChainsLoadProgress(const QVariantMap &rcvData)
{
    if(rcvData.isEmpty())
    {
        setNodeLoadProgress(0);
        return;
    }

    // write all answers
    QJsonObject obj;
    for(const QString &key: rcvData.keys())
        obj.insert(key, rcvData.value(key).toJsonValue());
    nodeLoadProgressJson.append(obj);

    // read load progress
    if(m_netList.count() > 0) return;
    if(!rcvData.contains("net") || !rcvData.contains("load_progress"))
    {
        qDebug() << "​​Missing required values 'net' or 'load_progress'." << rcvData;
        return;
    }
    bool convertOk = true;
    auto progress = rcvData["load_progress"].toInt(&convertOk);
    auto chain =  rcvData["chain_id"].toInt();
    int countChain = 2;

    if(!convertOk)
    {
        qDebug() << "Progress value is not an integer." << rcvData;
        return;
    }
    auto net = rcvData["net"].toString();
    if(m_networksLoadProgress.isEmpty())
    {
        auto netList = cellframe_node::getCellframeNodeInterface("local")->networks();
        std::vector <cellframe_node::CellframeNodeNetwork>  enabledNets;
        std::copy_if (netList.begin(), netList.end(), std::back_inserter(enabledNets), [](cellframe_node::CellframeNodeNetwork net){return net.enabled;} );

        for(const auto& net: enabledNets)
        {
            m_networksLoadProgress.insert(QString::fromStdString(net.name), QMap<int,int>());
        }
    }

    if(!m_networksLoadProgress.contains(net))
    {
        QMap<int,int> tmpMap = {{chain, progress}};
        m_networksLoadProgress.insert(net, std::move(tmpMap));
        qDebug() << "[DapModulesController] [rcvChainsLoadProgress] [ProgressInfo] node progress(New network). net: " << net << " progress: " << progress;
    }
    else
    {
        m_networksLoadProgress[net][chain] = progress;
        qDebug() << "[DapModulesController] [rcvChainsLoadProgress] [ProgressInfo] node progress. net: " << net << " progress: " << progress;
    }

    // calc total percent of node loading
    int total = 0;
    for(const auto &netInfo: qAsConst(m_networksLoadProgress))
    {
        for(auto& progress: netInfo)
        {
            total += progress;
        }
    }

    int value = total / (m_networksLoadProgress.count() * countChain);

    qDebug() << "[DapModulesController] -net "<< net << " \tprogress: " << progress << " \tchain: " << chain << " \ttotal: " << total << " \t new value: " << value << " \told value: " << m_nodeLoadProgress;
    if(value > m_nodeLoadProgress)
    {
        setNodeLoadProgress(value);
    }
}

void DapModulesController::setNodeLoadProgress(int progress)
{
    m_nodeLoadProgress = progress;
    emit nodeLoadProgressChanged();
}

void DapModulesController::updateNetworkListModel()
{
    QStringList list = {"All"};
    list.append(m_netList);
    m_netListModel->setStringList(std::move(list));
}

void DapModulesController::setCurrentWalletIndex(int newIndex)
{
//    qDebug()<<"setCurrentWalletIndex";

    if(newIndex == -1)
    {
        m_currentWalletIndex = newIndex;
        m_currentWalletName = "";
    }
    else
    {
        if(m_walletListModel->size() - 1 < newIndex
            || m_walletListModel->isEmpty()
            || (newIndex == m_currentWalletIndex &&
               m_walletListModel->at(newIndex).name == m_currentWalletName))
            return ;

        m_currentWalletIndex = newIndex;
        m_currentWalletName = m_walletListModel->at(newIndex).name;
    }

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
        for(int i = 0; i < m_walletListModel->size(); i++)
        {
            if(m_walletListModel->at(i).name == prevName)
            {
                if(i != m_currentWalletIndex)
                    setCurrentWalletIndex(i);
                return ;
            }
        }
    }

    setCurrentWalletIndex(0);
}

void DapModulesController::setCurrentNetwork(const QString& name)
{
    m_currentNetworkName = name;
    this->getSettings()->setValue("networkName", name);
    emit currentNetworkChanged(name);
}
