#include "DapModuleWallet.h"

DapModuleWallet::DapModuleWallet(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_timerUpdateWallet(new QTimer())
    , m_walletHashManager(new WalletHashManager())
    , m_txWorker(new DapTxWorker())
{
    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        m_walletHashManager->setContext(m_modulesCtrl->s_appEngine->rootContext());
        m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("walletHashManager", m_walletHashManager);
        m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("txWorker", m_txWorker);

        initConnect();
        m_timerUpdateWallet->start(2000);
//        setStatusInit(true);
    });

    connect(m_modulesCtrl, &DapModulesController::sigFeeRcv, [=] (const QVariant &data)
    {
        m_txWorker->m_feeBuffer = QJsonDocument::fromJson(data.toByteArray());
    });
}
DapModuleWallet::~DapModuleWallet()
{
    delete m_timerUpdateWallet;
    delete m_walletHashManager;

    disconnect(s_serviceCtrl, &DapServiceController::walletsReceived,          this, &DapModuleWallet::rcvWalletsInfo);
    disconnect(s_serviceCtrl, &DapServiceController::walletReceived,           this, &DapModuleWallet::rcvWalletInfo);
    disconnect(s_serviceCtrl, &DapServiceController::transactionCreated,       this, &DapModuleWallet::rcvCreateTx);
    disconnect(s_serviceCtrl, &DapServiceController::walletCreated,            this, &DapModuleWallet::rcvCreateWallet);
    disconnect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory);

    disconnect(m_timerUpdateWallet, &QTimer::timeout, this, &DapModuleWallet::slotUpdateWallet);
}

void DapModuleWallet::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::walletsReceived,
            this, &DapModuleWallet::rcvWalletsInfo,
            Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletReceived,
            this, &DapModuleWallet::rcvWalletInfo,
            Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::transactionCreated,
            this, &DapModuleWallet::rcvCreateTx,
            Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletCreated,
            this, &DapModuleWallet::rcvCreateWallet,
            Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived,
            this, &DapModuleWallet::rcvHistory,
            Qt::QueuedConnection);

    connect(m_txWorker, &DapTxWorker::sigSendTx,
            this, &DapModuleWallet::createTx,
            Qt::QueuedConnection);

    connect(m_timerUpdateWallet, &QTimer::timeout,
            this, &DapModuleWallet::slotUpdateWallet,
            Qt::QueuedConnection);

    connect(this, &DapAbstractModule::statusProcessingChanged, [=]
    {
        qDebug()<<"m_statusProcessing" << m_statusProcessing;
        if(m_statusProcessing)
        {
            QJsonDocument doc = QJsonDocument::fromJson(m_modulesCtrl->m_walletList);
            if(!doc.array().isEmpty() && (m_modulesCtrl->m_currentWalletIndex >= 0))
                getWalletInfo(QStringList()<<QString(m_modulesCtrl->m_currentWalletName) << "true");

            m_timerUpdateWallet->start(5000);
        }
        else
        {
            m_timerUpdateWallet->stop();
            setStatusInit(false);
        }
    });


    getWalletsInfo(QStringList()<<"true");
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
    m_timerUpdateWallet->stop();
    s_serviceCtrl->requestToService("DapAddWalletCommand", args);
}

void DapModuleWallet::createPassword(QStringList args)
{
    s_serviceCtrl->requestToService("DapCreatePassForWallet", args);
}

void DapModuleWallet::getTxHistory(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetAllWalletHistoryCommand", args);
}

void DapModuleWallet::rcvWalletsInfo(const QVariant &rcvData)
{
    updateWalletModel(rcvData, false);
    emit sigWalletsInfo(m_walletsModel.toJson());
    setStatusInit(true);
}
QByteArray DapModuleWallet::getWalletsModel()
{
    return m_walletsModel.toJson();
}

void DapModuleWallet::rcvWalletInfo(const QVariant &rcvData)
{
    updateWalletModel(rcvData, true);
//    qDebug()<<rcvData;
//    if(rcvData == "isEqual")
//        return;
    emit sigWalletInfo(rcvData);
}

void DapModuleWallet::rcvCreateTx(const QVariant &rcvData)
{
//    qDebug()<<rcvData;
    emit sigTxCreate(rcvData);
}

void DapModuleWallet::rcvCreateWallet(const QVariant &rcvData)
{
//    qDebug()<<rcvData;
    m_modulesCtrl->getWalletList();
    m_timerUpdateWallet->start(5000);
    emit sigWalletCreate(rcvData);
}

void DapModuleWallet::rcvHistory(const QVariant &rcvData)
{
//    qDebug()<<rcvData;
    emit sigHistory(rcvData);
}

void DapModuleWallet::slotUpdateWallet()
{
//    qDebug()<<"slotUpdateWallet";
    QJsonDocument doc = QJsonDocument::fromJson(m_modulesCtrl->m_walletList);
    if(doc.array().isEmpty() && (m_modulesCtrl->m_currentWalletIndex < 0))
        return ;

    m_timerUpdateWallet->stop();
    getWalletInfo(QStringList()<<QString(m_modulesCtrl->m_currentWalletName) <<"false");
    m_timerUpdateWallet->start(5000);
}

void DapModuleWallet::updateWalletModel(QVariant data, bool isSingle)
{
    QJsonDocument buff = QJsonDocument::fromJson(data.toByteArray());

    if(buff.isNull() || buff.isEmpty())
        return ;

    if(!isSingle)
    {
        m_walletsModel = buff;
        m_txWorker->m_walletBuffer = buff;
    }
    else
    {
        QJsonObject objBuff = buff.object();
        QString walletNameBuff = objBuff.value("name").toString();

        if(m_walletsModel.isEmpty())
        {   QJsonArray arr;
            arr.append(objBuff);
            m_walletsModel.setArray(arr);
            m_txWorker->m_walletBuffer = m_walletsModel;
        }
        else
        {
            QJsonArray arrWallet = m_walletsModel.array();

            for (auto itr  = arrWallet.begin();
                 itr != arrWallet.end(); itr++)
            {
                QJsonObject obj = itr->toObject();
                if(obj["name"].toString() == walletNameBuff)
                {
                    arrWallet.removeAt(itr.i);
                    arrWallet.insert(itr, objBuff);
//                    arrWallet.at(itr.i) = objBuff;
                    m_walletsModel.setArray(arrWallet);
                    m_txWorker->m_walletBuffer = m_walletsModel;
                    return ;
                }
            }
        }
    }
}
