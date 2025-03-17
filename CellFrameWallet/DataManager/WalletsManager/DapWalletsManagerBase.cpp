#include "DapWalletsManagerBase.h"

DapWalletsManagerBase::DapWalletsManagerBase(DapModulesController *moduleController)
    : DapAbstractDataManager(moduleController)
{}

void DapWalletsManagerBase::setCurrentWallet(const QPair<int,QString>& wallet)
{
    if(m_currentWallet == wallet)
    {
        return;
    }
    m_currentWallet = wallet;
    currentWalletChangedSlot();
    emit currentWalletChanged();
}

const void DapWalletsManagerBase::removeWallet(const QString &walletName)
{
    if(m_walletsInfo.contains(walletName))
    {
        m_walletsInfo.remove(walletName);
    }
}
