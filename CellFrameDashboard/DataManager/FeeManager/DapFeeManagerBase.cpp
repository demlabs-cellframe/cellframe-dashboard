#include "DapFeeManagerBase.h"

DapFeeManagerBase::DapFeeManagerBase(DapModulesController *moduleController)
    : DapAbstractDataManager(moduleController)
{

}

const CommonWallet::FeeInfo& DapFeeManagerBase::getFee(const QString& network)
{
    return m_feeInfo[network];
}
