#include "DapModuleWallet.h"

DapModuleWallet::DapModuleWallet(QObject *parent)
    : DapAbstractModule(parent)
{
    initConnect();
}

void DapModuleWallet::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory);
    connect(s_serviceCtrl, &DapServiceController::walletsReceived,          this, &DapModuleWallet::rcvWalletsInfo);
    connect(s_serviceCtrl, &DapServiceController::walletReceived,           this, &DapModuleWallet::rcvHistory);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory);
}

void DapModuleWallet::getWalletsInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletsInfoCommand");
}

void DapModuleWallet::getWalletInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletInfoCommand");
}

void DapModuleWallet::createTx(QStringList args)
{
    s_serviceCtrl->requestToService("DapCreateTransactionCommand");
}

void DapModuleWallet::createWallet(QStringList args)
{
    s_serviceCtrl->requestToService("DapAddWalletCommand");
}

void DapModuleWallet::getTxHistory(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetAllWalletHistoryCommand");
}

void DapModuleWallet::rcvWalletsInfo(const QVariant &rcvData)
{

}

void DapModuleWallet::rcvWalletInfo(const QVariant &rcvData)
{

}

void DapModuleWallet::rcvCreateTx(const QVariant &rcvData)
{

}

void DapModuleWallet::rcvCreateWallet(const QVariant &rcvData)
{

}

void DapModuleWallet::rcvHistory(const QVariant &rcvData)
{

}
