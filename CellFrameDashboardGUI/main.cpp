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

#ifdef Q_OS_WIN
#include "registry.h"
#endif

#include <sys/stat.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    DapApplication app(argc, argv);

    DapLogger dapLogger;
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

    app.qmlEngine()->load(QUrl("qrc:/main.qml"));

    Q_ASSERT(!app.qmlEngine()->rootObjects().isEmpty());


    return app.exec();
}
