#ifndef DAPAPPLICATION_H
#define DAPAPPLICATION_H

#include <QApplication>
#include <QtAndroid>
#include "DapNetworksList.h"
#include "QQmlApplicationEngine"
#include "DapServiceController.h"
#include "DapWalletBalanceModel.h"
#include "DapVpnOrdersModel.h"

class DapApplication : public QApplication
{
    Q_OBJECT

    Q_PROPERTY(DapWallet* currentWallet READ currentWallet WRITE setCurrentWallet NOTIFY currentWalletChanged)
public:
    DapApplication(int &argc, char **argv);

    DapNetworksList *networks();

    QQmlApplicationEngine *qmlEngine();

    Q_INVOKABLE void setClipboardText(const QString &text);
    Q_INVOKABLE DapWallet *currentWallet() const;
    Q_INVOKABLE void startService();
    void setCurrentWallet(DapWallet *a_currentWallet);
    DapVpnOrdersModel* getVpnOrdersModel();

signals:
    void currentWalletChanged(DapWallet* a_currentWallet);
private:
    void setContextProperties();
    void registerQmlTypes();


    DapNetworksList m_networks;
    QQmlApplicationEngine m_engine;
    DapWallet* m_currentWallet;
    DapServiceClient m_serviceClient;
    DapServiceController* m_serviceController;
    DapVpnOrdersModel m_vpnOrders;
};

#endif // DAPAPPLICATION_H
