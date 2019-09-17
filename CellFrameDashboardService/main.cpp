#include <QCoreApplication>
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QCommandLineParser>

#include <unistd.h>

#include "DapHalper.h"
#include "DapChainDashboardService.h"
#include "DapLogger.h"
#include "DapChainLogHandler.h"

void processArgs();

int main(int argc, char *argv[])
{
    // Creating a semaphore for locking external resources, as well as initializing an external resource-memory
    QSystemSemaphore systemSemaphore(QString("systemSemaphore for %1").arg("CellFrameDashboardService"), 1);

    QSharedMemory memmoryAppBagFix(QString("memmory for %1").arg("CellFrameDashboardService"));

    QSharedMemory memmoryApp(QString("memmory for %1").arg("CellFrameDashboardService"));
    // Check for the existence of a running instance of the program
    bool isRunning = DapHalper::getInstance().checkExistenceRunningInstanceApp(systemSemaphore, memmoryApp, memmoryAppBagFix);
  
    if(isRunning)
    {
        return 1;
    }

    QCoreApplication a(argc, argv);
    a.setOrganizationName("DEMLABS");
    a.setOrganizationDomain("demlabs.net");
    a.setApplicationName("CellFrameDashboardService");

    DapLogger dapLogger;
    /// TODO: The code is commented out at the time of developing the logging strategy in the project
//#ifndef QT_DEBUG
    #ifdef Q_OS_LINUX
        dapLogger.setLogFile(QString("/opt/cellframe-dashboard/log/%1Service.log").arg(DAP_BRAND));
    #endif
//#endif
    // Creating the main application object
    processArgs();
    DapChainDashboardService service;
    service.start();
    // Initialization of the application in the system tray
//    service.initTray();

    
    return a.exec();
}

void processArgs()
{
#ifdef Q_OS_LINUX
    QCommandLineParser clParser;
    clParser.parse(QCoreApplication::arguments());
    auto options = clParser.unknownOptionNames();
    if (options.contains("D")) {
        daemon(1, 0);
    }
    else if (options.contains("stop")) {
        qint64 pid = QCoreApplication::applicationPid();
        QProcess::startDetached("kill -9 " + QString::number(pid));
        exit(0);
    }
#endif
}
