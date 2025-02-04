#pragma once

#include <QTimer>
#include "DapAbstractMasterNodeCommand.h"

class DapStakeDelegate : public DapAbstractMasterNodeCommand
{
    Q_OBJECT
public:
    DapStakeDelegate(DapModulesController *modulesController);
    ~DapStakeDelegate();

    void stakeDelegate(const QVariantMap& masterNodeInfo);
    void tryCheckStakeDelegate(const QVariantMap& masterNodeInfo);

    void cencelRegistration() override;
private slots:
    void respondStakeDelegate(const QVariant &rcvData);
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
