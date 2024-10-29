#include "DapAbstractDiagnosticModel.h"

#include <QList>
#include <QMetaEnum>

/* DEFS */

struct ItemDiagnosticBridge::Data
{
    DapAbstractDiagnosticModel *model;
    DapAbstractDiagnosticModel::Item *item;
    QModelIndex begin, end;

    Data (DapAbstractDiagnosticModel *a_model, DapAbstractDiagnosticModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

//QMap<QString, QVariant> v;

static const QHash<QString, DapAbstractDiagnosticModel::DapAbstractDiagnosticModel::FieldId> s_fieldIdMap =
{
    {"proc_DB_size",               DapAbstractDiagnosticModel::FieldId::proc_DB_size},
    {"proc_chain_size",            DapAbstractDiagnosticModel::FieldId::proc_chain_size},
    {"proc_log_size",              DapAbstractDiagnosticModel::FieldId::proc_log_size},
    {"proc_memory_use",            DapAbstractDiagnosticModel::FieldId::proc_memory_use},
    {"proc_memory_use_value",      DapAbstractDiagnosticModel::FieldId::proc_memory_use_value},
    {"proc_name",                  DapAbstractDiagnosticModel::FieldId::proc_name},
    {"proc_status",                DapAbstractDiagnosticModel::FieldId::proc_status},
    {"proc_uptime",                DapAbstractDiagnosticModel::FieldId::proc_uptime},
    {"proc_version",               DapAbstractDiagnosticModel::FieldId::proc_version},

    {"system_CPU_load",            DapAbstractDiagnosticModel::FieldId::system_CPU_load},
    {"system_memory_free",         DapAbstractDiagnosticModel::FieldId::system_memory_free},
    {"system_memory_load",         DapAbstractDiagnosticModel::FieldId::system_memory_load},
    {"system_memory_total",        DapAbstractDiagnosticModel::FieldId::system_memory_total},
    {"system_memory_total_value",  DapAbstractDiagnosticModel::FieldId::system_memory_total_value},
    {"system_mac",                 DapAbstractDiagnosticModel::FieldId::system_mac},
    {"system_time_update",         DapAbstractDiagnosticModel::FieldId::system_time_update},
    {"system_time_update_unix",    DapAbstractDiagnosticModel::FieldId::system_time_update_unix},
    {"system_uptime",              DapAbstractDiagnosticModel::FieldId::system_uptime},
    {"system_uptime_dashboard",    DapAbstractDiagnosticModel::FieldId::system_uptime_dashboard},
    {"system_node_name",           DapAbstractDiagnosticModel::FieldId::system_node_name}
};

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static DapAbstractDiagnosticModel::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

DapAbstractDiagnosticModel::DapAbstractDiagnosticModel (QObject *a_parent)
  : QAbstractTableModel (a_parent)
  , m_items (new QList<DapAbstractDiagnosticModel::Item>())
{
  //qmlRegisterType<UserModel::Item> ("com.dap.model.UserModelItem", 1, 0, "UserModelItem");
  connect (this, &DapAbstractDiagnosticModel::sigSizeChanged,
           this, [this]
  {
    emit sizeChanged();
  });
}

DapAbstractDiagnosticModel::DapAbstractDiagnosticModel (const DapAbstractDiagnosticModel &a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<DapAbstractDiagnosticModel::Item>())
{
  operator= (a_src);
}

DapAbstractDiagnosticModel::DapAbstractDiagnosticModel (DapAbstractDiagnosticModel &&a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<DapAbstractDiagnosticModel::Item>())
{
  operator= (a_src);
}

DapAbstractDiagnosticModel::~DapAbstractDiagnosticModel()
{
  delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int DapAbstractDiagnosticModel::rowCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return m_items->size();
}

int DapAbstractDiagnosticModel::columnCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return s_fieldIdMap.size();
}

QVariant DapAbstractDiagnosticModel::data (const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  auto field        = DapAbstractDiagnosticModel::FieldId (role);
  const auto &item  = m_items->at (index.row());
  return _getValue (item, int (field));
}

QHash<int, QByteArray> DapAbstractDiagnosticModel::roleNames() const
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

DapAbstractDiagnosticModel *DapAbstractDiagnosticModel::global()
{
  static DapAbstractDiagnosticModel DapAbstractDiagnosticModel;
  return &DapAbstractDiagnosticModel;
}

int DapAbstractDiagnosticModel::add (const DapAbstractDiagnosticModel::Item &a_item)
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

void DapAbstractDiagnosticModel::insert (int a_index, const DapAbstractDiagnosticModel::Item &a_item)
{
  beginInsertRows (QModelIndex(), a_index, a_index);

  {
    m_items->insert (a_index, a_item);
    emit sigItemAdded (a_index);
    emit sigSizeChanged (size());
  }

  endInsertRows();

}

void DapAbstractDiagnosticModel::remove (int a_index)
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

int DapAbstractDiagnosticModel::indexOf (const DapAbstractDiagnosticModel::Item &a_item) const
{
  int index = 0;

  for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
    if (i->system_mac == a_item.system_mac)
      return index;

  return -1;
}

int DapAbstractDiagnosticModel::indexOfTime(qint64 time) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
      if (i->system_time_update_unix < time)
        return index;

