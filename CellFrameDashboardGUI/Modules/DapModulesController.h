#ifndef DAPMODULESCONTROLLER_H
#define DAPMODULESCONTROLLER_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "DapServiceController.h"
#include "Wallet/DapModuleWallet.h"

class DapModulesController : public QObject
{
    Q_OBJECT
public:
    explicit DapModulesController(QQmlApplicationEngine *appEngine, DapServiceController * serviceCtrl, QObject *parent = nullptr);

    QQmlApplicationEngine *s_appEngine;
    DapServiceController  *s_serviceCtrl;

    //Modules
    DapModuleWallet * m_wallet;
};

#endif // DAPMODULESCONTROLLER_H
