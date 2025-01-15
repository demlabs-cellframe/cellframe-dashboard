#include "DapOrderHistoryModel.h"

#include <QList>
#include <QMetaEnum>
#include <QDateTime>
#include "Modules/Dex/StockDataWorker/DapCommonDexMethods.h"

struct ItemOrderHistoryBridge::Data
{
    DapOrderHistoryModel *model;
    DapOrderHistoryModel::Item *item;
    QModelIndex begin, end;

    Data (DapOrderHistoryModel *a_model, DapOrderHistoryModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapOrderHistoryModel::DapOrderHistoryModel::FieldId> s_fieldIdMap =
    {
        {"pair",            DapOrderHistoryModel::FieldId::pair},
        {"date",            DapOrderHistoryModel::FieldId::date},
        {"unixDate",        DapOrderHistoryModel::FieldId::unixDate},
        {"type",            DapOrderHistoryModel::FieldId::type},
        {"side",            DapOrderHistoryModel::FieldId::side},
        {"hash",            DapOrderHistoryModel::FieldId::hash},
        {"price",           DapOrderHistoryModel::FieldId::price},
        {"filled",          DapOrderHistoryModel::FieldId::filled},
        {"amount",          DapOrderHistoryModel::FieldId::amount},
        {"status",          DapOrderHistoryModel::FieldId::status},
        {"network",         DapOrderHistoryModel::FieldId::network},
        {"tokenBuy",        DapOrderHistoryModel::FieldId::tokenBuy},
        {"tokenSell",       DapOrderHistoryModel::FieldId::tokenSell},
        {"tokenBuyOrigin",  DapOrderHistoryModel::FieldId::tokenBuyOrigin},
        {"tokenSellOrigin", DapOrderHistoryModel::FieldId::tokenSellOrigin},
        {"adaptiveSide",    DapOrderHistoryModel::FieldId::adaptiveSide},
        {"adaptivePair",    DapOrderHistoryModel::FieldId::adaptivePair},
        {"rateOrigin",    DapOrderHistoryModel::FieldId::rateOrigin}  
};

DapOrderHistoryModel::DapOrderHistoryModel (QObject *a_parent)
    : QAbstractTableModel (a_parent)
{
    connect (this, &DapOrderHistoryModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapOrderHistoryModel::DapOrderHistoryModel (const DapOrderHistoryModel &a_src)
    : QAbstractTableModel (a_src.parent())
{
    operator= (a_src);
}

DapOrderHistoryModel::DapOrderHistoryModel (DapOrderHistoryModel &&a_src)
    : QAbstractTableModel (a_src.parent())
{
    operator= (a_src);
}

DapOrderHistoryModel::~DapOrderHistoryModel()
{
}

int DapOrderHistoryModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items.size();
}

int DapOrderHistoryModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapOrderHistoryModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapOrderHistoryModel::FieldId (role);
    const auto &item  = m_items.at (index.row());
    return _getValue (item, int (field));
}

QHash<int, QByteArray> DapOrderHistoryModel::roleNames() const
{
    static QHash<int, QByteArray> names;

    if (names.isEmpty())
        for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
            names[int (i.value())] = i.key().toUtf8();

    return names;
}

void DapOrderHistoryModel::updateModel(const QList<DEX::Order> &data)
{
    beginResetModel();
    {
        m_items.clear();
        for(const auto& item: data)
        {
            if(!DapCommonDexMethods::isCorrectAmount(item.amount))
            {
                continue;
            }

            DapOrderHistoryModel::Item tmpItem;
            tmpItem.pair = item.side == "Buy" ? item.buyToken + "/" + item.sellToken : item.sellToken + "/" + item.buyToken;
            tmpItem.adaptivePair = item.sellTokenOrigin + "/" + item.buyTokenOrigin;
            QDateTime time = QDateTime::fromSecsSinceEpoch(item.unixTime.toLongLong());
            tmpItem.date = time.toString("yyyy-MM-dd hh:mm");
            tmpItem.unixDate = item.unixTime;
            tmpItem.type = "Limit";
            tmpItem.side = item.side;
            tmpItem.hash = item.hash;
            tmpItem.price = item.rate;
            tmpItem.filled = item.filled;
            tmpItem.amount = item.amount;
            tmpItem.status = item.status;
            tmpItem.network = item.network;
            tmpItem.tokenBuy = item.buyToken;
            tmpItem.tokenSell = item.sellToken;
            tmpItem.tokenBuyOrigin = item.buyTokenOrigin;
            tmpItem.tokenSellOrigin = item.sellTokenOrigin;
            tmpItem.adaptiveSide = item.adaptiveSide;
            tmpItem.adaptivePair = item.adaptivePair;
            tmpItem.rateOrigin = item.rateOrigin;
            m_items.append(std::move(tmpItem));
        }
        qDebug() << "[DapOrderHistoryModel] updateModel. new size: " << m_items.size();
    }
    endResetModel();
}


int DapOrderHistoryModel::indexOf (const DapOrderHistoryModel::Item &a_item) const
{
    int index = 0;

    for (auto i = m_items.cbegin(), e = m_items.cend(); i != e; i++, index++)
        if (i->date == a_item.date)
            return index;

    return -1;
}

const DapOrderHistoryModel::Item &DapOrderHistoryModel::at (int a_index) const
{
    return const_cast<DapOrderHistoryModel *> (this)->_get (a_index);
}

DapOrderHistoryModel::Item DapOrderHistoryModel::value (int a_index) const
{
    return at (a_index);
}

DapOrderHistoryModel::Item DapOrderHistoryModel::value (const QString& hash) const
{
    for(auto& item: m_items)
    {
        if(item.hash == hash)
        {
            return item;
        }
    }
    return DapOrderHistoryModel::Item();
}

int DapOrderHistoryModel::size() const
{
    return m_items.size();
}

bool DapOrderHistoryModel::isEmpty() const
{
    return 0 == m_items.size();
}

void DapOrderHistoryModel::clear()
{
    beginResetModel();

    {
        m_items.clear();
        emit sigSizeChanged (size());
    }

    endResetModel();
}

QVariant DapOrderHistoryModel::get (int a_index)
{
    return QVariant::fromValue (new ItemOrderHistoryBridge (new ItemOrderHistoryBridge::Data (this, &_get (a_index))));
}

const QVariant DapOrderHistoryModel::get(int a_index) const
{
    return const_cast<DapOrderHistoryModel*>(this)->get (a_index);
}

DapOrderHistoryModel::Item &DapOrderHistoryModel::_get(int a_index)
{
    static DapOrderHistoryModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {
        dummy = DapOrderHistoryModel::Item();
        return dummy;
    }

    return m_items[a_index];
}

const DapOrderHistoryModel::Item &DapOrderHistoryModel::_get(int a_index) const
{
    return const_cast<DapOrderHistoryModel*>(this)->_get (a_index);
}

void DapOrderHistoryModel::set (int a_index, const DapOrderHistoryModel::Item &a_item)
{
    if (a_index < 0 || a_index >= m_items.size())
        return;
    _get (a_index) = a_item;
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapOrderHistoryModel::set (int a_index, DapOrderHistoryModel::Item &&a_item)
{
    if (a_index < 0 || a_index >= m_items.size())
        return;
    _get (a_index) = std::move (a_item);
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int DapOrderHistoryModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapOrderHistoryModel::FieldId::invalid));
}

const DapOrderHistoryModel::Item &DapOrderHistoryModel::getItem(int a_index) const
{
    static DapOrderHistoryModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {
        dummy = DapOrderHistoryModel::Item();
        return dummy;
    }

    return m_items[a_index];
}

DapOrderHistoryModel::Iterator DapOrderHistoryModel::begin()
{
    return m_items.begin();
}

DapOrderHistoryModel::ConstIterator DapOrderHistoryModel::cbegin() const
{
    return m_items.cbegin();
}

DapOrderHistoryModel::Iterator DapOrderHistoryModel::end()
{
    return m_items.end();
}

DapOrderHistoryModel::ConstIterator DapOrderHistoryModel::cend()
{
    return m_items.cend();
}

QVariant DapOrderHistoryModel::_getValue (const DapOrderHistoryModel::Item &a_item, int a_fieldId)
{
    switch (DapOrderHistoryModel::FieldId (a_fieldId))
    {
    case DapOrderHistoryModel::FieldId::invalid: break;

    case DapOrderHistoryModel::FieldId::pair:               return a_item.pair;
    case DapOrderHistoryModel::FieldId::date:               return a_item.date;
    case DapOrderHistoryModel::FieldId::unixDate:           return a_item.unixDate;
    case DapOrderHistoryModel::FieldId::type:               return a_item.type;
    case DapOrderHistoryModel::FieldId::side:               return a_item.side;
    case DapOrderHistoryModel::FieldId::hash:               return a_item.hash;
    case DapOrderHistoryModel::FieldId::price:              return a_item.price;
    case DapOrderHistoryModel::FieldId::filled:             return a_item.filled;
    case DapOrderHistoryModel::FieldId::amount:             return a_item.amount;
    case DapOrderHistoryModel::FieldId::status:             return a_item.status;
    case DapOrderHistoryModel::FieldId::network:            return a_item.network;
    case DapOrderHistoryModel::FieldId::tokenBuy:           return a_item.tokenBuy;
    case DapOrderHistoryModel::FieldId::tokenSell:          return a_item.tokenSell;
    case DapOrderHistoryModel::FieldId::tokenBuyOrigin:     return a_item.tokenBuyOrigin;
    case DapOrderHistoryModel::FieldId::tokenSellOrigin:    return a_item.tokenSellOrigin;
    case DapOrderHistoryModel::FieldId::adaptiveSide:       return a_item.adaptiveSide;
    case DapOrderHistoryModel::FieldId::adaptivePair:       return a_item.adaptivePair;
    case DapOrderHistoryModel::FieldId::rateOrigin:         return a_item.rateOrigin;
    }

    return QVariant();
}

QVariant DapOrderHistoryModel::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapOrderHistoryModel::operator[] (int a_index) const
{
    return get (a_index);
}

DapOrderHistoryModel &DapOrderHistoryModel::operator= (const DapOrderHistoryModel &a_src)
{
    m_items  = a_src.m_items;
    return *this;
}

DapOrderHistoryModel &DapOrderHistoryModel::operator= (DapOrderHistoryModel &&a_src)
{
    if (this != &a_src)
    {
        m_items       = a_src.m_items;
    }
    return *this;
}

ItemOrderHistoryBridge::ItemOrderHistoryBridge (ItemOrderHistoryBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::dateChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::unixDateChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::pairChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::typeChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::sideChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::hashChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::priceChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::filledChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::amountChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::statusChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::networkChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::tokenBuyChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::tokenSellChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::tokenBuyOriginChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::tokenSellOriginChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::adaptiveSideChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::adaptivePairChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemOrderHistoryBridge::rateOriginChanged);
}

