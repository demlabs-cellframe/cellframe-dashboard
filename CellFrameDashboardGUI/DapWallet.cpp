#include "DapWallet.h"

DapWallet::DapWallet()
{

}

DapWallet& DapWallet::instance()
{
    static DapWallet instance;
    return instance;
}

QString DapWallet::walletBalance()
{
    return convertWalletBallance();
}

void DapWallet::walletBalanceChanged()
{

}

QStringList DapWallet::walletList()
{
    return m_wallets;
}

QString DapWallet::convertWalletBallance(const QString& aName) const
{
    QString balance = QString::number(walletBalance(aName));
    qDebug()<<"balance";
    return DapChainConvertor::toConvertCurrency( balance);
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

////double DapWallet::walletBalance(const int aWalletIndex) const
////{
////    QString address = m_walletList[aWalletIndex].first.Address;
////    return walletBalance(address);
////}

//QList<QObject*> DapWallet::tokeListByWallet(const QString& aWalletAddress, const QString& aNetwork) const
//{
////    QList<QObject*> tokenList;
////    for(int i = 0; i < m_walletList.count(); i++)
////    {
////        if(m_walletList[i].first.Address == aWalletAddress)
////        {
////            if(aNetwork.isEmpty() || aNetwork == m_walletList[i].first.Network)
////            {
////                DapChainWalletTokenItemList mTokenList = m_walletList[i].second;
////                for(int m = 0; m < mTokenList.count(); m++)
////                {
////                    tokenList.append(mTokenList[m]);
////                }

////                return tokenList;
////            }

////        }
////    }

////    return tokenList;
//}

//QList<QObject*> DapWallet::tokeListByIndex(const int aIndex) const
//{
////    QList<QObject*> tokenList;
////    DapChainWalletTokenItemList tokenDataList = m_walletList[aIndex].second;
////    for(int i = 0; i < tokenDataList.count(); i++)
////        tokenList.append(tokenDataList[i]);

////    return tokenList;
//}


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

//void DapWallet::appendWallet(const DapChainWalletData& aWallet)
//{
////    m_walletList.append(DapChainWalletPair(aWallet, DapChainWalletTokenItemList()));
////    int lastIndex = m_walletList.count() - 1;

//}

//void DapWallet::removeWallet(const QString& aWalletAddress)
//{
////    int removeIndex = -1;
////    for(int i = 0; i < m_walletList.count(); i++)
////    {
////        if(m_walletList[i].first.Address == aWalletAddress)
////        {
////            m_walletList.removeAt(i);
////            removeIndex = i;
////            break;
////        }
////    }

////    if(removeIndex == -1) return;

//}

//void DapWallet::removeWallet(const int aWalletIndex)
//{
////    if(aWalletIndex > m_walletList.count() || m_walletList.count() < aWalletIndex) return;

////    m_walletList.removeAt(aWalletIndex);

//}
