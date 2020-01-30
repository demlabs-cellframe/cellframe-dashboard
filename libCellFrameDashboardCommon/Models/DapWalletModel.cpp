#include "DapWalletModel.h"

DapWalletModel::DapWalletModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

DapWalletModel &DapWalletModel::getInstance()
{
    static DapWalletModel instance;
    return instance;
}

int DapWalletModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);

    return m_aWallets.count();
}

QVariant DapWalletModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    switch (role)
    {
        case NameDisplayRole:       return m_aWallets[index.row()].getName();
        case BalanceDisplayRole:    return m_aWallets[index.row()].getBalance();
        case AddressDisplayRole:    return m_aWallets[index.row()].getAddress();
        case IconDisplayRole:       return m_aWallets[index.row()].getIcon();
        case NetworksDisplayRole:   return m_aWallets[index.row()].getNetworks();
        case TokensDisplayRole:
            return QVariant::fromValue<QList<QObject*>>(getTokens(index.row()));
        case WalletsDisplayRole:    return getWalletList();
        default: break;
    }

    return QVariant();
}

QList<QObject*> DapWalletModel::getTokens(const int aIndex) const
{
    QList<QObject*> tokens;
    auto cbegin = m_aWallets[aIndex].getTokens().cbegin();
    auto cend = m_aWallets[aIndex].getTokens().cend();
    for(; cbegin != cend; ++ cbegin)
        tokens.append(*cbegin);

    return tokens;
}

QStringList DapWalletModel::getWalletList() const
{
    QStringList walletList;
    foreach (auto wallet, m_aWallets)
    {
        walletList.append(wallet.getName());
    }
    return walletList;
}

void DapWalletModel::appendWallet(const DapWallet &aWallet)
{
    m_aWallets.append(aWallet);

    emit walletListChanged(getWalletList());

    int lastIndex = m_aWallets.count() - 1;
    beginInsertRows(QModelIndex(), lastIndex, lastIndex);
    endInsertRows();
}

void DapWalletModel::appendToken(const QString &asWalletAddress, DapWalletToken* aToken)
{
    auto wallet = std::find_if(m_aWallets.begin(), m_aWallets.end(), [=] (const DapWallet& aWallet)
    {
        return aWallet.getAddresses().values().contains(asWalletAddress);
    });

    return wallet->addToken(aToken);
}

void DapWalletModel::removeWallet(const QString &asWalletAddress)
{
    int removeIndex = -1;
    auto wallet = std::find_if(m_aWallets.cbegin(), m_aWallets.cend(), [=] (const DapWallet& aWallet)
    {
        return aWallet.getAddresses().values().contains(asWalletAddress);
    });
    removeIndex = m_aWallets.indexOf(*wallet);
    m_aWallets.removeAt(removeIndex);

    emit walletListChanged(getWalletList());

    if(removeIndex == -1)
        return;
    beginRemoveRows(QModelIndex(), removeIndex, removeIndex);
    endRemoveRows();
}

void DapWalletModel::removeWallet(const int aWalletIndex)
{
    if(aWalletIndex >= m_aWallets.count() || m_aWallets.count() < aWalletIndex)
        return;
    beginRemoveRows(QModelIndex(), aWalletIndex, aWalletIndex);
    m_aWallets.removeAt(aWalletIndex);

    emit walletListChanged(getWalletList());

    endRemoveRows();
}

QHash<int, QByteArray> DapWalletModel::roleNames() const
{
    static const QHash<int, QByteArray> roles
    {
        { NameDisplayRole, "name" },
        { BalanceDisplayRole, "balance" },
        { AddressDisplayRole, "address" },
        { IconDisplayRole, "iconPath" },
        { NetworksDisplayRole, "networks" },
        { TokensDisplayRole, "tokens" },
        { WalletsDisplayRole, "walletList" }
    };

    return roles;
}
