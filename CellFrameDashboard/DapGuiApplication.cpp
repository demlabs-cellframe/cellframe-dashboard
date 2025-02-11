#include "DapGuiApplication.h"

DapGuiApplication::DapGuiApplication(int &argc, char **argv)
    :QApplication(argc, argv)
    , translator(new QMLTranslator(&m_engine, this))
{

    this->setOrganizationName("Cellframe Network");
    this->setOrganizationDomain(DAP_BRAND_BASE_LO ".net");
    this->setApplicationName(DAP_BRAND);
    this->setWindowIcon(QIcon(":/Resources/icon.ico"));

    QString lang = QSettings().value("currentLanguageName", "en").toString();
    qDebug() << "DapApplication" << "currentLanguageName" << lang;
    translator->setLanguage(lang);

    m_engine.rootContext()->setContextProperty("translator", translator);
}

DapGuiApplication::~DapGuiApplication()
{

}

QQmlApplicationEngine *DapGuiApplication::qmlEngine()
{
    return &m_engine;
}
