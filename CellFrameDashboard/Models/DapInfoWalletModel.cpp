#include "DapInfoWalletModel.h"
#include <QQmlContext>
#include <QList>
#include <QMetaEnum>
#include "QQmlApplicationEngine"
struct ItemItemBridge::Data
{
    DapInfoWalletModel *model;
    DapInfoWalletModel::Item *item;
    QModelIndex begin, end;

    Data (DapInfoWalletModel *a_model, DapInfoWalletModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapInfoWalletModel::DapInfoWalletModel::FieldId> s_fieldIdMap =
    {
        {"networkName",         DapInfoWalletModel::FieldId::networkName},
        {"address",             DapInfoWalletModel::FieldId::address},
        {"isLoad",              DapInfoWalletModel::FieldId::isLoad},
        {"networkTokensModel",  DapInfoWalletModel::FieldId::networkTokensModel}
        };

static DapInfoWalletModel::Item _dummy();

DapInfoWalletModel::DapInfoWalletModel (QObject *a_parent)
    : QAbstractTableModel (a_parent)
{
    connect (this, &DapInfoWalletModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapInfoWalletModel::DapInfoWalletModel (const DapInfoWalletModel &a_src)
    : QAbstractTableModel (a_src.parent())
{
    operator= (a_src);
    qmlRegisterType<DapTokensWalletModel>("DapTokensWalletModel", 1,0, "DapTokensWalletModel");
    qRegisterMetaType<TokenProxyModel*>("TokenProxyModel*");
}

DapInfoWalletModel::DapInfoWalletModel (DapInfoWalletModel &&a_src)
    : QAbstractTableModel (a_src.parent())
{
    operator= (a_src);
    qmlRegisterType<DapTokensWalletModel>("DapTokensWalletModel", 1,0, "DapTokensWalletModel");
}

DapInfoWalletModel::~DapInfoWalletModel()
{
}

int DapInfoWalletModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items.size();
}

int DapInfoWalletModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapInfoWalletModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapInfoWalletModel::FieldId (role);
    const auto &item  = m_items.at (index.row());
    auto val = _getValue (*item, int (field));
    return val;
}

QHash<int, QByteArray> DapInfoWalletModel::roleNames() const
{
    static QHash<int, QByteArray> names;

    if (names.isEmpty())
        for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
            names[int (i.value())] = i.key().toUtf8();

    return names;
}

void DapInfoWalletModel::addClearNetwork(const QString& networkName)
{
    int index = m_items.size();
    beginInsertRows (QModelIndex(), index, index);
    DapInfoWalletModel::Item* item = new DapInfoWalletModel::Item();
    item->networkName = networkName;
    m_items.append(std::move(item));
    endInsertRows();
}

void DapInfoWalletModel::updateModel(const QMap<QString, CommonWallet::WalletNetworkInfo>& networksInfo)
{
    beginResetModel();
    m_items.clear();

    for(const CommonWallet::WalletNetworkInfo& network: networksInfo)
    {
        DapInfoWalletModel::Item* item = new DapInfoWalletModel::Item();
        item->networkName = network.network;
        item->address = network.address;
        item->isLoad = true;
        item->networkTokensModel = new DapTokensWalletModel();
        item->networkTokensModel->updateAllToken(network.networkInfo);
        m_items.append(std::move(item));
    }
    emit dataChanged(index (0, 0), index (m_items.size(), 0));
    endResetModel();
}

void DapInfoWalletModel::remove (int a_index)
{
    if (a_index < 0 || a_index >= m_items.size())
        return;

    beginRemoveRows (QModelIndex(), a_index, a_index);

    {
        m_items.removeAt (a_index);
        emit sigItemRemoved (a_index);
        emit sigSizeChanged (size());
    }

    endRemoveRows();
}

const DapInfoWalletModel::Item &DapInfoWalletModel::at (int a_index) const
{
    return const_cast<DapInfoWalletModel *> (this)->_get (a_index);
}

DapInfoWalletModel::Item DapInfoWalletModel::value (int a_index) const
{
    return at (a_index);
}

int DapInfoWalletModel::size() const
{
    return m_items.size();
}

bool DapInfoWalletModel::isEmpty() const
{
    return 0 == m_items.size();
}

void DapInfoWalletModel::clear()
{
    beginResetModel();

    {
        m_items.clear();
        emit sigSizeChanged (size());
    }

    endResetModel();
}

QVariant DapInfoWalletModel::get (int a_index)
{
    return QVariant::fromValue (new ItemItemBridge (new ItemItemBridge::Data (this, &_get (a_index))));
}

const QVariant DapInfoWalletModel::get(int a_index) const
{
    return const_cast<DapInfoWalletModel*>(this)->get (a_index);
}

DapInfoWalletModel::Item &DapInfoWalletModel::_get(int a_index)
{
    static DapInfoWalletModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {
        dummy = _dummy();
        return dummy;
    }

    return *m_items[a_index];
}

const DapInfoWalletModel::Item &DapInfoWalletModel::_get(int a_index) const
{
    return const_cast<DapInfoWalletModel*>(this)->_get (a_index);
}

void DapInfoWalletModel::set (int a_index, const DapInfoWalletModel::Item &a_item)
{
    if (a_index < 0 || a_index >= m_items.size())
        return;
    _get (a_index) = a_item;
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapInfoWalletModel::set (int a_index, DapInfoWalletModel::Item &&a_item)
{
    if (a_index < 0 || a_index >= m_items.size())
        return;
    _get (a_index) = std::move (a_item);
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int DapInfoWalletModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapInfoWalletModel::FieldId::invalid));
}

const DapInfoWalletModel::Item &DapInfoWalletModel::getItem(int a_index) const
{
    static DapInfoWalletModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {
        dummy = _dummy();
        return dummy;
    }

    return *m_items[a_index];
}

QVariant DapInfoWalletModel::_getValue (const DapInfoWalletModel::Item &a_item, int a_fieldId)
{
    switch (DapInfoWalletModel::FieldId (a_fieldId))
    {
    case DapInfoWalletModel::FieldId::invalid: break;

    case DapInfoWalletModel::FieldId::networkName:          return a_item.networkName;
    case DapInfoWalletModel::FieldId::address:              return a_item.address;
    case DapInfoWalletModel::FieldId::isLoad:               return a_item.isLoad;
    case DapInfoWalletModel::FieldId::networkTokensModel:   return QVariant::fromValue(a_item.networkTokensModel);
    }
    return QVariant();
}

QVariant DapInfoWalletModel::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapInfoWalletModel::operator[] (int a_index) const
{
    return get (a_index);
}

DapInfoWalletModel &DapInfoWalletModel::operator= (const DapInfoWalletModel &a_src)
{
    m_items  = a_src.m_items;
    return *this;
}

DapInfoWalletModel &DapInfoWalletModel::operator= (DapInfoWalletModel &&a_src)
{
    if (this != &a_src)
    {
        m_items       = a_src.m_items;
    }
    return *this;
}

DapInfoWalletModel::Item _dummy()
{
    return DapInfoWalletModel::Item();
}

ItemItemBridge::ItemItemBridge (ItemItemBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemItemBridge::networkNameChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemItemBridge::addressChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemItemBridge::isLoadChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemItemBridge::networkTokensChanged);
}