ItemOrderHistoryBridge::ItemOrderHistoryBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemOrderHistoryBridge::ItemOrderHistoryBridge (const ItemOrderHistoryBridge &a_src)
    : QObject ()
{
    operator = (a_src);
}

ItemOrderHistoryBridge::ItemOrderHistoryBridge (ItemOrderHistoryBridge &&a_src)
    : QObject ()
{
    operator = (std::move (a_src));
}

ItemOrderHistoryBridge::~ItemOrderHistoryBridge()
{
    delete d;
}

QString ItemOrderHistoryBridge::date() const
{
    return (d && d->item) ? d->item->date : QString();
}

QString ItemOrderHistoryBridge::unixDate() const
{
    return (d && d->item) ? d->item->unixDate : QString();
}

QString ItemOrderHistoryBridge::pair() const
{
    return (d && d->item) ? d->item->pair : QString();
}

QString ItemOrderHistoryBridge::type() const
{
    return (d && d->item) ? d->item->type : QString();
}

QString ItemOrderHistoryBridge::side() const
{
    return (d && d->item) ? d->item->side : QString();
}

QString ItemOrderHistoryBridge::hash() const
{
    return (d && d->item) ? d->item->hash : QString();
}

QString ItemOrderHistoryBridge::price() const
{
    return (d && d->item) ? d->item->price : QString();
}

