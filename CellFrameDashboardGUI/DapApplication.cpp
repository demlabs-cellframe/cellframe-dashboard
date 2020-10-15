#include "DapApplication.h"
#include <QQmlContext>
#include <DapLogMessage.h>
#include <QIcon>
#include <QClipboard>

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
    qRegisterMetaType<DapWallet>();
    qRegisterMetaType<DapWalletToken>();
}

void DapApplication::setContextProperties()
{
    m_engine.rootContext()->setContextProperty("app", this);
    m_engine.rootContext()->setContextProperty("dapServiceController", &DapServiceController::getInstance());
    m_engine.rootContext()->setContextProperty("pt", 1);

    m_engine.rootContext()->setContextProperty("networksModel", QVariant::fromValue(this->networks()->model()));
}
