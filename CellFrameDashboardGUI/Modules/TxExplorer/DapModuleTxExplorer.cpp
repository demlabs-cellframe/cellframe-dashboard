#include "DapModuleTxExplorer.h"
#include <QQmlContext>

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>

#include <QDebug>

// static DapHistoryModel *m_historyModel = DapHistoryModel::global();

DapModuleTxExplorer::DapModuleTxExplorer(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_timerHistoryUpdate(new QTimer(this))
    , m_historyModel(new DapHistoryModel)
    , m_historyProxyModel(new DapHistoryProxyModel())
{
    m_historyProxyModel->setSourceModel(m_historyModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelLastActions", m_historyProxyModel);
    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelHistory", m_historyProxyModel);

    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        initConnect();
        updateHistory(true);
    });
    connect(m_modulesCtrl, &DapModulesController::currentWalletNameChanged, [this] ()
            {
                this->setWalletName(m_modulesCtrl->getCurrentWalletName());
            });
}

void DapModuleTxExplorer::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::allWalletHistoryReceived,
            this, &DapModuleTxExplorer::setHistoryModel,
            Qt::QueuedConnection);
    connect(m_timerHistoryUpdate, &QTimer::timeout,
            this, &DapModuleTxExplorer::slotHistoryUpdate,
            Qt::QueuedConnection);

    connect(this, &DapAbstractModule::statusProcessingChanged, [=]
    {
//            qDebug()<<"m_statusProcessing" << m_statusProcessing;
        if(m_statusProcessing)
        {
            m_timerHistoryUpdate->start(10000);
            slotHistoryUpdate();
//            sendCurrentHistoryModel();
        }
        else
        {
            m_timerHistoryUpdate->stop();
            //setStatusInit(false);
        }
    });
}

void DapModuleTxExplorer::setHistoryModel(const QVariant &rcvData)
{
    isSendReqeust = false;
//    qDebug() << "DapModuleTxExplorer::setHistoryModel"
//             << "isEqual" << (rcvData.toString() == "isEqual");
    if(rcvData.toString() == "isEqual")
        return;

    QJsonDocument doc = QJsonDocument::fromJson(rcvData.toByteArray());

    if (!doc.isObject())
        return;

    if (doc["walletName"].toString() != m_walletName /*||
        doc["isLastActions"].toBool() != m_isLastActions */)
    {
        qWarning() << "ERROR"
                   << "walletName" << doc["walletName"].toString() << m_walletName;

        return;
    }

    m_historyModel->clear();

    QJsonArray historyArray = doc["history"].toArray();

    QList<DapHistoryModel::Item> resultList;

    for(auto i = 0; i < historyArray.size(); i++)
    {
        DapHistoryModel::Item itemHistory;
        itemHistory.fee_token    = historyArray.at(i)["fee_token"].toString();
        itemHistory.fee_net      = historyArray.at(i)["fee_net"].toString();
        itemHistory.fee          = historyArray.at(i)["fee"].toString();
        itemHistory.value        = historyArray.at(i)["value"].toString();
        itemHistory.m_value      = historyArray.at(i)["m_value"].toString();
        itemHistory.m_token      = historyArray.at(i)["m_token"].toString();
        itemHistory.m_direction  = historyArray.at(i)["m_direction"].toString();
        itemHistory.direction    = historyArray.at(i)["direction"].toString();
        itemHistory.token        = historyArray.at(i)["token"].toString();
        itemHistory.status       = historyArray.at(i)["status"].toString();
        itemHistory.address      = historyArray.at(i)["address"].toString();
        itemHistory.date_to_secs = historyArray.at(i)["date_to_secs"].toString().toLongLong();
        itemHistory.date         = historyArray.at(i)["date"].toString();
        itemHistory.wallet_name  = historyArray.at(i)["wallet_name"].toString();
        itemHistory.network      = historyArray.at(i)["network"].toString();
        itemHistory.atom         = historyArray.at(i)["atom"].toString();
        itemHistory.tx_hash      = historyArray.at(i)["tx_hash"].toString();
        itemHistory.tx_status    = historyArray.at(i)["tx_status"].toString();

        QDateTime time = QDateTime::fromSecsSinceEpoch(itemHistory.date_to_secs);
        itemHistory.time = time.toString("hh:mm:ss");
        resultList.append(std::move(itemHistory));
        
    }

    std::sort(resultList.begin(), resultList.end(),[]
              (const DapHistoryModel::Item& a, const DapHistoryModel::Item& b)
              {
                  return a.date_to_secs > b.date_to_secs;
              });
    m_historyModel->updateModel(std::move(resultList));

        setStatusInit(true);

    emit updateHistoryModel();

}

void DapModuleTxExplorer::clearHistory()
{
    m_historyModel->clear();
    setStatusInit(false);
}

void DapModuleTxExplorer::setWalletName(QString str)
{
//    qDebug() << "DapModuleTxExplorer::setWalletName" << str;

    if (m_walletName != str)
    {
        m_walletName = str;

        m_historyModel->clear();
        isSendReqeust = false;
        updateHistory(true);
        setStatusInit(false);
    }
}


void DapModuleTxExplorer::slotHistoryUpdate()
{
    updateHistory(false);
}

void DapModuleTxExplorer::updateHistory(bool flag)
{
    QString currantWalletName = m_modulesCtrl->currentWalletName();

    if((currantWalletName.isEmpty() && (m_modulesCtrl->getCurrentWalletIndex() < 0)) || isSendReqeust)
        return ;

    m_timerHistoryUpdate->stop();
    s_serviceCtrl->requestToService("DapGetAllWalletHistoryCommand", QVariantList()<<m_modulesCtrl->getCurrentWalletName() << flag << false);
    m_timerHistoryUpdate->start(10000);
    isSendReqeust = true;
}