ItemItemBridge::ItemItemBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemItemBridge::ItemItemBridge (const ItemItemBridge &a_src)
{
    operator = (a_src);
}

ItemItemBridge::ItemItemBridge (ItemItemBridge &&a_src)
{
    operator = (std::move (a_src));
}

ItemItemBridge::~ItemItemBridge()
{
    delete d;
}

QString ItemItemBridge::networkName() const
{
    return (d && d->item) ? d->item->networkName : QString();
}

QString ItemItemBridge::address() const
{
    return (d && d->item) ? d->item->address : QString();
}

bool ItemItemBridge::isLoad() const
{
    return (d && d->item) ? d->item->isLoad : false;
}

DapTokensWalletModel* ItemItemBridge::networkTokensModel() const
{
    return (d && d->item) ? d->item->networkTokensModel : new DapTokensWalletModel();
}

ItemItemBridge &ItemItemBridge::operator =(const ItemItemBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemItemBridge &ItemItemBridge::operator =(ItemItemBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}

DapTokensWalletModel* DapInfoWalletModel::getModel(int index) const
{
    if( m_items.isEmpty() || m_items.size() <= index || index < 0)
    {
        return new DapTokensWalletModel();
    }
    return m_items[index]->networkTokensModel;
}

DapTokensWalletModel* DapInfoWalletModel::getModel(const QString& networkName) const
{
    if(m_items.isEmpty())
    {
        return new DapTokensWalletModel();
    }

    for(const auto& item: m_items)
    {
        if(item->networkName == networkName)
        {
            return item->networkTokensModel;
        }
    }
    return new DapTokensWalletModel();
}

QStringList DapInfoWalletModel::getFilterModel(const QString& networkName,  const QString& token1, const QString& token2)
{
    QStringList result;
    auto model = getModel(networkName);
    for(int i = 0; i < model->size(); i++)
    {
        if(model->at(i).tiker == token1 || model->at(i).tiker == token1)
        {
            result.append(model->at(i).tiker);
        }
    }
    return result;
}
