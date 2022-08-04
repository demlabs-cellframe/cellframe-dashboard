#include "DapApplication.h"
#include <QQmlContext>
#include <DapLogMessage.h>
#include <QIcon>
#include <QClipboard>
#include "quickcontrols/qrcodequickitem.h"
#include "DapVpnOrdersModel.h"
#include "dapvpnorderscontroller.h"

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
{
    this->setOrganizationName("Cellframe Network");
    this->setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    this->setApplicationName(DAP_BRAND);
    this->setWindowIcon(QIcon(":/Resources/icon.ico"));

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

    commandCmdController = new CommandCmdController();
    commandCmdController->dapServiceControllerInit(&DapServiceController::getInstance());

    m_mathBigNumbers = new DapMath();
    m_mathBigNumbers->test();

    this->registerQmlTypes();
    this->setContextProperties();

    qRegisterMetaType<DapNetwork::State>("DapNetwork::State");

    connect(&DapServiceController::getInstance(), &DapServiceController::networksListReceived, this->networks(), &DapNetworksList::fill);
    connect(&DapServiceController::getInstance(), &DapServiceController::networkStatusReceived, [this](const QVariant & a_stateMap){
        qDebug() << "networkStatusReceived" << a_stateMap;
        networks()->setNetworkProperties(a_stateMap.toMap());
    });

    connect(this->networks(), &DapNetworksList::networkAdded, [](DapNetwork* network){
        DapServiceController::getInstance().requestNetworkStatus(network->name());
    });

    connect(&DapServiceController::getInstance(), &DapServiceController::newTargetNetworkStateReceived, [this](const QVariant & a_state){
        qDebug() << "newTargetNetworkStateReceived" << a_state;
    });

    m_serviceController->requestWalletList();
    m_serviceController->requestOrdersList();
    m_serviceController->requestNetworksList();
    m_serviceController->requestToService("DapGetXchangeTokenPair", "full_info");
    m_serviceController->requestToService("DapGetXchangeOrdersList");

}

DapApplication::~DapApplication()
{
    qDebug() << "DapApplication::~DapApplication" << "disconnectAll";
    m_serviceController->disconnectAll();
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

    qmlRegisterType<CommandCmdController>("CommandCmdController", 1, 0, "CommandCmdController");

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

void DapApplication::setContextProperties()
{
    m_engine.rootContext()->setContextProperty("app", this);
    m_engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    m_engine.rootContext()->setContextProperty("pt", 1);

    m_engine.rootContext()->setContextProperty("networks", this->networks());
    m_engine.rootContext()->setContextProperty("vpnOrders", this->getVpnOrdersModel());

    m_engine.rootContext()->setContextProperty("commandCmdController", commandCmdController);
    m_engine.rootContext()->setContextProperty("dapMath", m_mathBigNumbers);
}
