#include "historymodel.h"

#include <QList>
#include <QMetaEnum>

/* DEFS */

struct ItemBridge::Data
{
    HistoryModel *model;
    HistoryModel::Item *item;
    QModelIndex begin, end;

    Data (HistoryModel *a_model, HistoryModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

//QMap<QString, QVariant> v;

static const QHash<QString, HistoryModel::HistoryModel::FieldId> s_fieldIdMap =
{
    {"tx_status",    HistoryModel::FieldId::tx_status},
    {"tx_hash",      HistoryModel::FieldId::tx_hash},
    {"atom",         HistoryModel::FieldId::atom},
    {"network",      HistoryModel::FieldId::network},
    {"wallet_name",  HistoryModel::FieldId::wallet_name},
    {"date",         HistoryModel::FieldId::date},
    {"date_to_secs", HistoryModel::FieldId::date_to_secs},
    {"address",      HistoryModel::FieldId::address},
    {"status",       HistoryModel::FieldId::status},
    {"token",        HistoryModel::FieldId::token},
    {"direction",    HistoryModel::FieldId::direction},
    {"value",        HistoryModel::FieldId::value},
    {"fee",          HistoryModel::FieldId::fee},
    {"fee_token",    HistoryModel::FieldId::fee_token},
};

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static HistoryModel::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

HistoryModel::HistoryModel (QObject *a_parent)
  : QAbstractTableModel (a_parent)
  , m_items (new QList<HistoryModel::Item>())
{
  //qmlRegisterType<UserModel::Item> ("com.dap.model.UserModelItem", 1, 0, "UserModelItem");
  connect (this, &HistoryModel::sigSizeChanged,
           this, [this]
  {
    emit sizeChanged();
  });
}

HistoryModel::HistoryModel (const HistoryModel &a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<HistoryModel::Item>())
{
  operator= (a_src);
}

HistoryModel::HistoryModel (HistoryModel &&a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<HistoryModel::Item>())
{
  operator= (a_src);
}

HistoryModel::~HistoryModel()
{
  delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int HistoryModel::rowCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return m_items->size();
}

int HistoryModel::columnCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return s_fieldIdMap.size();
}

QVariant HistoryModel::data (const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  auto field        = HistoryModel::FieldId (role);
  const auto &item  = m_items->at (index.row());
  return _getValue (item, int (field));
}

QHash<int, QByteArray> HistoryModel::roleNames() const
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

HistoryModel *HistoryModel::global()
{
  static HistoryModel historyModel;
  return &historyModel;
}

int HistoryModel::add (const HistoryModel::Item &a_item)
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

void HistoryModel::insert (int a_index, const HistoryModel::Item &a_item)
{
  beginInsertRows (QModelIndex(), a_index, a_index);

  {
    m_items->insert (a_index, a_item);
    emit sigItemAdded (a_index);
    emit sigSizeChanged (size());
  }

  endInsertRows();

}

void HistoryModel::remove (int a_index)
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

int HistoryModel::indexOf (const HistoryModel::Item &a_item) const
{
  int index = 0;

  for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
    if (i->tx_hash == a_item.tx_hash)
      return index;

  return -1;
}

int HistoryModel::indexOfTime(qint64 time) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
      if (i->date_to_secs < time)
        return index;

    return index;
}

const HistoryModel::Item &HistoryModel::at (int a_index) const
{
    return const_cast<HistoryModel *> (this)->_get (a_index);
}

HistoryModel::Item HistoryModel::value (int a_index) const
{
  return at (a_index);
}

int HistoryModel::size() const
{
  return m_items->size();
}

bool HistoryModel::isEmpty() const
{
  return 0 == m_items->size();
}

void HistoryModel::clear()
{
  beginResetModel();

  {
    m_items->clear();
    emit sigSizeChanged (size());
  }

  endResetModel();
}

