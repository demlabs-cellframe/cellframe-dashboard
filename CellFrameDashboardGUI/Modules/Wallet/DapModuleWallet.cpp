#include "DapModuleWallet.h"

DapModuleWallet::DapModuleWallet(QQmlApplicationEngine *appEngine, DapServiceController *serviceCtrl, QObject *parent)
    : QObject(parent),
      s_appEngine(appEngine),
      s_serviceCtrl(serviceCtrl)
{

    connect(s_serviceCtrl, &DapServiceController::walletsListReceived, this, &DapModuleWallet::test);

    getWalletList();
}

void DapModuleWallet::getWalletList()
{
    s_serviceCtrl->requestToService("DapGetListWalletsCommand");
}

void DapModuleWallet::test(const QVariant &test)
{
    qDebug()<<test;
}
