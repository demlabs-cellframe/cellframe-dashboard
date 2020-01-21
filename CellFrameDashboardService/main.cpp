#include <QApplication>
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QCommandLineParser>
#include <QProcess>

#include <unistd.h>

#include "DapHalper.h"
#include "DapServiceController.h"
#include "DapLogger.h"

#include <sys/stat.h>

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

    QApplication a(argc, argv);
    a.setOrganizationName("DEMLABS");
    a.setOrganizationDomain("demlabs.net");
    a.setApplicationName("CellFrameDashboardService");

    DapLogger dapLogger;
    /// TODO: The code is commented out at the time of developing the logging strategy in the project
//#ifndef QT_DEBUG
    #ifdef Q_OS_LINUX
        dapLogger.setLogFile(QString("/opt/cellframe-dashboard/log/%1Service.log").arg(DAP_BRAND));
    #elif defined Q_OS_WIN
        dapLogger.setLogFile(QString("%1Service.log").arg(DAP_BRAND));
        dapLogger.setLogLevel(L_INFO);
    #elif defined Q_OS_MAC
	mkdir("tmp/cellframe-dashboard_log",0777);
	dapLogger.setLogFile(QString("/tmp/cellframe-dashboard_log/%1Service.log").arg(DAP_BRAND));
    #endif
//#endif
    // Creating the main application object
    processArgs();
    DapServiceController serviceController;
    serviceController.start();

    
    return a.exec();
}

void processArgs()
{
#if defined(Q_OS_LINUX) || defined(Q_OS_MAC)
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
