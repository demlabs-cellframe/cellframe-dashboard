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
#include "DapUiQmlWidgetModel.h"
#include "DapSettings.h"
#include "DapSettingsCipher.h"
#include "DapServiceClient.h"
#include "DapServiceController.h"
#include "DapLogger.h"
#include "DapLogMessage.h"
#include "DapLogModel.h"
#include "DapChainWalletsModel.h"
#include "DapChainNodeNetworkModel.h"
#include "DapChainNodeNetworkExplorer.h"
#include "DapScreenHistoryFilterModel.h"


#include <QRegExp>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("DEMLABS");
    app.setOrganizationDomain("demlabs.com");
    app.setApplicationName("Kelvin Dashboard");
    app.setWindowIcon(QIcon(":/Resources/Icons/icon.ico"));
    
    DapLogger dapLogger;
    /// TODO: The code is commented out at the time of developing the logging strategy in the project
//#ifndef QT_DEBUG
    #ifdef Q_OS_LINUX
        dapLogger.setLogFile(QString("/opt/kelvin-dashboard/log/%1Gui.log").arg(DAP_BRAND));
    #endif
//#endif

    /// Local client.
    DapServiceClient dapServiceClient;
    // Creating a service controller
    DapServiceController &controller = DapServiceController::getInstance();
    controller.init(&dapServiceClient);
    dapServiceClient.init();
    controller.getNodeLogs(0, 100);
    controller.getWallets();
    controller.getHistory();

    DapScreenHistoryFilterModel::getInstance()
            .setSourceModel(&DapScreenHistoryModel::getInstance());
//    controller.getNodeNetwork();

    qmlRegisterType<DapScreenDialog>("KelvinDashboard", 1, 0, "DapScreenDialog");
    qmlRegisterType<DapScreenDialogChangeWidget>("KelvinDashboard", 1, 0, "DapScreenDialogChangeWidget");
    qmlRegisterType<DapLogMessage>("LogMessage", 1, 0, "DapLogMessage");
    qmlRegisterType<DapChainNodeNetworkExplorer>("NodeNetworkExplorer", 1, 0, "DapUiQmlWidgetNodeNetwork");
//    qmlRegisterType<DapScreenHistoryModel>("")
    qmlRegisterSingletonType<DapUiQmlWidgetModel>("KelvinDashboard", 1, 0, "DapUiQmlWidgetModel", DapUiQmlWidgetModel::singletonProvider);
    qmlRegisterType<DapScreenHistoryModel>("DapTransactionHistory", 1, 0, "DapTransactionModel");
    
    QQmlApplicationEngine engine;
//    qreal dpi = QGuiApplication::primaryScreen()->physicalDotsPerInch();
    engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    engine.rootContext()->setContextProperty("dapUiQmlWidgetModel", &DapUiQmlWidgetModel::getInstance());
    engine.rootContext()->setContextProperty("dapLogModel", &DapLogModel::getInstance());
    engine.rootContext()->setContextProperty("dapChainWalletsModel", &DapChainWalletsModel::getInstance());
    engine.rootContext()->setContextProperty("dapNodeNetworkModel", &DapChainNodeNetworkModel::getInstance());
    engine.rootContext()->setContextProperty("dapHistoryModel", &DapScreenHistoryFilterModel::getInstance());
    engine.rootContext()->setContextProperty("pt", 1.3 /* *dpi */);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    
//    DapSettings &settings = DapSettings::getInstance("Settings.json");
//    DapSettingsCipher &set = DapSettingsCipher::getInstance(settings);
//    qDebug() << "Settings file name: " << set.getFileName();
//    set.setKeyValue("user", "Vasy");
//    bool f = false;
//    set.setGroupPropertyValue("widgets", "name", "Services client", "visible", f);
//    qDebug() << set.getGroupPropertyValue("widgets", "name", "Services client", "visible").toBool();
//    qDebug() << set.getKeyValue("user");
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}
