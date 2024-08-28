#include "DapTokensWalletModel.h"
#include <QQmlContext>
#include <QList>
#include <QMetaEnum>
#include "QQmlApplicationEngine"

struct ItemTokensBridge::Data
{
    DapTokensWalletModel *model;
    DapTokensWalletModel::Item *item;
    QModelIndex begin, end;

    Data (DapTokensWalletModel *a_model, DapTokensWalletModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapTokensWalletModel::DapTokensWalletModel::FieldId> s_fieldIdMap = 
    {
        {"tokenName",           DapTokensWalletModel::FieldId::tokenName},
        {"value",               DapTokensWalletModel::FieldId::value},
        {"valueDatoshi",        DapTokensWalletModel::FieldId::valueDatoshi},
        {"tiker",               DapTokensWalletModel::FieldId::tiker},
        {"network",             DapTokensWalletModel::FieldId::network},
        {"availableDatoshi",    DapTokensWalletModel::FieldId::availableDatoshi},
        {"availableCoins",      DapTokensWalletModel::FieldId::availableCoins}        
        };

static DapTokensWalletModel::Item _dummy();

DapTokensWalletModel::DapTokensWalletModel (QObject *a_parent)
    : QAbstractTableModel (a_parent)
{
    connect (this, &DapTokensWalletModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapTokensWalletModel::DapTokensWalletModel (const DapTokensWalletModel &a_src)
    : QAbstractTableModel (a_src.parent())
{
    operator= (a_src);
}

DapTokensWalletModel::DapTokensWalletModel (DapTokensWalletModel &&a_src)
    : QAbstractTableModel (a_src.parent())
{
    operator= (a_src);
}

DapTokensWalletModel::~DapTokensWalletModel()
{
}

int DapTokensWalletModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items.size();
}

int DapTokensWalletModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapTokensWalletModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapTokensWalletModel::FieldId (role);
    const auto &item  = m_items.at (index.row());
    return _getValue (item, int (field));
}

QHash<int, QByteArray> DapTokensWalletModel::roleNames() const
{
    static QHash<int, QByteArray> names;

    if (names.isEmpty())
        for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
            names[int (i.value())] = i.key().toUtf8();

    return names;
}

void DapTokensWalletModel::updateAllToken(const QList<CommonWallet::WalletTokensInfo> &tokens)
{
    beginResetModel();
    m_items.clear();

    for(const CommonWallet::WalletTokensInfo& item: tokens)
    {
        m_items.append(DapTokensWalletModel::Item(item));
    }
    endResetModel();
}

void DapTokensWalletModel::addToken(const CommonWallet::WalletTokensInfo& token)
{
    int index = m_items.size();

    beginInsertRows (QModelIndex(), index, index);
    m_items.append(DapTokensWalletModel::Item(token));
    endInsertRows();
}

void DapTokensWalletModel::setDataFromOtherModel(const QList<DapTokensWalletModel::Item>& items)
{
    beginResetModel();
    m_items.clear();
    m_items.append(items);
    emit sizeChanged();
    endResetModel();
}

int DapTokensWalletModel::indexOf (const DapTokensWalletModel::Item &a_item) const
{
    int index = 0;

    for (auto i = m_items.cbegin(), e = m_items.cend(); i != e; i++, index++)
        if (i->tiker == a_item.tiker)
            return index;

    return -1;
}

const DapTokensWalletModel::Item &DapTokensWalletModel::at (int a_index) const
{
    return const_cast<DapTokensWalletModel *> (this)->_get (a_index);
}

DapTokensWalletModel::Item DapTokensWalletModel::value (int a_index) const
{
    return at (a_index);
}

int DapTokensWalletModel::size() const
{
    return m_items.size();
}

QVariant DapTokensWalletModel::get (int a_index)
{
    return QVariant::fromValue (new ItemTokensBridge (new ItemTokensBridge::Data (this, &_get (a_index))));
}

const QVariant DapTokensWalletModel::get(int a_index) const
{
    return const_cast<DapTokensWalletModel*>(this)->get (a_index);
}

QVariant DapTokensWalletModel::get(const QString& tokenName) const
{
    int size = m_items.size();
    int index = -1;
    for (int i = 0; i < size; i++)
    {
        if(m_items[i].tokenName == tokenName)
        {
            index = i;
            break;
        }
    }
    return  get(index);
}

DapTokensWalletModel::Item &DapTokensWalletModel::_get(int a_index)
{
    static DapTokensWalletModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {
        dummy = _dummy();
        return dummy;
    }

    return m_items[a_index];
}

const DapTokensWalletModel::Item &DapTokensWalletModel::_get(int a_index) const
{
    return const_cast<DapTokensWalletModel*>(this)->_get (a_index);
}

int DapTokensWalletModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapTokensWalletModel::FieldId::invalid));
}

