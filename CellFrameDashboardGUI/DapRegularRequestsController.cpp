#include "DapRegularRequestsController.h"

#include <QDebug>
#include <QRegularExpression>
#include <QJsonValue>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonDocument>

DapRegularRequestsController::DapRegularRequestsController(QString cliPath, QString toolPath, QObject *parent)
    : QObject(parent)
    , m_nodeCliPath(cliPath)
    , m_nodeToolPath(toolPath)
    , m_cmdList(new DapCommandList(cliPath, toolPath))
    , m_timerUpdateListNetworks(new QTimer())
    , m_timerUpdateListWallets(new QTimer())
    , m_timerUpdateFee(new QTimer())
{
}

DapRegularRequestsController::~DapRegularRequestsController()
{
    delete m_timerUpdateListWallets;
    delete m_timerUpdateListNetworks;
    delete m_timerUpdateFee;
    delete m_cmdList;
}

void DapRegularRequestsController::start()
{
    m_timerUpdateListNetworks->start(TIMER_COUNT);
    m_timerUpdateListWallets->start(TIMER_COUNT);
    m_timerUpdateFee->start(FEE_TIMER);

    connect(m_timerUpdateListNetworks, &QTimer::timeout, this, &DapRegularRequestsController::updateListNetworks);
    connect(m_timerUpdateListWallets, &QTimer::timeout, this, &DapRegularRequestsController::updateListWallets);
    connect(m_timerUpdateFee, &QTimer::timeout, this, &DapRegularRequestsController::updateFeeInfo);
    updateListNetworks();
    updateListWallets();
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
    for(const auto& item: qAsConst(networksArray))
    {
        listNetworks.append(item.toString());
    }
    m_networkList = listNetworks;
    if(m_networkList.isEmpty())
    {
        emit feeClear();
    }
    updateFeeInfo();
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
    for(const auto& item: qAsConst(wallets))
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

void DapRegularRequestsController::updateFeeInfo()
{
    for(const auto& network: qAsConst(m_networkList))
    {
        auto request = m_cmdList->getJsonResult(m_cmdList->getFeeComand(network), "fee info").result;
        QByteArray feeByte = QJsonDocument(request.toObject()).toJson();
        if(!m_lastRespondFee.contains(network) || feeByte != m_lastRespondFee[network])
        {
            m_lastRespondFee[network] = feeByte;
            NetworkSpace::FeeInfoStruct result;

            auto testJsonBlock = [](bool expression, const QString& message) -> bool
            {
                if(expression)
                {
                    qWarning() << QString("[DapRegularRequestsController] [getFee] The output of the node has changed or some kind of error has occurred.(%1)").arg(message);
                    return false;
                }
                return true;
            };

            if(!testJsonBlock(request.isNull(), "the result block was not found"))
                continue;
            if(!testJsonBlock(!request.isArray(), "The block is no longer an array"))
                continue;

            auto mainArray = request.toArray();

            if(!testJsonBlock(mainArray.isEmpty(), "the array is empty"))
                continue;
            if(!testJsonBlock(!mainArray[0].toObject().contains("fees"), "the fees block is missing"))
                continue;

            auto fees = mainArray[0].toObject()["fees"].toObject();
            if(!testJsonBlock(!fees.contains("network"), "the network block is missing"))
                continue;

            {
                auto network = fees["network"].toObject();
                if(!testJsonBlock(!network.contains("addr"), "the network addr block is missing"))
                    continue;
                if(!testJsonBlock(!network.contains("balance"), "the network balance block is missing"))
                    continue;
                if(!testJsonBlock(!network.contains("coins"), "the network coins block is missing"))
                    continue;
                if(!testJsonBlock(!network.contains("ticker"), "the network ticker block is missing"))
                    continue;

                result.netCoins = network["coins"].toString();
                result.netDatoshi = network["balance"].toString();
                result.netTicker = network["ticker"].toString();
                result.netAddr = network["addr"].toString();
            }

            if(!testJsonBlock(!fees.contains("validators"), "the network block is missing"))
                continue;

            {
                auto validators = fees["validators"].toObject();

                auto getData = [&result, &testJsonBlock, &validators](const QString& blockName)
                {
                    auto object = validators[blockName].toObject();
                    if(!testJsonBlock(!object.contains("balance"), "the validators balance block is missing"))
                        return;
                    if(!testJsonBlock(!object.contains("coin"), "the validators coin block is missing"))
                        return;
                    NetworkSpace::ValidatorItem item;
                    item.coin = object["coin"].toString();
                    item.datoshi = object["balance"].toString();
                    result.validatorFeeList.insert(blockName,item);
                };

                if(!testJsonBlock(!validators.contains("average"), "the validators average block is missing"))
                    continue;
                getData("average");

                if(!testJsonBlock(!validators.contains("max"), "the validators balance block is missing"))
                    continue;
                getData("max");

                if(!testJsonBlock(!validators.contains("median"), "the validators coins block is missing"))
                    continue;
                getData("median");

                if(!testJsonBlock(!validators.contains("min"), "the validators ticker block is missing"))
                    continue;
                getData("min");

                if(!testJsonBlock(!validators.contains("token"), "the validators addr block is missing"))
                    continue;
                result.valTicker = validators["token"].toString();
            }
            QPair<QString, NetworkSpace::FeeInfoStruct> pair = {network, result};
            QVariant resultVariant = QVariant::fromValue(pair);

            emit feeUpdated(resultVariant);
        }
    }
}