QVariant HistoryModel::get (int a_index)
{
//  ItemBridge item (new ItemBridge::Data (this, &_get (a_index)));
//  return QVariant::fromValue (item);
  return QVariant::fromValue (new ItemBridge (new ItemBridge::Data (this, &_get (a_index))));
}

const QVariant HistoryModel::get(int a_index) const
{
  return const_cast<HistoryModel*>(this)->get (a_index);
}

HistoryModel::Item &HistoryModel::_get(int a_index)
{
  static HistoryModel::Item dummy;

  if (a_index < 0 || a_index >= m_items->size())
    {
      dummy = _dummy();
      return dummy;
    }

  return (*m_items) [a_index];
}

const HistoryModel::Item &HistoryModel::_get(int a_index) const
{
  return const_cast<HistoryModel*>(this)->_get (a_index);
}

void HistoryModel::set (int a_index, const HistoryModel::Item &a_item)
{
  if (a_index < 0 || a_index >= m_items->size())
    return;
  _get (a_index) = a_item;
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void HistoryModel::set (int a_index, HistoryModel::Item &&a_item)
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

int HistoryModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, HistoryModel::FieldId::invalid));
}

const HistoryModel::Item &HistoryModel::getItem(int a_index) const
{
    static HistoryModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
      {
        dummy = _dummy();
        return dummy;
      }

    return (*m_items) [a_index];
}

HistoryModel::Iterator HistoryModel::begin()
{
  return m_items->begin();
}

HistoryModel::ConstIterator HistoryModel::cbegin() const
{
  return m_items->cbegin();
}

HistoryModel::Iterator HistoryModel::end()
{
  return m_items->end();
}

HistoryModel::ConstIterator HistoryModel::cend()
{
  return m_items->cend();
}

QVariant HistoryModel::_getValue (const HistoryModel::Item &a_item, int a_fieldId)
{
  switch (HistoryModel::FieldId (a_fieldId))
    {
    case HistoryModel::FieldId::invalid: break;

    case HistoryModel::FieldId::tx_status:     return a_item.tx_status;
    case HistoryModel::FieldId::tx_hash:       return a_item.tx_hash;
    case HistoryModel::FieldId::atom:          return a_item.atom;
    case HistoryModel::FieldId::network:       return a_item.network;
    case HistoryModel::FieldId::wallet_name:   return a_item.wallet_name;
    case HistoryModel::FieldId::date:          return a_item.date;
    case HistoryModel::FieldId::date_to_secs:  return a_item.date_to_secs;
    case HistoryModel::FieldId::address:       return a_item.address;
    case HistoryModel::FieldId::status:        return a_item.status;
    case HistoryModel::FieldId::token:         return a_item.token;
    case HistoryModel::FieldId::direction:     return a_item.direction;
    case HistoryModel::FieldId::value:         return a_item.value;
    case HistoryModel::FieldId::fee:           return a_item.fee;
    case HistoryModel::FieldId::fee_token:     return a_item.fee_token;
    }

  return QVariant();
}

