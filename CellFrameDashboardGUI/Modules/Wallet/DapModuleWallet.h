#ifndef DAPMODULEWALLET_H
#define DAPMODULEWALLET_H

#include <QObject>
#include <QDebug>
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

#include "DapServiceController.h"

class DapModuleWallet : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleWallet(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);


private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;

public:
    void initConnect();

    QString testWal{"testWal"};


private:
    void getWalletsInfo(QStringList args);
    void getWalletInfo(QStringList args);
    void createTx(QStringList args);
    void createWallet(QStringList args);
    void getTxHistory(QStringList args);


private slots:
    void rcvWalletsInfo(const QVariant &rcvData);
    void rcvWalletInfo(const QVariant &rcvData);
    void rcvCreateTx(const QVariant &rcvData);
    void rcvCreateWallet(const QVariant &rcvData);
    void rcvHistory(const QVariant &rcvData);
};

#endif // DAPMODULEWALLET_H