    return index;
}

const DapAbstractDiagnosticModel::Item &DapAbstractDiagnosticModel::at (int a_index) const
{
    return const_cast<DapAbstractDiagnosticModel *> (this)->_get (a_index);
}

DapAbstractDiagnosticModel::Item DapAbstractDiagnosticModel::value (int a_index) const
{
  return at (a_index);
}

int DapAbstractDiagnosticModel::size() const
{
  return m_items->size();
}

bool DapAbstractDiagnosticModel::isEmpty() const
{
  return 0 == m_items->size();
}

void DapAbstractDiagnosticModel::clear()
{
  beginResetModel();

  {
    m_items->clear();
    emit sigSizeChanged (size());
  }

  endResetModel();
}

QVariant DapAbstractDiagnosticModel::get (int a_index)
{
//  ItemDiagnosticBridge item (new ItemDiagnosticBridge::Data (this, &_get (a_index)));
//  return QVariant::fromValue (item);
  return QVariant::fromValue (new ItemDiagnosticBridge (new ItemDiagnosticBridge::Data (this, &_get (a_index))));
}

const QVariant DapAbstractDiagnosticModel::get(int a_index) const
{
  return const_cast<DapAbstractDiagnosticModel*>(this)->get (a_index);
}

DapAbstractDiagnosticModel::Item &DapAbstractDiagnosticModel::_get(int a_index)
{
  static DapAbstractDiagnosticModel::Item dummy;

  if (a_index < 0 || a_index >= m_items->size())
    {
      dummy = _dummy();
      return dummy;
    }

  return (*m_items) [a_index];
}

const DapAbstractDiagnosticModel::Item &DapAbstractDiagnosticModel::_get(int a_index) const
{
  return const_cast<DapAbstractDiagnosticModel*>(this)->_get (a_index);
}

void DapAbstractDiagnosticModel::set (int a_index, const DapAbstractDiagnosticModel::Item &a_item)
{
  if (a_index < 0 || a_index >= m_items->size())
    return;
  _get (a_index) = a_item;
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapAbstractDiagnosticModel::set (int a_index, DapAbstractDiagnosticModel::Item &&a_item)
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

int DapAbstractDiagnosticModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapAbstractDiagnosticModel::FieldId::invalid));
}

const DapAbstractDiagnosticModel::Item &DapAbstractDiagnosticModel::getItem(int a_index) const
{
    static DapAbstractDiagnosticModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
      {
        dummy = _dummy();
        return dummy;
      }

    return (*m_items) [a_index];
}

DapAbstractDiagnosticModel::Iterator DapAbstractDiagnosticModel::begin()
{
  return m_items->begin();
}

DapAbstractDiagnosticModel::ConstIterator DapAbstractDiagnosticModel::cbegin() const
{
  return m_items->cbegin();
}

DapAbstractDiagnosticModel::Iterator DapAbstractDiagnosticModel::end()
{
  return m_items->end();
}

