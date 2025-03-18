#pragma once

#include <QObject>
#include "DapAbstractMasterNodeCommand.h"

class DapSrvStakeInvalidateStage : public DapAbstractMasterNodeCommand
{
    Q_OBJECT
public:
    DapSrvStakeInvalidateStage(DapServiceController *serviceController);

    void stakeInvalidate(const QVariantMap& masterNodeInfo);
    void checkStakeInvalidate(const QVariantMap& masterNodeInfo);
    void cencelRegistration() override;
private slots:
    void respondStakeInvalidate(const QVariant &rcvData);
    void respondCheckStakeDelegate(const QVariant &rcvData);
    void respondMempoolCheck(const QVariant &rcvData);

    void mempoolCheck();
    void checkStake();
private:
    void checkStakeDelegate();
private:
    QTimer* m_checkStakeTimer = nullptr;

    const int TIME_OUT_CHECK_STAKE = 5000;
};
