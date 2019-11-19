#include "DapChainWalletModel.h"

DapChainWalletModel::DapChainWalletModel(QObject *parent)
    : QAbstractListModel(parent)
{
    m_currentWallet = "private";
}

DapChainWalletModel& DapChainWalletModel::instance()
{
    static DapChainWalletModel instance;
    return instance;
}

int DapChainWalletModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid()) return 0;
    return m_walletList.count();
}

QVariant DapChainWalletModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) return QVariant();
    switch (role) {
        case WalletNameDisplayRole:         return m_walletList[index.row()].first.Name;
        case WalletAddressDisplayRole:      return m_walletList[index.row()].first.Address;
        case WalletIconDisplayRole:         return m_walletList[index.row()].first.IconPath;
        case NetworkDisplayRole:            return m_walletList[index.row()].first.Network;
        case WalletTokenListDisplayRole:
            qDebug() << "search item list by address" << m_walletList[index.row()].first.Address;
            return QVariant::fromValue<QList<QObject*>>(tokeListByIndex(index.row()));
        default: break;
    }

    return QVariant();
}

QHash<int, QByteArray> DapChainWalletModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[WalletNameDisplayRole] = "walletNameDisplayRole";
    roles[WalletAddressDisplayRole] = "walletAddressDisplayRole";
    roles[WalletIconDisplayRole] = "walletIconDisplayRole";
    roles[WalletTokenListDisplayRole] = "walletTokenListDisplayRole";
    roles[NetworkDisplayRole] = "networkDisplayRole";
    return roles;
}

double DapChainWalletModel::walletBalance(const QString& aAddress) const
{
    double balance = 0.0;
    for(int i = 0; i < m_walletList.count(); i++)
    {
        if(m_walletList[i].first.Address == aAddress)
        {
            DapChainWalletTokenItemList tokenList = m_walletList[i].second;
            for(int m = 0; m < tokenList.count(); m++)
            {
                balance += tokenList[i]->balance();
            }

            break;
        }
    }

    return balance;
}

double DapChainWalletModel::walletBalance(const int aWalletIndex) const
{
    QString address = m_walletList[aWalletIndex].first.Address;
    return walletBalance(address);
}

QList<QObject*> DapChainWalletModel::tokeListByWallet(const QString& aWalletAddress, const QString& aNetwork) const
{
    QList<QObject*> tokenList;
    for(int i = 0; i < m_walletList.count(); i++)
    {
        if(m_walletList[i].first.Address == aWalletAddress)
        {
            if(aNetwork.isEmpty() || aNetwork == m_walletList[i].first.Network)
            {
                DapChainWalletTokenItemList mTokenList = m_walletList[i].second;
                for(int m = 0; m < mTokenList.count(); m++)
                {
                    tokenList.append(mTokenList[m]);
                }

                return tokenList;
            }

        }
    }

    return tokenList;
}

QList<QObject*> DapChainWalletModel::tokeListByIndex(const int aIndex) const
{
    QList<QObject*> tokenList;
    DapChainWalletTokenItemList tokenDataList = m_walletList[aIndex].second;
    for(int i = 0; i < tokenDataList.count(); i++)
        tokenList.append(tokenDataList[i]);

    return tokenList;
}

double DapChainWalletModel::walletBalance() const
{
    return m_walletBalance;
}

QList<QObject*> DapChainWalletModel::tokenList() const
{
    return m_tokenList;
}

void DapChainWalletModel::setCurrentWallet(const QString& aWalletAddress)
{
    if(aWalletAddress == m_currentWallet) return;
    beginResetModel();
    m_currentWallet = aWalletAddress;
    m_walletBalance = walletBalance(aWalletAddress);
    m_tokenList = tokeListByWallet(aWalletAddress);
    endResetModel();

    emit walletBalanceChanged(m_walletBalance);
    emit tokenListChanged(m_tokenList);
}

void DapChainWalletModel::setCurrentWallet(const int aWalletIndex)
{
    QString address = m_walletList[aWalletIndex].first.Address;
    setCurrentWallet(address);
}

void DapChainWalletModel::setWalletData(const QByteArray& aData)
{
    beginResetModel();
//    m_walletList.clear();
    QList<QPair<DapChainWalletData, QList<DapChainWalletTokenData>>> walletData;
    QDataStream in(aData);
    in >> walletData;

    for(int i = 0; i < walletData.count(); i++)
    {
        DapChainWalletPair walletPair(walletData[i].first, DapChainWalletTokenItemList());
        QList<DapChainWalletTokenData> tokeData = walletData[i].second;

        for(int m = 0; m < tokeData.count(); m++)
        {
            qDebug() << "network: " << walletPair.first.Network;
            walletPair.second.append(new DapChainWalletTokenItem(walletData[i].first.Address, tokeData[m], this));
            qDebug() << "wallet: " << walletPair.first.Name << walletPair.first.Address;
            qDebug() << "token: " << walletPair.second.last()->name() << walletPair.second.last()->balance();
            qDebug() << "-----------------------";
        }

        m_walletList.append(walletPair);
    }

    endResetModel();
}

void DapChainWalletModel::appendWallet(const DapChainWalletData& aWallet)
{
    m_walletList.append(DapChainWalletPair(aWallet, DapChainWalletTokenItemList()));
    int lastIndex = m_walletList.count() - 1;
    beginInsertRows(QModelIndex(), lastIndex, lastIndex);
    endInsertRows();
}

void DapChainWalletModel::appendToken(const QString& aWalletAddress, const DapChainWalletTokenData& aTokenData)
{
    for(int i = 0; i < m_walletList.count(); i++)
    {
        if(m_walletList[i].first.Address == aWalletAddress)
        {
            m_walletList[i].second.append(new DapChainWalletTokenItem(aWalletAddress, aTokenData, this));
        }
    }
}

void DapChainWalletModel::removeWallet(const QString& aWalletAddress)
{
    int removeIndex = -1;
    for(int i = 0; i < m_walletList.count(); i++)
    {
        if(m_walletList[i].first.Address == aWalletAddress)
        {
            m_walletList.removeAt(i);
            removeIndex = i;
            break;
        }
    }

    if(removeIndex == -1) return;
    beginRemoveRows(QModelIndex(), removeIndex, removeIndex);
    endRemoveRows();
}

void DapChainWalletModel::removeWallet(const int aWalletIndex)
{
    if(aWalletIndex > m_walletList.count() || m_walletList.count() < aWalletIndex) return;
    beginRemoveRows(QModelIndex(), aWalletIndex, aWalletIndex);
    m_walletList.removeAt(aWalletIndex);
    endRemoveRows();
}
