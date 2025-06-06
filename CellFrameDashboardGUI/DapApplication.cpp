#include "DapApplication.h"
#include <QQmlContext>
#include <DapLogMessage.h>
#include <QIcon>
#include <QClipboard>
#include "quickcontrols/qrcodequickitem.h"
#include "DapVpnOrdersModel.h"
#include "dapvpnorderscontroller.h"
#include "DapNodePathManager.h"


#ifdef ANDROID
#include <QtAndroid>
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QAndroidIntent>
#endif

DapApplication::DapApplication(int &argc, char **argv)
    :QApplication(argc, argv)

    , m_serviceClient(DAP_SERVICE_NAME)
    , m_serviceController(&DapServiceController::getInstance())
//    , stockDataWorker(new StockDataWorker(m_engine.rootContext(), this))
//    , m_historyWorker(new HistoryWorker(m_engine.rootContext(), this))
    , configWorker(new ConfigWorker(this))
//    , stringWorker(new StringWorker(this))
    , dateWorker(new DateWorker(this))
    , translator(new QMLTranslator(&m_engine, this))
{
    this->setOrganizationName("Cellframe Network");
    this->setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    this->setApplicationName(DAP_BRAND);
    this->setWindowIcon(QIcon(":/Resources/icon.ico"));



    QString lang = QSettings().value("currentLanguageName", "en").toString();
    qDebug() << "DapApplication"
             << "currentLanguageName" << lang;

    translator->setLanguage(lang);

    qDebug()<<QString(DAP_SERVICE_NAME);

#ifdef Q_OS_ANDROID
    QAndroidIntent serviceIntent(QtAndroid::androidActivity().object(),
                                        "com/Cellframe/Dashboard/DashboardService");
    QAndroidJniObject result = QtAndroid::androidActivity().callObjectMethod(
                "startForegroundService",
                "(Landroid/content/Intent;)Landroid/content/ComponentName;",
                serviceIntent.handle().object());
#endif

    m_serviceController->init(&m_serviceClient);
    m_serviceClient.init();

    m_commandHelper = new CommandHelperController();

    s_modulesInit = new DapModulesController(qmlEngine());
    connect(s_modulesInit, &DapModulesController::walletsListUpdated, m_commandHelper, &CommandHelperController::tryDataUpdate);
    connect(s_modulesInit, &DapModulesController::netListUpdated, m_commandHelper, &CommandHelperController::tryDataUpdate);
    s_modulesInit->setConfigWorker(configWorker);

    m_DapNotifyController = new DapNotifyController();

    notifySignalsAttach();
    s_modulesInit->setNotifyCtrl(m_DapNotifyController);
    m_DapNotifyController->init();

    this->registerQmlTypes();
    this->setContextProperties();
}

DapApplication::~DapApplication()
{
    notifySignalsDetach();
//    delete stockDataWorker;
    delete configWorker;
    delete m_commandHelper;
//    delete m_diagnosticWorker;
//    delete stringWorker;

    qDebug() << "DapApplication::~DapApplication" << "disconnectAll";

    m_serviceController->disconnectAll();
}

void DapApplication::notifySignalsAttach()
{
    connect(m_DapNotifyController, &DapNotifyController::socketState,          this, &DapApplication::notifySocketStateChanged);
    connect(m_DapNotifyController, &DapNotifyController::socketState,          m_serviceController, &DapServiceController::slotStateSocket);
    connect(m_DapNotifyController, &DapNotifyController::netStates,            m_serviceController, &DapServiceController::slotNetState);
}

void DapApplication::notifySignalsDetach()
{
    disconnect(m_DapNotifyController, &DapNotifyController::socketState,        this, &DapApplication::notifySocketStateChanged);
    disconnect(m_DapNotifyController, &DapNotifyController::socketState,        m_serviceController, &DapServiceController::slotStateSocket);
    disconnect(m_DapNotifyController, &DapNotifyController::netStates,          m_serviceController, &DapServiceController::slotNetState);
}

