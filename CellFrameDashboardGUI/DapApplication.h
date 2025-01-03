#ifndef DAPAPPLICATION_H
#define DAPAPPLICATION_H

#include <QApplication>
#include "DapNetworksList.h"
//#include "DiagnosticWorker/DiagnosticWorker.h"
#include "Modules/DapModulesController.h"
#include "QQmlApplicationEngine"
#include "DapServiceController.h"
#include "DapWalletBalanceModel.h"
#include "DapVpnOrdersModel.h"
#include "mobile/QMLClipboard.h"
#include "mobile/testcontroller.h"
#include "Autocomplete/CommandHelperController.h"
#include "NotifyController/DapNotifyController.h"
//#include "DapMath.h"
//#include "DiagnosticWorker/models/NodeModel.h"

#include <iostream>

#include "ConfigWorker/configworker.h"
//#include "Workers/stringworker.h"
//#include "Workers/dateworker.h"

#include "Translator/qmltranslator.h"

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

    DapNetworksList *networks();

    QQmlApplicationEngine *qmlEngine();

    Q_INVOKABLE void setClipboardText(const QString &text);
//    Q_INVOKABLE DapWallet *currentWallet() const;
    Q_INVOKABLE void startService();

    Q_INVOKABLE void requestToService(QVariant sName, QVariantList sArgs);
    Q_INVOKABLE void notifyService(QVariant sName, QVariantList sArgs);

    DapVpnOrdersModel* getVpnOrdersModel();

    DapModulesController *s_modulesInit;

signals:
//    void currentWalletChanged(DapWallet* a_currentWallet);
private:
    void setContextProperties();
    void registerQmlTypes();

    void notifySignalsAttach();
    void notifySignalsDetach();
    void notifySocketStateChanged(QString state);

    CommandHelperController* m_commandHelper = nullptr; 
    DapNetworksList m_networks;
    QQmlApplicationEngine m_engine;
//    DapWallet* m_currentWallet;
    DapServiceClient m_serviceClient;
    DapServiceController* m_serviceController;
    DapNotifyController *m_DapNotifyController;
    DapVpnOrdersModel m_vpnOrders;
//    DapMath *m_mathBigNumbers;
//    DiagnosticWorker *m_diagnosticWorker;

//    StockDataWorker *stockDataWorker;
    ConfigWorker *configWorker;
//    StringWorker *stringWorker;
    DateWorker   *dateWorker;

    QMLTranslator * translator;

    QThread *m_threadNotify;
};

#endif // DAPAPPLICATION_H
