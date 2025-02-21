#include <QApplication>
#include <QGuiApplication>
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QScreen>
#include <memory>
#include "sys/stat.h"
#include <signal.h>



#ifdef Q_OS_ANDROID
#include <QtAndroid>
#include <QAndroidJniObject>
#include <QAndroidIntent>
#endif

#include "DapLogHandler.h"

#include "DapApplication.h"
#include "DapGuiApplication.h"
#include "systemtray.h"

#include "DapLogger.h"
#include "DapLogHandler.h"

#include "node_globals/NodeGlobals.h"

#ifdef Q_OS_WIN
#include "registry.h"
#endif

const int RESTART_CODE = 12345;
int MIN_WIDTH = 1280;
int MIN_HEIGHT = 720;
int DEFAULT_WIDTH = 1280;
int DEFAULT_HEIGHT = 720;

bool SingleApplicationTest(const QString &appName);
void createDapLogger();
QByteArray scaleCalculate(int argc, char *argv[]);
void blocksignal(int signal_to_block /* i.e. SIGPIPE */ );

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    blocksignal(SIGPIPE);

    QApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    QApplication::setAttribute(Qt::AA_ForceRasterWidgets);
    QApplication::setHighDpiScaleFactorRoundingPolicy(Qt::HighDpiScaleFactorRoundingPolicy::PassThrough);

    QCoreApplication::setOrganizationName("Cellframe Network");
    QCoreApplication::setOrganizationDomain("cellframe.net");
    QCoreApplication::setApplicationName(DAP_BRAND);

    if (!SingleApplicationTest(DAP_BRAND)) {
        return 1;
    }

    createDapLogger();

    std::unique_ptr<DapApplication> mainApp = std::make_unique<DapApplication>();

    int countRestart = -1;
    int result = RESTART_CODE;

    while (result == RESTART_CODE){
        mainApp->clearData();

        countRestart++;

        qDebug() << "New app start";
        qputenv("QT_SCALE_FACTOR", scaleCalculate(argc, argv));
        qDebug()<<argv[argc-1];

        std::unique_ptr<DapGuiApplication> app = std::make_unique<DapGuiApplication>(argc, argv, RESTART_CODE, DEFAULT_WIDTH, DEFAULT_HEIGHT, MIN_WIDTH, MIN_HEIGHT);
        mainApp->setCountRestart(countRestart);
        mainApp->setGuiApp(app.get());

        app->loadUrl();
        result = app->exec();
        app->qmlEngine()->deleteLater();
        app.reset();
    }

    mainApp.reset();
    DapLogger::deleteLogger();
    return result;
}

void blocksignal(int signal_to_block /* i.e. SIGPIPE */ )
{
#ifndef Q_OS_WIN
    sigset_t set;
    sigset_t old_state;

    sigprocmask(SIG_BLOCK, NULL, &old_state);

    set = old_state;
    sigaddset(&set, signal_to_block);

    sigprocmask(SIG_BLOCK, &set, NULL);
#endif
}

bool SingleApplicationTest(const QString &appName)
{
    static QSystemSemaphore semaphore("<" + appName + " uniq semaphore id>", 1);
    semaphore.acquire();

#ifndef Q_OS_WIN32
    QSharedMemory nixFixSharedMemory("<" + appName + " uniq memory id>");
    if (nixFixSharedMemory.attach()) {
        nixFixSharedMemory.detach();
    }
#endif

    static QSharedMemory sharedMemory("<" + appName + " uniq memory id>");
    bool isRunning = sharedMemory.attach();
    if (!isRunning) {
        sharedMemory.create(1);
    }

    semaphore.release();

    if (isRunning) {
        QMessageBox::warning(nullptr, QObject::tr("Warning"),
                             QObject::tr("The application '%1' is already running.").arg(appName));
        return false;
    }

    return true;
}

void createDapLogger()
{
    dap_log_set_external_output(LOGGER_OUTPUT_STDOUT, nullptr);
    auto *dapLogger = new DapLogger(QApplication::instance(), "GUI", 10, TypeLogCleaning::FULL_FILE_SIZE);
    QString logPath = dapLogger->getPathToFile();

#if defined(QT_DEBUG) && defined(ANDROID)
    auto *logHandlerGui = new DapLogHandler(logPath, QApplication::instance());
    QObject::connect(logHandlerGui, &DapLogHandler::logChanged, [logHandlerGui]() {
        for (const QString &msg : logHandlerGui->request()) {
#ifdef ANDROID
            __android_log_print(ANDROID_LOG_DEBUG, DAP_BRAND "*** Gui ***", "%s\n", qPrintable(msg));
#else
                std::cout << ":=== Srv ===" << qPrintable(msg) << "\n";
#endif
        }
    });
#endif

#ifdef QT_DEBUG
    logPath = DapLogger::currentLogFilePath(DAP_BRAND, "GUI");
    auto *serviceLogHandler = new DapLogHandler(logPath, QApplication::instance());
    QObject::connect(serviceLogHandler, &DapLogHandler::logChanged, [serviceLogHandler]() {
        for (const QString &msg : serviceLogHandler->request()) {
#ifdef ANDROID
            __android_log_print(ANDROID_LOG_DEBUG, DAP_BRAND "=== Srv ===", "%s\n", qPrintable(msg));
#else
                std::cout << "=== Srv ===" << qPrintable(msg) << "\n";
#endif
        }
    });
#endif
}

QByteArray scaleCalculate(int argc, char *argv[])
{
    int localArgc = argc;
    char **localArgv = new char*[argc];

    for (int i = 0; i < argc; ++i) {
        localArgv[i] = strdup(argv[i]);
    }

    QGuiApplication app(localArgc, localArgv);

    for (int i = 0; i < argc; ++i) {
        free(localArgv[i]);
    }
    delete[] localArgv;

    QScreen *screen = app.primaryScreen();
    if (!screen) {
        qWarning() << "No primary screen found!";
        return QByteArray("1.0");
    }

    QRect screenGeometry = screen->availableGeometry();
    int maxWidth = screenGeometry.width();
    int maxHeight = screenGeometry.height();

    qDebug() << "maxWidth:" << maxWidth << "maxHeight:" << maxHeight;

    QSettings settings;
    double scale = settings.value("window_scale", 1.0).toDouble();
    qDebug() << "Initial window_scale:" << scale;

    scale = qMax(scale, 0.6);

    double widthScale = double(maxWidth) / double(MIN_WIDTH);
    double heightScale = double(maxHeight) / double(MIN_HEIGHT);
    qDebug() << "max width scale:" << widthScale;
    qDebug() << "max height scale:" << heightScale;

    scale = qMin(scale, qMin(widthScale, heightScale));

    settings.setValue("window_scale", scale);
    qDebug() << "Final window_scale:" << scale;

    return QByteArray::number(scale, 'f', 1);
}
