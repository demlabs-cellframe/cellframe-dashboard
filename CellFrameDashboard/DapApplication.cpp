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

DapApplication::DapApplication(int &argc, char **argv)
    :QApplication(argc, argv)
    , m_engine(new QQmlApplicationEngine())
    , m_serviceController(new DapServiceController())
    , dateWorker(new DateWorker(this))
    , translator(new QMLTranslator(&m_engine, this))
{
    this->setOrganizationName("Cellframe Network");
    this->setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    this->setApplicationName(DAP_BRAND);
    this->setWindowIcon(QIcon(":/Resources/icon.ico"));

    m_dontShowNodeModeFlag = QSettings().value("dontShowNodeModeFlag", false).toBool();
    setNodeMode(QSettings().value("node_mode", DapNodeMode::REMOTE).toInt());

    m_nodeWrapper = new CellframeNodeQmlWrapper(qmlEngine());
//    qDebug()<<m_nodeWrapper->nodeInstalled();
//    qDebug()<<m_nodeWrapper->nodeServiceLoaded();
//    qDebug()<<m_nodeWrapper->nodeRunning();
//    qDebug()<<m_nodeWrapper->nodeVersion();

#ifdef Q_OS_ANDROID
    QAndroidIntent serviceIntent(QtAndroid::androidActivity().object(),
                                        "com/Cellframe/Dashboard/DashboardService");
    QAndroidJniObject result = QtAndroid::androidActivity().callObjectMethod(
                "startForegroundService",
                "(Landroid/content/Intent;)Landroid/content/ComponentName;",
                serviceIntent.handle().object());
#endif

    QString lang = QSettings().value("currentLanguageName", "en").toString();
    qDebug() << "DapApplication" << "currentLanguageName" << lang;
    translator->setLanguage(lang);

    m_modulesController = new DapModulesController(qmlEngine(), m_serviceController);
    // connect(m_modulesController, &DapModulesController::walletsListUpdated, m_commandHelper, &CommandHelperController::tryDataUpdate);
    // connect(m_modulesController, &DapModulesController::netListUpdated,     m_commandHelper, &CommandHelperController::tryDataUpdate);

    s_dapNotifyController = new DapNotifyController();
    m_modulesController->setNotifyCtrl(s_dapNotifyController);
    s_dapNotifyController->init();

    if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL)
    {
        m_commandHelper = new CommandHelperController(m_serviceController);
    }

    this->registerQmlTypes();
    this->setContextProperties();
}

DapApplication::~DapApplication()
{
    delete m_commandHelper;
    delete dateWorker;
    delete translator;
    delete m_nodeWrapper;
    delete s_dapNotifyController;
    delete m_modulesController;
    delete m_serviceController;
    m_engine.deleteLater();
}

QQmlApplicationEngine *DapApplication::qmlEngine()
{
    return &m_engine;
}

void DapApplication::setClipboardText(const QString &text)
{
    clipboard()->setText(text);
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

void DapApplication::setContextProperties()
{
    m_engine.rootContext()->setContextProperty("app", this);
    m_engine.rootContext()->setContextProperty("dapServiceController", m_serviceController);
    m_engine.rootContext()->setContextProperty("pt", 1);

    m_engine.rootContext()->setContextProperty("translator", translator);
    m_engine.rootContext()->setContextProperty("nodePathManager", &DapNodePathManager::getInstance());
    m_engine.rootContext()->setContextProperty("OS_WIN_FLAG", QVariant::fromValue(OS_WIN_FLAG));

    if(DapNodeMode::getNodeMode() == DapNodeMode::LOCAL)
    {
        m_engine.rootContext()->setContextProperty("commandHelperController", m_commandHelper);
    }
}
