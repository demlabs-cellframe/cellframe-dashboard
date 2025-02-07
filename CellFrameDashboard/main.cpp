#include <QApplication>
#include <QGuiApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QScreen>
#include <memory>
#include "sys/stat.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidIntent>
#endif

#include "DapLogger.h"
#include "DapDataLocal.h"
#include "DapLogHandler.h"

#include "DapApplication.h"
#include "DapGuiApplication.h"
#include "systemtray.h"
#include "resizeimageprovider.h"
#include "windowframerect.h"
#include "DapLogger.h"
#include "DapLogHandler.h"

#include "node_globals/NodeGlobals.h"

#ifdef Q_OS_WIN
#include "registry.h"
#endif

//#ifdef Q_OS_WIN32
//#include <windows.h>
//#endif

bool SingleApplicationTest(const QString &appName)
{
    static QSystemSemaphore semaphore("<"+appName+" uniq semaphore id>", 1);
    semaphore.acquire();

#ifndef Q_OS_WIN32
    QSharedMemory nix_fix_shared_memory("<"+appName+" uniq memory id>");
    if(nix_fix_shared_memory.attach())
    {
        nix_fix_shared_memory.detach();
    }
#endif

    static QSharedMemory sharedMemory("<"+appName+" uniq memory id>");
    bool is_running;
    if (sharedMemory.attach())
    {
        is_running = true;
    }
    else
    {
        sharedMemory.create(1);
        is_running = false;
    }

    semaphore.release();

    if(is_running)
    {
        QMessageBox msgBox;
        msgBox.setIcon(QMessageBox::Warning);
        msgBox.setText(QObject::tr("The application '%1' is already running.").arg(appName));
        msgBox.exec();
        return false;
    }

    return true;
}

void showErrorMessage(const QString &appName)
{
    QMessageBox msgBox;
    msgBox.setIcon(QMessageBox::Warning);
    msgBox.setText(QObject::tr("The application '%1' is already running.").arg(appName));
    msgBox.exec();
}

void createDapLogger()
{
    dap_log_set_external_output (LOGGER_OUTPUT_STDOUT, nullptr);
    DapLogger *dapLogger = new DapLogger (QApplication::instance(), "GUI", 10, TypeLogCleaning::FULL_FILE_SIZE);
    QString logPath = dapLogger->getPathToFile();

#if defined(QT_DEBUG) && defined(ANDROID)
    DapLogHandler *logHandlerGui = new DapLogHandler (logPath, QApplication::instance());

    QObject::connect (logHandlerGui, &DapLogHandler::logChanged, [logHandlerGui]()
                     {
                         for (QString &msg : logHandlerGui->request())
#ifdef ANDROID
                             __android_log_print (ANDROID_LOG_DEBUG, DAP_BRAND "*** Gui ***", "%s\n", qPrintable (msg));
#else
                std::cout << ":=== Srv ===" << qPrintable (msg) << "\n";
#endif

                     });
#endif

#ifdef QT_DEBUG
    logPath = DapLogger::currentLogFilePath (DAP_BRAND, "GUI");
    DapLogHandler *serviceLogHandler = new DapLogHandler (logPath, QApplication::instance());

    QObject::connect (serviceLogHandler, &DapLogHandler::logChanged, [serviceLogHandler]()
                     {
                         for (QString &msg : serviceLogHandler->request())
                         {
#ifdef ANDROID
                             __android_log_print (ANDROID_LOG_DEBUG, DAP_BRAND "=== Srv ===", "%s\n", qPrintable (msg));
#else
                std::cout << "=== Srv ===" << qPrintable (msg) << "\n";
#endif
                         }
                     });

#endif
}

const int RESTART_CODE = 12345;

int MIN_WIDTH = 1280;
int MIN_HEIGHT = 720;

int DEFAULT_WIDTH = 1280;
int DEFAULT_HEIGHT = 720;

const int USING_NOTIFY = 0;

