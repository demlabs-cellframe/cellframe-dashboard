#ifndef DAPAPPLICATION_H
#define DAPAPPLICATION_H

#include <QApplication>
#include "DapNetworksList.h"
#include "QQmlApplicationEngine"
#include "DapServiceController.h"
#include "DapVpnOrdersModel.h"

class DapApplication : public QApplication
{
    Q_OBJECT

public:
    DapApplication(int &argc, char **argv);

    DapNetworksList *networks();
    QQmlApplicationEngine *qmlEngine();

    Q_INVOKABLE void setClipboardText(const QString &text);

    DapVpnOrdersModel* getVpnOrdersModel();

private:
    void setContextProperties();
    void registerQmlTypes();

    DapNetworksList m_networks;
    QQmlApplicationEngine m_engine;
    DapVpnOrdersModel m_vpnOrders;
};

#endif // DAPAPPLICATION_H
