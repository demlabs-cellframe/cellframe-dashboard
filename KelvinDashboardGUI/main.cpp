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
    qmlRegisterSingletonType<DapClient>("KelvinDashboard", 1, 0, "DapClient", DapClient::singletonProvider);
    
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("dapClient", &DapClient::getInstance());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}
