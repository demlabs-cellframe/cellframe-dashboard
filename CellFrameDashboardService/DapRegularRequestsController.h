#ifndef DAPREGULARREQUESTSCONTROLLER_H
#define DAPREGULARREQUESTSCONTROLLER_H

#include <QObject>
#include <QTimer>
#include <QByteArray>
#include "handlers/DapCommandList.h"

#include "NodePathManager.h"

class DapRegularRequestsController : public QObject
{
    Q_OBJECT
public:
    DapRegularRequestsController(QString cliPath, QString toolPath, QObject *parent = nullptr);
    ~DapRegularRequestsController();

    void start();

signals:
    void listNetworksUpdated(const QVariant &netlist);
    void listWalletsUpdated(const QVariant &wallets);

    void feeUpdated(const QVariant &fee);
    void feeClear();
private slots:
    void updateListNetworks();
    void updateListWallets();
    void updateFeeInfo();
private:
    /// Compare it with current to send signals only if them different
    bool compareWithLastRespond(const QVariant &current, QByteArray &last);
private:

    QString m_nodeCliPath;
    QString m_nodeToolPath;

    QStringList m_networkList;

    DapCommandList *m_cmdList = nullptr;

    QTimer *m_timerUpdateListNetworks = nullptr;
    QTimer *m_timerUpdateListWallets = nullptr;
    QTimer *m_timerUpdateFee = nullptr;

    QByteArray m_lastRespondNetworks;
    QByteArray m_lastRespondWallets;

    const int TIMER_COUNT = 1000;
    const int FEE_TIMER = 30000;
};

#endif // DAPREGULARREQUESTSCONTROLLER_H
