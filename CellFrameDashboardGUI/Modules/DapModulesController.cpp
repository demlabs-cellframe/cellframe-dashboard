#include "DapModulesController.h"

#include <QQmlContext>

DapModulesController::DapModulesController(QQmlApplicationEngine *appEngine, DapServiceController *serviceCtrl, QObject *parent)
    : QObject(parent),
    s_appEngine(appEngine),
    s_serviceCtrl(serviceCtrl),
    m_wallet(new DapModuleWallet(s_appEngine, s_serviceCtrl)),
    m_stringWorker(new StringWorker(this))
{
    s_appEngine->rootContext()->
            setContextProperty("stringWorker", m_stringWorker);
}

DapModulesController::~DapModulesController()
{
    delete m_wallet;
    delete m_stringWorker;
}
