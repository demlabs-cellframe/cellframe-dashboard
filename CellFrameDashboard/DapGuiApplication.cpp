#include "DapGuiApplication.h"

const int USING_NOTIFY = 0;

#if defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)
const QString CURRENT_OS = "linux";
#elif defined(Q_OS_WIN)
const QString CURRENT_OS = "win";
#elif defined(Q_OS_MAC)
const QString CURRENT_OS = "macos";
#else
const QString CURRENT_OS = "unknown";
#endif

DapGuiApplication::DapGuiApplication(int &argc, char **argv, int restartCode, int defaultWidth, int defaultHeight, int minWidth, int minHeight)
    :QApplication(argc, argv)
    , translator(new QMLTranslator(&m_engine, this))
    , m_restartCode(restartCode)
    , m_defaultWidth(defaultWidth)
    , m_defaultHeight(defaultHeight)
    , m_minWidth(minWidth)
    , m_minHeight(minHeight)
{

    this->setOrganizationName("Cellframe Network");
    this->setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    this->setApplicationName(DAP_BRAND);
    this->setWindowIcon(QIcon(":/Resources/icon.ico"));

    QString lang = QSettings().value("currentLanguageName", "en").toString();
    qDebug() << "DapApplication" << "currentLanguageName" << lang;
    translator->setLanguage(lang);

    qmlEngine()->addImageProvider("resize", new ResizeImageProvider);
    qmlRegisterType<WindowFrameRect>("windowframerect", 1, 0, "WindowFrameRect");

    m_engine.rootContext()->setContextProperty("translator", translator);

    QQmlContext *context = qmlEngine()->rootContext();
    context->setContextProperty("RESTART_CODE", QVariant::fromValue(m_restartCode));
    context->setContextProperty("MIN_WIDTH", QVariant::fromValue(m_minWidth));
    context->setContextProperty("MIN_HEIGHT", QVariant::fromValue(m_minHeight));
    context->setContextProperty("MAX_WIDTH", QVariant::fromValue(m_minWidth));
    context->setContextProperty("MAX_HEIGHT", QVariant::fromValue(m_minHeight));
    context->setContextProperty("DEFAULT_WIDTH", QVariant::fromValue(m_defaultWidth));
    context->setContextProperty("DEFAULT_HEIGHT", QVariant::fromValue(m_defaultHeight));
    context->setContextProperty("USING_NOTIFY", QVariant::fromValue(USING_NOTIFY));
    context->setContextProperty("CURRENT_OS", QVariant::fromValue(CURRENT_OS));

    m_url.setUrl(getSkinUrl());

    QObject::connect(qmlEngine(), &QQmlApplicationEngine::objectCreated,
        this, [this](QObject *obj, const QUrl &objUrl) {
            if (!obj && m_url == objUrl) {
                QCoreApplication::exit(-1);
            }
        }, Qt::QueuedConnection);
}

DapGuiApplication::~DapGuiApplication()
{
}

QQmlApplicationEngine *DapGuiApplication::qmlEngine()
{
    return &m_engine;
}

void DapGuiApplication::loadUrl()
{
    qmlEngine()->load(m_url);
}

QString DapGuiApplication::getSkinUrl()
{
    QSettings settings;
    auto projectSkin = settings.value("project_skin", "").toString();
    if (projectSkin.isEmpty()) {
        settings.setValue("project_skin", "dashboard");
    }

    bool walletSkin = projectSkin == "wallet";
    walletSkin = false; // TODO: BLOCKED WALLET SKIN

    if (walletSkin) {
        qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));
        m_minWidth = 375;
        m_minHeight = 812;
        m_defaultWidth = 375;
        m_defaultHeight = 812;

        return "qrc:/walletSkin/main.qml";
    }

    return "qrc:/main.qml";
}
