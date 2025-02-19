#include "DapHistoryModel.h"

#include <QList>
#include <QMetaEnum>

struct ItemHistoryBridge::Data
{
    DapHistoryModel *model;
    DapHistoryModel::Item *item;
    QModelIndex begin, end;

    Data (DapHistoryModel *a_model, DapHistoryModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapHistoryModel::DapHistoryModel::FieldId> s_fieldIdMap =
    {
        {"tx_status",    DapHistoryModel::FieldId::tx_status},
        {"tx_hash",      DapHistoryModel::FieldId::tx_hash},
        {"atom",         DapHistoryModel::FieldId::atom},
        {"network",      DapHistoryModel::FieldId::network},
        {"wallet_name",  DapHistoryModel::FieldId::wallet_name},
        {"date",         DapHistoryModel::FieldId::date},
        {"date_to_secs", DapHistoryModel::FieldId::date_to_secs},
        {"time",         DapHistoryModel::FieldId::time},
        {"address",      DapHistoryModel::FieldId::address},
        {"status",       DapHistoryModel::FieldId::status},
        {"token",        DapHistoryModel::FieldId::token},
        {"direction",    DapHistoryModel::FieldId::direction},
        {"value",        DapHistoryModel::FieldId::value},
        {"m_value",      DapHistoryModel::FieldId::m_value},
        {"m_token",      DapHistoryModel::FieldId::m_token},
        {"m_direction",  DapHistoryModel::FieldId::m_direction},
        {"x_value",      DapHistoryModel::FieldId::x_value},
        {"x_token",      DapHistoryModel::FieldId::x_token},
        {"x_direction",  DapHistoryModel::FieldId::x_direction},
        {"fee",          DapHistoryModel::FieldId::fee},
        {"fee_token",    DapHistoryModel::FieldId::fee_token},
        {"fee_net",      DapHistoryModel::FieldId::fee_net},
        };

static DapHistoryModel::Item _dummy();

DapHistoryModel::DapHistoryModel (QObject *a_parent)
    : QAbstractTableModel (a_parent)
    , m_items (new QList<DapHistoryModel::Item>())
{
    connect (this, &DapHistoryModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapHistoryModel::DapHistoryModel (const DapHistoryModel &a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapHistoryModel::Item>())
{
    operator= (a_src);
}

DapHistoryModel::DapHistoryModel (DapHistoryModel &&a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapHistoryModel::Item>())
{
    operator= (a_src);
}

DapHistoryModel::~DapHistoryModel()
{
    delete m_items;
}

int DapHistoryModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items->size();
}

int DapHistoryModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapHistoryModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapHistoryModel::FieldId (role);
    const auto &item  = m_items->at (index.row());
    return _getValue (item, int (field));
}

QHash<int, QByteArray> DapHistoryModel::roleNames() const
{
    static QHash<int, QByteArray> names;

    if (names.isEmpty())
        for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
            names[int (i.value())] = i.key().toUtf8();

    return names;
}

DapHistoryModel *DapHistoryModel::global()
{
    static DapHistoryModel DapHistoryModel;
    return &DapHistoryModel;
}

bool DapHistoryModel::updateModel(const QList<Item>& historyList)
{
    m_items->clear();
    beginResetModel();
    m_items->append(historyList);
    endResetModel();
    return true;
}

int DapHistoryModel::add (const DapHistoryModel::Item &a_item)
{
    int index = m_items->size();

    beginInsertRows (QModelIndex(), index, index);

    {
        m_items->append (a_item);
        emit sigSizeChanged (index + 1);
    }

    endInsertRows();

    return index;
}

void DapHistoryModel::insert (int a_index, const DapHistoryModel::Item &a_item)
{
    beginInsertRows (QModelIndex(), a_index, a_index);

    {
        m_items->insert (a_index, a_item);
        emit sigItemAdded (a_index);
        emit sigSizeChanged (size());
    }

    endInsertRows();

}

void DapHistoryModel::remove (int a_index)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;

    beginRemoveRows (QModelIndex(), a_index, a_index);

    {
        m_items->removeAt (a_index);
        emit sigItemRemoved (a_index);
        emit sigSizeChanged (size());
    }

    endRemoveRows();
}

int DapHistoryModel::indexOf (const DapHistoryModel::Item &a_item) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
        if (i->tx_hash == a_item.tx_hash)
            return index;

    return -1;
}

int DapHistoryModel::indexOfTime(qint64 time) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
        if (i->date_to_secs < time)
            return index;

    return index;
}

