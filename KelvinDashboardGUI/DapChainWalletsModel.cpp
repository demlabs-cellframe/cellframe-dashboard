#include "DapChainWalletsModel.h"

DapChainWalletsModel::DapChainWalletsModel(QObject *parent)
{

}

DapChainWalletsModel &DapChainWalletsModel::getInstance()
{
    static DapChainWalletsModel instance;
    return instance;
}

int DapChainWalletsModel::rowCount(const QModelIndex &) const
{
    return m_dapChainWallets.count();
}

QVariant DapChainWalletsModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < rowCount())
            switch (role) {
            case IconWalletRole: return m_dapChainWallets.at(index.row())->getIconPath();
            case NameWalletRole: return m_dapChainWallets.at(index.row())->getName();
            case AddressWalletRole: return m_dapChainWallets.at(index.row())->getAddress();
            default:
                return QVariant();
        }
    return QVariant();
}

QHash<int, QByteArray> DapChainWalletsModel::roleNames() const
{
    static const QHash<int, QByteArray> roles {
            { IconWalletRole, "iconPath" },
            { NameWalletRole, "name" },
            { AddressWalletRole, "address" }
        };

    return roles;
}

QVariantMap DapChainWalletsModel::get(int row) const
{
    const DapChainWallet *wallet = m_dapChainWallets.value(row);
    return { {"iconPath", wallet->getIconPath()}, {"name", wallet->getName()}, {"address", wallet->getAddress()} };
}

void DapChainWalletsModel::append(const DapChainWallet &arWallet)
{
    this->append(arWallet.getIconPath(), arWallet.getName(), arWallet.getAddress());
}

void DapChainWalletsModel::append(const QString& asIconPath, const QString &asName, const QString  &asAddress)
{
    int row = 0;
    while (row < m_dapChainWallets.count())
        ++row;
    beginInsertRows(QModelIndex(), row, row);
    m_dapChainWallets.insert(row, new DapChainWallet(asIconPath, asName, asAddress));
    endInsertRows();
}

void DapChainWalletsModel::set(int row, const QString& asIconPath, const QString &asName, const QString  &asAddresss)
{
    if (row < 0 || row >= m_dapChainWallets.count())
            return;

        DapChainWallet *wallet = m_dapChainWallets.value(row);
        wallet->setIconPath(asIconPath);
        wallet->setName(asName);
        wallet->setAddress(asAddresss);
        dataChanged(index(row, 0), index(row, 0), { IconWalletRole, NameWalletRole, AddressWalletRole });
}

void DapChainWalletsModel::remove(int row)
{
    if (row < 0 || row >= m_dapChainWallets.count())
            return;

        beginRemoveRows(QModelIndex(), row, row);
        m_dapChainWallets.removeAt(row);
        endRemoveRows();
}

QObject *DapChainWalletsModel::singletonProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return &getInstance();
}