void HistoryModel::_setValue (HistoryModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
  switch (HistoryModel::FieldId (a_fieldId))
    {
    case HistoryModel::FieldId::invalid: break;

    case HistoryModel::FieldId::tx_status:     a_item.tx_status    = a_value.toString(); break;
    case HistoryModel::FieldId::tx_hash:       a_item.tx_hash      = a_value.toString(); break;
    case HistoryModel::FieldId::atom:          a_item.atom         = a_value.toString(); break;
    case HistoryModel::FieldId::network:       a_item.network      = a_value.toString(); break;
    case HistoryModel::FieldId::wallet_name:   a_item.wallet_name  = a_value.toString(); break;
    case HistoryModel::FieldId::date:          a_item.date         = a_value.toString(); break;
    case HistoryModel::FieldId::date_to_secs:  a_item.date_to_secs = a_value.toString().toLongLong(); break;
    case HistoryModel::FieldId::address:       a_item.address      = a_value.toString(); break;
    case HistoryModel::FieldId::status:        a_item.status       = a_value.toString(); break;
    case HistoryModel::FieldId::token:         a_item.token        = a_value.toString(); break;
    case HistoryModel::FieldId::direction:     a_item.direction    = a_value.toString(); break;
    case HistoryModel::FieldId::value:         a_item.value        = a_value.toString(); break;
    case HistoryModel::FieldId::fee:           a_item.fee          = a_value.toString(); break;
    case HistoryModel::FieldId::fee_token:     a_item.fee_token    = a_value.toString(); break;
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant HistoryModel::operator[] (int a_index)
{
  return get (a_index);
}

const QVariant HistoryModel::operator[] (int a_index) const
{
  return get (a_index);
}

HistoryModel &HistoryModel::operator= (const HistoryModel &a_src)
{
  *m_items  = *a_src.m_items;
  return *this;
}

HistoryModel &HistoryModel::operator= (HistoryModel &&a_src)
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

HistoryModel::Item _dummy()
{
  return HistoryModel::Item
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
      QString()
  };
}

/********************************************
 * ITEM BRIDGE
 *******************************************/

ItemBridge::ItemBridge (ItemBridge::Data *a_data)
  : d (a_data)
{
  if (!d || !d->model)
    return;
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::tx_statusChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::tx_hashChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::atomChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::networkChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::wallet_nameChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::dateChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::date_to_secsChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::addressChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::statusChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::tokenChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::directionChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::valueChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::feeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemBridge::fee_tokenChanged);
}

ItemBridge::ItemBridge (QObject *a_parent)
  : QObject (a_parent)
  , d (nullptr)
{

}

ItemBridge::ItemBridge (const ItemBridge &a_src)
{
  operator = (a_src);
}

ItemBridge::ItemBridge (ItemBridge &&a_src)
{
  operator = (std::move (a_src));
}

ItemBridge::~ItemBridge()
{
  delete d;
}

/* METHODS */

QString ItemBridge::tx_status() const
{
  return (d && d->item) ? d->item->tx_status : QString();
}

void ItemBridge::setTx_status (const QString &tx_status)
{
  if (!_beginSetValue())
    return;
  d->item->tx_status = tx_status;
  emit tx_statusChanged();
  _endSetValue();
}

QString ItemBridge::tx_hash() const
{
  return (d && d->item) ? d->item->tx_hash : QString();
}

void ItemBridge::setTx_hash (const QString &tx_hash)
{
  if (!_beginSetValue())
    return;
  d->item->tx_hash = tx_hash;
  emit tx_hashChanged();
  _endSetValue();
}

QString ItemBridge::atom() const
{
  return (d && d->item) ? d->item->atom : QString();
}

void ItemBridge::setAtom (const QString &atom)
{
  if (!_beginSetValue())
    return;
  d->item->atom = atom;
  emit atomChanged();
  _endSetValue();
}

QString ItemBridge::network() const
{
  return (d && d->item) ? d->item->network : QString();
}

void ItemBridge::setNetwork (const QString &network)
{
  if (!_beginSetValue())
    return;
  d->item->network = network;
  emit networkChanged();
  _endSetValue();
}

QString ItemBridge::wallet_name() const
{
  return (d && d->item) ? d->item->wallet_name : QString();
}

void ItemBridge::setWallet_name (const QString &wallet_name)
{
  if (!_beginSetValue())
    return;
  d->item->wallet_name = wallet_name;
  emit wallet_nameChanged();
  _endSetValue();
}

QString ItemBridge::date() const
{
    return (d && d->item) ? d->item->date : QString();
}

void ItemBridge::setDate (const QString &date)
{
  if (!_beginSetValue())
    return;
  d->item->date = date;
  emit dateChanged();
  dateChanged();
}

qint64 ItemBridge::date_to_secs() const
{
  return (d && d->item) ? d->item->date_to_secs : 0;
}

