#include "DapModuleWallet.h"

DapModuleWallet::DapModuleWallet(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_timerUpdateWallet(new QTimer())
{
    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        initConnect();
        m_timerUpdateWallet->start(2000);
        setStatusInit(true);
    });
}

void DapModuleWallet::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::walletsReceived,          this, &DapModuleWallet::rcvWalletsInfo);
    connect(s_serviceCtrl, &DapServiceController::walletReceived,           this, &DapModuleWallet::rcvWalletInfo);
    connect(s_serviceCtrl, &DapServiceController::transactionCreated,       this, &DapModuleWallet::rcvCreateTx);
    connect(s_serviceCtrl, &DapServiceController::walletCreated,            this, &DapModuleWallet::rcvCreateWallet);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory);


    connect(m_timerUpdateWallet, &QTimer::timeout, this, &DapModuleWallet::slotUpdateWallet);


    s_serviceCtrl->requestToService("DapGetWalletsInfoCommand", QStringList()<<"true");
}

void DapModuleWallet::timerUpdateFlag(bool flag)
{
    if(flag)
        m_timerUpdateWallet->start(2000);
    else
        m_timerUpdateWallet->stop();
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
    m_walletsModel = QJsonDocument::fromJson(rcvData.toByteArray());
    emit sigWalletsInfo(m_walletsModel.toJson());
}
QByteArray DapModuleWallet::getWalletsModel()
{
    return m_walletsModel.toJson();
}

void DapModuleWallet::rcvWalletInfo(const QVariant &rcvData)
{
    qDebug()<<rcvData;
    emit sigWalletInfo(rcvData);
}

void DapModuleWallet::rcvCreateTx(const QVariant &rcvData)
{
    qDebug()<<rcvData;
    emit sigTxCreate(rcvData);
}

void DapModuleWallet::rcvCreateWallet(const QVariant &rcvData)
{
    qDebug()<<rcvData;
    m_modulesCtrl->restoreIndex();
    emit sigWalletCreate(rcvData);
}

void DapModuleWallet::rcvHistory(const QVariant &rcvData)
{
    qDebug()<<rcvData;
    emit sigHistory(rcvData);
}

void DapModuleWallet::slotUpdateWallet()
{
    qDebug()<<"slotUpdateWallet";
    if(m_modulesCtrl->m_walletList.isEmpty() && (m_modulesCtrl->m_currentWalletIndex < 0))
        return ;

    m_timerUpdateWallet->stop();
    getWalletInfo(QStringList()<<QString(m_modulesCtrl->m_currentWalletName));
    m_timerUpdateWallet->start(2000);
}
