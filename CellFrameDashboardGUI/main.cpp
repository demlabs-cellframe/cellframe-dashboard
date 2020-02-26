#include <QApplication>
#include <QGuiApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemSemaphore>
#include <QSharedMemory>
#include <QScreen>

#include "DapHalper.h"
#include "ServiceClient/DapServiceClient.h"
#include "DapServiceController.h"
#include "DapLogger.h"
#include "DapLogMessage.h"
#include "DapWallet.h"

#ifdef Q_OS_WIN
#include "registry.h"
#endif

#include <sys/stat.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("DEMLABS");
    app.setOrganizationDomain("demlabs.net");
    app.setApplicationName("CellFrame Dashboard");
    app.setWindowIcon(QIcon(":/res/icons/icon.ico"));

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



    /// Local client.
    DapServiceClient dapServiceClient(DAP_SERVICE_NAME);
    // Creating a service controller
    DapServiceController &controller = DapServiceController::getInstance();
    controller.init(&dapServiceClient);
    dapServiceClient.init();
    qmlRegisterType<DapLogMessage>("Demlabs", 1, 0, "DapLogMessage");
    qmlRegisterType<DapWallet>("Demlabs", 1, 0, "DapWallet");
    qmlRegisterType<DapWalletToken>("Demlabs", 1, 0, "DapWalletToken");
    qRegisterMetaType<DapWallet>();
    qRegisterMetaType<DapWalletToken>();
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    engine.rootContext()->setContextProperty("pt", 1);
    engine.load(QUrl("qrc:/main.qml"));

    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}
