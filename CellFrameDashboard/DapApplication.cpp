#include "DapApplication.h"

#ifdef Q_OS_WIN
#include "registry.h"
const int OS_WIN_FLAG = 1;
#endif

#ifndef Q_OS_WIN
#include <sys/stat.h>
const int OS_WIN_FLAG = 0;
#endif

#ifdef ANDROID
#include <QtAndroid>
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <QAndroidIntent>
#endif

DapApplication::DapApplication(QObject *parent)
    :QObject(parent)
{
}

DapApplication::~DapApplication()
{
    clearData();
}

QQmlApplicationEngine *DapApplication::qmlEngine()
{
    return m_guiApp->qmlEngine();
}

void DapApplication::setClipboardText(const QString &text)
{
    m_guiApp->clipboard()->setText(text);
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


    qmlRegisterType<QrCodeQuickItem>("Demlabs", 1, 0, "QrCodeQuickItem");

    qmlRegisterType<QMLClipboard>("qmlclipboard", 1,0, "QMLClipboard");
    qmlRegisterType<DapVPNOrdersController>("VPNOrdersController", 1,0, "VPNOrdersController");
}

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

void DapApplication::setRPCAddress(QString address)
{
    QSettings().setValue("rpc_address", address);
    DapNodeMode::setRPCAddress(address.toStdString());
}

void DapApplication::resetRPCAddress()
{
    QSettings().setValue("rpc_address", "rpc.cellframe.net");
    DapNodeMode::resetRPCAddress();
}

void DapApplication::setNodeMode(int mode)
{
    QSettings().setValue("node_mode", mode);
    DapNodeMode::setNodeMode((DapNodeMode::NodeMode)mode);
}

void DapApplication::setDontShowNodeModeFlag(bool isDontShow)
{
    m_dontShowNodeModeFlag = isDontShow;
    QSettings().setValue("dontShowNodeModeFlag", m_dontShowNodeModeFlag);
}

void DapApplication::setGuiApp(DapGuiApplication *guiApp)
{
    m_guiApp = guiApp;
    m_engine = guiApp->qmlEngine();

    m_serviceController = new DapServiceController();
    dateWorker = new DateWorker(this);

    m_dontShowNodeModeFlag = QSettings().value("dontShowNodeModeFlag", false).toBool();
    setNodeMode(QSettings().value("node_mode", DapNodeMode::REMOTE).toInt());
    setRPCAddress(QSettings().value("rpc_address", "rpc.cellframe.net").toString());

    m_modulesController = new DapModulesController(qmlEngine(), m_serviceController);
    m_serviceController->run();
    m_nodeWrapper = new CellframeNodeQmlWrapper(qmlEngine());

#ifdef Q_OS_ANDROID
    QAndroidIntent serviceIntent(QtAndroid::androidActivity().object(),
                                 "com/Cellframe/Dashboard/DashboardService");
    QAndroidJniObject result = QtAndroid::androidActivity().callObjectMethod(
        "startForegroundService",
        "(Landroid/content/Intent;)Landroid/content/ComponentName;",
        serviceIntent.handle().object());
#endif

    if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL)
    {
        m_commandHelper = new CommandHelperController(m_serviceController);
        s_dapNotifyController = new DapNotifyController();
        m_modulesController->setNotifyCtrl(s_dapNotifyController);
        s_dapNotifyController->init();
    }

    this->registerQmlTypes();
    this->setContextProperties();
}

void DapApplication::clearData()
{
    if(dateWorker)            delete dateWorker;
    if(m_commandHelper)       delete m_commandHelper;
    if(m_nodeWrapper)         delete m_nodeWrapper;
    if(s_dapNotifyController) delete s_dapNotifyController;
    if(m_modulesController)   delete m_modulesController;
    if(m_serviceController)   delete m_serviceController;

    dateWorker            = nullptr;
    m_commandHelper       = nullptr;
    m_nodeWrapper         = nullptr;
    s_dapNotifyController = nullptr;
    m_modulesController   = nullptr;
    m_serviceController   = nullptr;

    m_guiApp = nullptr;
    m_engine = nullptr;
}

void DapApplication::setContextProperties()
{
    m_engine->rootContext()->setContextProperty("app", this);
    m_engine->rootContext()->setContextProperty("dapServiceController", m_serviceController);
    m_engine->rootContext()->setContextProperty("pt", 1);

    m_engine->rootContext()->setContextProperty("nodePathManager", &DapNodePathManager::getInstance());


    m_engine->rootContext()->setContextProperty("nodePathManager", &DapNodePathManager::getInstance());
    m_engine->rootContext()->setContextProperty("OS_WIN_FLAG", QVariant::fromValue(OS_WIN_FLAG));

    if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL)
    {
        m_engine->rootContext()->setContextProperty("commandHelperController", m_commandHelper);
        m_engine->rootContext()->setContextProperty("dapNotifyController", s_dapNotifyController);
    }
}
