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
        case WalletTokenListDisplayRole:
            return QVariant::fromValue<QList<QObject*>>(tokeListByWallet(m_currentWallet));
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
        if(m_walletList.at(i).first.Address == aWalletAddress)
        {
            DapChainWalletTokenItemList mTokenList = m_walletList.at(i).second;
            for(int m = 0; m < mTokenList.count(); m++)
            {
                if(aNetwork.isEmpty() || aNetwork == mTokenList[m]->network())
                    tokenList.append(mTokenList[m]);
            }
        }
    }

    return tokenList;
}

double DapChainWalletModel::walletBalance() const
{
    return m_walletBalance;
}

void DapChainWalletModel::setCurrentWallet(const QString& aWalletAddress)
{
    if(aWalletAddress == m_currentWallet) return;
    beginResetModel();
    m_currentWallet = aWalletAddress;
    m_walletBalance = walletBalance(aWalletAddress);
    endResetModel();

    emit walletBalanceChanged(m_walletBalance);
}

void DapChainWalletModel::setCurrentWallet(const int aWalletIndex)
{
    QString address = m_walletList[aWalletIndex].first.Address;
    setCurrentWallet(address);
}

void DapChainWalletModel::setWalletData(const QByteArray& aData)
{
    beginResetModel();
    m_walletList.clear();
    QList<QPair<DapChainWalletData, QList<DapChainWalletTokenData>>> walletData;
    QDataStream in(aData);
    in >> walletData;

    for(int i = 0; i < walletData.count(); i++)
    {
        DapChainWalletPair walletPair(walletData[i].first, DapChainWalletTokenItemList());
        QList<DapChainWalletTokenData> tokeData = walletData[i].second;

        for(int m = 0; m < tokeData.count(); m++)
            walletPair.second.append(new DapChainWalletTokenItem(tokeData[m], this));
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
            m_walletList[i].second.append(new DapChainWalletTokenItem(aTokenData, this));
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