const DapHistoryModel::Item &DapHistoryModel::at (int a_index) const
{
    return const_cast<DapHistoryModel *> (this)->_get (a_index);
}

DapHistoryModel::Item DapHistoryModel::value (int a_index) const
{
    return at(a_index);
}

int DapHistoryModel::size() const
{
    return m_items->size();
}

bool DapHistoryModel::isEmpty() const
{
    return 0 == m_items->size();
}

void DapHistoryModel::clear()
{
    beginResetModel();

    {
        m_items->clear();
        m_hash.clear();
        emit sigSizeChanged(size());
    }

    endResetModel();
}

QVariant DapHistoryModel::get (int a_index)
{
    //  ItemHistoryBridge item (new ItemHistoryBridge::Data (this, &_get (a_index)));
    //  return QVariant::fromValue (item);
    return QVariant::fromValue (new ItemHistoryBridge (new ItemHistoryBridge::Data (this, &_get (a_index))));
}

const QVariant DapHistoryModel::get(int a_index) const
{
    return const_cast<DapHistoryModel*>(this)->get (a_index);
}

DapHistoryModel::Item &DapHistoryModel::_get(int a_index)
{
    static DapHistoryModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

const DapHistoryModel::Item &DapHistoryModel::_get(int a_index) const
{
    return const_cast<DapHistoryModel*>(this)->_get (a_index);
}

void DapHistoryModel::set (int a_index, const DapHistoryModel::Item &a_item)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;
    _get (a_index) = a_item;
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapHistoryModel::set (int a_index, DapHistoryModel::Item &&a_item)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;
    _get (a_index) = std::move (a_item);
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int DapHistoryModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapHistoryModel::FieldId::invalid));
}

