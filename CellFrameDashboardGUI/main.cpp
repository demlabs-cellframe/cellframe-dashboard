#include <QApplication>
#include <QGuiApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QScreen>

#include "DapHelper.h"
#include "serviceClient/DapServiceClient.h"
#include "DapServiceController.h"
#include "DapLogger.h"
#include "DapLogMessage.h"
#include "DapWallet.h"
#include "DapApplication.h"

#include "systemtray.h"

#ifdef Q_OS_WIN
#include "registry.h"
#endif

#include <sys/stat.h>

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

// Restore the application for the Windows system:
//        QTextCodec *codec = QTextCodec::codecForName("UTF-8");
//        QString s = codec->toUnicode(appName.toUtf8());
//        LPCWSTR lps = (LPCWSTR)s.utf16();

//        HWND hWnd = FindWindow(nullptr, lps);
//        if (hWnd)
//        {
//            ShowWindow(hWnd, SW_RESTORE);
//            SetForegroundWindow(hWnd);
//        }
        return false;
    }

    return true;
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    DapApplication app(argc, argv);

    if (!SingleApplicationTest(app.applicationName()))
        return 1;

    DapLogger dapLogger;

    dapLogger.setPathToLog(DapLogger::defaultLogPath(DAP_BRAND));

    QDir dir(dapLogger.getPathToLog());
    if (!dir.exists()) {
        qDebug() << "No folder:" << dapLogger.getPathToLog();
        dir.mkpath(".");
    }

    /// TODO: The code is commented out at the time of developing the logging strategy in the project
//#ifndef QT_DEBUG
    #ifdef Q_OS_LINUX
        dapLogger.setLogFile(QString("/opt/cellframe-dashboard/log/%1Gui.log").arg(DAP_BRAND));
    #elif defined Q_OS_MACOS
	mkdir("/tmp/cellframe-dashboard_log",0777);
	dapLogger.setLogFile(QString("/tmp/cellframe-dashboard_log/%1Gui.log").arg(DAP_BRAND));
    #elif defined Q_OS_WIN
    dapLogger.setLogFile(QString("%1/%2/log/%2GUI.log").arg(regGetUsrPath()).arg(DAP_BRAND));
    dapLogger.setLogLevel(L_DEBUG);
    #endif
//#endif

    SystemTray * systemTray = new SystemTray();
    QQmlContext * context = app.qmlEngine()->rootContext();
    context->setContextProperty("systemTray", systemTray);

    app.qmlEngine()->load(QUrl("qrc:/main.qml"));

    Q_ASSERT(!app.qmlEngine()->rootObjects().isEmpty());


    return app.exec();
}
