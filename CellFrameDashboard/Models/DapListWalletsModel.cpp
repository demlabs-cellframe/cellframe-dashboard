#include "DapListWalletsModel.h"
#include <QDebug>
#include <QJsonArray>
#include <QJsonValue>
#include <QJsonObject>>
#include <QList>
#include <QMetaEnum>

struct ItemListWalletBridge::Data
{
    DapListWalletsModel *model;
    DapListWalletsModel::Item *item;
    QModelIndex begin, end;

    Data (DapListWalletsModel *a_model, DapListWalletsModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapListWalletsModel::DapListWalletsModel::FieldId> s_fieldIdMap =
    {
        {"walletName",      DapListWalletsModel::FieldId::walletName},
        {"statusProtected", DapListWalletsModel::FieldId::statusProtected},
        {"isLoad",          DapListWalletsModel::FieldId::isLoad},
        {"isMigrate",       DapListWalletsModel::FieldId::isMigrate},
        {"walletModel",     DapListWalletsModel::FieldId::walletModel},
    };

DapListWalletsModel::DapListWalletsModel (QObject *a_parent)
    : QAbstractTableModel (a_parent)
{
    connect (this, &DapListWalletsModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapListWalletsModel::DapListWalletsModel (const DapListWalletsModel &a_src)
    : QAbstractTableModel (a_src.parent())
{
}

DapListWalletsModel::DapListWalletsModel (DapListWalletsModel &&a_src)
    : QAbstractTableModel (a_src.parent())
{
}

DapListWalletsModel::~DapListWalletsModel()
{
}

int DapListWalletsModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items.size();
}

int DapListWalletsModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapListWalletsModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    const auto &item  = m_items.at (index.row());

    switch (DapListWalletsModel::FieldId (DapListWalletsModel::FieldId (role)))
    {
    case DapListWalletsModel::FieldId::invalid: break;

    case DapListWalletsModel::FieldId::walletName:      return item.walletName;
    case DapListWalletsModel::FieldId::statusProtected: return item.statusProtected;
    case DapListWalletsModel::FieldId::isLoad:          return item.isLoad;
    case DapListWalletsModel::FieldId::isMigrate:       return item.isMigrate;
    }
    return QVariant();
}

QHash<int, QByteArray> DapListWalletsModel::roleNames() const
{
    static QHash<int, QByteArray> names;

    if (names.isEmpty())
        for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
            names[int (i.value())] = i.key().toUtf8();

    return names;
}

QVariant DapListWalletsModel::get (int a_index)
{
    return QVariant::fromValue (new ItemListWalletBridge (new ItemListWalletBridge::Data (this, &_get (a_index))));
}

const QVariant DapListWalletsModel::get(int a_index) const
{
    return const_cast<DapListWalletsModel*>(this)->get (a_index);
}

DapListWalletsModel::Item &DapListWalletsModel::_get(int a_index)
{
    static DapListWalletsModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {

        return dummy;
    }

    return m_items[a_index];
}

const DapListWalletsModel::Item &DapListWalletsModel::_get(int a_index) const
{
    return const_cast<DapListWalletsModel*>(this)->_get (a_index);
}

void DapListWalletsModel::updateWallets(const QMap<QString, CommonWallet::WalletInfo>& wallets)
{
    beginResetModel ();
    m_items.clear();
    for(const QString& walletName: wallets.keys())
    {
        DapListWalletsModel::Item item;
        const auto& tmpWallet = wallets[walletName];
        item.walletName = tmpWallet.walletName;
        item.statusProtected = tmpWallet.status;
        item.isLoad = tmpWallet.isLoad;
        item.isMigrate = tmpWallet.isMigrate;
        m_items.append(std::move(item));
    }

    endResetModel();
    emit dataChanged(index (0, 0), index (m_items.size(), 0));
    emit sizeChanged();
}

void DapListWalletsModel::clear()
{
    beginResetModel();
    m_items.clear();
    endResetModel();
    emit sizeChanged();
}

ItemListWalletBridge::ItemListWalletBridge (ItemListWalletBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemListWalletBridge::walletNameChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemListWalletBridge::isLoadChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemListWalletBridge::isMigrateChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemListWalletBridge::statusProtectedChanged);
}

ItemListWalletBridge::ItemListWalletBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemListWalletBridge::ItemListWalletBridge (const ItemListWalletBridge &a_src)
{
    operator = (a_src);
}

ItemListWalletBridge::ItemListWalletBridge (ItemListWalletBridge &&a_src)
{
    operator = (std::move (a_src));
}

ItemListWalletBridge::~ItemListWalletBridge()
{
    delete d;
}

QString ItemListWalletBridge::walletName() const
{
    return (d && d->item) ? d->item->walletName : QString();
}

QString ItemListWalletBridge::statusProtected() const
{
    return (d && d->item) ? d->item->statusProtected : QString();
}

bool ItemListWalletBridge::isLoad() const
{
    return (d && d->item) ? d->item->isLoad : false;
}

bool ItemListWalletBridge::isMigrate() const
{
    return (d && d->item) ? d->item->isMigrate : false;
}

DapInfoWalletModel* ItemListWalletBridge::walletModel() const
{
//    return (d && d->item) ? d->item.walletModel : new DapInfoWalletModel();
}

ItemListWalletBridge &ItemListWalletBridge::operator =(const ItemListWalletBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemListWalletBridge &ItemListWalletBridge::operator =(ItemListWalletBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}