DapAbstractDiagnosticModel::ConstIterator DapAbstractDiagnosticModel::cend()
{
  return m_items->cend();
}

QVariant DapAbstractDiagnosticModel::_getValue (const DapAbstractDiagnosticModel::Item &a_item, int a_fieldId)
{
  switch (DapAbstractDiagnosticModel::FieldId (a_fieldId))
    {
    case DapAbstractDiagnosticModel::FieldId::invalid: break;

    case DapAbstractDiagnosticModel::FieldId::proc_DB_size              :  return a_item.proc_DB_size;
    case DapAbstractDiagnosticModel::FieldId::proc_chain_size           :  return a_item.proc_chain_size;
    case DapAbstractDiagnosticModel::FieldId::proc_log_size             :  return a_item.proc_log_size;
    case DapAbstractDiagnosticModel::FieldId::proc_memory_use           :  return a_item.proc_memory_use;
    case DapAbstractDiagnosticModel::FieldId::proc_memory_use_value     :  return a_item.proc_memory_use_value;
    case DapAbstractDiagnosticModel::FieldId::proc_name                 :  return a_item.proc_name;
    case DapAbstractDiagnosticModel::FieldId::proc_status               :  return a_item.proc_status;
    case DapAbstractDiagnosticModel::FieldId::proc_uptime               :  return a_item.proc_uptime;
    case DapAbstractDiagnosticModel::FieldId::proc_version              :  return a_item.proc_version;
    case DapAbstractDiagnosticModel::FieldId::system_CPU_load           :  return a_item.system_CPU_load;
    case DapAbstractDiagnosticModel::FieldId::system_memory_free        :  return a_item.system_memory_free;
    case DapAbstractDiagnosticModel::FieldId::system_memory_load        :  return a_item.system_memory_load;
    case DapAbstractDiagnosticModel::FieldId::system_memory_total       :  return a_item.system_memory_total;
    case DapAbstractDiagnosticModel::FieldId::system_memory_total_value :  return a_item.system_memory_total_value;
    case DapAbstractDiagnosticModel::FieldId::system_mac                :  return a_item.system_mac;
    case DapAbstractDiagnosticModel::FieldId::system_time_update        :  return a_item.system_time_update;
    case DapAbstractDiagnosticModel::FieldId::system_time_update_unix   :  return a_item.system_time_update_unix;
    case DapAbstractDiagnosticModel::FieldId::system_uptime             :  return a_item.system_uptime;
    case DapAbstractDiagnosticModel::FieldId::system_uptime_dashboard   :  return a_item.system_uptime_dashboard;
    case DapAbstractDiagnosticModel::FieldId::system_node_name          :  return a_item.system_node_name;
    }

  return QVariant();
}

