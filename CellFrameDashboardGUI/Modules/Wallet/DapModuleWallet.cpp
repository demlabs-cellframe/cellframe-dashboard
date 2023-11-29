#include "DapModuleWallet.h"
#include <QStringList>

DapModuleWallet::DapModuleWallet(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_walletHashManager(new WalletHashManager())
    , m_txWorker(new DapTxWorker())
    , m_modulesCtrl(parent)
    , m_timerUpdateListWallets(new QTimer())
    , m_timerUpdateWallet(new QTimer())
    , m_walletModel(new DapListWalletsModel())
    , m_infoWallet (new DapInfoWalletModel())
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletModelList", m_walletModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("walletModelInfo", m_infoWallet);
    updateListWallets();

    connect(m_timerUpdateListWallets, &QTimer::timeout, this, &DapModuleWallet::updateListWallets, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletsListReceived, this, &DapModuleWallet::walletsListReceived, Qt::QueuedConnection);
    m_timerUpdateListWallets->start(5000);
    connect(this, &DapModuleWallet::currentWalletChanged, this, &DapModuleWallet::startUpdateCurrentWallet);

    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        m_walletHashManager->setContext(m_modulesCtrl->s_appEngine->rootContext());
        m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("walletHashManager", m_walletHashManager);
        m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("txWorker", m_txWorker);

        initConnect();
        m_timerUpdateWallet->start(2000);
    });

    connect(m_modulesCtrl, &DapModulesController::sigFeeRcv, [=] (const QVariant &data)
    {
        m_txWorker->m_feeBuffer = QJsonDocument::fromJson(data.toByteArray());
    });
}

DapModuleWallet::~DapModuleWallet()
{
    delete m_timerUpdateListWallets;
    delete m_timerUpdateWallet;
    delete m_walletHashManager;
    delete m_walletModel;

    disconnect(s_serviceCtrl, &DapServiceController::walletsReceived,          this, &DapModuleWallet::rcvWalletsInfo);
    disconnect(s_serviceCtrl, &DapServiceController::walletReceived,           this, &DapModuleWallet::rcvWalletInfo);
    disconnect(s_serviceCtrl, &DapServiceController::transactionCreated,       this, &DapModuleWallet::rcvCreateTx);
    disconnect(s_serviceCtrl, &DapServiceController::walletCreated,            this, &DapModuleWallet::rcvCreateWallet);
    disconnect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory);

    disconnect(m_timerUpdateWallet, &QTimer::timeout, this, &DapModuleWallet::slotUpdateWallet);
}

void DapModuleWallet::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::walletsReceived, this, &DapModuleWallet::rcvWalletsInfo, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletReceived, this, &DapModuleWallet::rcvWalletInfo, Qt::QueuedConnection);

    connect(s_serviceCtrl, &DapServiceController::transactionCreated, this, &DapModuleWallet::rcvCreateTx, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::walletCreated, this, &DapModuleWallet::rcvCreateWallet, Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived, this, &DapModuleWallet::rcvHistory, Qt::QueuedConnection);

    connect(m_txWorker, &DapTxWorker::sigSendTx, this, &DapModuleWallet::createTx, Qt::QueuedConnection);

    connect(m_timerUpdateWallet, &QTimer::timeout, this, &DapModuleWallet::slotUpdateWallet, Qt::QueuedConnection);

    getWalletsInfo(QStringList()<<"true");
}


void DapModuleWallet::updateListWallets()
{
    m_modulesCtrl->updateListWallets();
}

void DapModuleWallet::walletsListReceived(const QVariant &rcvData)
{
    QJsonDocument doc = QJsonDocument::fromJson(rcvData.toByteArray());

    if(doc.array().isEmpty())
    {
        setCurrentWallet(-1);
    }

    if(m_walletListTest != doc.toJson())
    {
        m_walletListTest = doc.toJson();
        updateWalletInfo(doc);

        m_walletModel->updateWallets(m_walletsInfo);

        if(!m_firstDataLoad)
        {
            restoreIndex();
            m_firstDataLoad = true;
            m_modulesCtrl->tryStartModules();
        }
        int index = getIndexWallet(m_currentWallet.second);
        if(m_walletsInfo.isEmpty())
        {
            m_currentWallet = {-1, ""};
        }
        else if(index == -1)
        {
            m_currentWallet = {0, m_walletsInfo.firstKey()};
        }
        else
        {
            m_currentWallet = {index, m_currentWallet.second};
        }

        if(m_walletsInfo.contains(m_currentWallet.second))
        {
            m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);
        }
        emit listWalletChanged();
    }
}