const DapHistoryModel::Item &DapHistoryModel::getItem(int a_index) const
{
    static DapHistoryModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

DapHistoryModel::Iterator DapHistoryModel::begin()
{
    return m_items->begin();
}

DapHistoryModel::ConstIterator DapHistoryModel::cbegin() const
{
    return m_items->cbegin();
}

DapHistoryModel::Iterator DapHistoryModel::end()
{
    return m_items->end();
}

DapHistoryModel::ConstIterator DapHistoryModel::cend()
{
    return m_items->cend();
}

QVariant DapHistoryModel::_getValue (const DapHistoryModel::Item &a_item, int a_fieldId)
{
    switch (DapHistoryModel::FieldId (a_fieldId))
    {
    case DapHistoryModel::FieldId::invalid: break;

    case DapHistoryModel::FieldId::tx_status:     return a_item.tx_status;
    case DapHistoryModel::FieldId::tx_hash:       return a_item.tx_hash;
    case DapHistoryModel::FieldId::atom:          return a_item.atom;
    case DapHistoryModel::FieldId::network:       return a_item.network;
    case DapHistoryModel::FieldId::wallet_name:   return a_item.wallet_name;
    case DapHistoryModel::FieldId::date:          return a_item.date;
    case DapHistoryModel::FieldId::date_to_secs:  return a_item.date_to_secs;
    case DapHistoryModel::FieldId::time:          return a_item.time;
    case DapHistoryModel::FieldId::address:       return a_item.address;
    case DapHistoryModel::FieldId::status:        return a_item.status;
    case DapHistoryModel::FieldId::token:         return a_item.token;
    case DapHistoryModel::FieldId::direction:     return a_item.direction;
    case DapHistoryModel::FieldId::value:         return a_item.value;
    case DapHistoryModel::FieldId::m_value:       return a_item.m_value;
    case DapHistoryModel::FieldId::m_token:       return a_item.m_token;
    case DapHistoryModel::FieldId::m_direction:   return a_item.m_direction;
    case DapHistoryModel::FieldId::x_value:       return a_item.x_value;
    case DapHistoryModel::FieldId::x_token:       return a_item.x_token;
    case DapHistoryModel::FieldId::x_direction:   return a_item.x_direction;    
    case DapHistoryModel::FieldId::fee:           return a_item.fee;
    case DapHistoryModel::FieldId::fee_token:     return a_item.fee_token;
    case DapHistoryModel::FieldId::fee_net:       return a_item.fee_net;
    }

    return QVariant();
}

void DapHistoryModel::_setValue (DapHistoryModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
    switch (DapHistoryModel::FieldId (a_fieldId))
    {
    case DapHistoryModel::FieldId::invalid: break;

    case DapHistoryModel::FieldId::tx_status:     a_item.tx_status    = a_value.toString(); break;
    case DapHistoryModel::FieldId::tx_hash:       a_item.tx_hash      = a_value.toString(); break;
    case DapHistoryModel::FieldId::atom:          a_item.atom         = a_value.toString(); break;
    case DapHistoryModel::FieldId::network:       a_item.network      = a_value.toString(); break;
    case DapHistoryModel::FieldId::wallet_name:   a_item.wallet_name  = a_value.toString(); break;
    case DapHistoryModel::FieldId::date:          a_item.date         = a_value.toString(); break;
    case DapHistoryModel::FieldId::date_to_secs:  a_item.date_to_secs = a_value.toString().toLongLong(); break;
    case DapHistoryModel::FieldId::time:          a_item.time         = a_value.toString(); break;
    case DapHistoryModel::FieldId::address:       a_item.address      = a_value.toString(); break;
    case DapHistoryModel::FieldId::status:        a_item.status       = a_value.toString(); break;
    case DapHistoryModel::FieldId::token:         a_item.token        = a_value.toString(); break;
    case DapHistoryModel::FieldId::direction:     a_item.direction    = a_value.toString(); break;
    case DapHistoryModel::FieldId::value:         a_item.value        = a_value.toString(); break;
    case DapHistoryModel::FieldId::m_value:       a_item.m_value      = a_value.toString(); break;
    case DapHistoryModel::FieldId::m_token:       a_item.m_token      = a_value.toString(); break;
    case DapHistoryModel::FieldId::m_direction:   a_item.m_direction  = a_value.toString(); break;
    case DapHistoryModel::FieldId::x_value:       a_item.x_value      = a_value.toString(); break;
    case DapHistoryModel::FieldId::x_token:       a_item.x_token      = a_value.toString(); break;
    case DapHistoryModel::FieldId::x_direction:   a_item.x_direction  = a_value.toString(); break;    
    case DapHistoryModel::FieldId::fee:           a_item.fee          = a_value.toString(); break;
    case DapHistoryModel::FieldId::fee_token:     a_item.fee_token    = a_value.toString(); break;
    case DapHistoryModel::FieldId::fee_net:       a_item.fee_net      = a_value.toString(); break;
    }
}

QVariant DapHistoryModel::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapHistoryModel::operator[] (int a_index) const
{
    return get (a_index);
}

DapHistoryModel &DapHistoryModel::operator= (const DapHistoryModel &a_src)
{
    *m_items  = *a_src.m_items;
    return *this;
}

DapHistoryModel &DapHistoryModel::operator= (DapHistoryModel &&a_src)
{
    if (this != &a_src)
    {
        delete m_items;
        m_items       = a_src.m_items;
        a_src.m_items = nullptr;
    }
    return *this;
}

/********************************************
 * FUNCTIONS
 *******************************************/

DapHistoryModel::Item _dummy()
{
    return DapHistoryModel::Item
        {
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            0,
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString()
        };
}

ItemHistoryBridge::ItemHistoryBridge (ItemHistoryBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::tx_statusChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::tx_hashChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::atomChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::networkChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::wallet_nameChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::dateChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::date_to_secsChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::timeChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::addressChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::statusChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::tokenChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::directionChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::valueChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::feeChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemHistoryBridge::fee_tokenChanged);
}

ItemHistoryBridge::ItemHistoryBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemHistoryBridge::ItemHistoryBridge (const ItemHistoryBridge &a_src)
{
    operator = (a_src);
}

ItemHistoryBridge::ItemHistoryBridge (ItemHistoryBridge &&a_src)
{
    operator = (std::move (a_src));
}

ItemHistoryBridge::~ItemHistoryBridge()
{
    delete d;
}

/* METHODS */

QString ItemHistoryBridge::tx_status() const
{
    return (d && d->item) ? d->item->tx_status : QString();
}

void ItemHistoryBridge::setTx_status (const QString &tx_status)
{
    if (!_beginSetValue())
        return;
    d->item->tx_status = tx_status;
    emit tx_statusChanged();
    _endSetValue();
}

QString ItemHistoryBridge::tx_hash() const
{
    return (d && d->item) ? d->item->tx_hash : QString();
}

void ItemHistoryBridge::setTx_hash (const QString &tx_hash)
{
    if (!_beginSetValue())
        return;
    d->item->tx_hash = tx_hash;
    emit tx_hashChanged();
    _endSetValue();
}

