#ifndef DAPMODULESINIT_H
#define DAPMODULESINIT_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>
#include "qqmlcontext.h"

#include "DapAbstractModule.h"
#include "Wallet/DapModuleWallet.h"
#include "Test/DapModuleTest.h"


class DapModulesInit : public QObject
{
    Q_OBJECT
public:
    DapModulesInit(QQmlApplicationEngine *appEngine, QObject *parent = nullptr);

    QQmlApplicationEngine *s_appEngine;

    //Modules
    QList<DapAbstractModule*> m_listModules;
    DapModuleWallet * m_wallet;

    DapModuleTest * m_test;

public:
    void updateData();
    void initModules();

};

#endif // DAPMODULESINIT_H
