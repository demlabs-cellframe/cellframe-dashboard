#ifndef WALLETHISTORYMANAGER_H
#define WALLETHISTORYMANAGER_H

#include <QObject>
#include <QQmlContext>
#include "walletinfo.h"
#include "wallethistoryinfo.h"

class WalletHistoryManager : public QObject
{
    Q_OBJECT
public:
    explicit WalletHistoryManager(QObject *parent = nullptr);

    void setContext(QQmlContext *cont);

public slots:
    void walletsInfoReceived(const QVariant& inputList);

    void historyReceived(const QVariant& inputList);

    void getWalletHistory(int walletIndex);

signals:
    void requestToService(const QString& asServiceName,
        const QVariant &network, const QVariant &chain,
        const QVariant &address, const QVariant &name,
        const QVariant &arg5 = QVariant(), const QVariant &arg6 = QVariant(),
        const QVariant &arg7 = QVariant(), const QVariant &arg8 = QVariant(),
        const QVariant &arg9 = QVariant(), const QVariant &arg10 = QVariant());

//    void testSignal(const QString& message);

private:
    void updateModel();

private:
    QList <WalletInfo> walletsList;

    QList <WalletHistoryInfo> historyList;

    QQmlContext *context;
};

#endif // WALLETHISTORYMANAGER_H
