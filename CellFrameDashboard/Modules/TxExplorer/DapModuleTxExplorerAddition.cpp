#include "DapModuleTxExplorerAddition.h"
#include <QQmlContext>
#include "DapDataManagerController.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QDateTime>

#include <QDebug>

DapModuleTxExplorerAddition::DapModuleTxExplorerAddition(DapModulesController *parent)
    : DapModuleTxExplorer(parent)
{
    m_modulesCtrl->getAppEngine()->rootContext()->setContextProperty("fullModelHistory", m_historyModel);
}

void DapModuleTxExplorerAddition::setWalletName(QString str)
{
    // DapModuleTxExplorer::setWalletName(str);
    // if (m_walletName != str)
    // {
    //     m_historyProxyModel->resetCount();
    // }
}

void DapModuleTxExplorerAddition::setHistoryModel(const QVariant &rcvData)
{
    isSendReqeust = false;

    setIsRequest(true);

    if(rcvData.toString() == "isEqual")
        return;

    QJsonDocument doc = QJsonDocument::fromJson(rcvData.toByteArray());

    if (!doc.isObject())
        return;

    // if (doc["walletName"].toString() != m_modulesCtrl->getManagerController()->getCurrentWallet().second)
    // {
    //     qWarning() << "ERROR"
    //                << "walletName" << doc["walletName"].toString() << m_walletName
    //                << "isLastActions" << doc["isLastActions"].toBool() << m_isLastActions;
    //     return;
    // }

    QList<DapHistoryModel::Item> historyResult;

    QJsonArray historyArray = doc["history"].toArray();

    for(auto i = 0; i < historyArray.size(); i++)
    {
        DapHistoryModel::Item itemHistory;
        itemHistory.fee_token    = historyArray.at(i)["fee_token"].toString();
        itemHistory.fee_net      = historyArray.at(i)["fee_net"].toString();
        itemHistory.fee          = historyArray.at(i)["fee"].toString();
        itemHistory.value        = historyArray.at(i)["value"].toString();
        itemHistory.m_value      = historyArray.at(i)["m_value"].toString();
        itemHistory.m_token      = historyArray.at(i)["m_token"].toString();
        itemHistory.m_direction  = historyArray.at(i)["m_direction"].toString();
        itemHistory.x_value      = historyArray.at(i)["x_value"].toString();
        itemHistory.x_token      = historyArray.at(i)["x_token"].toString();
        itemHistory.x_direction  = historyArray.at(i)["x_direction"].toString();
        itemHistory.direction    = historyArray.at(i)["direction"].toString();
        itemHistory.token        = historyArray.at(i)["token"].toString();
        itemHistory.status       = historyArray.at(i)["status"].toString();
        itemHistory.address      = historyArray.at(i)["address"].toString();
        itemHistory.date_to_secs = historyArray.at(i)["date_to_secs"].toString().toLongLong();
        itemHistory.date         = historyArray.at(i)["date"].toString();
        itemHistory.wallet_name  = historyArray.at(i)["wallet_name"].toString();
        itemHistory.network      = historyArray.at(i)["network"].toString();
        itemHistory.atom         = historyArray.at(i)["atom"].toString();
        itemHistory.tx_hash      = historyArray.at(i)["tx_hash"].toString();
        itemHistory.tx_status    = historyArray.at(i)["tx_status"].toString();

        historyResult.append(std::move(itemHistory));
    }
    std::sort(historyResult.begin(), historyResult.end(),[]
              (const DapHistoryModel::Item& a, const DapHistoryModel::Item& b)
              {
                  return a.date_to_secs > b.date_to_secs;
              });

    m_historyModel->updateModel(historyResult);
    emit updateHistoryModel();
}

void DapModuleTxExplorerAddition::setLastActions(bool flag)
{
    if (m_isLastActions != flag)
    {
        m_isLastActions = flag;
    }
}

void DapModuleTxExplorerAddition::setIsRequest(bool isRequest)
{
    m_isRequest = isRequest;
    emit isRequestChanged(isRequest);
}