const DapTokensWalletModel::Item &DapTokensWalletModel::getItem(int a_index) const
{
    static DapTokensWalletModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {
        dummy = _dummy();
        return dummy;
    }

    return m_items[a_index];
}

DapTokensWalletModel::ConstIterator DapTokensWalletModel::cbegin() const
{
    return m_items.cbegin();
}

DapTokensWalletModel::ConstIterator DapTokensWalletModel::cend()
{
    return m_items.cend();
}

QVariant DapTokensWalletModel::_getValue (const DapTokensWalletModel::Item &a_item, int a_fieldId)
{
    switch (DapTokensWalletModel::FieldId (a_fieldId))
    {
    case DapTokensWalletModel::FieldId::invalid: break;

    case DapTokensWalletModel::FieldId::tokenName:          return a_item.tokenName;
    case DapTokensWalletModel::FieldId::value:              return a_item.value;
    case DapTokensWalletModel::FieldId::valueDatoshi:       return a_item.valueDatoshi;
    case DapTokensWalletModel::FieldId::tiker:              return a_item.tiker;
    case DapTokensWalletModel::FieldId::network:            return a_item.network;
    case DapTokensWalletModel::FieldId::availableDatoshi:   return a_item.availableDatoshi;
    case DapTokensWalletModel::FieldId::availableCoins:     return a_item.availableCoins;
    }

    return QVariant();
}

QVariant DapTokensWalletModel::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapTokensWalletModel::operator[] (int a_index) const
{
    return get (a_index);
}

DapTokensWalletModel &DapTokensWalletModel::operator= (const DapTokensWalletModel &a_src)
{
    m_items  = a_src.m_items;
    return *this;
}

DapTokensWalletModel &DapTokensWalletModel::operator= (DapTokensWalletModel &&a_src)
{
    if (this != &a_src)
    {
        m_items       = a_src.m_items;
    }
    return *this;
}

DapTokensWalletModel::Item _dummy()
{
    return DapTokensWalletModel::Item();
}

ItemTokensBridge::ItemTokensBridge (ItemTokensBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensBridge::tokenNameChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensBridge::valueChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensBridge::valueDatoshiChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensBridge::tikerChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensBridge::networkChanged); 
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensBridge::availableDatoshiChanged); 
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensBridge::availableCoinsChanged); 
}

ItemTokensBridge::ItemTokensBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemTokensBridge::ItemTokensBridge (const ItemTokensBridge &a_src)
{
    operator = (a_src);
}

ItemTokensBridge::ItemTokensBridge (ItemTokensBridge &&a_src)
{
    operator = (std::move (a_src));
}

ItemTokensBridge::~ItemTokensBridge()
{
    delete d;
}

QString ItemTokensBridge::tokenName() const
{
    return (d && d->item) ? d->item->tokenName : QString();
}

QString ItemTokensBridge::value() const
{
    return (d && d->item) ? d->item->value : QString();
}

QString ItemTokensBridge::valueDatoshi() const
{
    return (d && d->item) ? d->item->valueDatoshi : QString();
}

QString ItemTokensBridge::tiker() const
{
    return (d && d->item) ? d->item->tiker : QString();
}

QString ItemTokensBridge::network() const
{
    return (d && d->item) ? d->item->network : QString();
}

QString ItemTokensBridge::availableDatoshi() const
{
    return (d && d->item) ? d->item->availableDatoshi : QString();
}

QString ItemTokensBridge::availableCoins() const
{
    return (d && d->item) ? d->item->availableCoins : QString();
}

ItemTokensBridge &ItemTokensBridge::operator =(const ItemTokensBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemTokensBridge &ItemTokensBridge::operator =(ItemTokensBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}

