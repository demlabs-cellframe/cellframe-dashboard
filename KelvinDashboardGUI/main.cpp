#include <QApplication>
#include <QGuiApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemSemaphore>
#include <QSharedMemory>

#include "DapHalper.h"
#include "DapScreenDialog.h"
#include "DapScreenDialogChangeWidget.h"
#include "DapUiQmlWidgetModel.h"
#include "DapSettings.h"
#include "DapSettingsCipher.h"
#include "DapServiceClient.h"
#include "DapServiceController.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("DEMLABS");
    app.setOrganizationDomain("demlabs.com");
    app.setApplicationName("Kelvin Client");
    app.setWindowIcon(QIcon(":/Resources/Icons/icon.ico"));
    
    /// Local client.
    DapServiceClient dapServiceClient;
    // Creating a service controller
    DapServiceController &controller = DapServiceController::getInstance();
    controller.init(&dapServiceClient);
    dapServiceClient.init();
    
    qmlRegisterType<DapScreenDialog>("KelvinDashboard", 1, 0, "DapScreenDialog");
    qmlRegisterType<DapScreenDialogChangeWidget>("KelvinDashboard", 1, 0, "DapScreenDialogChangeWidget");
    qmlRegisterSingletonType<DapServiceController>("KelvinDashboard", 1, 0, "DapServiceController", DapServiceController::singletonProvider);
    qmlRegisterSingletonType<DapUiQmlWidgetModel>("KelvinDashboard", 1, 0, "DapUiQmlWidgetModel", DapUiQmlWidgetModel::singletonProvider);
    
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    engine.rootContext()->setContextProperty("dapUiQmlWidgetModel", &DapUiQmlWidgetModel::getInstance());
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