void DapModuleWallet::restoreIndex()
{
    QString prevName = m_modulesCtrl->getSettings()->value("walletName", "").toString();

    if(!prevName.isEmpty())
    {
        setCurrentWallet(prevName);
        return;
    }

    setCurrentWallet(0);
}

void DapModuleWallet::updateWalletInfo(const QJsonDocument& document)
{
    QJsonArray walletArray = document.array();

    QStringList currentList;

    for(const QJsonValue value: walletArray)
    {
        QJsonObject tmpObject = value.toObject();
        if(tmpObject.contains("name") && tmpObject.contains("status"))
        {
            QString walletName = tmpObject["name"].toString();
            if(!walletName.isEmpty())
            {
                if(m_walletsInfo.contains(walletName))
                {
                    m_walletsInfo[walletName].status = tmpObject["status"].toString();
                }
                else
                {
                    if(!walletName.isEmpty())
                    {
                        CommonWallet::WalletInfo tmpWallet;
                        tmpWallet.walletName = walletName;
                        tmpWallet.status = tmpObject["status"].toString();
                        m_walletsInfo.insert(walletName, std::move(tmpWallet));
                    }
                }
                currentList.append(walletName);
            }
        }
    }

    QStringList tmpList = m_walletsInfo.keys();
    QStringList diffList;
    for(const QString& str: tmpList)
    {
        if(!currentList.contains(str))
        {
            diffList.append(str);
        }
    }

    for(const QString& str: diffList)
    {
        m_walletsInfo.remove(str);
    }
}

void DapModuleWallet::setCurrentWallet(int index)
{
    QPair<int,QString> newWallet;
    if(index == -1 || m_walletsInfo.isEmpty())
    {
        newWallet = {-1, ""};
    }
    else if(m_walletsInfo.size() > index)
    {
        QStringList list = m_walletsInfo.keys();
        newWallet = {index, list[index]};
    }
    else
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }

    if(newWallet.first != m_currentWallet.first)
    {
        setNewCurrentWallet(std::move(newWallet));
    }
}

void DapModuleWallet::setCurrentWallet(const QString& walletName)
{
     QPair<int,QString> newWallet;

    if(m_walletsInfo.isEmpty())
    {
        newWallet = {-1, ""};
    }
    else if(walletName.isEmpty() || walletName.trimmed().isEmpty())
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }
    else if(m_walletsInfo.contains(walletName))
    {
        int index = getIndexWallet(walletName);
        newWallet = {index, walletName};
    }
    else
    {
        newWallet = {0, m_walletsInfo.first().walletName};
    }

    if(newWallet.first != m_currentWallet.first)
    {
        setNewCurrentWallet(std::move(newWallet));
    }
}

int DapModuleWallet::getIndexWallet(const QString& walletName) const
{
    QStringList walletsList = m_walletsInfo.keys();
    int index = -1;
    for(int i = 0; i < walletsList.size(); i++)
    {
        if(walletName == walletsList[i])
        {
            index = i;
            break;
        }
    }
    return index;
}

void DapModuleWallet::setNewCurrentWallet(const QPair<int,QString> newWallet)
{
    m_currentWallet = newWallet;
    m_modulesCtrl->getSettings()->setValue("walletName", m_currentWallet.second);
    if(!m_currentWallet.second.isEmpty())
    {
        m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);
    }
    else
    {
        m_infoWallet->updateModel({});
    }
    emit currentWalletChanged();
    m_modulesCtrl->setCurrentWallet(m_currentWallet);
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

void DapModuleWallet::requestWalletInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletInfoCommand", args);
}

void DapModuleWallet::createTx(QStringList args)
{
    s_serviceCtrl->requestToService("DapCreateTransactionCommand", args);
}

void DapModuleWallet::requestWalletTokenInfo(QStringList args)
{
    s_serviceCtrl->requestToService("DapGetWalletTokenInfoCommand", args);
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
}

void DapModuleWallet::rcvWalletInfo(const QVariant &rcvData)
{
    updateWalletModel(rcvData, true);
}

void DapModuleWallet::rcvCreateTx(const QVariant &rcvData)
{
//    qDebug()<<rcvData;
    emit sigTxCreate(rcvData);
}

void DapModuleWallet::rcvCreateWallet(const QVariant &rcvData)
{
//    qDebug()<<rcvData;
    m_modulesCtrl->updateListWallets();
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
    requestWalletInfo(QStringList() << getCurrentWalletName() <<"false");
}

