#include "wallethistorymanager.h"

#include "DapWallet.h"
#include "DapWalletHistoryEvent.h"

#include <QByteArray>
#include <QDebug>

WalletHistoryManager::WalletHistoryManager(QObject *parent) :
    QObject(parent),
    context(nullptr)
{

}

void WalletHistoryManager::setContext(QQmlContext *cont)
{
    context = cont;
}

void WalletHistoryManager::walletsInfoReceived(const QVariant &inputList)
{
    qDebug() << "WalletHistoryManager::walletsInfoReceived";

    QByteArray  array = QByteArray::fromHex(inputList.toByteArray());
    QList<DapWallet> tempWallets;

    QDataStream in(&array, QIODevice::ReadOnly);
    in >> tempWallets;

    walletsList.clear();

    auto begin = tempWallets.begin();
    auto end = tempWallets.end();
    DapWallet * wallet = nullptr;

    for(;begin != end; ++begin)
    {
        WalletInfo info;

        wallet = new DapWallet(*begin);

        info.name = wallet->getName();

        QMap<QString, QString> map = wallet->getAddresses();

        foreach (const QString &key, map.keys())
        {
            NetworkInfo network;

            network.network = key;
            network.address = map.value(key);

            if (key == "core-t")
                network.chain = "zerochain";
            else
                network.chain = "zero";

            info.networkList.append(network);
        }

        qDebug() << "WalletHistoryManager WalletInfo"
            << info.name << info.networkList.first().network;

        walletsList.append(info);
    }

    getWalletHistory(0);
}

void WalletHistoryManager::historyReceived(const QVariant &inputList)
{
    qDebug() << "WalletHistoryManager::historyReceived";

    QByteArray  array = QByteArray::fromHex(inputList.toByteArray());
    QList<DapWalletHistoryEvent> tempWalletHistory;

    QDataStream in(&array, QIODevice::ReadOnly);
    in >> tempWalletHistory;

    QList<QObject*> walletHistory;
    auto begin = tempWalletHistory.begin();
    auto end = tempWalletHistory.end();
    DapWalletHistoryEvent * wallethistoryEvent = nullptr;
    for(;begin != end; ++begin)
    {
        WalletHistoryInfo info;

        wallethistoryEvent = new DapWalletHistoryEvent(*begin);

        info.wallet = wallethistoryEvent->getWallet();
        info.network = wallethistoryEvent->getNetwork();
        info.token = wallethistoryEvent->getName();
        info.txStatus = wallethistoryEvent->getStatus();
        info.txAmount = wallethistoryEvent->getAmount();
        info.date = wallethistoryEvent->getDate();
        info.secsSinceEpoch = wallethistoryEvent->getSecsSinceEpoch();

        historyList.append(info);

        qDebug() << "WalletHistoryManager WalletHistoryInfo"
            << info.wallet << info.network
            << info.token << info.txStatus << info.txAmount << info.date;
    }

    updateModel();
}

void WalletHistoryManager::getWalletHistory(int walletIndex)
{
    if (walletIndex <0 || walletIndex >= walletsList.size())
        return;

    for (int i = 0; i < walletsList.at(walletIndex).networkList.size(); ++i)
    {
        emit requestToService("DapGetWalletHistoryCommand",
            walletsList.at(walletIndex).networkList.at(i).network,
            walletsList.at(walletIndex).networkList.at(i).chain,
            walletsList.at(walletIndex).networkList.at(i).address,
            walletsList.at(walletIndex).name);
    }
}

void WalletHistoryManager::updateModel()
{
    qDebug() << "WalletHistoryManager::updateModel";

    QVariantList model;

    for (WalletHistoryInfo info: historyList)
    {
        model.append(QVariant::fromValue(info));

        qDebug() << "WalletHistoryInfo"
            << info.wallet << info.network
            << info.token << info.txStatus << info.txAmount << info.date;
    }

    context->setContextProperty("modelLastActions", model);

//    emit testSignal("WalletHistoryManager::updateModel");
}
