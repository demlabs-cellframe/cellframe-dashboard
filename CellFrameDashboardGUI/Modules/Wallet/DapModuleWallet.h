#ifndef DAPMODULEWALLET_H
#define DAPMODULEWALLET_H

#include <QObject>
#include <QDebug>
#include <QMap>
#include <QPair>

#include "../DapAbstractModule.h"
#include "../DapModulesController.h"
#include "WalletRestore/wallethashmanager.h"
#include "DapTxWorker.h"
#include "CommonWallet/DapWalletInfo.h"
#include "../../Models/DapListWalletsModel.h"
#include "../../Models/DapInfoWalletModel.h"

class DapModuleWallet : public DapAbstractModule
{
    Q_OBJECT

public:
    explicit DapModuleWallet(DapModulesController *parent);
    ~DapModuleWallet();

//    QJsonDocument m_walletsModel;

    Q_INVOKABLE void timerUpdateFlag(bool flag);
    Q_INVOKABLE void updateCurrentWallet(){slotUpdateWallet();}
    Q_INVOKABLE void getWalletsInfo(QStringList args);
    Q_INVOKABLE void requestWalletInfo(QStringList args);
    Q_INVOKABLE void createWallet(QStringList args);
    Q_INVOKABLE void getTxHistory(QStringList args);
    Q_INVOKABLE void createPassword(QStringList args);

    Q_INVOKABLE void setCurrentWallet(int index);
    Q_INVOKABLE void setCurrentWallet(const QString& walletName);
    Q_INVOKABLE int getCurrentIndex() const {return m_currentWallet.first;}
    Q_INVOKABLE QString getCurrentWalletName() const {return m_currentWallet.second;}

private:
    void initConnect();
    void updateWalletModel(QVariant, bool isSingle);
    void setNewCurrentWallet(const QPair<int, QString> newWallet);
    void updateWalletInfo(const QJsonDocument &document);
    void restoreIndex();

    int getIndexWallet(const QString& walletName) const;

    CommonWallet::WalletInfo creatInfoObject(const QJsonObject& walletObject);
signals:
    void sigWalletInfo(const QVariant& result);
    void sigWalletsInfo(const QVariant& result);
    void sigTxCreate(const QVariant& result);
    void sigWalletCreate(const QVariant& result);
    void sigHistory(const QVariant& result);

    void walletsModelChanged();
    void listWalletChanged();
    void listWalletFirstChenged();
    void currentWalletChanged();
private slots:
    void rcvWalletsInfo(const QVariant &rcvData);
    void rcvWalletInfo(const QVariant &rcvData);
    void rcvCreateTx(const QVariant &rcvData);
    void rcvCreateWallet(const QVariant &rcvData);
    void rcvHistory(const QVariant &rcvData);

    void slotUpdateWallet();
    void createTx(QStringList args);
    void requestWalletTokenInfo(QStringList args);

    void updateListWallets();
    void walletsListReceived(const QVariant &rcvData);

    void startUpdateCurrentWallet();

private:

    WalletHashManager *m_walletHashManager;
    DapTxWorker *m_txWorker;

    DapModulesController* m_modulesCtrl;
    QTimer *m_timerUpdateListWallets;
    QTimer *m_timerUpdateWallet;
    QTimer *m_timerCurrantUpdateWallet;

    QMap<QString, CommonWallet::WalletInfo> m_walletsInfo;

    DapListWalletsModel* m_walletModel = nullptr;
    DapInfoWalletModel* m_infoWallet = nullptr;

    QPair<int,QString> m_currentWallet = {-1, ""};
    QByteArray m_walletListTest;
    QByteArray m_walletsInfoTest;
    QByteArray m_walletInfoTest;

    bool m_firstDataLoad = false;
};

#endif // DAPMODULEWALLET_H
