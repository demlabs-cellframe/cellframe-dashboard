#include "DapAbstractWalletList.h"


#include <QList>
#include <QMetaEnum>

/* DEFS */

struct ItemWalletListBridge::Data
{
    DapAbstractWalletList *model;
    DapAbstractWalletList::Item *item;
    QModelIndex begin, end;

    Data (DapAbstractWalletList *a_model, DapAbstractWalletList::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

//QMap<QString, QVariant> v;

static const QHash<QString, DapAbstractWalletList::DapAbstractWalletList::FieldId> s_fieldIdMap =
{
    {"name",   DapAbstractWalletList::FieldId::name},
    {"statusProtect", DapAbstractWalletList::FieldId::statusProtect}
};

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static DapAbstractWalletList::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

DapAbstractWalletList::DapAbstractWalletList (QObject *a_parent)
  : QAbstractTableModel (a_parent)
  , m_items (new QList<DapAbstractWalletList::Item>())
{
  //qmlRegisterType<UserModel::Item> ("com.dap.model.UserModelItem", 1, 0, "UserModelItem");
  connect (this, &DapAbstractWalletList::sigSizeChanged,
           this, [this]
  {
    emit sizeChanged();
  });
}

DapAbstractWalletList::DapAbstractWalletList (const DapAbstractWalletList &a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<DapAbstractWalletList::Item>())
{
  operator= (a_src);
}

DapAbstractWalletList::DapAbstractWalletList (DapAbstractWalletList &&a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<DapAbstractWalletList::Item>())
{
  operator= (a_src);
}

DapAbstractWalletList::~DapAbstractWalletList()
{
  delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int DapAbstractWalletList::rowCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return m_items->size();
}

int DapAbstractWalletList::columnCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return s_fieldIdMap.size();
}

QVariant DapAbstractWalletList::data (const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  auto field        = DapAbstractWalletList::FieldId (role);
  const auto &item  = m_items->at (index.row());
  return _getValue (item, int (field));
}

QHash<int, QByteArray> DapAbstractWalletList::roleNames() const
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

DapAbstractWalletList *DapAbstractWalletList::global()
{
  static DapAbstractWalletList DapAbstractWalletList;
  return &DapAbstractWalletList;
}

int DapAbstractWalletList::add (const DapAbstractWalletList::Item &a_item)
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

void DapAbstractWalletList::insert (int a_index, const DapAbstractWalletList::Item &a_item)
{
  beginInsertRows (QModelIndex(), a_index, a_index);

  {
    m_items->insert (a_index, a_item);
    emit sigItemAdded (a_index);
    emit sigSizeChanged (size());
  }

  endInsertRows();

}

void DapAbstractWalletList::remove (int a_index)
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

int DapAbstractWalletList::indexOf (const DapAbstractWalletList::Item &a_item) const
{
  int index = 0;

  for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
    if (i->name == a_item.name)
      return index;

  return -1;
}

const DapAbstractWalletList::Item &DapAbstractWalletList::at (int a_index) const
{
    return const_cast<DapAbstractWalletList *> (this)->_get (a_index);
}

DapAbstractWalletList::Item DapAbstractWalletList::value (int a_index) const
{
  return at (a_index);
}

int DapAbstractWalletList::size() const
{
  return m_items->size();
}

bool DapAbstractWalletList::isEmpty() const
{
  return 0 == m_items->size();
}

void DapAbstractWalletList::clear()
{
  beginResetModel();

  {
    m_items->clear();
    emit sigSizeChanged (size());
  }

  endResetModel();
}

QVariant DapAbstractWalletList::get (int a_index)
{
//  ItemWalletListBridge item (new ItemWalletListBridge::Data (this, &_get (a_index)));
//  return QVariant::fromValue (item);
  return QVariant::fromValue (new ItemWalletListBridge (new ItemWalletListBridge::Data (this, &_get (a_index))));
}

const QVariant DapAbstractWalletList::get(int a_index) const
{
  return const_cast<DapAbstractWalletList*>(this)->get (a_index);
}

DapAbstractWalletList::Item &DapAbstractWalletList::_get(int a_index)
{
  static DapAbstractWalletList::Item dummy;

  if (a_index < 0 || a_index >= m_items->size())
    {
      dummy = _dummy();
      return dummy;
    }

  return (*m_items) [a_index];
}

const DapAbstractWalletList::Item &DapAbstractWalletList::_get(int a_index) const
{
  return const_cast<DapAbstractWalletList*>(this)->_get (a_index);
}

void DapAbstractWalletList::set (int a_index, const DapAbstractWalletList::Item &a_item)
{
  if (a_index < 0 || a_index >= m_items->size())
    return;
  _get (a_index) = a_item;
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapAbstractWalletList::set (int a_index, DapAbstractWalletList::Item &&a_item)
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

int DapAbstractWalletList::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapAbstractWalletList::FieldId::invalid));
}

