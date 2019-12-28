#include "DapWallet.h"

DapWallet::DapWallet()
{

}

DapWallet& DapWallet::instance()
{
    static DapWallet instance;
    return instance;
}

QStringList DapWallet::walletList()
{
    return m_wallets;
}

double DapWallet::walletBalance(const QString& aName) const
{
    double balance = 0.0;

    for(int i = 0; i < m_walletList.count(); i++)
    {
        if(m_walletList[i].first.Name == aName || aName == ALL_WALLETS)
        {
            DapChainWalletTokenItemList tokenList = m_walletList[i].second;
            for(int m = 0; m < tokenList.count(); m++)
            {
                balance += tokenList[m]->balance();
            }
        }
    }
    return balance;
}

void DapWallet::setWalletData(const QByteArray& aData)
{

    m_walletList.clear();
    m_wallets.clear();
    m_wallets << ALL_WALLETS;

    QList<QPair<DapChainWalletData, QList<DapChainWalletTokenData>>> walletData;
    QDataStream in(aData);
    in >> walletData;

    for(int i = 0; i < walletData.count(); i++)
    {
        DapChainWalletPair walletPair(walletData[i].first, DapChainWalletTokenItemList());
        QList<DapChainWalletTokenData> tokeData = walletData[i].second;
        if(!m_wallets.contains(walletData[i].first.Name))
            m_wallets.append(walletData[i].first.Name);

        for(int m = 0; m < tokeData.count(); m++)
        {
            walletPair.second.append(new DapChainWalletTokenItem(walletData[i].first.Address, tokeData[m], this));
        }

        m_walletList.append(walletPair);
    }
    emit walletListChanged(m_wallets);
}
