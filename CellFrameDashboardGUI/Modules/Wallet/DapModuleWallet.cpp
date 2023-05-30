#include "DapModuleWallet.h"

DapModuleWallet::DapModuleWallet(DapModulesController *modulesCtrl, DapAbstractModule *parent)
    : DapAbstractModule(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
    , s_modulesCtrl(modulesCtrl)
{
    initConnect();
}

void DapModuleWallet::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::walletsReceived,          this, &DapModuleWallet::rcvWalletsInfo);
    connect(s_serviceCtrl, &DapServiceController::walletReceived,           this, &DapModuleWallet::rcvWalletInfo);
    connect(s_serviceCtrl, &DapServiceController::transactionCreated,       this, &DapModuleWallet::rcvCreateTx);
    connect(s_serviceCtrl, &DapServiceController::walletCreated,            this, &DapModuleWallet::rcvCreateWallet);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory);



    s_serviceCtrl->requestToService("DapGetWalletsInfoCommand", QStringList()<<"true");
}

void DapModuleWallet::getWalletsInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletsInfoCommand", args);
}

void DapModuleWallet::getWalletInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletInfoCommand", args);
}

void DapModuleWallet::createTx(QStringList args)
{
    s_serviceCtrl->requestToService("DapCreateTransactionCommand", args);
}

void DapModuleWallet::createWallet(QStringList args)
{
    s_serviceCtrl->requestToService("DapAddWalletCommand", args);
}

void DapModuleWallet::getTxHistory(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetAllWalletHistoryCommand", args);
}

void DapModuleWallet::rcvWalletsInfo(const QVariant &rcvData)
{
    QJsonDocument doc = QJsonDocument::fromJson(rcvData.toByteArray());
    m_walletsModel = doc.toJson();
    emit sigWalletInfo(doc.toJson());
}
QByteArray DapModuleWallet::getWalletsModel()
{
    return m_walletsModel;
}

void DapModuleWallet::rcvWalletInfo(const QVariant &rcvData)
{
    qDebug()<<rcvData;
    emit sigWalletsInfo(rcvData);
}

void DapModuleWallet::rcvCreateTx(const QVariant &rcvData)
{
    qDebug()<<rcvData;
    emit sigTxCreate(rcvData);
}

void DapModuleWallet::rcvCreateWallet(const QVariant &rcvData)
{
    qDebug()<<rcvData;
    emit sigWalletCreate(rcvData);
}

void DapModuleWallet::rcvHistory(const QVariant &rcvData)
{
    qDebug()<<rcvData;
    emit sigHistory(rcvData);
}
