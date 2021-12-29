#include <QCoreApplication>
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QCommandLineParser>
#include <QProcess>
#include <QAndroidService>

#include <unistd.h>

#include "DapHelper.h"
#include "DapServiceController.h"
#include "DapLogger.h"
#include "DapPluginsPathControll.h"

#include "dapconfigreader.h"

#include <sys/stat.h>

#ifdef Q_OS_WIN
#include "registry.h"
#endif

void processArgs();

int main(int argc, char *argv[])
{    
    // Creating a semaphore for locking external resources, as well as initializing an external resource-memory
    QSystemSemaphore systemSemaphore(QString("systemSemaphore for %1").arg("CellFrameDashboardService"), 1);

    QSharedMemory memmoryAppBagFix(QString("memmory for %1").arg("CellFrameDashboardService"));

    QSharedMemory memmoryApp(QString("memmory for %1").arg("CellFrameDashboardService"));
    // Check for the existence of a running instance of the program
    bool isRunning = DapHelper::getInstance().checkExistenceRunningInstanceApp(systemSemaphore, memmoryApp, memmoryAppBagFix);
  
    if(isRunning)
    {
        return 1;
    }
#ifdef Q_OS_ANDROID
    QAndroidService a(argc, argv);
    a.setOrganizationName("Cellframe Network");
    a.setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    a.setApplicationName(DAP_BRAND "Service");
#else
    QCoreApplication a(argc, argv);
    a.setOrganizationName("Cellframe Network");
    a.setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    a.setApplicationName(DAP_BRAND "Service");
#endif
    DapLogger dapLogger;

    //logs
    dapLogger.setPathToLog(DapLogger::defaultLogPath(DAP_BRAND_LO));
    QDir dir(dapLogger.getPathToLog());
    if (!dir.exists()) {
        qDebug() << "No folder:" << dapLogger.getPathToLog();
        dir.mkpath(".");
        QString str = "chmod 777 " + dapLogger.getPathToLog();
        system(str.toUtf8().data());
    }

    DapPluginsPathControll dapPlugins;

    //plugins path
    dapPlugins.setPathToPlugin(DapPluginsPathControll::defaultPluginPath(DAP_BRAND_LO));
    QDir dirPlug(dapPlugins.getPathToPlugin());
    if(!dirPlug.exists())
    {
        qDebug() << "No folder:" << dapPlugins.getPathToPlugin();
        dirPlug.mkpath(".");
        QString str = "chmod 777 " + dapPlugins.getPathToPlugin();
        system(str.toUtf8().data());
    }
    QDir dirDownloadPlug(dapPlugins.getPathToPluginsDownload());
    if(!dirDownloadPlug.exists())
    {
        qDebug() << "No folder:" << dapPlugins.getPathToPluginsDownload();
        dirDownloadPlug.mkpath(".");
        QString str = "chmod 777 " + dapPlugins.getPathToPluginsDownload();
        system(str.toUtf8().data());
    }

    DapConfigReader configReader;

    bool debug_mode = configReader.getItemBool("general", "debug_dashboard_mode", false);

    qDebug() << "debug_dashboard_mode" << debug_mode;

    if (debug_mode)
        dapLogger.setLogLevel(L_DEBUG);
    else
        dapLogger.setLogLevel(L_INFO);

    /// TODO: The code is commented out at the time of developing the logging strategy in the project
//#ifndef QT_DEBUG
    #ifdef Q_OS_LINUX
        dapLogger.setLogFile(QString("/opt/%1/log/%2Service.log").arg(DAP_BRAND_LO).arg(DAP_BRAND));
    #elif defined Q_OS_WIN
        dapLogger.setLogFile(QString("%1/%2/log/%2Service.log").arg(regGetUsrPath()).arg(DAP_BRAND));
    #elif defined Q_OS_MAC
	mkdir("tmp/cellframe-dashboard_log",0777);
	dapLogger.setLogFile(QString("/tmp/cellframe-dashboard_log/%1Service.log").arg(DAP_BRAND));
    #endif
//#endif

    // Creating the main application object
    processArgs();
    DapServiceController serviceController;
    serviceController.start();
    qDebug() << "SERVICE STARTED";

    
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
