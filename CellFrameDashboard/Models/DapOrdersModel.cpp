#include "DapOrdersModel.h"

#include <QList>
#include <QMetaEnum>

/* DEFS */

struct ItemOrdersBridge::Data
{
    DapOrdersModel *model;
    DapOrdersModel::Item *item;
    QModelIndex begin, end;

    Data (DapOrdersModel *a_model, DapOrdersModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

//QMap<QString, QVariant> v;

static const QHash<QString, DapOrdersModel::DapOrdersModel::FieldId> s_fieldIdMap =
    {
        {"hash",          DapOrdersModel::FieldId::hash},
        {"network",       DapOrdersModel::FieldId::network},
        {"version",       DapOrdersModel::FieldId::version},
        {"direction",     DapOrdersModel::FieldId::direction},
        {"created",       DapOrdersModel::FieldId::created},
        {"srv_uid",       DapOrdersModel::FieldId::srv_uid},
        {"price",         DapOrdersModel::FieldId::price},
        {"price_unit",    DapOrdersModel::FieldId::price_unit},
        {"price_token",   DapOrdersModel::FieldId::price_token},
        {"node_addr",     DapOrdersModel::FieldId::node_addr},
        {"node_location", DapOrdersModel::FieldId::node_location},
        {"tx_cond_hash",  DapOrdersModel::FieldId::tx_cond_hash},
        {"ext",           DapOrdersModel::FieldId::ext},
        {"pkey",          DapOrdersModel::FieldId::pkey},
        {"units",         DapOrdersModel::FieldId::units},
        {"status",        DapOrdersModel::FieldId::status},
        {"amount",        DapOrdersModel::FieldId::amount},
        {"buyToken",      DapOrdersModel::FieldId::buyToken},
        {"sellToken",     DapOrdersModel::FieldId::sellToken},
        {"rate",          DapOrdersModel::FieldId::rate},
        {"filled",        DapOrdersModel::FieldId::filled}
    };

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static DapOrdersModel::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

DapOrdersModel::DapOrdersModel (QObject *a_parent)
    : QAbstractTableModel (a_parent)
    , m_items (new QList<DapOrdersModel::Item>())
{
    //qmlRegisterType<UserModel::Item> ("com.dap.model.UserModelItem", 1, 0, "UserModelItem");
    connect (this, &DapOrdersModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapOrdersModel::DapOrdersModel (const DapOrdersModel &a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapOrdersModel::Item>())
{
    operator= (a_src);
}

DapOrdersModel::DapOrdersModel (DapOrdersModel &&a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapOrdersModel::Item>())
{
    operator= (a_src);
}

DapOrdersModel::~DapOrdersModel()
{
    delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int DapOrdersModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items->size();
}

int DapOrdersModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapOrdersModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapOrdersModel::FieldId (role);
    const auto &item  = m_items->at (index.row());
    return _getValue (item, int (field));
}

QHash<int, QByteArray> DapOrdersModel::roleNames() const
{
    static QHash<int, QByteArray> names;

    if (names.isEmpty())
        for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
            names[int (i.value())] = i.key().toUtf8();

    return names;
}

/********************************************
 * METHODS
 *******************************************/

DapOrdersModel *DapOrdersModel::global()
{
    static DapOrdersModel DapOrdersModel;
    return &DapOrdersModel;
}

int DapOrdersModel::add (const DapOrdersModel::Item &a_item)
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

void DapOrdersModel::insert (int a_index, const DapOrdersModel::Item &a_item)
{
    beginInsertRows (QModelIndex(), a_index, a_index);

    {
        m_items->insert (a_index, a_item);
        emit sigItemAdded (a_index);
        emit sigSizeChanged (size());
    }

    endInsertRows();

}

void DapOrdersModel::remove (int a_index)
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

int DapOrdersModel::indexOf (const DapOrdersModel::Item &a_item) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
        if (i->hash == a_item.hash)
            return index;

    return -1;
}

const DapOrdersModel::Item &DapOrdersModel::at (int a_index) const
{
    return const_cast<DapOrdersModel *> (this)->_get (a_index);
}

DapOrdersModel::Item DapOrdersModel::value (int a_index) const
{
    return at (a_index);
}

int DapOrdersModel::size() const
{
    return m_items->size();
}

bool DapOrdersModel::isEmpty() const
{
    return 0 == m_items->size();
}

void DapOrdersModel::clear()
{
    beginResetModel();

    {
        m_items->clear();
        emit sigSizeChanged (size());
    }

    endResetModel();
}

QVariant DapOrdersModel::get (int a_index)
{
    //  ItemOrdersBridge item (new ItemOrdersBridge::Data (this, &_get (a_index)));
    //  return QVariant::fromValue (item);
    return QVariant::fromValue (new ItemOrdersBridge (new ItemOrdersBridge::Data (this, &_get (a_index))));
}

const QVariant DapOrdersModel::get(int a_index) const
{
    return const_cast<DapOrdersModel*>(this)->get (a_index);
}

DapOrdersModel::Item &DapOrdersModel::_get(int a_index)
{
    static DapOrdersModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

const DapOrdersModel::Item &DapOrdersModel::_get(int a_index) const
{
    return const_cast<DapOrdersModel*>(this)->_get (a_index);
}

void DapOrdersModel::set (int a_index, const DapOrdersModel::Item &a_item)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;
    _get (a_index) = a_item;
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapOrdersModel::set (int a_index, DapOrdersModel::Item &&a_item)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;
    _get (a_index) = std::move (a_item);
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

//QVariant UserModel::getValue (int a_index, int a_fieldId) const
//{
//  return _getValue (_get (a_index), a_fieldId);
//}

//void UserModel::setValue (int a_index, int a_fieldId, const QVariant &a_value)
//{
//  /* if state provided as string */
//  if (a_fieldId == int (UserModel::FieldId::role)
//      && a_value.type() == QVariant::String)
//    {
//      static int stateEnumIndex = UserModel::staticMetaObject.indexOfEnumerator ("Role");
//      static auto enumStateMeta = UserModel::staticMetaObject.enumerator (stateEnumIndex);
//      int state                 = enumStateMeta.keyToValue (a_value.toString().toUtf8());
//      if (state != -1)
//        _setValue (_get (a_index), a_fieldId, state);
//    }

//  /* set value */
//  else
//    _setValue (_get (a_index), a_fieldId, a_value);

//  emit sigItemChanged (a_index);
//  emit dataChanged (index (a_index, 0), index (a_index, columnCount()));
//}

//QVariant UserModel::getProperty (int a_index, const QString &a_fieldName) const
//{
//  auto fieldId  = s_fieldIdMap.value (a_fieldName, UserModel::FieldId::invalid);
//  if (fieldId == UserModel::FieldId::invalid)
//    return QVariant();
//  return getValue (a_index, int (fieldId));
//}

//void UserModel::setProperty (int a_index, const QString &a_fieldName, const QVariant &a_value)
//{
//  auto fieldId  = s_fieldIdMap.value (a_fieldName, UserModel::FieldId::invalid);
//  if (fieldId == UserModel::FieldId::invalid)
//    return;
//  setValue (a_index, int (fieldId), a_value);
//}

int DapOrdersModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapOrdersModel::FieldId::invalid));
}

