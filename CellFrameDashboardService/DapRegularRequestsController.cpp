#include "DapRegularRequestsController.h"

#include <QDebug>
#include <QRegularExpression>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>


DapRegularRequestsController::DapRegularRequestsController(QObject *parent)
    : QObject(parent)
    , m_cmdList(new DapCommandList())
    , m_timerUpdateListNetworks(new QTimer())
    , m_timerUpdateListWallets(new QTimer())
{
}

DapRegularRequestsController::~DapRegularRequestsController()
{
    delete m_timerUpdateListWallets;
    delete m_timerUpdateListNetworks;
    delete m_cmdList;
}

void DapRegularRequestsController::start()
{
    m_timerUpdateListNetworks->start(TIMER_COUNT);
    m_timerUpdateListWallets->start(TIMER_COUNT);

    connect(m_timerUpdateListNetworks, &QTimer::timeout, this, &DapRegularRequestsController::updateListNetworks);
    //[=] {
//        updateListNetworks();
//    });

    connect(m_timerUpdateListWallets, &QTimer::timeout, this, &DapRegularRequestsController::updateListWallets);
//            [=] {
//        updateListWallets();
//    });
}

void DapRegularRequestsController::updateListNetworks()
{
    QStringList listNetworks;

    // Request
    auto respondVar = m_cmdList->getListNetworks();

    // Compare with last respond
    if(compareWithLastRespond(respondVar, m_lastRespondNetworks)) return;

    // Parsing
    auto respond = m_cmdList->getJsonResult(respondVar,"net list");

    QString errorMsg = m_cmdList->getError(respond.error);
    if(!errorMsg.isEmpty())
    {
        qWarning() << "Get net list. Error:" << errorMsg;
        return;
    }

    auto networksObject = respond.result.toArray()[0].toObject();
    auto networksArray = networksObject["networks"].toArray();
    for(const auto& item: networksArray)
    {
        listNetworks.append(item.toString());
    }

    QVariant result = QVariant::fromValue(listNetworks);
    emit listNetworksUpdated(std::move(result));
}

void DapRegularRequestsController::updateListWallets()
{
    QMap<QString, QString> listWallets;

    // Request
    auto respondVar = m_cmdList->getRequestListWallets();

    // Compare with last respond
    if(compareWithLastRespond(respondVar, m_lastRespondWallets)) return;

    // Parsing
    auto respond = m_cmdList->getJsonResult(respondVar,"wallet list");

    QString errorMsg = m_cmdList->getError(respond.error);
    if(!errorMsg.isEmpty())
    {
        qWarning() << "Get wallet list. Error:" << errorMsg;
        return;
    }

    auto wallets = respond.result[0].toArray();
    for(const auto& item: wallets)
    {
        auto walletObject = item.toObject();

        if(!walletObject.contains("Wallet"))
        {
            continue;
        }
        QString tmpName = walletObject["Wallet"].toString();
        auto tmpList = tmpName.split(".");
        if(tmpList.size() != 2)
        {
            continue;
        }
        if(tmpList[1] != "dwallet")
        {
            continue;
        }
        QString walletName = tmpList[0];
        if(!walletObject.contains("status"))
        {
            qWarning() << "The result is not a list.";
            continue;
        }
        QString status = walletObject["status"].toString();
        if(status == "protected-inactive")
        {
            status = "non-Active";
        }
        else if(status == "protected-active")
        {
            status = "Active";
        }
        else if(status == "unprotected")
        {
            status = "";
        }
        else
        {
            continue;
        }
        listWallets.insert(walletName, status);
    }

    // Send result
    QVariant result = QVariant::fromValue(listWallets);
    emit listWalletsUpdated(std::move(result));
}

bool DapRegularRequestsController::compareWithLastRespond(const QVariant &current, QByteArray &last)
{
    QByteArray curr = current.toJsonDocument().toJson();
    if(last == curr)
    {
        // is equal
        return true;
    }
    last = curr;
    return false;
}
