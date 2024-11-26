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
    , m_serviceController(&DapServiceController::getInstance())
    , configWorker(new ConfigWorker(this))
    , dateWorker(new DateWorker(this))
    , translator(new QMLTranslator(&m_engine, this))
{
    this->setOrganizationName("Cellframe Network");
    this->setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    this->setApplicationName(DAP_BRAND);
    this->setWindowIcon(QIcon(":/Resources/icon.ico"));

    m_serviceController->init();
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

    m_commandHelper = new CommandHelperController();
    s_modulesInit = new DapModulesController(qmlEngine());
    connect(s_modulesInit, &DapModulesController::walletsListUpdated, m_commandHelper, &CommandHelperController::tryDataUpdate);
    connect(s_modulesInit, &DapModulesController::netListUpdated,     m_commandHelper, &CommandHelperController::tryDataUpdate);
    s_modulesInit->setConfigWorker(configWorker);

    this->registerQmlTypes();
    this->setContextProperties();
}

DapApplication::~DapApplication()
{
    delete configWorker;
    delete m_commandHelper;

    qDebug() << "DapApplication::~DapApplication" << "disconnectAll";

    m_serviceController->disconnectAll();
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
void DapApplication::notifyService(QVariant sName, QVariantList sArgs)
{
    m_serviceController->notifyService(sName.toString(), sArgs);
}

void DapApplication::setContextProperties()
{
    m_engine.rootContext()->setContextProperty("app", this);
    m_engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    m_engine.rootContext()->setContextProperty("pt", 1);

    m_engine.rootContext()->setContextProperty("commandHelperController", m_commandHelper);
    m_engine.rootContext()->setContextProperty("configWorker", configWorker);
    m_engine.rootContext()->setContextProperty("translator", translator);
    m_engine.rootContext()->setContextProperty("nodePathManager", &DapNodePathManager::getInstance());
    m_engine.rootContext()->setContextProperty("OS_WIN_FLAG", QVariant::fromValue(OS_WIN_FLAG));
    m_engine.rootContext()->setContextProperty("nodeConfigToolController", &DapConfigToolController::getInstance());


}
