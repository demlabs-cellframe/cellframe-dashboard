#include <QApplication>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QIcon>
#include <QSystemSemaphore>
#include <QSharedMemory>

/// Check for the existence of a running instance of the program.
/// @param systemSemaphore Semaphore for blocking shared resource.
/// @param memmoryApp Shared memory.
/// @param memmoryAppBagFix Shared memory for Linux system features.
/// @return If the application is running, it returns three, otherwise false.
bool checkExistenceRunningInstanceApp(QSystemSemaphore& systemSemaphore, QSharedMemory &memmoryApp, QSharedMemory &memmoryAppBagFix);

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    
    // Creating a semaphore for locking external resources, as well as initializing an external resource-memory
    QSystemSemaphore systemSemaphore(QString("systemSemaphore for %1").arg("Kelvin"), 1);
#ifndef Q_OS_WIN
    QSharedMemory memmoryAppBagFix(QString("memmory for %1").arg("Kelvin"));
#endif
    QSharedMemory memmoryApp(QString("memmory for %1").arg("Kelvin"));
    // Check for the existence of a running instance of the program
    bool isRunning = checkExistenceRunningInstanceApp(systemSemaphore, memmoryApp, memmoryAppBagFix);
  
    if(isRunning)
    {
        return 1;
    }
    
    QApplication app(argc, argv);
    app.setOrganizationName("DEMLABS");
    app.setOrganizationDomain("demlabs.com");
    app.setApplicationName("Kelvin");
    app.setWindowIcon(QIcon(":/Resources/Icons/icon.ico"));
    
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    
    if (engine.rootObjects().isEmpty())
        return -1;
    
    return app.exec();
}

/// Check for the existence of a running instance of the program.
/// @param systemSemaphore Semaphore for blocking shared resource.
/// @param memmoryApp Shared memory.
/// @param memmoryAppBagFix Shared memory for Linux system features.
/// @return If the application is running, it returns three, otherwise false.
bool checkExistenceRunningInstanceApp(QSystemSemaphore& systemSemaphore, QSharedMemory &memmoryApp, QSharedMemory &memmoryAppBagFix)
{
    systemSemaphore.acquire();
    
    if(memmoryAppBagFix.attach())
    {
        memmoryAppBagFix.detach();
    }
    
    bool isRunning {false};
    
    if (memmoryApp.attach())
    {
        isRunning = true;
    }
    else
    {
        memmoryApp.create(1);
        isRunning = false;
    }
    
    systemSemaphore.release();
    
    return isRunning;
}
