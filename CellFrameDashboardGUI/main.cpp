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
#include "DapScreenDialog.h"
#include "DapScreenDialogChangeWidget.h"
#include "DapSettings.h"
#include "DapServiceClient.h"
#include "DapServiceController.h"
#include "DapLogger.h"
#include "DapLogMessage.h"
#include "DapLogModel.h"
#include "DapChainWalletsModel.h"
#include "DapChainNodeNetworkModel.h"
#include "DapChainNodeNetworkExplorer.h"
#include "DapScreenHistoryFilterModel.h"
#include "DapSettingsNetworkModel.h"
#include "DapConsoleModel.h"
#include "DapChainConvertor.h"
#include "DapClipboard.h"

#include "DapChainWalletModel.h"
#include "DapWalletFilterModel.h"

#include <QRegExp>

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
    dapLogger.setLogFile(QString("%Dashboard.log").arg(DAP_BRAND));
    dapLogger.setLogLevel(L_DEBUG);
    #endif
//#endif

    /// Local client.
    DapServiceClient dapServiceClient;
    // Creating a service controller
    DapServiceController &controller = DapServiceController::getInstance();
    controller.init(&dapServiceClient);
    dapServiceClient.init();
    controller.getWallets();
    controller.requestWalletData();
    controller.getHistory();
    controller.getCmdHistory();
    controller.getNetworkList();

    DapScreenHistoryFilterModel::getInstance()
            .setSourceModel(&DapScreenHistoryModel::getInstance());

    DapWalletFilterModel::instance()
            .setSourceModel(&DapChainWalletModel::instance());

    qmlRegisterType<DapScreenDialog>("CellFrameDashboard", 1, 0, "DapScreenDialog");
    qmlRegisterType<DapScreenDialogChangeWidget>("CellFrameDashboard", 1, 0, "DapScreenDialogChangeWidget");
    qmlRegisterType<DapLogMessage>("LogMessage", 1, 0, "DapLogMessage");
    qmlRegisterType<DapChainNodeNetworkExplorer>("NodeNetworkExplorer", 1, 0, "DapUiQmlWidgetNodeNetwork");
    qmlRegisterType<DapScreenHistoryModel>("DapTransactionHistory", 1, 0, "DapTransactionModel");

    QQmlApplicationEngine engine;
    /// TODO: this method for getting DPI screen can be useful in the future
//    qreal dpi = QGuiApplication::primaryScreen()->physicalDotsPerInch();
    engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    engine.rootContext()->setContextProperty("dapLogModel", &DapLogModel::getInstance());
    engine.rootContext()->setContextProperty("dapChainWalletsModel", &DapChainWalletsModel::getInstance());
    engine.rootContext()->setContextProperty("dapNodeNetworkModel", &DapChainNodeNetworkModel::getInstance());
    engine.rootContext()->setContextProperty("dapConsoleModel", &DapConsoleModel::getInstance());
    engine.rootContext()->setContextProperty("dapHistoryModel", &DapScreenHistoryFilterModel::getInstance());
    engine.rootContext()->setContextProperty("dapSettingsNetworkModel", &DapSettingsNetworkModel::getInstance());
    engine.rootContext()->setContextProperty("dapChainConvertor", &DapChainConvertor::getInstance());
    engine.rootContext()->setContextProperty("dapWalletFilterModel", &DapWalletFilterModel::instance());
    engine.rootContext()->setContextProperty("dapWalletModel", &DapChainWalletModel::instance());
    engine.rootContext()->setContextProperty("clipboard", &DapClipboard::instance());
    engine.rootContext()->setContextProperty("pt", 1);
    engine.load(QUrl("qrc:/screen/main.qml"));

    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}
