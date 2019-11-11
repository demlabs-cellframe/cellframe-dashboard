#include "DapChainWalletModel.h"

DapChainWalletModel::DapChainWalletModel(QObject *parent)
    : QAbstractListModel(parent)
{
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

float DapChainWalletModel::walletBalance(const QString& aAddress) const
{
    float balance = 0.0;
    for(int i = 0; i < m_walletList.count(); i++)
    {
        if(m_walletList[i].first.Address == aAddress)
        {
            DapChainWalletTokenList tokenList = m_walletList[i].second;
            for(int m = 0; m < tokenList.count(); m++)
            {
                balance += tokenList[i]->balance();
            }

            break;
        }
    }

    return balance;
}

QList<QObject*> DapChainWalletModel::tokeListByWallet(const QString& aWalletAddress, const QString& aNetwork) const
{
    QList<QObject*> tokenList;
    for(int i = 0; i < m_walletList.count(); i++)
    {
        if(m_walletList.at(i).first.Address == aWalletAddress)
        {
            DapChainWalletTokenList mTokenList = m_walletList.at(i).second;
            for(int m = 0; m < mTokenList.count(); m++)
            {
                if(aNetwork.isEmpty() || aNetwork == mTokenList[m]->network())
                    tokenList.append(mTokenList[m]);
            }
        }
    }

    return tokenList;
}

float DapChainWalletModel::walletBalance() const
{
    return m_walletBalance;
}

void DapChainWalletModel::setCurrentWallet(const QString& aWallet)
{
    if(aWallet == m_currentWallet) return;
    beginResetModel();
    m_currentWallet = aWallet;
    m_walletBalance = walletBalance(aWallet);
    endResetModel();

    emit walletBalanceChanged(m_walletBalance);
}

void DapChainWalletModel::setWalletData(const QList<DapChainWalletPair>& aData)
{
    if(aData == m_walletList) return;
    beginResetModel();
    m_walletList = aData;
    endResetModel();
}

void DapChainWalletModel::appendWallet(const DapChainWalletData& aWallet)
{
    m_walletList.append(DapChainWalletPair(aWallet, DapChainWalletTokenList()));
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
