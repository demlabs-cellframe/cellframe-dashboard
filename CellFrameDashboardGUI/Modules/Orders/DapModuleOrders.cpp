#include "DapModuleOrders.h"

static DapOrdersModel *s_ordersModel = DapOrdersModel::global();

DapModuleOrders::DapModuleOrders(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_modulesCtrl(parent)
    , m_timerUpdateOrders(new QTimer())
{

    m_modulesCtrl->s_appEngine->rootContext()->setContextProperty("modelOrders", s_ordersModel);

    connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    {
        initConnect();
    });
}

DapModuleOrders::~DapModuleOrders()
{
    disconnect(s_serviceCtrl, &DapServiceController::ordersListReceived, this, &DapModuleOrders::rcvOrdersList);

    disconnect(m_timerUpdateOrders, &QTimer::timeout, this, &DapModuleOrders::slotUpdateOrders);

    delete m_timerUpdateOrders;
}

void DapModuleOrders::getOrdersList()
{
    s_serviceCtrl->requestToService("DapGetListOrdersCommand");
    s_serviceCtrl->requestToService("DapGetXchangeOrdersList");
}

void DapModuleOrders::rcvXchangeOrderList(const QVariant &rcvData)
{
    if(buffDexOrders != rcvData.toByteArray())
    {
        s_statusModel.first = false;
        buffDexOrders = rcvData.toByteArray();
        modelProcessing(rcvData, true);
    }
}

void DapModuleOrders::rcvOrdersList(const QVariant &rcvData)
{
    if(buffVPNOrders != rcvData.toByteArray())
    {
        s_statusModel.second = false;
        buffVPNOrders = rcvData.toByteArray();
        modelProcessing(rcvData, false);
    }
}

void DapModuleOrders::initConnect()
{
    connect(s_serviceCtrl, &DapServiceController::ordersListReceived,
            this, &DapModuleOrders::rcvOrdersList,
            Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::rcvXchangeOrderList,
            this, &DapModuleOrders::rcvXchangeOrderList,
            Qt::QueuedConnection);

    connect(m_timerUpdateOrders, &QTimer::timeout,
            this, &DapModuleOrders::slotUpdateOrders,
            Qt::QueuedConnection);

    connect(this, &DapAbstractModule::statusProcessingChanged, [=]
    {
        qDebug()<<"m_statusProcessing" << m_statusProcessing;
        if(m_statusProcessing)
        {
            slotUpdateOrders();
        }
        else
        {
            m_timerUpdateOrders->stop();
            setStatusInit(false);
        }
    });
}

void DapModuleOrders::slotUpdateOrders()
{
    m_timerUpdateOrders->stop();
    getOrdersList();
    m_timerUpdateOrders->start(20000);
}

void DapModuleOrders::setCurrentTab(int tabIndex)
{
    if (m_currentTab != tabIndex)
    {
        m_currentTab = tabIndex;
        updateOrdersModel();
    }
}

void DapModuleOrders::modelProcessing(const QVariant &rcvData, bool dexFlag)
{
    QJsonDocument dataDoc = QJsonDocument::fromJson(rcvData.toByteArray());

    if (!dataDoc.isObject())
        return;

    if(s_statusModel.first && s_statusModel.second)
    {
        s_statusModel.first = false;
        s_statusModel.second = false;
        m_ordersModel.clear();
    }

    QStringList networks = dataDoc.object().keys();

    for(const QString &network : qAsConst(networks))
    {
        QJsonArray ordersArr = dataDoc.object()[network].toArray();

        for (auto itr = ordersArr.begin(); itr != ordersArr.end(); itr++)
        {
            DapOrdersModel::Item itemOrder;
            QJsonObject obj = itr->toObject();

            if(dexFlag)
            {
                itemOrder.hash       = obj["order_hash"].toString();
                itemOrder.network    = network;
                itemOrder.created    = obj["created"].toString();
                itemOrder.status     = obj["status"].toString();
                itemOrder.amount     = obj["amount"].toString();
                itemOrder.sellToken  = obj["sell_token"].toString();
                itemOrder.buyToken   = obj["buy_token"].toString();
                itemOrder.filled     = obj["filled"].toString();
                itemOrder.rate       = obj["rate"].toString();
                itemOrder.srv_uid    = "DEX";

                s_statusModel.first = true;
            }
            else
            {
                if(obj["srv_uid"].toString() == "Other")
                    continue;

                itemOrder.hash          = obj["hash"].toString();
                itemOrder.network       = network;
                itemOrder.version       = obj["version"].toString();
                itemOrder.direction     = obj["direction"].toString() == "SERV_DIR_SELL" ? "SELL" : "BUY";
                itemOrder.created       = obj["created"].toString();
                itemOrder.srv_uid       = obj["srv_uid"].toString();
                itemOrder.price         = obj["price"].toString();
                itemOrder.price_unit    = obj["price_unit"].toString();
                itemOrder.price_token   = obj["price_token"].toString();
                itemOrder.node_addr     = obj["node_addr"].toString();
                itemOrder.node_location = obj["node_location"].toString();
                itemOrder.tx_cond_hash  = obj["tx_cond_hash"].toString();
                itemOrder.ext           = obj["ext"].toString();
                itemOrder.pkey          = obj["pkey"].toString();
                itemOrder.units         = obj["units"].toString();

                s_statusModel.second = true;
            }

            m_ordersModel.add(itemOrder);
        }
    }

    if(s_statusModel.first && s_statusModel.second)
    {
        updateOrdersModel();
        setStatusInit(true);
    }
}

void DapModuleOrders::updateOrdersModel()
{
    //TODO: set current tab and sort items

    s_ordersModel->clear();

    for (auto i = 0; i < m_ordersModel.size(); ++i)
    {
        const DapOrdersModel::Item &item = m_ordersModel.getItem(i);

        if(m_currentTab == VPN && item.srv_uid == "VPN")
            s_ordersModel->add(item);
        else if (m_currentTab == DEX && item.srv_uid == "DEX")
            s_ordersModel->add(item);
        else if (m_currentTab == Stake && item.srv_uid == "Stake")
            s_ordersModel->add(item);
    }
}


