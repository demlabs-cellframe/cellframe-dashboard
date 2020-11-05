#include "DapApplication.h"
#include <QQmlContext>
#include <DapLogMessage.h>
#include <QIcon>
#include <QClipboard>
#include "quickcontrols/qrcodequickitem.h"
#include "DapVpnOrdersModel.h"

DapApplication::DapApplication(int &argc, char **argv)
    :QApplication(argc, argv)
{
    this->setOrganizationName("DEMLABS");
    this->setOrganizationDomain("demlabs.net");
    this->setApplicationName("CellFrame Dashboard");
    this->setWindowIcon(QIcon(":/resources/icons/icon.ico"));

    this->registerQmlTypes();
    this->setContextProperties();

    qRegisterMetaType<DapNetwork::State>("DapNetwork::State");

    connect(&DapServiceController::getInstance(), &DapServiceController::networksListReceived, this->networks(), &DapNetworksList::fill);
    connect(&DapServiceController::getInstance(), &DapServiceController::networkStatusReceived, [this](const QVariant & a_stateMap){
        networks()->setNetworkProperties(a_stateMap.toMap());
    });

    connect(this->networks(), &DapNetworksList::networkAdded, [](DapNetwork* network){
        DapServiceController::getInstance().requestNetworkStatus(network->name());
    });

    connect(&DapServiceController::getInstance(), &DapServiceController::newTargetNetworkStateReceived, [this](const QVariant & a_state){
        qDebug() << "newTargetNetworkStateReceived" << a_state;
    });
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

void DapApplication::setContextProperties()
{
    m_engine.rootContext()->setContextProperty("app", this);
    m_engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    m_engine.rootContext()->setContextProperty("pt", 1);

    m_engine.rootContext()->setContextProperty("networks", this->networks());
    m_engine.rootContext()->setContextProperty("vpnOrders", this->getVpnOrdersModel());
}