QString ItemOrderHistoryBridge::filled() const
{
    return (d && d->item) ? d->item->filled : QString();
}

QString ItemOrderHistoryBridge::amount() const
{
    return (d && d->item) ? d->item->amount : QString();
}

QString ItemOrderHistoryBridge::status() const
{
    return (d && d->item) ? d->item->status : QString();
}

QString ItemOrderHistoryBridge::network() const
{
    return (d && d->item) ? d->item->network : QString();
}

QString ItemOrderHistoryBridge::tokenBuy() const
{
    return (d && d->item) ? d->item->tokenBuy : QString();
}

QString ItemOrderHistoryBridge::tokenSell() const
{
    return (d && d->item) ? d->item->tokenSell : QString();
}

QString ItemOrderHistoryBridge::tokenBuyOrigin() const
{
    return (d && d->item) ? d->item->tokenBuyOrigin : QString();
}

QString ItemOrderHistoryBridge::tokenSellOrigin() const
{
    return (d && d->item) ? d->item->tokenSellOrigin : QString();
}

QString ItemOrderHistoryBridge::adaptiveSide() const
{
    return (d && d->item) ? d->item->adaptiveSide : QString();
}

QString ItemOrderHistoryBridge::rateOrigin() const
{
    return (d && d->item) ? d->item->rateOrigin : QString();
}

QString ItemOrderHistoryBridge::adaptivePair() const
{
    return (d && d->item) ? d->item->adaptivePair : QString();
}

ItemOrderHistoryBridge &ItemOrderHistoryBridge::operator =(const ItemOrderHistoryBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemOrderHistoryBridge &ItemOrderHistoryBridge::operator =(ItemOrderHistoryBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}
