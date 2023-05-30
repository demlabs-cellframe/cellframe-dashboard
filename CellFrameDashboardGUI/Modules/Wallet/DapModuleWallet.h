#ifndef DAPMODULEWALLET_H
#define DAPMODULEWALLET_H

#include <QObject>
#include <QDebug>
#include "DapServiceController.h"
#include "../../Models/AbstractModels/DapAbstractModelWallets.h"
#include "../DapAbstractModule.h"
#include "../DapModulesController.h"

class DapModuleWallet : public DapAbstractModule
{
    Q_OBJECT
public:
    explicit DapModuleWallet(DapModulesController * modulesCtrl, DapAbstractModule *parent = nullptr);

    Q_PROPERTY (QByteArray m_walletsModel READ getWalletsModel NOTIFY walletsModelChanged)
    Q_INVOKABLE QByteArray getWalletsModel();
    QByteArray m_walletsModel;

private:
    DapServiceController  *s_serviceCtrl;
    DapModulesController  *s_modulesCtrl;

public:
    void initConnect();

    QString testWal{"testWal"};


public:
    Q_INVOKABLE void getWalletsInfo(QStringList args);
    Q_INVOKABLE void getWalletInfo(QStringList args);
    Q_INVOKABLE void createTx(QStringList args);
    Q_INVOKABLE void createWallet(QStringList args);
    Q_INVOKABLE void getTxHistory(QStringList args);

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
};

#endif // DAPMODULEWALLET_H
