#pragma once

#include "DapFeeManagerBase.h"
#include <QTimer>

class DapFeeManager : public DapFeeManagerBase
{
    Q_OBJECT
public:
    DapFeeManager(DapModulesController *moduleController);

protected:
    void initManager() override;

private slots:
    void updateFee();
    void requestFee(const QString &network);
    void rcvFee(const QVariant &rcvData);
    void slotRcvFeeTimeout();
private:
    QTimer* m_feeUpdateTimer = nullptr;
    QTimer* m_rcvFeeTimeout  = nullptr;

    QString m_lastNatworkRequest = "";
    bool m_isRequestData = false;
    const int TIME_FEE_UPDATE = 60000;
    const int TIME_FEE_TIMEOUT = 30000;
};

