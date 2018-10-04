#include <QApplication>
#include <QGuiApplication>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemSemaphore>
#include <QSharedMemory>

#include "DapHalper.h"
#include "DapClient.h"
#include "DapScreenLogin.h"
#include "DapScreenDialog.h"
#include "DapScreenDialogChangeWidget.h"
#include "DapUiQmlWidgetModel.h"
#include "DapSettings.h"
#include "DapSettingsCipher.h"

int main(int argc, char *argv[])
{
    // Creating a semaphore for locking external resources, as well as initializing an external resource-memory
    QSystemSemaphore systemSemaphore(QString("systemSemaphore for %1").arg("KelvinDashboardGUI"), 1);
#ifndef Q_OS_WIN
    QSharedMemory memmoryAppBagFix(QString("memmory for %1").arg("KelvinDashboardGUI"));
#endif
    QSharedMemory memmoryApp(QString("memmory for %1").arg("KelvinDashboardGUI"));
    // Check for the existence of a running instance of the program
    bool isRunning = DapHalper::getInstance().checkExistenceRunningInstanceApp(systemSemaphore, memmoryApp, memmoryAppBagFix);
  
    if(isRunning)
    {
        return 1;
    }
    
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("DEMLABS");
    app.setOrganizationDomain("demlabs.com");
    app.setApplicationName("Kelvin Client");
    app.setWindowIcon(QIcon(":/Resources/Icons/icon.ico"));
    
    // Set the name of the service connection
    DapClient::getInstance().setNameSrvice(app.applicationName());
    // We establish a connection with the service
    DapClient::getInstance().connectToService("Kelvin Client");
    
    qmlRegisterType<DapScreenLogin>("KelvinDashboard", 1, 0, "DapScreenLogin");
    qmlRegisterType<DapScreenDialog>("KelvinDashboard", 1, 0, "DapScreenDialog");
    qmlRegisterType<DapScreenDialogChangeWidget>("KelvinDashboard", 1, 0, "DapScreenDialogChangeWidget");
    qmlRegisterSingletonType<DapClient>("KelvinDashboard", 1, 0, "DapClient", DapClient::singletonProvider);
    qmlRegisterSingletonType<DapUiQmlWidgetModel>("KelvinDashboard", 1, 0, "DapUiQmlWidgetModel", DapUiQmlWidgetModel::singletonProvider);
    
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dapClient", &DapClient::getInstance());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    
    DapSettings &settings = DapSettings::getInstance("Settings.json");
    DapSettingsCipher &set = DapSettingsCipher::getInstance(settings);
    qDebug() << "Settings file name: " << set.getFileName();
    set.setKeyValue("user", "Vasy");
    bool f = false;
    set.setGroupPropertyValue("widgets", "name", "Services client", "visible", f);
    qDebug() << set.getGroupPropertyValue("widgets", "name", "Services client", "visible").toBool();
    qDebug() << set.getKeyValue("user");
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}
