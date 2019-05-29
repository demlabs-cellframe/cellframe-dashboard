#include <QApplication>
#include <QSystemSemaphore>
#include <QSharedMemory>

#include "DapHalper.h"
#include "DapChainDashboardService.h"
#include "DapLogger.h"
#include "DapChainLogHandler.h"

int main(int argc, char *argv[])
{
    // Creating a semaphore for locking external resources, as well as initializing an external resource-memory
    QSystemSemaphore systemSemaphore(QString("systemSemaphore for %1").arg("KelvinDashboardService"), 1);
#ifndef Q_OS_WIN
    QSharedMemory memmoryAppBagFix(QString("memmory for %1").arg("KelvinDashboardService"));
#endif
    QSharedMemory memmoryApp(QString("memmory for %1").arg("KelvinDashboardService"));
    // Check for the existence of a running instance of the program
    bool isRunning = DapHalper::getInstance().checkExistenceRunningInstanceApp(systemSemaphore, memmoryApp, memmoryAppBagFix);
  
    if(isRunning)
    {
        return 1;
    }
    
    QApplication a(argc, argv);
    a.setOrganizationName("DEMLABS");
    a.setOrganizationDomain("demlabs.com");
    a.setApplicationName("KelvinDashboardService");

    DapLogger dapLogger;
    /// TODO: The code is commented out at the time of developing the logging strategy in the project
//#ifndef QT_DEBUG
    #ifdef Q_OS_LINUX
        dapLogger.setLogFile(QString("/opt/%1/log/%2Service.log").arg(QString(DAP_BRAND)).arg(DAP_BRAND));
    #endif
//#endif
    // Creating the main application object
    DapChainDashboardService service;
    service.start();
    // Initialization of the application in the system tray
    service.initTray();
    
    return a.exec();
}