QByteArray scaleCalculate(int argc, char *argv[])
{
    int argc2 = argc;
    char** argv2 = new char*[argc];

    for(int i=0; i<argc; ++i)
    {
        argv2[i] = new char[strlen(argv[i])+1];
        strcpy(argv2[i],argv[i]);
    }

    QApplication *temp = new QApplication(argc2, argv2);

    int maxWidth = temp->primaryScreen()->availableGeometry().width();
    int maxHeight = temp->primaryScreen()->availableGeometry().height();

    qDebug()<<"maxWidth" << maxWidth << "maxHeight" << maxHeight;

    double scale = QSettings().value("window_scale", 1.0).toDouble();

    qDebug() << "window_scale" << QString::number(scale).toDouble();

    if(scale <= 0.6)
        scale = 0.6;

    if (MIN_WIDTH * scale > maxWidth)
    {
        scale = (double)maxWidth/MIN_WIDTH;
        qDebug() << "Maximum scale for current resolution: " << QString::number(scale, 'f', 1).toDouble();
        QSettings().setValue("window_scale", QString::number(scale, 'f', 1).toDouble());
    }
    if (MIN_HEIGHT * scale > maxHeight)
    {
        scale = (double)maxHeight/MIN_HEIGHT;
        qDebug() << "Maximum scale for current resolution: " << QString::number(scale, 'f', 1).toDouble();
        QSettings().setValue("window_scale", QString::number(scale, 'f', 1).toDouble());
    }

    temp->quit();
    delete temp;

    for(int i=0; i<argc; ++i)
    {
        delete [] argv2[i];
    }

    delete [] argv2;

    qDebug() << "window_scale" << QString::number(scale, 'f', 1).toDouble();

    return QString::number(scale, 'f', 1).toLocal8Bit();
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    QApplication::setAttribute(Qt::AA_ForceRasterWidgets);
    QApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);

    // Temp 'copy-past' for change skin
    QCoreApplication::setOrganizationName("Cellframe Network");
    QCoreApplication::setOrganizationDomain("cellframe.net");
    QCoreApplication::setApplicationName(DAP_BRAND);

    DapApplication mainApp = new DapApplication();

    if (!SingleApplicationTest(DAP_BRAND))
        return 1;

    dap_log_set_external_output (LOGGER_OUTPUT_STDOUT, nullptr);
    new DapLogger (QApplication::instance(), "GUI", 10, TypeLogCleaning::FULL_FILE_SIZE);
    int countRestart = -1;
    int result = RESTART_CODE;
    while (result == RESTART_CODE)
    {
        /// CHANGE SKIN - BEGIN TEMPORARY CODE
        auto projectSkin = QSettings().value("project_skin", "").toString();

        countRestart++;

        if(projectSkin.isEmpty()) QSettings().setValue("project_skin", "dashboard");
        bool walletSkin = projectSkin == "wallet";
/*---*/ walletSkin = false; // TODO: BLOCKED WALLET SKIN
        if(walletSkin)
        {
            qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

            MIN_WIDTH = 375;
            MIN_HEIGHT = 812;
            DEFAULT_WIDTH = 375;
            DEFAULT_HEIGHT = 812;
        }
        /// CHANGE SKIN - END

        qDebug() << "New app start";
        qputenv("QT_SCALE_FACTOR",  scaleCalculate(argc, argv));
        DapGuiApplication * app = new DapGuiApplication(argc, argv);
        mainApp.setCountRestart(countRestart);
        mainApp.setGuiApp(app);

        app->qmlEngine()->addImageProvider("resize", new ResizeImageProvider);
        qmlRegisterType<WindowFrameRect>("windowframerect", 1,0, "WindowFrameRect");

        QString os;

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
        os = "linux";
#elif defined Q_OS_WIN
        os = "win";
#elif defined Q_OS_MAC
        os = "macos";
#else
        os = "unknown";
#endif

        QQmlContext * context = app->qmlEngine()->rootContext();
        context->setContextProperty("RESTART_CODE", QVariant::fromValue(RESTART_CODE));
        context->setContextProperty("MIN_WIDTH", QVariant::fromValue(MIN_WIDTH));
        context->setContextProperty("MIN_HEIGHT", QVariant::fromValue(MIN_HEIGHT));
        context->setContextProperty("MAX_WIDTH", QVariant::fromValue(MIN_WIDTH));
        context->setContextProperty("MAX_HEIGHT", QVariant::fromValue(MIN_HEIGHT));

        context->setContextProperty("DEFAULT_WIDTH", QVariant::fromValue(DEFAULT_WIDTH));
        context->setContextProperty("DEFAULT_HEIGHT", QVariant::fromValue(DEFAULT_HEIGHT));
        context->setContextProperty("USING_NOTIFY", QVariant::fromValue(USING_NOTIFY));
        context->setContextProperty("CURRENT_OS", QVariant::fromValue(os));

        //const QUrl url(QStringLiteral("qrc:/main.qml"));
        QString pathMainQML = QStringLiteral("qrc:/main.qml");
        if(walletSkin) pathMainQML = QStringLiteral("qrc:/walletSkin/main.qml");
        QUrl url(pathMainQML);

        QObject::connect(app->qmlEngine(), &QQmlApplicationEngine::objectCreated,
            app, [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            }, Qt::QueuedConnection);

        app->qmlEngine()->load(url);
        result = app->exec();
        app->quit();
        delete app;
        mainApp.clearData();
    }


    DapLogger::deleteLogger();
    return result;
}
