#include "DapRegularRequestsController.h"

#include <QDebug>
#include <QRegularExpression>


DapRegularRequestsController::DapRegularRequestsController(DapCommandList *cmdList, QObject *parent)
    : QObject(parent)
    , m_cmdList(cmdList)
{
    m_timerUpdateListNetworks = new QTimer();
    m_timerUpdateListWallets = new QTimer();
}

DapRegularRequestsController::~DapRegularRequestsController()
{
    delete m_timerUpdateListWallets;
    delete m_timerUpdateListNetworks;
}

void DapRegularRequestsController::start()
{
    m_timerUpdateListNetworks->start(TIMER_COUNT);
    m_timerUpdateListWallets->start(TIMER_COUNT);

    connect(m_timerUpdateListNetworks, &QTimer::timeout, this, [=] {
        updateListNetworks();
    });

    connect(m_timerUpdateListWallets, &QTimer::timeout, this, [=] {
        updateListWallets();
    });
}

void DapRegularRequestsController::updateListNetworks()
{
    QStringList listNetworks;
    QString respond = m_cmdList->getListNetworks();
    if(m_lastRespondNetworks == respond)
    {
        // no change data
        return;
    }
    m_lastRespondNetworks = respond;

    if(!respond.contains("Socket connection err") && respond.contains("networks:"))
    {
        auto list = respond.split('\n');
        for(int i = 0; i < list.size(); i++)
        {
            if(list[i].contains("networks:"))
            {
                auto nets = list[i+1].split(',');
                for(auto &net: nets)
                {
                    listNetworks.append(net.trimmed());
                }
            }
        }
    }
    else
    {
        qWarning() << "ERROR. Networks list command. Message:" << respond;
    }

    QVariant result = QVariant::fromValue(listNetworks);
    emit listNetworksUpdated(std::move(result));
}

void DapRegularRequestsController::updateListWallets()
{
    QMap<QString, QString> listWallets;
    QString respond = m_cmdList->getRequestListWallets();
    if(m_lastRespondWallets == respond)
    {
        // no change data
        return;
    }
    m_lastRespondWallets = respond;

    auto list = respond.split('\n');
    auto regularWallet = QRegularExpression(R"(Wallet: (\S+).dwallet)");
    auto regularStatus = QRegularExpression(R"(status: (.+))");
    QString walletName;

    for(auto& str: list)
    {
        str = str.trimmed();
        if(str.isEmpty())
        {
            continue;
        }

        auto matchWalletName = regularWallet.match(str);
        if(matchWalletName.hasMatch())
        {
            walletName = matchWalletName.captured(1);
            continue;
        }
        if(!walletName.isEmpty())
        {
            auto matchStatus = regularStatus.match(str);
            if(matchStatus.hasMatch())
            {
                QString status = matchStatus.captured(1);
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
        }
    }

    QVariant result = QVariant::fromValue(listWallets);
    emit listWalletsUpdated(std::move(result));
}

