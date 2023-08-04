#ifndef DAPMODULEWALLET_H
#define DAPMODULEWALLET_H

#include <QObject>
#include <QDebug>
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "WalletRestore/wallethashmanager.h"
#include "DapTxWorker.h"

class DapModuleWallet : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleWallet(DapModulesController *parent);
    ~DapModuleWallet();

//    Q_PROPERTY (QByteArray m_walletsModel READ getWalletsModel NOTIFY walletsModelChanged)
    Q_INVOKABLE QByteArray getWalletsModel();
    QJsonDocument m_walletsModel;

    Q_INVOKABLE void timerUpdateFlag(bool flag);
    Q_INVOKABLE void updateCurrentWallet(){slotUpdateWallet();};


private:
    DapModulesController* m_modulesCtrl;
    QTimer *m_timerUpdateWallet;

public:
    void initConnect();
    QString testWal{"testWal"};
    WalletHashManager *m_walletHashManager;
    DapTxWorker *m_txWorker;

public:
    Q_INVOKABLE void getWalletsInfo(QStringList args);
    Q_INVOKABLE void getWalletInfo(QStringList args);
    Q_INVOKABLE void createWallet(QStringList args);
    Q_INVOKABLE void getTxHistory(QStringList args);

private:
    void updateWalletModel(QVariant, bool isSingle);

signals:
    void sigWalletInfo(const QVariant& result);
    void sigWalletsInfo(const QVariant& result);
    void sigTxCreate(const QVariant& result);
    void sigWalletCreate(const QVariant& result);
    void sigHistory(const QVariant& result);

    void walletsModelChanged();


private slots:
    void rcvWalletsInfo(const QVariant &rcvData);
    void rcvWalletInfo(const QVariant &rcvData);
    void rcvCreateTx(const QVariant &rcvData);
    void rcvCreateWallet(const QVariant &rcvData);
    void rcvHistory(const QVariant &rcvData);

    void slotUpdateWallet();
    void createTx(QStringList args);
};

#endif // DAPMODULEWALLET_H
