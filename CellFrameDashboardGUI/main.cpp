#include <QApplication>
#include <QGuiApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QScreen>
#include <sys/stat.h>
#include <memory>

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidIntent>
#endif


#include "DapApplication.h"
#include "systemtray.h"
#include "resizeimageprovider.h"
#include "windowframerect.h"
#include "DapLogger.h"
#include "DapLogHandler.h"

#include "DapNodePathManager.h"

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

const int MIN_WIDTH = 1280;
const int MIN_HEIGHT = 720;

const int DEFAULT_WIDTH = 1280;
const int DEFAULT_HEIGHT = 720;

//#ifdef Q_OS_MAC
//const int USING_NOTIFY = 0;
//#else
//const int USING_NOTIFY = 1;
//#endif


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

    int maxWidth = DapApplication::primaryScreen()->availableGeometry().width();
    int maxHeight = DapApplication::primaryScreen()->availableGeometry().height();

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

    qDebug() << "window_scale" << QString::number(scale, 'f', 1).toDouble();

    for(int i=0; i<argc; ++i)
    {
        delete [] argv2[i];
    }

    delete [] argv2;

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

    QCoreApplication::setOrganizationName("Cellframe Network");
    QCoreApplication::setOrganizationDomain("cellframe.net");
    QCoreApplication::setApplicationName(DAP_BRAND);

    createDapLogger();
    //std::unique_ptr<DapLogger> logger_ptr = DapLogger::instance();
    int result = RESTART_CODE;


    bool isSingleApp = SingleApplicationTest(DAP_BRAND);

    while (result == RESTART_CODE)
    {
        qDebug() << "New app start";
        qputenv("QT_SCALE_FACTOR",  scaleCalculate(argc, argv));
        DapApplication * app = new DapApplication(argc, argv);

        if(!isSingleApp)
        {
            showErrorMessage(DAP_BRAND);
            return 1;
        }

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
        context->setContextProperty("DEFAULT_WIDTH", QVariant::fromValue(DEFAULT_WIDTH));
        context->setContextProperty("DEFAULT_HEIGHT", QVariant::fromValue(DEFAULT_HEIGHT));
        context->setContextProperty("USING_NOTIFY", QVariant::fromValue(USING_NOTIFY));
        context->setContextProperty("CURRENT_OS", QVariant::fromValue(os));

        const QUrl url(QStringLiteral("qrc:/main.qml"));
        QObject::connect(app->qmlEngine(), &QQmlApplicationEngine::objectCreated,
            app, [url](QObject *obj, const QUrl &objUrl) {
                if (!obj && url == objUrl)
                    QCoreApplication::exit(-1);
            }, Qt::QueuedConnection);

        app->qmlEngine()->load(url);
        DapNodePathManager::getInstance().checkNeedDownload();
        DapLogger::instance()->startUpdateTimer();
        result = app->exec();
        delete app;
    }

    DapLogger::deleteLogger();

    return result;
}
