#pragma once

#include <DapAbstractDataManager.h>
#include "Modules/Wallet/CommonWallet/DapWalletInfo.h"

class DapFeeManagerBase : public DapAbstractDataManager
{
    Q_OBJECT
public:
    DapFeeManagerBase(DapModulesController *moduleController);

    const CommonWallet::FeeInfo& getFee(const QString& network);
    bool isFeeEmpty() { return m_feeInfo.isEmpty(); }
signals:
    void feeUpdated(const QString& network);
protected:
    QMap<QString, CommonWallet::FeeInfo> m_feeInfo;
};

