#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "DapServiceController.h"
#include "Wallet/DapModuleWallet.h"
#include "stringworker.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    explicit DapModulesController(QQmlApplicationEngine *appEngine, DapServiceController * serviceCtrl, QObject *parent = nullptr);
    ~DapModulesController();

    QQmlApplicationEngine *s_appEngine;
    DapServiceController  *s_serviceCtrl;

    //Modules
    DapModuleWallet * m_wallet;
    StringWorker *m_stringWorker;
};

#endif // DAPMODULESCONTROLLER_H