void DapModuleWallet::updateWalletModel(QVariant data, bool isSingle)
{
    QByteArray byteArrayData = data.toByteArray();

    if(isSingle)
    {
        if(m_walletInfoTest != byteArrayData)
        {
            m_walletInfoTest = byteArrayData;
        }
        else
        {
            return;
        }
    }
    else
    {
        if(m_walletsInfoTest != byteArrayData)
        {
            m_walletsInfoTest = byteArrayData;
        }
        else
        {
            return;
        }
    }

    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);

    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    if(!isSingle)
    {
        QJsonArray walletArray = document.array();
        if(walletArray.isEmpty())
        {
            return;
        }

        for(const QJsonValue& walletValue: walletArray)
        {
            CommonWallet::WalletInfo tmpInfo = creatInfoObject(std::move(walletValue.toObject()));
            if(m_walletsInfo.contains(tmpInfo.walletName))
            {
                m_walletsInfo[tmpInfo.walletName] = std::move(tmpInfo);
            }
            else
            {
                if(!tmpInfo.walletName.isEmpty())
                {
                    m_walletsInfo.insert(tmpInfo.walletName, std::move(tmpInfo));
                }
            }
        }
        emit walletsModelChanged();
    }
    else
    {
        QJsonObject inObject = document.object();
        CommonWallet::WalletInfo tmpInfo = creatInfoObject(std::move(inObject));
        if(m_walletsInfo.contains(tmpInfo.walletName))
        {
            m_walletsInfo[tmpInfo.walletName] = std::move(tmpInfo);
        }
        else
        {
            if(!tmpInfo.walletName.isEmpty())
            {
                m_walletsInfo.insert(tmpInfo.walletName, std::move(tmpInfo));
            }
        }
        emit walletsModelChanged();
    }
    m_infoWallet->updateModel(m_walletsInfo[m_currentWallet.second].walletInfo);
    m_walletModel->updateWallets(m_walletsInfo);
    emit walletsModelChanged();
}

CommonWallet::WalletInfo DapModuleWallet::creatInfoObject(const QJsonObject& walletObject)
{
    CommonWallet::WalletInfo wallet;

    if(walletObject.contains("name"))
    {
        wallet.walletName = walletObject["name"].toString();
    }
    else
    {
        qWarning() << "[creatInfoObject] No wallet name";
        return CommonWallet::WalletInfo();
    }

    if(walletObject.contains("status"))
    {
        wallet.status = walletObject["status"].toString();
    }
    wallet.isLoad = true;
    if(walletObject.contains("networks"))
    {
        for(const QJsonValue& networkValue: walletObject["networks"].toArray())
        {
            QJsonObject networkObject = networkValue.toObject();
            CommonWallet::WalletNetworkInfo networkInfo;

            if(networkObject.contains("address"))
            {
                networkInfo.address = networkObject["address"].toString();
            }
            else
            {
                qWarning() << "The wallet address is missing on the network or the input data has changed";
                continue;
            }

            if(networkObject.contains("name"))
            {
                networkInfo.network = networkObject["name"].toString();
            }
            else
            {
                qWarning() << "The network name is missing or the input data has changed";
                continue;
            }

            if(networkObject.contains("tokens"))
            {
                for(const QJsonValue& tokenValue: networkObject["tokens"].toArray())
                {
                    QJsonObject tokenObject = tokenValue.toObject();
                    CommonWallet::WalletTokensInfo token;
                    if(tokenObject.contains("coins"))
                    {
                        token.value = tokenObject["coins"].toString();
                    }
                    if(tokenObject.contains("datoshi"))
                    {
                        token.datoshi = tokenObject["datoshi"].toString();
                    }
                    if(tokenObject.contains("name"))
                    {
                        token.ticker = tokenObject["name"].toString();
                        token.tokenName = tokenObject["name"].toString();
                    }

                    networkInfo.networkInfo.append(token);
                }
            }

            wallet.walletInfo.insert(networkInfo.network, networkInfo);
        }
    }
    return wallet;
}

void DapModuleWallet::startUpdateCurrentWallet()
{
    qDebug() << "New current wallet - " << m_currentWallet.second;

    if(!m_walletsInfo.contains(m_currentWallet.second))
    {
        qWarning() << "The wallet that you have now switched to does not exist";
        return;
    }

    emit walletsModelChanged();
    requestWalletInfo(QStringList() << m_currentWallet.second << "true");
}
