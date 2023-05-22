#ifndef DAPMODULEWALLET_H
#define DAPMODULEWALLET_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "DapServiceController.h"

class DapModuleWallet : public QObject
{
    Q_OBJECT
public:
    explicit DapModuleWallet(QQmlApplicationEngine *appEngine, DapServiceController * serviceCtrl, QObject *parent = nullptr);

private:
    QQmlApplicationEngine *s_appEngine;
    DapServiceController  *s_serviceCtrl;


public:
    void getWalletList();

public slots:
    void test(const QVariant &test);


};

#endif // DAPMODULEWALLET_H