const DapOrdersModel::Item &DapOrdersModel::getItem(int a_index) const
{
    static DapOrdersModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

DapOrdersModel::Iterator DapOrdersModel::begin()
{
    return m_items->begin();
}

DapOrdersModel::ConstIterator DapOrdersModel::cbegin() const
{
    return m_items->cbegin();
}

DapOrdersModel::Iterator DapOrdersModel::end()
{
    return m_items->end();
}

DapOrdersModel::ConstIterator DapOrdersModel::cend()
{
    return m_items->cend();
}

QVariant DapOrdersModel::_getValue (const DapOrdersModel::Item &a_item, int a_fieldId)
{
    switch (DapOrdersModel::FieldId (a_fieldId))
    {
    case DapOrdersModel::FieldId::invalid: break;

    case DapOrdersModel::FieldId::hash:             return a_item.hash;
    case DapOrdersModel::FieldId::network:          return a_item.network;
    case DapOrdersModel::FieldId::version:          return a_item.version;
    case DapOrdersModel::FieldId::direction:        return a_item.direction;
    case DapOrdersModel::FieldId::created:          return a_item.created;
    case DapOrdersModel::FieldId::srv_uid:          return a_item.srv_uid;
    case DapOrdersModel::FieldId::price:            return a_item.price;
    case DapOrdersModel::FieldId::price_unit:       return a_item.price_unit;
    case DapOrdersModel::FieldId::price_token:      return a_item.price_token;
    case DapOrdersModel::FieldId::node_addr:        return a_item.node_addr;
    case DapOrdersModel::FieldId::node_location:    return a_item.node_location;
    case DapOrdersModel::FieldId::tx_cond_hash:     return a_item.tx_cond_hash;
    case DapOrdersModel::FieldId::ext:              return a_item.ext;
    case DapOrdersModel::FieldId::pkey:             return a_item.pkey;
    case DapOrdersModel::FieldId::units:            return a_item.units;
    case DapOrdersModel::FieldId::status:           return a_item.status;
    case DapOrdersModel::FieldId::amount:           return a_item.amount;
    case DapOrdersModel::FieldId::buyToken:         return a_item.buyToken;
    case DapOrdersModel::FieldId::sellToken:        return a_item.sellToken;
    case DapOrdersModel::FieldId::rate:             return a_item.rate;
    case DapOrdersModel::FieldId::filled:           return a_item.filled;
    }

    return QVariant();
}

void DapOrdersModel::_setValue (DapOrdersModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
    switch (DapOrdersModel::FieldId (a_fieldId))
    {
    case DapOrdersModel::FieldId::invalid: break;

    case DapOrdersModel::FieldId::hash:           a_item.hash          = a_value.toString(); break;
    case DapOrdersModel::FieldId::network:        a_item.network       = a_value.toString(); break;
    case DapOrdersModel::FieldId::version:        a_item.version       = a_value.toString(); break;
    case DapOrdersModel::FieldId::direction:      a_item.direction     = a_value.toString(); break;
    case DapOrdersModel::FieldId::created:        a_item.created       = a_value.toString(); break;
    case DapOrdersModel::FieldId::srv_uid:        a_item.srv_uid       = a_value.toString(); break;
    case DapOrdersModel::FieldId::price:          a_item.price         = a_value.toString(); break;
    case DapOrdersModel::FieldId::price_unit:     a_item.price_unit    = a_value.toString(); break;
    case DapOrdersModel::FieldId::price_token:    a_item.price_token   = a_value.toString(); break;
    case DapOrdersModel::FieldId::node_addr:      a_item.node_addr     = a_value.toString(); break;
    case DapOrdersModel::FieldId::node_location:  a_item.node_location = a_value.toString(); break;
    case DapOrdersModel::FieldId::tx_cond_hash:   a_item.tx_cond_hash  = a_value.toString(); break;
    case DapOrdersModel::FieldId::ext:            a_item.ext           = a_value.toString(); break;
    case DapOrdersModel::FieldId::pkey:           a_item.pkey          = a_value.toString(); break;
    case DapOrdersModel::FieldId::units:          a_item.units         = a_value.toString(); break;
    case DapOrdersModel::FieldId::status:         a_item.status        = a_value.toString(); break;
    case DapOrdersModel::FieldId::amount:         a_item.amount        = a_value.toString(); break;
    case DapOrdersModel::FieldId::buyToken:       a_item.buyToken      = a_value.toString(); break;
    case DapOrdersModel::FieldId::sellToken:      a_item.sellToken     = a_value.toString(); break;
    case DapOrdersModel::FieldId::rate:           a_item.rate          = a_value.toString(); break;
    case DapOrdersModel::FieldId::filled:         a_item.filled        = a_value.toString(); break;
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant DapOrdersModel::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapOrdersModel::operator[] (int a_index) const
{
    return get (a_index);
}

DapOrdersModel &DapOrdersModel::operator= (const DapOrdersModel &a_src)
{
    *m_items  = *a_src.m_items;
    return *this;
}

DapOrdersModel &DapOrdersModel::operator= (DapOrdersModel &&a_src)
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

DapOrdersModel::Item _dummy()
{
    return DapOrdersModel::Item
        {
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
            QString(),
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

/********************************************
 * ITEM BRIDGE
 *******************************************/

ItemOrdersBridge::ItemOrdersBridge (ItemOrdersBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::hashChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::networkChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::versionChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::directionChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::createdChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::srv_uidChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::priceChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::price_unitChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::price_tokenChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::node_addrChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::node_locationChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::tx_cond_hashChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::extChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::pkeyChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::unitsChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::rateChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::buyTokenChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::amountChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::sellTokenChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::statusChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemOrdersBridge::filledChanged);
}

ItemOrdersBridge::ItemOrdersBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemOrdersBridge::ItemOrdersBridge (const ItemOrdersBridge &a_src)
{
    operator = (a_src);
}

ItemOrdersBridge::ItemOrdersBridge (ItemOrdersBridge &&a_src)
{
    operator = (std::move (a_src));
}

ItemOrdersBridge::~ItemOrdersBridge()
{
    delete d;
}

/* METHODS */

QString ItemOrdersBridge::hash() const
{
    return (d && d->item) ? d->item->hash : QString();
}

void ItemOrdersBridge::setHash (const QString &hash)
{
    if (!_beginSetValue())
        return;
    d->item->hash = hash;
    emit hashChanged();
    _endSetValue();
}

QString ItemOrdersBridge::network() const
{
    return (d && d->item) ? d->item->network : QString();
}

void ItemOrdersBridge::setNetwork (const QString &network)
{
    if (!_beginSetValue())
        return;
    d->item->network = network;
    emit networkChanged();
    _endSetValue();
}

QString ItemOrdersBridge::version() const
{
    return (d && d->item) ? d->item->version : QString();
}

void ItemOrdersBridge::setVersion (const QString &version)
{
    if (!_beginSetValue())
        return;
    d->item->version = version;
    emit versionChanged();
    _endSetValue();
}

QString ItemOrdersBridge::direction() const
{
    return (d && d->item) ? d->item->direction : QString();
}

void ItemOrdersBridge::setDirection (const QString &direction)
{
    if (!_beginSetValue())
        return;
    d->item->direction = direction;
    emit directionChanged();
    _endSetValue();
}

QString ItemOrdersBridge::created() const
{
    return (d && d->item) ? d->item->created : QString();
}

void ItemOrdersBridge::setCreated (const QString &created)
{
    if (!_beginSetValue())
        return;
    d->item->created = created;
    emit createdChanged();
    _endSetValue();
}

QString ItemOrdersBridge::srv_uid() const
{
    return (d && d->item) ? d->item->srv_uid : QString();
}

void ItemOrdersBridge::setSrv_uid (const QString &srv_uid)
{
    if (!_beginSetValue())
        return;
    d->item->srv_uid = srv_uid;
    emit srv_uidChanged();
    _endSetValue();
}

QString ItemOrdersBridge::price() const
{
    return (d && d->item) ? d->item->price : QString();
}

void ItemOrdersBridge::setPrice (const QString &price)
{
    if (!_beginSetValue())
        return;
    d->item->price = price;
    emit priceChanged();
    _endSetValue();
}

QString ItemOrdersBridge::price_unit() const
{
    return (d && d->item) ? d->item->price_unit : QString();
}

void ItemOrdersBridge::setPrice_unit (const QString &price_unit)
{
    if (!_beginSetValue())
        return;
    d->item->price_unit = price_unit;
    emit price_unitChanged();
    _endSetValue();
}

QString ItemOrdersBridge::price_token() const
{
    return (d && d->item) ? d->item->price_token : QString();
}

void ItemOrdersBridge::setPrice_token (const QString &price_token)
{
    if (!_beginSetValue())
        return;
    d->item->price_token = price_token;
    emit price_tokenChanged();
    _endSetValue();
}

QString ItemOrdersBridge::node_addr() const
{
    return (d && d->item) ? d->item->node_addr : QString();
}

void ItemOrdersBridge::setNode_addr (const QString &node_addr)
{
    if (!_beginSetValue())
        return;
    d->item->node_addr   = node_addr;
    emit node_addrChanged();
    _endSetValue();
}

QString ItemOrdersBridge::node_location() const
{
    return (d && d->item) ? d->item->node_location : QString();
}

void ItemOrdersBridge::setNode_location (const QString &node_location)
{
    if (!_beginSetValue())
        return;
    d->item->node_location   = node_location;
    emit node_locationChanged();
    _endSetValue();
}

QString ItemOrdersBridge::tx_cond_hash() const
{
    return (d && d->item) ? d->item->tx_cond_hash : QString();
}

void ItemOrdersBridge::setTx_cond_hash (const QString &tx_cond_hash)
{
    if (!_beginSetValue())
        return;
    d->item->tx_cond_hash   = tx_cond_hash;
    emit tx_cond_hashChanged();
    _endSetValue();
}

QString ItemOrdersBridge::ext() const
{
    return (d && d->item) ? d->item->ext : QString();
}

void ItemOrdersBridge::setExt (const QString &ext)
{
    if (!_beginSetValue())
        return;
    d->item->ext   = ext;
    emit extChanged();
    _endSetValue();
}

QString ItemOrdersBridge::pkey() const
{
    return (d && d->item) ? d->item->pkey : QString();
}

void ItemOrdersBridge::setPkey (const QString &pkey)
{
    if (!_beginSetValue())
        return;
    d->item->pkey   = pkey;
    emit pkeyChanged();
    _endSetValue();
}

QString ItemOrdersBridge::units() const
{
    return (d && d->item) ? d->item->units : QString();
}

void ItemOrdersBridge::setUnits (const QString &units)
{
    if (!_beginSetValue())
        return;
    d->item->units   = units;
    emit unitsChanged();
    _endSetValue();
}

QString ItemOrdersBridge::status() const
{
    return (d && d->item) ? d->item->status : QString();
}

void ItemOrdersBridge::setStatus (const QString &status)
{
    if (!_beginSetValue())
        return;
    d->item->status   = status;
    emit statusChanged();
    _endSetValue();
}

QString ItemOrdersBridge::amount() const
{
    return (d && d->item) ? d->item->amount : QString();
}

void ItemOrdersBridge::setAmount (const QString &amount)
{
    if (!_beginSetValue())
        return;
    d->item->amount   = amount;
    emit amountChanged();
    _endSetValue();
}

QString ItemOrdersBridge::buyToken() const
{
    return (d && d->item) ? d->item->buyToken : QString();
}

void ItemOrdersBridge::setBuyToken (const QString &buyToken)
{
    if (!_beginSetValue())
        return;
    d->item->buyToken   = buyToken;
    emit buyTokenChanged();
    _endSetValue();
}

QString ItemOrdersBridge::sellToken() const
{
    return (d && d->item) ? d->item->sellToken : QString();
}

void ItemOrdersBridge::setSellToken (const QString &sellToken)
{
    if (!_beginSetValue())
        return;
    d->item->sellToken   = sellToken;
    emit sellTokenChanged();
    _endSetValue();
}

QString ItemOrdersBridge::rate() const
{
    return (d && d->item) ? d->item->rate : QString();
}

void ItemOrdersBridge::setRate (const QString &rate)
{
    if (!_beginSetValue())
        return;
    d->item->rate   = rate;
    emit rateChanged();
    _endSetValue();
}

QString ItemOrdersBridge::filled() const
{
    return (d && d->item) ? d->item->filled : QString();
}

void ItemOrdersBridge::setFilled (const QString &filled)
{
    if (!_beginSetValue())
        return;
    d->item->filled   = filled;
    emit filledChanged();
    _endSetValue();
}

bool ItemOrdersBridge::_beginSetValue()
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

void ItemOrdersBridge::_endSetValue()
{
    emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemOrdersBridge::operator[] (const QString &a_valueName)
{
    if (!d || !d->model || !d->item)
        return QVariant();

    int fieldId = d->model->fieldId (a_valueName);

    switch (DapOrdersModel::FieldId (fieldId))
    {

    case DapOrdersModel::FieldId::hash:          return hash();          break;
    case DapOrdersModel::FieldId::network:       return network();       break;
    case DapOrdersModel::FieldId::version:       return version();       break;
    case DapOrdersModel::FieldId::direction:     return direction();     break;
    case DapOrdersModel::FieldId::created:       return created();       break;
    case DapOrdersModel::FieldId::srv_uid:       return srv_uid();       break;
    case DapOrdersModel::FieldId::price:         return price();         break;
    case DapOrdersModel::FieldId::price_unit:    return price_unit();    break;
    case DapOrdersModel::FieldId::price_token:   return price_token();   break;
    case DapOrdersModel::FieldId::node_addr:     return node_addr();     break;
    case DapOrdersModel::FieldId::node_location: return node_location(); break;
    case DapOrdersModel::FieldId::tx_cond_hash:  return tx_cond_hash();  break;
    case DapOrdersModel::FieldId::ext:           return ext();           break;
    case DapOrdersModel::FieldId::pkey:          return pkey();          break;
    case DapOrdersModel::FieldId::units:         return units();         break;
    case DapOrdersModel::FieldId::status:        return status();        break;
    case DapOrdersModel::FieldId::amount:        return amount();        break;
    case DapOrdersModel::FieldId::buyToken:      return buyToken();      break;
    case DapOrdersModel::FieldId::sellToken:     return sellToken();     break;
    case DapOrdersModel::FieldId::rate:          return rate();          break;
    case DapOrdersModel::FieldId::filled:        return filled();        break;

    case DapOrdersModel::FieldId::invalid:
    default:
        break;
    }

    return QVariant();
}

ItemOrdersBridge &ItemOrdersBridge::operator =(const ItemOrdersBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemOrdersBridge &ItemOrdersBridge::operator =(ItemOrdersBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}

/*-----------------------------------------*/
