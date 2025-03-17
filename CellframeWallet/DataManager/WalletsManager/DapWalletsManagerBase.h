#pragma once

#include <DapAbstractDataManager.h>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include "CommandKeys.h"
#include "DapCommonMethods.h"
#include "Modules/Wallet/CommonWallet/DapWalletInfo.h"

class DapWalletsManagerBase : public DapAbstractDataManager
{
    Q_OBJECT
public:
    DapWalletsManagerBase(DapModulesController *moduleController);

    const QPair<int,QString>& getCurrentWallet() const { return m_currentWallet; }
    void setCurrentWallet(const QPair<int,QString>& wallet);

    const QMap<QString, CommonWallet::WalletInfo>& getWalletsInfo() const {return m_walletsInfo; }
    const CommonWallet::WalletInfo getCurrentWalletInfo() const {return m_walletsInfo.value(m_currentWallet.second);}
    const CommonWallet::WalletInfo getWalletInfo(QString walletName) const {return m_walletsInfo.value(walletName);}
    virtual void updateWalletList() {}
    virtual void updateWalletInfo() {}
    const QVariantList& getDuplicateWallets() const {return m_duplicateWallets; }
    const void removeWallet(const QString &walletName);

signals:
    void currentWalletChanged();
    void walletListChanged();
    void walletInfoChanged(const QString& walletName, const QString& networkName = "");
protected slots:
    virtual void currentWalletChangedSlot() {}
protected:
    QMap<QString, CommonWallet::WalletInfo> m_walletsInfo;
    QPair<int,QString> m_currentWallet = {-1, ""};

    QVariantList m_duplicateWallets;

};

