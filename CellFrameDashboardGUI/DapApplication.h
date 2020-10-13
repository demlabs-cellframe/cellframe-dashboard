#ifndef DAPAPPLICATION_H
#define DAPAPPLICATION_H

#include <QApplication>
#include "DapNetworksList.h"
#include "QQmlApplicationEngine"
#include "DapServiceController.h"

class DapApplication : public QApplication
{
public:
    DapApplication(int &argc, char **argv);

    DapNetworksList *networks();
    QQmlApplicationEngine *qmlEngine();

private:
    void setContextProperties();
    void registerQmlTypes();

    DapNetworksList m_networks;
    QQmlApplicationEngine m_engine;
};

#endif // DAPAPPLICATION_H