void DapApplication::notifySocketStateChanged(QString state)
{
    notifyService("DapRcvNotify", QVariantList()<<state);
}

DapNetworksList *DapApplication::networks()
{
    return &m_networks;
}

QQmlApplicationEngine *DapApplication::qmlEngine()
{
    return &m_engine;
}

void DapApplication::setClipboardText(const QString &text)
{
    clipboard()->setText(text);
}

DapVpnOrdersModel *DapApplication::getVpnOrdersModel()
{
    return &m_vpnOrders;
}

void DapApplication::registerQmlTypes()
{
    //register only enums
    qmlRegisterUncreatableType<DapCertificateType>("DapCertificateManager.Commands", 1, 0, "DapCertificateType"
                         , "Error create DapCertificateType");

    //register enums and constant property as singletone
    qmlRegisterSingletonType<DapCertificateCommands>("DapCertificateManager.Commands", 1, 0, "DapCertificateCommands"
            , [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
                    Q_UNUSED(engine)
                    Q_UNUSED(scriptEngine)

                    //qInfo() << "DapCertificateCommands initialize in Qml";
                    QQmlEngine::setObjectOwnership(DapCertificateCommands::instance()
                                                   , QQmlEngine::ObjectOwnership::CppOwnership);
                    return DapCertificateCommands::instance();
            });


    qmlRegisterType<DapLogMessage>("Demlabs", 1, 0, "DapLogMessage");
    qmlRegisterType<DapWallet>("Demlabs", 1, 0, "DapWallet");
    qmlRegisterType<DapWalletToken>("Demlabs", 1, 0, "DapWalletToken");
    qmlRegisterType<QrCodeQuickItem>("Demlabs", 1, 0, "QrCodeQuickItem");
    qRegisterMetaType<DapWallet>();
    qRegisterMetaType<DapWalletToken>();

    qmlRegisterType<DapVpnOrder>("Demlabs", 1, 0, "DapVpnOrder");
    qRegisterMetaType<DapVpnOrder>();

    qmlRegisterType<QMLClipboard>("qmlclipboard", 1,0, "QMLClipboard");
    qmlRegisterType<DapVPNOrdersController>("VPNOrdersController", 1,0, "VPNOrdersController");

}

/*DapWallet *DapApplication::currentWallet() const
{
    return m_currentWallet;
}*/

void DapApplication::startService()
{
    qInfo()<<"C++ -> < Go run Dashboard Service >";
#ifdef Q_OS_ANDROID
    QtAndroid::androidContext().callMethod<void>("startService", "()V");
#endif
}

void DapApplication::requestToService(QVariant sName, QVariantList sArgs)
{
    m_serviceController->requestToService(sName.toString(), sArgs);
}
void DapApplication::notifyService(QVariant sName, QVariantList sArgs)
{
    m_serviceController->notifyService(sName.toString(), sArgs);
}

void DapApplication::setContextProperties()
{
    m_engine.rootContext()->setContextProperty("app", this);
    m_engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    m_engine.rootContext()->setContextProperty("pt", 1);

//    m_engine.rootContext()->setContextProperty("networks", this->networks());
//    m_engine.rootContext()->setContextProperty("vpnOrders", this->getVpnOrdersModel());

    m_engine.rootContext()->setContextProperty("commandHelperController", m_commandHelper);
    m_engine.rootContext()->setContextProperty("configWorker", configWorker);
    m_engine.rootContext()->setContextProperty("translator", translator);
    m_engine.rootContext()->setContextProperty("nodePathManager", &DapNodePathManager::getInstance());
    m_engine.rootContext()->setContextProperty("nodeConfigToolController", &DapConfigToolController::getInstance());
    m_engine.rootContext()->setContextProperty("dapNotifyController", m_DapNotifyController);
}
