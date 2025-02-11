#include "DapModuleOrders.h"
#include "DapDataManagerController.h"

static DapOrdersModel *s_ordersModel = DapOrdersModel::global();

DapModuleOrders::DapModuleOrders(DapModulesController *parent)
    : DapAbstractModule(parent)
    , m_timerUpdateOrders(new QTimer())
{

    m_ordersProxyModel.setSourceModel(&m_ordersModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelOrders", s_ordersModel);
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("modelOrdersProxy", &m_ordersProxyModel);

    connect(m_modulesCtrl, &DapModulesController::initDone, [this] ()
    {
        initConnect();
    });
}

DapModuleOrders::~DapModuleOrders()
{
    disconnect(s_serviceCtrl, &DapServiceController::ordersListReceived, this, &DapModuleOrders::rcvOrdersList);
    disconnect(s_serviceCtrl, &DapServiceController::rcvXchangeOrderList,this, &DapModuleOrders::rcvXchangeOrderList);
    disconnect(s_serviceCtrl, &DapServiceController::createdVPNOrder,this, &DapModuleOrders::rcvCreateVPNOrder);
    disconnect(s_serviceCtrl, &DapServiceController::createdStakeOrder,this, &DapModuleOrders::rcvCreateStakeOrder);

    disconnect(m_timerUpdateOrders, &QTimer::timeout, this, &DapModuleOrders::slotUpdateOrders);

    delete m_timerUpdateOrders;
}

void DapModuleOrders::setPkeyFilterText(const QString &pkey)
{
    m_pkeyFilter = pkey;
    m_ordersProxyModel.setPkeyFilter(pkey);
    emit pkeyFilterChanged(m_pkeyFilter);
}

void DapModuleOrders::setNodeAddrFilterText(const QString &nodeAddr)
{
    if(!nodeAddr.isEmpty())
    {
        m_nodeAddrFilter = nodeAddr;
        m_ordersProxyModel.setNodeAddrFilter(nodeAddr);
        emit nodeAddrFilterChanged(m_nodeAddrFilter);
    }
}

void DapModuleOrders::getOrdersList()
{
    s_serviceCtrl->requestToService("DapGetListOrdersCommand");

    QStringList netList = m_modulesCtrl->getManagerController()->getNetworkList();
    QString nodeMade = DapNodeMode::getNodeMode() == DapNodeMode::NodeMode::LOCAL ? Dap::NodeMode::LOCAL_MODE : Dap::NodeMode::REMOTE_MODE;
    QVariantMap request = {
        {Dap::CommandParamKeys::NODE_MODE_KEY, nodeMade}
        ,{Dap::KeysParam::NETWORK_LIST, netList}
    };
    s_serviceCtrl->requestToService("DapGetXchangeOrdersList", request);
}

void DapModuleOrders::rcvXchangeOrderList(const QVariant &rcvData)
{
    if(buffDexOrders != rcvData.toByteArray() || !m_statusInit)
    {
        s_statusModel.first = false;
        buffDexOrders = rcvData.toByteArray();
        modelProcessing(rcvData, true);
    }
}

void DapModuleOrders::rcvCreateVPNOrder(const QVariant &rcvData)
{
    slotUpdateOrders();
    emit sigCreateVPNOrder(rcvData);
}

void DapModuleOrders::rcvCreateStakeOrder(const QVariant &rcvData)
{
    slotUpdateOrders();
    emit sigCreateStakeOrder(rcvData);
}

void DapModuleOrders::rcvOrdersList(const QVariant &rcvData)
{
    if(buffVPNOrders != rcvData.toByteArray() || !m_statusInit)
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
    connect(s_serviceCtrl, &DapServiceController::createdVPNOrder,
            this, &DapModuleOrders::rcvCreateVPNOrder,
            Qt::QueuedConnection);
    connect(s_serviceCtrl, &DapServiceController::createdStakeOrder,
            this, &DapModuleOrders::rcvCreateStakeOrder,
            Qt::QueuedConnection);

    connect(m_timerUpdateOrders, &QTimer::timeout,
            this, &DapModuleOrders::slotUpdateOrders,
            Qt::QueuedConnection);

    connect(this, &DapAbstractModule::statusProcessingChanged, [this]
    {
        qDebug()<<"m_statusProcessing" << m_statusProcessing;
        if(m_statusProcessing)
        {
            if(s_statusModel.first && s_statusModel.second && s_ordersModel->size())
            {
                setStatusInit(true);
                slotUpdateOrders();
            }
            else
                slotUpdateOrders();
        }
        else
        {
            m_timerUpdateOrders->stop();
            setStatusInit(false);
        }
    });
}

void DapModuleOrders::createStakeOrder(QStringList args)
{
    s_serviceCtrl->requestToService("DapCreateStakeOrder", args);
}

void DapModuleOrders::createVPNOrder(QStringList args)
{
    QStringList resultParams = {"network", args[0],
                                "direction", args[1],
                                "srv_uid", args[2],
                                "price", args[3],
                                "price_unit", args[4],
                                "price_token", args[5],
                                "units", args[6],
                                "node_addr", args[7],
                                "cert", args[8],
                                "region", args[9],
                                "continent", args[10]};

    
    s_serviceCtrl->requestToService("DapCreateVPNOrder", resultParams);
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
    auto byteArrayData = DapCommonMethods::convertJsonResult(rcvData.toByteArray());
    QJsonDocument document = QJsonDocument::fromJson(byteArrayData);
    if(document.isNull() || document.isEmpty())
    {
        return;
    }

    QJsonObject resultObj = document.object();

    if(s_statusModel.first && s_statusModel.second)
    {
        s_statusModel.first = false;
        s_statusModel.second = false;
        m_ordersModel.clear();
    }

    QStringList networks = resultObj.keys();

    for(const QString &network : qAsConst(networks))
    {
        QJsonArray ordersArr = resultObj[network].toArray();

        for (auto itr = ordersArr.begin(); itr != ordersArr.end(); itr++)
        {
            DapOrdersModel::Item itemOrder;
            QJsonObject obj = itr->toObject();

            if(dexFlag && !s_statusModel.first)
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
            }
            else if(!dexFlag && !s_statusModel.second)
            {
                if(obj["srv_uid"].toString() == "Other")
                    continue;

                itemOrder.hash          = obj["hash"].toString();
                itemOrder.network       = network;
                itemOrder.version       = obj["version"].toString();
                itemOrder.direction     = obj["direction"].toString() == "SERV_DIR_SELL" ? "SELL" : "BUY";
                itemOrder.created       = obj["created"].toString();
                itemOrder.srv_uid       = obj["srv_uid"].toString();
                itemOrder.price         = obj["price coins"].toString();
                itemOrder.price_unit    = obj["price unit"].toString();
                itemOrder.price_token   = obj["price token"].toString();
                itemOrder.node_addr     = obj["node_addr"].toString();
                itemOrder.node_location = obj["node_location"].toString();
                itemOrder.tx_cond_hash  = obj["tx_cond_hash"].toString();
                itemOrder.ext           = obj["ext"].toString();
                itemOrder.pkey          = obj["pkey"].toString();
                itemOrder.units         = obj["units"].toString();
            }

            m_ordersModel.add(itemOrder);
        }
    }
    if(dexFlag)
        s_statusModel.first = true;
    else
        s_statusModel.second = true;

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


