#ifndef DAPAPPLICATION_H
#define DAPAPPLICATION_H

#include <QApplication>
#include "DapNetworksList.h"
#include "DiagnosticWorker/DiagnosticWorker.h"
#include "Modules/DapModulesInit.h"
#include "QQmlApplicationEngine"
#include "DapServiceController.h"
#include "DapWalletBalanceModel.h"
#include "DapVpnOrdersModel.h"
#include "mobile/QMLClipboard.h"
#include "mobile/testcontroller.h"
#include "Autocomplete/CommandCmdController.h"
#include "DapMath.h"
#include "HistoryWorker/historyworker.h"
#include "DiagnosticWorker/models/NodeModel.h"

#include "DapLogger.h"
#include "DapDataLocal.h"
#include "DapLogHandler.h"
#include <iostream>

#include "StockDataWorker/stockdataworker.h"

#include "ConfigWorker/configworker.h"

#ifdef Q_OS_ANDROID
#include <QtAndroid>
#endif

class DapApplication : public QApplication
{
    Q_OBJECT

//    Q_PROPERTY(DapWallet* currentWallet READ currentWallet WRITE setCurrentWallet NOTIFY currentWalletChanged)

public:
    DapApplication(int &argc, char **argv);

    ~DapApplication();

    void createDapLogger();

    DapNetworksList *networks();

    QQmlApplicationEngine *qmlEngine();

    Q_INVOKABLE void setClipboardText(const QString &text);
//    Q_INVOKABLE DapWallet *currentWallet() const;
    Q_INVOKABLE void startService();

    Q_INVOKABLE void requestToService(QVariant sName, QVariantList sArgs);
    Q_INVOKABLE void notifyService(QVariant sName, QVariantList sArgs);

    DapVpnOrdersModel* getVpnOrdersModel();
    CommandCmdController *commandCmdController;

    DapModulesInit *s_modulesInit;

signals:
//    void currentWalletChanged(DapWallet* a_currentWallet);
private:
    void setContextProperties();
    void registerQmlTypes();


    DapNetworksList m_networks;
    QQmlApplicationEngine m_engine;
//    DapWallet* m_currentWallet;
    DapServiceClient m_serviceClient;
    DapServiceController* m_serviceController;
    DapVpnOrdersModel m_vpnOrders;
    DapMath *m_mathBigNumbers;
    DiagnosticWorker *m_diagnosticWorker;

    StockDataWorker *stockDataWorker;
    HistoryWorker * m_historyWorker;
    ConfigWorker *configWorker;
};

#endif // DAPAPPLICATION_H
