#include "MainProcess.h"


MainProcess::MainProcess(sConfig *conf, QObject *parent) : QObject(parent)
{
    config=conf;
}

MainProcess::~MainProcess()
{
    
}

bool MainProcess::init()
{
    qDebug() << "Я здесь уже";
    // Creating the main application object
    service.start();
//    service.initTray();
//    tickNet->start();
    // Initialization of the application in the system tray
//    QTimer::singleShot(1,this, SLOT(initTray()));
//    service.initTray();
    return true;
}

void MainProcess::initTray()
{
    service.initTray();
}
