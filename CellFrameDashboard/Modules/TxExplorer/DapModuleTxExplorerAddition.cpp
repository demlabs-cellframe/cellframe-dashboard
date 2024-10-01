#include "DapModuleTxExplorerAddition.h"
#include <QQmlContext>

#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>

#include <QDebug>

DapModuleTxExplorerAddition::DapModuleTxExplorerAddition(DapModulesController *parent)
    : DapModuleTxExplorer(parent)
{

     auto* engine = m_modulesCtrl->getAppEngine();
     Q_ASSERT(engine);

     engine->rootContext()->setContextProperty("fullModelHistory", m_historyModel);


    // connect(m_modulesCtrl, &DapModulesController::initDone, [=] ()
    // {
    //     initConnect();
    //     updateHistory(true);
    // });

    // connect(m_modulesCtrl, &DapModulesController::currentWalletNameChanged, [this] ()
    //         {
    //             this->setWalletName(m_modulesCtrl->getCurrentWalletName());
    //         });
}
