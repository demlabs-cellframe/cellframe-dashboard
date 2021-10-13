#include "DapApplication.h"
#include <QQmlContext>
#include <DapLogMessage.h>
#include <QIcon>
#include <QClipboard>
#include "quickcontrols/qrcodequickitem.h"
#include "DapVpnOrdersModel.h"

DapApplication::DapApplication(int &argc, char **argv)
    :QApplication(argc, argv)
    , m_serviceClient(DAP_SERVICE_NAME)
    , m_serviceController(&DapServiceController::getInstance())
{
    this->setOrganizationName("Cellframe Network");
    this->setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    this->setApplicationName(DAP_BRAND);
    this->setWindowIcon(QIcon(":/resources/icons/icon.ico"));

    qDebug()<<QString(DAP_SERVICE_NAME);

    m_serviceController->init(&m_serviceClient);
    m_serviceClient.init();

    this->registerQmlTypes();
    this->setContextProperties();

    qRegisterMetaType<DapNetwork::State>("DapNetwork::State");

    connect(&DapServiceController::getInstance(), &DapServiceController::networksListReceived, this->networks(), &DapNetworksList::fill);
    connect(&DapServiceController::getInstance(), &DapServiceController::networkStatusReceived, [this](const QVariant & a_stateMap){
        qDebug() << "networkStatusReceived" << a_stateMap;
        networks()->setNetworkProperties(a_stateMap.toMap());
    });

    connect(this->networks(), &DapNetworksList::networkAdded, [](DapNetwork* network){
        DapServiceController::getInstance().requestNetworkStatus(network->name());
    });

    connect(&DapServiceController::getInstance(), &DapServiceController::newTargetNetworkStateReceived, [this](const QVariant & a_state){
        qDebug() << "newTargetNetworkStateReceived" << a_state;
    });

    connect(m_serviceController, &DapServiceController::walletsReceived, [this](QList<QObject*> walletList)
    {
        qDebug() << "walletsReceived" << walletList;
        if (!walletList.isEmpty())
            this->setCurrentWallet(static_cast<DapWallet*>(walletList[0]));

        this->m_serviceController->requestWalletInfo(currentWallet()->getName(), currentWallet()->getNetworks());
    });
    m_serviceController->requestWalletList();
    m_serviceController->requestOrdersList();

    connect(m_serviceController, &DapServiceController::walletInfoReceived, [this](const QVariant& walletInfo)
    {
        qDebug() << "walletInfoReceived" << walletInfo;
        QVariantMap infoMap = walletInfo.toMap();
        if (currentWallet()->getName() == infoMap.value(DapGetWalletInfoCommand::WALLET_NAME).toString())
        {
            DapWalletBalanceModel::WalletBallanceInfo_t walletBalance;

            QVariantMap networkAllInfos = infoMap.value(DapGetWalletInfoCommand::NETWORKS_INFO).toMap();
            for (auto netIt = networkAllInfos.begin(); netIt != networkAllInfos.end(); ++netIt)
            {
                QVariantMap networkInfo = netIt.value().toMap().value(DapGetWalletInfoCommand::BALANCE).toMap();

                if (networkInfo.count() == 0)
                    continue;

                DapBalanceModel::BalanceInfo_t networkBalance;
                for (auto tokenIt = networkInfo.begin(); tokenIt != networkInfo.end(); ++tokenIt)
                {
                    const DapToken* currentToken = DapToken::token(tokenIt.key());

                    balance_t currentAmount = tokenIt.value().value<balance_t>();

                    if (networkBalance.contains(currentToken))
                        currentAmount =  currentAmount + networkBalance[currentToken];

                    networkBalance[currentToken] = currentAmount;
                }

                DapNetwork *currentNetwork = networks()->addIfNotExist(netIt.key());

                walletBalance.insert(currentNetwork, networkBalance);
            }
            currentWallet()->setBalance(walletBalance);
        }


    });


    m_currentWallet = new DapWallet(this);

    m_currentWallet->setBalance({{}});

}

DapNetworksList *DapApplication::networks()
{
    return &m_networks;
}

QQmlApplicationEngine *DapApplication::qmlEngine()
{
    return &m_engine;
}

void DapApplication::setClipboardText(const QString &text)
{
    clipboard()->setText(text);
}

DapVpnOrdersModel *DapApplication::getVpnOrdersModel()
{
    return &m_vpnOrders;
}

void DapApplication::registerQmlTypes()
{
    //register only enums
    qmlRegisterUncreatableType<DapCertificateType>("DapCertificateManager.Commands", 1, 0, "DapCertificateType"
                         , "Error create DapCertificateType");

    //register enums and constant property as singletone
    qmlRegisterSingletonType<DapCertificateCommands>("DapCertificateManager.Commands", 1, 0, "DapCertificateCommands"
            , [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
                    Q_UNUSED(engine)
                    Q_UNUSED(scriptEngine)

                    //qInfo() << "DapCertificateCommands initialize in Qml";
                    QQmlEngine::setObjectOwnership(DapCertificateCommands::instance()
                                                   , QQmlEngine::ObjectOwnership::CppOwnership);
                    return DapCertificateCommands::instance();
            });


    qmlRegisterType<DapLogMessage>("Demlabs", 1, 0, "DapLogMessage");
    qmlRegisterType<DapWallet>("Demlabs", 1, 0, "DapWallet");
    qmlRegisterType<DapWalletToken>("Demlabs", 1, 0, "DapWalletToken");
    qmlRegisterType<QrCodeQuickItem>("Demlabs", 1, 0, "QrCodeQuickItem");
    qRegisterMetaType<DapWallet>();
    qRegisterMetaType<DapWalletToken>();

    qmlRegisterType<DapVpnOrder>("Demlabs", 1, 0, "DapVpnOrder");
    qRegisterMetaType<DapVpnOrder>();

}

DapWallet *DapApplication::currentWallet() const
{
    return m_currentWallet;
}

void DapApplication::setCurrentWallet(DapWallet *a_currentWallet)
{
    if (m_currentWallet == a_currentWallet)
        return;
    m_currentWallet = a_currentWallet;

    emit this->currentWalletChanged(a_currentWallet);
}

void DapApplication::setContextProperties()
{
    m_engine.rootContext()->setContextProperty("app", this);
    m_engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    m_engine.rootContext()->setContextProperty("pt", 1);

    m_engine.rootContext()->setContextProperty("networks", this->networks());
    m_engine.rootContext()->setContextProperty("vpnOrders", this->getVpnOrdersModel());
}
