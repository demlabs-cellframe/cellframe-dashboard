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
#include "DapPluginsController.h"

#include "dap_config.h"

#if defined (Q_OS_MACOS)
#include "dap_common.h"
#endif

#include "systemtray.h"

#include "models/VpnOrdersModel.h"

#ifdef Q_OS_WIN
#include "registry.h"
#endif

#include <sys/stat.h>

//#ifdef Q_OS_WIN32
//#include <windows.h>
//#endif

#include "WalletRestore/wallethashmanager.h"

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

QString getConfigPath()
{
#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
    return QString("/opt/%1-node/etc").arg(DAP_BRAND_BASE_LO);
#elif defined (Q_OS_MACOS)
    char * l_username = NULL;
    exec_with_ret(&l_username,"whoami|tr -d '\n'");
    if (!l_username)
    {
        qWarning() << "Fatal Error: Can't obtain username";
        return QString();
    }
    return QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/etc").arg(l_username);
#elif defined (Q_OS_WIN)
    return QString("%1/cellframe-node/etc").arg(regWGetUsrPath());
#elif defined Q_OS_ANDROID
    return QString("/sdcard/cellframe-node/etc");
#else
    return QString();
#endif
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    DapApplication app(argc, argv);

    if (!SingleApplicationTest(app.applicationName()))
        return 1;

    DapLogger dapLogger;

    dapLogger.setPathToLog(DapLogger::defaultLogPath(DAP_BRAND_LO));

    QDir dir(dapLogger.getPathToLog());
    if (!dir.exists()) {
        qDebug() << "No folder:" << dapLogger.getPathToLog();
        dir.mkpath(".");
    }

    bool debug_mode = false;
    QString config_path = getConfigPath();
    if (!dap_config_init(config_path.toLocal8Bit()))
    {
        dap_config_t * config = dap_config_open("cellframe-node");
        if (config != NULL)
            debug_mode = dap_config_get_item_bool_default(
                        config, "general", "debug_dashboard_mode", false);
        else
            qDebug() << "Error in dap_config_open!";
    }
    else
        qDebug() << "Error in dap_config_init!" << config_path;

    qDebug() << "debug_dashboard_mode" << debug_mode;

    if (debug_mode)
        dapLogger.setLogLevel(L_DEBUG);
    else
        dapLogger.setLogLevel(L_INFO);

    /// TODO: The code is commented out at the time of developing the logging strategy in the project
//#ifndef QT_DEBUG
    #ifdef Q_OS_LINUX
        dapLogger.setLogFile(QString("/opt/%1/log/%2Gui.log").arg(DAP_BRAND_LO).arg(DAP_BRAND));
    #elif defined Q_OS_MACOS
	mkdir("/tmp/cellframe-dashboard_log",0777);
	dapLogger.setLogFile(QString("/tmp/cellframe-dashboard_log/%1Gui.log").arg(DAP_BRAND));
    #elif defined Q_OS_WIN
    dapLogger.setLogFile(QString("%1/%2/log/%2GUI.log").arg(regGetUsrPath()).arg(DAP_BRAND));
    #endif
//#endif

    //Plugin file
        QString filePluginConfig;
    #ifdef Q_OS_LINUX
        filePluginConfig = QString("/opt/%1/plugins/configPlugin.ini").arg(DAP_BRAND_LO);
    #elif defined Q_OS_MACOS
        mkdir("/tmp/cellframe-dashboard_plugins",0777);
        filePluginConfig = QString("/tmp/cellframe-dashboard_plugins/configPlugin.ini");
    #elif defined Q_OS_WIN
        filePluginConfig = QString("%1/%2/plugins/configPlugin.ini").arg(regGetUsrPath()).arg(DAP_BRAND);
    #endif

    QFile filePlugin(filePluginConfig);
    if(!filePlugin.exists())
    {
        if(filePlugin.open(QIODevice::WriteOnly))
            filePlugin.close();
    }

    SystemTray * systemTray = new SystemTray();
    QQmlContext * context = app.qmlEngine()->rootContext();
    context->setContextProperty("systemTray", systemTray);

    // For wallet restore
    WalletHashManager walletHashManager;

    context->setContextProperty("walletHashManager", &walletHashManager);
    walletHashManager.setContext(context);

    //For plugins
    DapPluginsController pluginsManager(filePluginConfig);
    context->setContextProperty("pluginsManager", &pluginsManager);

    app.qmlEngine()->load(QUrl("qrc:/main.qml"));

    Q_ASSERT(!app.qmlEngine()->rootObjects().isEmpty());


    return app.exec();
}
