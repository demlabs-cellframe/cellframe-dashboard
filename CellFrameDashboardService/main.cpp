#ifdef ANDROID
#include <QAndroidService>
#include <android/log.h>
#else
#include <QCoreApplication>
#endif
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QCommandLineParser>
#include <QProcess>

#include <unistd.h>

#include "DapHelper.h"
#include "DapServiceController.h"
#include "DapLogger.h"
#include "DapPluginsPathControll.h"
#include "dapconfigreader.h"
#include <sys/stat.h>

#include <DapNotificationWatcher.h>
void processArgs();

#ifdef Q_OS_WIN
#include "registry.h"
#include "Service.h"
void ServiceMain(int argc, char *argv[]) {
        qputenv("QT_LOGGING_RULES", "qt.network.ssl.warning=false");
        QCoreApplication a(argc, argv);
        a.setOrganizationName("Cellframe Network");
        a.setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
        a.setApplicationName(DAP_BRAND "Service");

        DapLogger dapLogger(QCoreApplication::instance(), "Service");

        DapPluginsPathControll dapPlugins;
        dapPlugins.setPathToPlugin(DapPluginsPathControll::defaultPluginPath(DAP_BRAND_LO));

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
        dapLogger.setLogLevel(debug_mode ? L_DEBUG : L_INFO);

        ServiceProcClass *s = ServiceProcClass::me();
        s->serviceStatusHandle = RegisterServiceCtrlHandler(ServiceProcClass::serviceName, (LPHANDLER_FUNCTION)ControlHandler);
        if (s->serviceStatusHandle == (SERVICE_STATUS_HANDLE)0) {
            qDebug() << "Error: couldn't register service control handler!";
            return;
        }
        qInfo() << QString::fromWCharArray(ServiceProcClass::serviceName) + " started";

        DapServiceController serviceController;
        if (!serviceController.start()) {
            s->UpdateServiceStatus(SERVICE_STOPPED, 100);
            qCritical() << "Error: couldn't init the service!";
            return;
        }
        HANDLE hWorkerThr = CreateThread(nullptr, 0, ServiceProcClass::ServiceWorkerThr, s, 0, nullptr);
        s->UpdateServiceStatus(SERVICE_RUNNING, 0);
        QObject::connect(s, SIGNAL(stopService()), &a, SLOT(quit()));
        a.exec();
        qDebug() << "System service stopped";
        CloseHandle(hWorkerThr);
        return;
}

void serviceInstall() {
    SC_HANDLE schSCManager;
    SC_HANDLE schService;
    wchar_t binPath[MAX_PATH];
    GetModuleFileName(nullptr, binPath, MAX_PATH);
    schSCManager = OpenSCManager(nullptr, nullptr, SC_MANAGER_ALL_ACCESS);
    assert(schSCManager != nullptr);
    schService = CreateService(
            schSCManager,
            ServiceProcClass::serviceName,
            ServiceProcClass::serviceName,
            SERVICE_ALL_ACCESS,
            SERVICE_WIN32_OWN_PROCESS,
            SERVICE_AUTO_START,
            SERVICE_ERROR_NORMAL,
            binPath,
            nullptr, nullptr, nullptr, nullptr, nullptr);
    assert(schService != nullptr);
    CloseServiceHandle(schService);
    CloseServiceHandle(schSCManager);
}

void setPermissionsForStartService(){
    int ret = exec_silent(qUtf8Printable("sc sdset " DAP_BRAND "Service \"D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;RPWPCR;;;" +
                               QString::fromWCharArray(getUserSID(shGetUsrPath())) + ")S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)\""));
    if (ret) qDebug() << "Set rights for service failed";
        else qDebug() << "Successful set rights for service";
}

int main(int argc, char *argv[]) {
    qputenv("QT_BEARER_POLL_TIMEOUT", QByteArray::number(-1));
    if (argc == 1) {
        SERVICE_TABLE_ENTRY winService[] = {
            { (LPWSTR)ServiceProcClass::serviceName, (LPSERVICE_MAIN_FUNCTION)ServiceMain },
            { nullptr, nullptr }
        };
        if(!StartServiceCtrlDispatcher(winService)) {
            qDebug() << "Error: Windows Service Dispatcher couldn't start! Code: " << GetLastError();
        }
        return 0;
    } else {
        if (strcmp(argv[1], "install") == 0) {
            qInfo() << "Installing service...";
            serviceInstall();
            setPermissionsForStartService();
        }
    }
    return 0;
}

#else
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
#else
    QCoreApplication a(argc, argv);
#endif

    a.setOrganizationName("Cellframe Network");
    a.setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    a.setApplicationName(DAP_BRAND "Service");

    DapLogger dapLogger(QCoreApplication::instance(), "Service");
    DapPluginsPathControll dapPlugins;

    DapConfigReader configReader;
    bool debug_mode = configReader.getItemBool("general", "debug_dashboard_mode", false);
    qDebug() << "debug_dashboard_mode" << debug_mode;
    dapLogger.setLogLevel(debug_mode ? L_DEBUG : L_INFO);

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

    // Creating the main application object
    processArgs();
    DapServiceController serviceController;
    serviceController.start();
    qDebug() << "SERVICE STARTED";

    
    return a.exec();
}

#endif

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
