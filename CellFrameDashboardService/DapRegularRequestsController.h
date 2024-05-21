#ifndef DAPREGULARREQUESTSCONTROLLER_H
#define DAPREGULARREQUESTSCONTROLLER_H

#include <QObject>
#include <QTimer>
#include <QByteArray>
#include "handlers/DapCommandList.h"

class DapRegularRequestsController : public QObject
{
    Q_OBJECT
public:
    DapRegularRequestsController(DapCommandList *cmdList, QObject *parent = nullptr);
    ~DapRegularRequestsController();

    void start();

signals:
    void listNetworksUpdated(const QVariant &netlist);
    void listWalletsUpdated(const QVariant &wallets);

private:
    const int TIMER_COUNT = 1000;

    DapCommandList *m_cmdList;

    QTimer *m_timerUpdateListNetworks = nullptr;
    QTimer *m_timerUpdateListWallets = nullptr;

    /// Compare it with current to send signals only if them different
    bool compareWithLastRespond(const QVariant &current, QByteArray &last);
    QByteArray m_lastRespondNetworks;
    QByteArray m_lastRespondWallets;

    void updateListNetworks();
    void updateListWallets();

};

#endif // DAPREGULARREQUESTSCONTROLLER_H