void DapAbstractDiagnosticModel::_setValue (DapAbstractDiagnosticModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
  switch (DapAbstractDiagnosticModel::FieldId (a_fieldId))
    {
    case DapAbstractDiagnosticModel::FieldId::invalid: break;

    case DapAbstractDiagnosticModel::FieldId::proc_DB_size              :  a_item.proc_DB_size              = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_chain_size           :  a_item.proc_chain_size           = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_log_size             :  a_item.proc_log_size             = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_memory_use           :  a_item.proc_memory_use           = a_value.toInt(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_memory_use_value     :  a_item.proc_memory_use_value     = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_name                 :  a_item.proc_name                 = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_status               :  a_item.proc_status               = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_uptime               :  a_item.proc_uptime               = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_version              :  a_item.proc_version              = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::system_CPU_load           :  a_item.system_CPU_load           = a_value.toInt(); break;
    case DapAbstractDiagnosticModel::FieldId::system_memory_free        :  a_item.system_memory_free        = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::system_memory_load        :  a_item.system_memory_load        = a_value.toInt(); break;
    case DapAbstractDiagnosticModel::FieldId::system_memory_total       :  a_item.system_memory_total       = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::system_memory_total_value :  a_item.system_memory_total_value = a_value.toInt(); break;
    case DapAbstractDiagnosticModel::FieldId::system_mac                :  a_item.system_mac                = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::system_time_update        :  a_item.system_time_update        = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::system_time_update_unix   :  a_item.system_time_update_unix   = a_value.toString().toLong(); break;
    case DapAbstractDiagnosticModel::FieldId::system_uptime             :  a_item.system_uptime             = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::system_uptime_dashboard   :  a_item.system_uptime_dashboard   = a_value.toString(); break;
    case DapAbstractDiagnosticModel::FieldId::system_node_name          :  a_item.system_node_name          = a_value.toString(); break;
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant DapAbstractDiagnosticModel::operator[] (int a_index)
{
  return get (a_index);
}

const QVariant DapAbstractDiagnosticModel::operator[] (int a_index) const
{
  return get (a_index);
}

DapAbstractDiagnosticModel &DapAbstractDiagnosticModel::operator= (const DapAbstractDiagnosticModel &a_src)
{
  *m_items  = *a_src.m_items;
  return *this;
}

DapAbstractDiagnosticModel &DapAbstractDiagnosticModel::operator= (DapAbstractDiagnosticModel &&a_src)
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

DapAbstractDiagnosticModel::Item _dummy()
{
  return DapAbstractDiagnosticModel::Item
  {
      QString(),
      QString(),
      QString(),
      0,
      QString(),
      QString(),
      QString(),
      QString(),
      QString(),
      0,
      QString(),
      0,
      QString(),
      0,
      QString(),
      QString(),
      0,
      QString(),
      QString(),
      QString()
  };
}

/********************************************
 * ITEM BRIDGE
 *******************************************/

ItemDiagnosticBridge::ItemDiagnosticBridge (ItemDiagnosticBridge::Data *a_data)
  : d (a_data)
{
  if (!d || !d->model)
    return;
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_DB_sizeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_chain_sizeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_log_sizeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_memory_useChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_memory_use_valueChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_nameChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_statusChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_uptimeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::proc_versionChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_CPU_loadChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_memory_freeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_memory_loadChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_memory_totalChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &::ItemDiagnosticBridge::system_memory_total_valueChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_macChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_time_updateChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_time_update_unixChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_uptimeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_uptime_dashboardChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemDiagnosticBridge::system_node_nameChanged);

}

ItemDiagnosticBridge::ItemDiagnosticBridge (QObject *a_parent)
  : QObject (a_parent)
  , d (nullptr)
{

}

ItemDiagnosticBridge::ItemDiagnosticBridge (const ItemDiagnosticBridge &a_src)
{
  operator = (a_src);
}

ItemDiagnosticBridge::ItemDiagnosticBridge (ItemDiagnosticBridge &&a_src)
{
  operator = (std::move (a_src));
}

ItemDiagnosticBridge::~ItemDiagnosticBridge()
{
  delete d;
}

/* METHODS */

QString ItemDiagnosticBridge::proc_DB_size() const
{
  return (d && d->item) ? d->item->proc_DB_size : QString();
}

void ItemDiagnosticBridge::setProc_DB_size (const QString &proc_DB_size)
{
  if (!_beginSetValue())
    return;
  d->item->proc_DB_size = proc_DB_size;
  emit proc_DB_sizeChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::proc_chain_size() const
{
  return (d && d->item) ? d->item->proc_chain_size : QString();
}

void ItemDiagnosticBridge::setProc_chain_size (const QString &proc_chain_size)
{
  if (!_beginSetValue())
    return;
  d->item->proc_chain_size = proc_chain_size;
  emit proc_chain_sizeChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::proc_log_size() const
{
  return (d && d->item) ? d->item->proc_log_size : QString();
}

void ItemDiagnosticBridge::setProc_log_size (const QString &proc_log_size)
{
  if (!_beginSetValue())
    return;
  d->item->proc_log_size = proc_log_size;
  emit proc_log_sizeChanged();
  _endSetValue();
}

int ItemDiagnosticBridge::proc_memory_use() const
{
  return (d && d->item) ? d->item->proc_memory_use : 0;
}

void ItemDiagnosticBridge::setProc_memory_use (const int &proc_memory_use)
{
  if (!_beginSetValue())
    return;
  d->item->proc_memory_use = proc_memory_use;
  emit proc_memory_useChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::proc_memory_use_value() const
{
  return (d && d->item) ? d->item->proc_memory_use_value : QString();
}

void ItemDiagnosticBridge::setProc_memory_use_value (const QString &proc_memory_use_value)
{
  if (!_beginSetValue())
    return;
  d->item->proc_memory_use_value = proc_memory_use_value;
  emit proc_memory_use_valueChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::proc_name() const
{
    return (d && d->item) ? d->item->proc_name : QString();
}

void ItemDiagnosticBridge::setProc_name (const QString &proc_name)
{
  if (!_beginSetValue())
    return;
  d->item->proc_name = proc_name;
  emit proc_nameChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::proc_status() const
{
  return (d && d->item) ? d->item->proc_status : QString();
}

void ItemDiagnosticBridge::setProc_status (QString proc_status)
{
  if (!_beginSetValue())
    return;
  d->item->proc_status = proc_status;
  emit proc_statusChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::proc_uptime() const
{
    return (d && d->item) ? d->item->proc_uptime : QString();
}

void ItemDiagnosticBridge::setProc_uptime (const QString &proc_uptime)
{
  if (!_beginSetValue())
    return;
  d->item->proc_uptime = proc_uptime;
  emit proc_uptimeChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::proc_version() const
{
  return (d && d->item) ? d->item->proc_version : QString();
}

void ItemDiagnosticBridge::setProc_version (const QString &proc_version)
{
  if (!_beginSetValue())
    return;
  d->item->proc_version = proc_version;
  emit proc_versionChanged();
  _endSetValue();
}

int ItemDiagnosticBridge::system_CPU_load() const
{
  return (d && d->item) ? d->item->system_CPU_load : 0;
}

void ItemDiagnosticBridge::setSystem_CPU_load (const int &system_CPU_load)
{
  if (!_beginSetValue())
    return;
  d->item->system_CPU_load   = system_CPU_load;
  emit system_CPU_loadChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::system_memory_free() const
{
  return (d && d->item) ? d->item->system_memory_free : QString();
}

void ItemDiagnosticBridge::setSystem_memory_free (const QString &system_memory_free)
{
  if (!_beginSetValue())
    return;
  d->item->system_memory_free   = system_memory_free;
  emit system_memory_freeChanged();
  _endSetValue();
}

int ItemDiagnosticBridge::system_memory_load() const
{
  return (d && d->item) ? d->item->system_memory_load : 0;
}

void ItemDiagnosticBridge::setSystem_memory_load (const int &system_memory_load)
{
  if (!_beginSetValue())
    return;
  d->item->system_memory_load   = system_memory_load;
  emit system_memory_loadChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::system_memory_total() const
{
  return (d && d->item) ? d->item->system_memory_total : QString();
}

void ItemDiagnosticBridge::setSystem_memory_total (const QString &system_memory_total)
{
  if (!_beginSetValue())
    return;
  d->item->system_memory_total   = system_memory_total;
  emit system_memory_totalChanged();
  _endSetValue();
}

int ItemDiagnosticBridge::system_memory_total_value() const
{
  return (d && d->item) ? d->item->system_memory_total_value : 0;
}

void ItemDiagnosticBridge::setSystem_memory_total_value (const int &system_memory_total_value)
{
  if (!_beginSetValue())
    return;
  d->item->system_memory_total_value   = system_memory_total_value;
  emit system_memory_total_valueChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::system_mac() const
{
  return (d && d->item) ? d->item->system_mac : QString();
}

void ItemDiagnosticBridge::setSystem_mac (const QString &system_mac)
{
  if (!_beginSetValue())
    return;
  d->item->system_mac   = system_mac;
  emit system_macChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::system_time_update() const
{
  return (d && d->item) ? d->item->system_time_update : QString();
}

void ItemDiagnosticBridge::setSystem_time_update (const QString &system_time_update)
{
  if (!_beginSetValue())
    return;
  d->item->system_time_update   = system_time_update;
  emit system_time_updateChanged();
  _endSetValue();
}

quint64 ItemDiagnosticBridge::system_time_update_unix() const
{
  return (d && d->item) ? d->item->system_time_update_unix : 0;
}

void ItemDiagnosticBridge::setSystem_time_update_unix (const quint64 &system_time_update_unix)
{
  if (!_beginSetValue())
    return;
  d->item->system_time_update_unix   = system_time_update_unix;
  emit system_time_update_unixChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::system_uptime() const
{
  return (d && d->item) ? d->item->system_uptime : QString();
}

void ItemDiagnosticBridge::setSystem_uptime (const QString &system_uptime)
{
  if (!_beginSetValue())
    return;
  d->item->system_uptime   = system_uptime;
  emit system_uptimeChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::system_uptime_dashboard() const
{
  return (d && d->item) ? d->item->system_uptime_dashboard : QString();
}

void ItemDiagnosticBridge::setSystem_uptime_dashboard (const QString &system_uptime_dashboard)
{
  if (!_beginSetValue())
    return;
  d->item->system_uptime_dashboard   = system_uptime_dashboard;
  emit system_uptime_dashboardChanged();
  _endSetValue();
}

QString ItemDiagnosticBridge::system_node_name() const
{
  return (d && d->item) ? d->item->system_node_name : QString();
}

void ItemDiagnosticBridge::setSystem_node_name (const QString &system_node_name)
{
  if (!_beginSetValue())
    return;
  d->item->system_node_name   = system_node_name;
  emit system_node_nameChanged();
  _endSetValue();
}

bool ItemDiagnosticBridge::_beginSetValue()
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

void ItemDiagnosticBridge::_endSetValue()
{
  emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemDiagnosticBridge::operator[] (const QString &a_valueName)
{
  if (!d || !d->model || !d->item)
    return QVariant();

  int fieldId = d->model->fieldId (a_valueName);


  switch (DapAbstractDiagnosticModel::FieldId (fieldId))
    {

    case DapAbstractDiagnosticModel::FieldId::proc_DB_size              :  return proc_DB_size(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_chain_size           :  return proc_chain_size(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_log_size             :  return proc_log_size(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_memory_use           :  return proc_memory_use(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_memory_use_value     :  return proc_memory_use_value(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_name                 :  return proc_name(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_status               :  return proc_status(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_uptime               :  return proc_uptime(); break;
    case DapAbstractDiagnosticModel::FieldId::proc_version              :  return proc_version(); break;
    case DapAbstractDiagnosticModel::FieldId::system_CPU_load           :  return system_CPU_load(); break;
    case DapAbstractDiagnosticModel::FieldId::system_memory_free        :  return system_memory_free(); break;
    case DapAbstractDiagnosticModel::FieldId::system_memory_load        :  return system_memory_load(); break;
    case DapAbstractDiagnosticModel::FieldId::system_memory_total       :  return system_memory_total(); break;
    case DapAbstractDiagnosticModel::FieldId::system_memory_total_value :  return system_memory_total_value(); break;
    case DapAbstractDiagnosticModel::FieldId::system_mac                :  return system_mac(); break;
    case DapAbstractDiagnosticModel::FieldId::system_time_update        :  return system_time_update(); break;
    case DapAbstractDiagnosticModel::FieldId::system_time_update_unix   :  return system_time_update_unix(); break;
    case DapAbstractDiagnosticModel::FieldId::system_uptime             :  return system_uptime(); break;
    case DapAbstractDiagnosticModel::FieldId::system_uptime_dashboard   :  return system_uptime_dashboard(); break;
    case DapAbstractDiagnosticModel::FieldId::system_node_name          :  return system_node_name(); break;

    case DapAbstractDiagnosticModel::FieldId::invalid:
     default:
      break;
    }

  return QVariant();
}

ItemDiagnosticBridge &ItemDiagnosticBridge::operator =(const ItemDiagnosticBridge &a_src)
{
  if (this != &a_src)
    d = new Data (*a_src.d);
  return *this;
}

ItemDiagnosticBridge &ItemDiagnosticBridge::operator =(ItemDiagnosticBridge &&a_src)
{
  if (this != &a_src)
    {
      d = std::move (a_src.d);
      a_src.d = nullptr;
    }
  return *this;
}

/*-----------------------------------------*/
