#include "DapModulesController.h"

DapModulesController::DapModulesController(QObject *parent)
    : QObject(parent)
    , s_serviceCtrl(&DapServiceController::getInstance())
{
    m_timerUpdateData = new QTimer(this);
    connect(m_timerUpdateData, &QTimer::timeout, this, &DapModulesController::getWalletList);
    connect(m_timerUpdateData, &QTimer::timeout, this, &DapModulesController::getNetworkList);

    connect(s_serviceCtrl, &DapServiceController::walletsReceived, this, &DapModulesController::rcvWalletList);
    connect(s_serviceCtrl, &DapServiceController::walletsReceived, this, &DapModulesController::rcvNetList);


}

DapModulesController::~DapModulesController()
{
    delete m_timerUpdateData;
}

DapModulesController &DapModulesController::getInstance()
{
    static DapModulesController instance;
    return instance;
}

void DapModulesController::setListModules(QMap<QString, DapAbstractModule*> &list)
{
    m_listModules = list;
}

QMap<QString, DapAbstractModule*> DapModulesController::getListModules()
{
    return m_listModules;
}

void DapModulesController::getWalletList()
{

}

void DapModulesController::getNetworkList()
{

}

void DapModulesController::rcvWalletList(const QVariant &rcvData)
{

}

void DapModulesController::rcvNetList(const QVariant &rcvData)
{

}
