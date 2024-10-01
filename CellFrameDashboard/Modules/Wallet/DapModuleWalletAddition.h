#ifndef DAPMODULEWALLETADDITION_H
#define DAPMODULEWALLETADDITION_H

#include "DapModuleWallet.h"

class DapModuleWalletAddition : public DapModuleWallet
{
    Q_OBJECT

public:
    explicit DapModuleWalletAddition(DapModulesController *parent);
    ~DapModuleWalletAddition();

    Q_PROPERTY(QString currentNetworkName       READ getCurrentNetworkName  WRITE setCurrentNetworkName     NOTIFY currentNetworkChanged FINAL)
    Q_PROPERTY(QString currentAddress           READ getCurrentAddressNetwork  NOTIFY currentDataChange FINAL)

    Q_INVOKABLE void requestWalletInfo(const QString &walletName, const QString &key);

    Q_INVOKABLE void setCurrentWallet(int index) override;
    Q_INVOKABLE void setCurrentWallet(const QString& walletName) override;

    Q_INVOKABLE bool isModel() const;
    Q_INVOKABLE bool checkWalletLocked(QString walletName);

    Q_INVOKABLE QString isCreateOrder(const QString& network, const QString& amount, const QString& tokenName);
    Q_INVOKABLE QString getCurrentAddressNetwork();
    Q_INVOKABLE QString getAddressNetworkByWallet(const QString& walletName);

    void setCurrentNetworkName(const QString& networkName);
    QString getCurrentNetworkName() const { return m_currentNetworkName; }

private:
    void updateWalletInfo(const QJsonArray &array);
    void setNewCurrentWallet(const QPair<int, QString> newWallet) override;
    void updateWalletModel(QVariant, bool isSingle) override;
    CommonWallet::WalletInfo creatInfoObject(const QJsonObject& walletObject) override;

private slots:
    void walletsListReceived(const QVariant &rcvData) override;
    void rcvCreateTx(const QVariant &rcvData) override;
    void rcvFee(const QVariant &rcvData) override;

signals:
    void currentWalletNameChanged(const QString& name);

    void currentNetworkChanged(const QString& networkName);
    void currentDataChange();

private:
    int m_currentNetworkIndex = -1;
    QString m_currentNetworkName = "";


};

#endif // DAPMODULEWALLETADDITION_H