QString ItemHistoryBridge::atom() const
{
    return (d && d->item) ? d->item->atom : QString();
}

void ItemHistoryBridge::setAtom (const QString &atom)
{
    if (!_beginSetValue())
        return;
    d->item->atom = atom;
    emit atomChanged();
    _endSetValue();
}

QString ItemHistoryBridge::network() const
{
    return (d && d->item) ? d->item->network : QString();
}

void ItemHistoryBridge::setNetwork (const QString &network)
{
    if (!_beginSetValue())
        return;
    d->item->network = network;
    emit networkChanged();
    _endSetValue();
}

QString ItemHistoryBridge::wallet_name() const
{
    return (d && d->item) ? d->item->wallet_name : QString();
}

void ItemHistoryBridge::setWallet_name (const QString &wallet_name)
{
    if (!_beginSetValue())
        return;
    d->item->wallet_name = wallet_name;
    emit wallet_nameChanged();
    _endSetValue();
}

QString ItemHistoryBridge::date() const
{
    return (d && d->item) ? d->item->date : QString();
}

void ItemHistoryBridge::setDate (const QString &date)
{
    if (!_beginSetValue())
        return;
    d->item->date = date;
    emit dateChanged();
    _endSetValue();
}

qint64 ItemHistoryBridge::date_to_secs() const
{
    return (d && d->item) ? d->item->date_to_secs : 0;
}

void ItemHistoryBridge::setDate_to_secs (qint64 date_to_secs)
{
    if (!_beginSetValue())
        return;
    d->item->date_to_secs = date_to_secs;
    emit date_to_secsChanged();
    _endSetValue();
}

QString ItemHistoryBridge::time() const
{
    return (d && d->item) ? d->item->time : QString();
}

void ItemHistoryBridge::setTime (const QString &time)
{
    if (!_beginSetValue())
        return;
    d->item->time = time;
    emit timeChanged();
    _endSetValue();
}

QString ItemHistoryBridge::address() const
{
    return (d && d->item) ? d->item->address : QString();
}

void ItemHistoryBridge::setAddress (const QString &address)
{
    if (!_beginSetValue())
        return;
    d->item->address = address;
    emit addressChanged();
    _endSetValue();
}

QString ItemHistoryBridge::status() const
{
    return (d && d->item) ? d->item->status : QString();
}

void ItemHistoryBridge::setStatus (const QString &status)
{
    if (!_beginSetValue())
        return;
    d->item->status   = status;
    emit statusChanged();
    _endSetValue();
}

QString ItemHistoryBridge::token() const
{
    return (d && d->item) ? d->item->token : QString();
}

void ItemHistoryBridge::setToken (const QString &token)
{
    if (!_beginSetValue())
        return;
    d->item->token   = token;
    emit tokenChanged();
    _endSetValue();
}

QString ItemHistoryBridge::direction() const
{
    return (d && d->item) ? d->item->direction : QString();
}

void ItemHistoryBridge::setDirection (const QString &direction)
{
    if (!_beginSetValue())
        return;
    d->item->direction   = direction;
    emit directionChanged();
    _endSetValue();
}

QString ItemHistoryBridge::m_value() const
{
    return (d && d->item) ? d->item->m_value : QString();
}

void ItemHistoryBridge::setM_Value (const QString &m_value)
{
    if (!_beginSetValue())
        return;
    d->item->m_value   = m_value;
    emit m_valueChanged();
    _endSetValue();
}

QString ItemHistoryBridge::x_value() const
{
    return (d && d->item) ? d->item->x_value : QString();
}

void ItemHistoryBridge::setX_Value (const QString &x_value)
{
    if (!_beginSetValue())
        return;
    d->item->x_value   = x_value;
    emit x_valueChanged();
    _endSetValue();
}

QString ItemHistoryBridge::value() const
{
    return (d && d->item) ? d->item->value : QString();
}

void ItemHistoryBridge::setValue (const QString &value)
{
    if (!_beginSetValue())
        return;
    d->item->value   = value;
    emit valueChanged();
    _endSetValue();
}

QString ItemHistoryBridge::fee() const
{
    return (d && d->item) ? d->item->fee : QString();
}

void ItemHistoryBridge::setFee (const QString &fee)
{
    if (!_beginSetValue())
        return;
    d->item->fee   = fee;
    emit feeChanged();
    _endSetValue();
}

QString ItemHistoryBridge::fee_token() const
{
    return (d && d->item) ? d->item->fee_token : QString();
}