void ItemBridge::setDate_to_secs (qint64 date_to_secs)
{
  if (!_beginSetValue())
    return;
  d->item->date_to_secs = date_to_secs;
  emit date_to_secsChanged();
  _endSetValue();
}

QString ItemBridge::address() const
{
  return (d && d->item) ? d->item->address : QString();
}

void ItemBridge::setAddress (const QString &address)
{
  if (!_beginSetValue())
    return;
  d->item->address = address;
  emit addressChanged();
  _endSetValue();
}

QString ItemBridge::status() const
{
  return (d && d->item) ? d->item->status : QString();
}

void ItemBridge::setStatus (const QString &status)
{
  if (!_beginSetValue())
    return;
  d->item->status   = status;
  emit statusChanged();
  _endSetValue();
}

QString ItemBridge::token() const
{
  return (d && d->item) ? d->item->token : QString();
}

void ItemBridge::setToken (const QString &token)
{
  if (!_beginSetValue())
    return;
  d->item->token   = token;
  emit tokenChanged();
  _endSetValue();
}

QString ItemBridge::direction() const
{
  return (d && d->item) ? d->item->direction : QString();
}

void ItemBridge::setDirection (const QString &direction)
{
  if (!_beginSetValue())
    return;
  d->item->direction   = direction;
  emit directionChanged();
  _endSetValue();
}

QString ItemBridge::value() const
{
  return (d && d->item) ? d->item->value : QString();
}

void ItemBridge::setValue (const QString &value)
{
  if (!_beginSetValue())
    return;
  d->item->value   = value;
  emit valueChanged();
  _endSetValue();
}

QString ItemBridge::fee() const
{
  return (d && d->item) ? d->item->fee : QString();
}

void ItemBridge::setFee (const QString &fee)
{
  if (!_beginSetValue())
    return;
  d->item->fee   = fee;
  emit feeChanged();
  _endSetValue();
}

QString ItemBridge::fee_token() const
{
  return (d && d->item) ? d->item->fee_token : QString();
}

void ItemBridge::setFee_token (const QString &fee_token)
{
  if (!_beginSetValue())
    return;
  d->item->fee_token   = fee_token;
  emit fee_tokenChanged();
  _endSetValue();
}

bool ItemBridge::_beginSetValue()
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

void ItemBridge::_endSetValue()
{
  emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemBridge::operator[] (const QString &a_valueName)
{
  if (!d || !d->model || !d->item)
    return QVariant();

  int fieldId = d->model->fieldId (a_valueName);


  switch (HistoryModel::FieldId (fieldId))
    {

    case HistoryModel::FieldId::tx_status:     return tx_status();    break;
    case HistoryModel::FieldId::tx_hash:       return tx_hash();      break;
    case HistoryModel::FieldId::atom:          return atom();         break;
    case HistoryModel::FieldId::network:       return network();      break;
    case HistoryModel::FieldId::wallet_name:   return wallet_name();  break;
    case HistoryModel::FieldId::date:          return date();         break;
    case HistoryModel::FieldId::date_to_secs:  return date_to_secs(); break;
    case HistoryModel::FieldId::address:       return address();      break;
    case HistoryModel::FieldId::status:        return status();       break;
    case HistoryModel::FieldId::token:         return token();        break;
    case HistoryModel::FieldId::direction:     return direction();    break;
    case HistoryModel::FieldId::value:         return value();        break;
    case HistoryModel::FieldId::fee:           return fee();          break;
    case HistoryModel::FieldId::fee_token:     return fee_token();    break;

    case HistoryModel::FieldId::invalid:
     default:
      break;
    }

  return QVariant();
}

ItemBridge &ItemBridge::operator =(const ItemBridge &a_src)
{
  if (this != &a_src)
    d = new Data (*a_src.d);
  return *this;
}

ItemBridge &ItemBridge::operator =(ItemBridge &&a_src)
{
  if (this != &a_src)
    {
      d = std::move (a_src.d);
      a_src.d = nullptr;
    }
  return *this;
}

/*-----------------------------------------*/