const DapAbstractWalletList::Item &DapAbstractWalletList::getItem(int a_index) const
{
    static DapAbstractWalletList::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
      {
        dummy = _dummy();
        return dummy;
      }

    return (*m_items) [a_index];
}

DapAbstractWalletList::Iterator DapAbstractWalletList::begin()
{
  return m_items->begin();
}

DapAbstractWalletList::ConstIterator DapAbstractWalletList::cbegin() const
{
  return m_items->cbegin();
}

DapAbstractWalletList::Iterator DapAbstractWalletList::end()
{
  return m_items->end();
}

DapAbstractWalletList::ConstIterator DapAbstractWalletList::cend()
{
  return m_items->cend();
}

QVariant DapAbstractWalletList::_getValue (const DapAbstractWalletList::Item &a_item, int a_fieldId)
{
  switch (DapAbstractWalletList::FieldId (a_fieldId))
    {
    case DapAbstractWalletList::FieldId::invalid: break;

    case DapAbstractWalletList::FieldId::name              :  return a_item.name;
    case DapAbstractWalletList::FieldId::statusProtect     :  return a_item.statusProtect;
    }

  return QVariant();
}

void DapAbstractWalletList::_setValue (DapAbstractWalletList::Item &a_item, int a_fieldId, const QVariant &a_value)
{
  switch (DapAbstractWalletList::FieldId (a_fieldId))
    {
    case DapAbstractWalletList::FieldId::invalid: break;

    case DapAbstractWalletList::FieldId::name              :  a_item.name    = a_value.toString(); break;
    case DapAbstractWalletList::FieldId::statusProtect     :  a_item.statusProtect  = a_value.toString(); break;
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant DapAbstractWalletList::operator[] (int a_index)
{
  return get (a_index);
}

const QVariant DapAbstractWalletList::operator[] (int a_index) const
{
  return get (a_index);
}

DapAbstractWalletList &DapAbstractWalletList::operator= (const DapAbstractWalletList &a_src)
{
  *m_items  = *a_src.m_items;
  return *this;
}

DapAbstractWalletList &DapAbstractWalletList::operator= (DapAbstractWalletList &&a_src)
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

DapAbstractWalletList::Item _dummy()
{
  return DapAbstractWalletList::Item
  {
      QString(),
      QString()
  };
}

/********************************************
 * ITEM BRIDGE
 *******************************************/

ItemWalletListBridge::ItemWalletListBridge (ItemWalletListBridge::Data *a_data)
  : d (a_data)
{
  if (!d || !d->model)
    return;
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemWalletListBridge::nameChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemWalletListBridge::statusProtectChanged);
}

ItemWalletListBridge::ItemWalletListBridge (QObject *a_parent)
  : QObject (a_parent)
  , d (nullptr)
{

}

ItemWalletListBridge::ItemWalletListBridge (const ItemWalletListBridge &a_src)
{
  operator = (a_src);
}

ItemWalletListBridge::ItemWalletListBridge (ItemWalletListBridge &&a_src)
{
  operator = (std::move (a_src));
}

ItemWalletListBridge::~ItemWalletListBridge()
{
  delete d;
}

/* METHODS */

QString ItemWalletListBridge::name() const
{
  return (d && d->item) ? d->item->name : QString();
}

void ItemWalletListBridge::setName (const QString &name)
{
  if (!_beginSetValue())
    return;
  d->item->name = name;
  emit nameChanged();
  _endSetValue();
}

QString ItemWalletListBridge::statusProtect() const
{
  return (d && d->item) ? d->item->statusProtect : QString();
}

void ItemWalletListBridge::setStatusProtect (const QString &statusProtect)
{
  if (!_beginSetValue())
    return;
  d->item->statusProtect = statusProtect;
  emit statusProtectChanged();
  _endSetValue();
}

bool ItemWalletListBridge::_beginSetValue()
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

void ItemWalletListBridge::_endSetValue()
{
  emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemWalletListBridge::operator[] (const QString &a_valueName)
{
  if (!d || !d->model || !d->item)
    return QVariant();

  int fieldId = d->model->fieldId (a_valueName);


  switch (DapAbstractWalletList::FieldId (fieldId))
    {
    case DapAbstractWalletList::FieldId::name             :  return name(); break;
    case DapAbstractWalletList::FieldId::statusProtect    :  return statusProtect(); break;

    case DapAbstractWalletList::FieldId::invalid:
     default:
      break;
    }

  return QVariant();
}

ItemWalletListBridge &ItemWalletListBridge::operator =(const ItemWalletListBridge &a_src)
{
  if (this != &a_src)
    d = new Data (*a_src.d);
  return *this;
}

ItemWalletListBridge &ItemWalletListBridge::operator =(ItemWalletListBridge &&a_src)
{
  if (this != &a_src)
    {
      d = std::move (a_src.d);
      a_src.d = nullptr;
    }
  return *this;
}

/*-----------------------------------------*/