void ItemHistoryBridge::setFee_token (const QString &fee_token)
{
    if (!_beginSetValue())
        return;
    d->item->fee_token   = fee_token;
    emit fee_tokenChanged();
    _endSetValue();
}

QString ItemHistoryBridge::fee_net() const
{
    return (d && d->item) ? d->item->fee_net : QString();
}

void ItemHistoryBridge::setFee_net (const QString &fee_net)
{
    if (!_beginSetValue())
        return;
    d->item->fee_net   = fee_net;
    emit fee_netChanged();
    _endSetValue();
}

QString ItemHistoryBridge::m_direction() const
{
    return (d && d->item) ? d->item->m_direction : QString();
}

void ItemHistoryBridge::setM_direction (const QString &m_direction)
{
    if (!_beginSetValue())
        return;
    d->item->m_direction   = m_direction;
    emit m_directionChanged();
    _endSetValue();
}

QString ItemHistoryBridge::m_token() const
{
    return (d && d->item) ? d->item->m_token : QString();
}

void ItemHistoryBridge::setM_token (const QString &m_token)
{
    if (!_beginSetValue())
        return;
    d->item->m_token   = m_token;
    emit m_tokenChanged();
    _endSetValue();
}

QString ItemHistoryBridge::x_direction() const
{
    return (d && d->item) ? d->item->x_direction : QString();
}

void ItemHistoryBridge::setX_direction (const QString &x_direction)
{
    if (!_beginSetValue())
        return;
    d->item->x_direction   = x_direction;
    emit x_directionChanged();
    _endSetValue();
}

QString ItemHistoryBridge::x_token() const
{
    return (d && d->item) ? d->item->x_token : QString();
}

void ItemHistoryBridge::setX_token (const QString &x_token)
{
    if (!_beginSetValue())
        return;
    d->item->x_token   = x_token;
    emit x_tokenChanged();
    _endSetValue();
}

bool ItemHistoryBridge::_beginSetValue()
{
    if (!d || !d->model || !d->item)
        return false;

    int index = d->model->indexOf (*d->item);
    if (index == -1)
        return false;

    int columns = d->model->columnCount() - 1;
    d->begin  = d->model->index(index, 0);
    d->end    = d->model->index(index, columns);
    return true;
}

void ItemHistoryBridge::_endSetValue()
{
    emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemHistoryBridge::operator[] (const QString &a_valueName)
{
    if (!d || !d->model || !d->item)
        return QVariant();

    int fieldId = d->model->fieldId (a_valueName);


    switch (DapHistoryModel::FieldId (fieldId))
    {

    case DapHistoryModel::FieldId::tx_status:     return tx_status();    break;
    case DapHistoryModel::FieldId::tx_hash:       return tx_hash();      break;
    case DapHistoryModel::FieldId::atom:          return atom();         break;
    case DapHistoryModel::FieldId::network:       return network();      break;
    case DapHistoryModel::FieldId::wallet_name:   return wallet_name();  break;
    case DapHistoryModel::FieldId::date:          return date();         break;
    case DapHistoryModel::FieldId::date_to_secs:  return date_to_secs(); break;
    case DapHistoryModel::FieldId::address:       return address();      break;
    case DapHistoryModel::FieldId::status:        return status();       break;
    case DapHistoryModel::FieldId::token:         return token();        break;
    case DapHistoryModel::FieldId::direction:     return direction();    break;
    case DapHistoryModel::FieldId::value:         return value();        break;
    case DapHistoryModel::FieldId::m_value:       return m_value();      break;
    case DapHistoryModel::FieldId::m_token:       return m_token();      break;
    case DapHistoryModel::FieldId::m_direction:   return m_direction();    break;
    case DapHistoryModel::FieldId::x_value:       return x_value();      break;
    case DapHistoryModel::FieldId::x_token:       return x_token();      break;
    case DapHistoryModel::FieldId::x_direction:   return x_direction();    break;    
    case DapHistoryModel::FieldId::fee:           return fee();          break;
    case DapHistoryModel::FieldId::fee_token:     return fee_token();    break;
    case DapHistoryModel::FieldId::fee_net:       return fee_net();      break;

    case DapHistoryModel::FieldId::invalid:
    default:
        break;
    }

    return QVariant();
}

ItemHistoryBridge &ItemHistoryBridge::operator =(const ItemHistoryBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemHistoryBridge &ItemHistoryBridge::operator =(ItemHistoryBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}

