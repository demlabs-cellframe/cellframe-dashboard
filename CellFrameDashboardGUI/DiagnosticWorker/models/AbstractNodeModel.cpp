#include "AbstractNodeModel.h"

#include <QList>
#include <QMetaEnum>

/* DEFS */

struct ItemNodeBridge::Data
{
    AbstractNodeModel *model;
    AbstractNodeModel::Item *item;
    QModelIndex begin, end;

    Data (AbstractNodeModel *a_model, AbstractNodeModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

//QMap<QString, QVariant> v;

static const QHash<QString, AbstractNodeModel::AbstractNodeModel::FieldId> s_fieldIdMap =
{
    {"proc_DB_size",               AbstractNodeModel::FieldId::proc_DB_size},
    {"proc_chain_size",            AbstractNodeModel::FieldId::proc_chain_size},
    {"proc_log_size",              AbstractNodeModel::FieldId::proc_log_size},
    {"proc_memory_use",            AbstractNodeModel::FieldId::proc_memory_use},
    {"proc_memory_use_value",      AbstractNodeModel::FieldId::proc_memory_use_value},
    {"proc_name",                  AbstractNodeModel::FieldId::proc_name},
    {"proc_status",                AbstractNodeModel::FieldId::proc_status},
    {"proc_uptime",                AbstractNodeModel::FieldId::proc_uptime},
    {"proc_version",               AbstractNodeModel::FieldId::proc_version},

    {"system_CPU_load",            AbstractNodeModel::FieldId::system_CPU_load},
    {"system_memory_free",         AbstractNodeModel::FieldId::system_memory_free},
    {"system_memory_load",         AbstractNodeModel::FieldId::system_memory_load},
    {"system_memory_total",        AbstractNodeModel::FieldId::system_memory_total},
    {"system_memory_total_value",  AbstractNodeModel::FieldId::system_memory_total_value},
    {"system_mac",                 AbstractNodeModel::FieldId::system_mac},
    {"system_time_update",         AbstractNodeModel::FieldId::system_time_update},
    {"system_time_update_unix",    AbstractNodeModel::FieldId::system_time_update_unix},
    {"system_uptime",              AbstractNodeModel::FieldId::system_uptime},
    {"system_uptime_dashboard",    AbstractNodeModel::FieldId::system_uptime_dashboard},
};

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static AbstractNodeModel::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

AbstractNodeModel::AbstractNodeModel (QObject *a_parent)
  : QAbstractTableModel (a_parent)
  , m_items (new QList<AbstractNodeModel::Item>())
{
  //qmlRegisterType<UserModel::Item> ("com.dap.model.UserModelItem", 1, 0, "UserModelItem");
  connect (this, &AbstractNodeModel::sigSizeChanged,
           this, [this]
  {
    emit sizeChanged();
  });
}

AbstractNodeModel::AbstractNodeModel (const AbstractNodeModel &a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<AbstractNodeModel::Item>())
{
  operator= (a_src);
}

AbstractNodeModel::AbstractNodeModel (AbstractNodeModel &&a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<AbstractNodeModel::Item>())
{
  operator= (a_src);
}

AbstractNodeModel::~AbstractNodeModel()
{
  delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int AbstractNodeModel::rowCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return m_items->size();
}

int AbstractNodeModel::columnCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return s_fieldIdMap.size();
}

QVariant AbstractNodeModel::data (const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  auto field        = AbstractNodeModel::FieldId (role);
  const auto &item  = m_items->at (index.row());
  return _getValue (item, int (field));
}

QHash<int, QByteArray> AbstractNodeModel::roleNames() const
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

AbstractNodeModel *AbstractNodeModel::global()
{
  static AbstractNodeModel AbstractNodeModel;
  return &AbstractNodeModel;
}

int AbstractNodeModel::add (const AbstractNodeModel::Item &a_item)
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

void AbstractNodeModel::insert (int a_index, const AbstractNodeModel::Item &a_item)
{
  beginInsertRows (QModelIndex(), a_index, a_index);

  {
    m_items->insert (a_index, a_item);
    emit sigItemAdded (a_index);
    emit sigSizeChanged (size());
  }

  endInsertRows();

}

void AbstractNodeModel::remove (int a_index)
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

int AbstractNodeModel::indexOf (const AbstractNodeModel::Item &a_item) const
{
  int index = 0;

  for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
    if (i->system_mac == a_item.system_mac)
      return index;

  return -1;
}

int AbstractNodeModel::indexOfTime(qint64 time) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
      if (i->system_time_update_unix < time)
        return index;

    return index;
}

const AbstractNodeModel::Item &AbstractNodeModel::at (int a_index) const
{
    return const_cast<AbstractNodeModel *> (this)->_get (a_index);
}

AbstractNodeModel::Item AbstractNodeModel::value (int a_index) const
{
  return at (a_index);
}

int AbstractNodeModel::size() const
{
  return m_items->size();
}

bool AbstractNodeModel::isEmpty() const
{
  return 0 == m_items->size();
}

void AbstractNodeModel::clear()
{
  beginResetModel();

  {
    m_items->clear();
    emit sigSizeChanged (size());
  }

  endResetModel();
}

QVariant AbstractNodeModel::get (int a_index)
{
//  ItemNodeBridge item (new ItemNodeBridge::Data (this, &_get (a_index)));
//  return QVariant::fromValue (item);
  return QVariant::fromValue (new ItemNodeBridge (new ItemNodeBridge::Data (this, &_get (a_index))));
}

const QVariant AbstractNodeModel::get(int a_index) const
{
  return const_cast<AbstractNodeModel*>(this)->get (a_index);
}

AbstractNodeModel::Item &AbstractNodeModel::_get(int a_index)
{
  static AbstractNodeModel::Item dummy;

  if (a_index < 0 || a_index >= m_items->size())
    {
      dummy = _dummy();
      return dummy;
    }

  return (*m_items) [a_index];
}

const AbstractNodeModel::Item &AbstractNodeModel::_get(int a_index) const
{
  return const_cast<AbstractNodeModel*>(this)->_get (a_index);
}

void AbstractNodeModel::set (int a_index, const AbstractNodeModel::Item &a_item)
{
  if (a_index < 0 || a_index >= m_items->size())
    return;
  _get (a_index) = a_item;
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void AbstractNodeModel::set (int a_index, AbstractNodeModel::Item &&a_item)
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

int AbstractNodeModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, AbstractNodeModel::FieldId::invalid));
}

const AbstractNodeModel::Item &AbstractNodeModel::getItem(int a_index) const
{
    static AbstractNodeModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
      {
        dummy = _dummy();
        return dummy;
      }

    return (*m_items) [a_index];
}

AbstractNodeModel::Iterator AbstractNodeModel::begin()
{
  return m_items->begin();
}

AbstractNodeModel::ConstIterator AbstractNodeModel::cbegin() const
{
  return m_items->cbegin();
}

AbstractNodeModel::Iterator AbstractNodeModel::end()
{
  return m_items->end();
}

AbstractNodeModel::ConstIterator AbstractNodeModel::cend()
{
  return m_items->cend();
}

QVariant AbstractNodeModel::_getValue (const AbstractNodeModel::Item &a_item, int a_fieldId)
{
  switch (AbstractNodeModel::FieldId (a_fieldId))
    {
    case AbstractNodeModel::FieldId::invalid: break;

    case AbstractNodeModel::FieldId::proc_DB_size              :  return a_item.proc_DB_size;
    case AbstractNodeModel::FieldId::proc_chain_size           :  return a_item.proc_chain_size;
    case AbstractNodeModel::FieldId::proc_log_size             :  return a_item.proc_log_size;
    case AbstractNodeModel::FieldId::proc_memory_use           :  return a_item.proc_memory_use;
    case AbstractNodeModel::FieldId::proc_memory_use_value     :  return a_item.proc_memory_use_value;
    case AbstractNodeModel::FieldId::proc_name                 :  return a_item.proc_name;
    case AbstractNodeModel::FieldId::proc_status               :  return a_item.proc_status;
    case AbstractNodeModel::FieldId::proc_uptime               :  return a_item.proc_uptime;
    case AbstractNodeModel::FieldId::proc_version              :  return a_item.proc_version;
    case AbstractNodeModel::FieldId::system_CPU_load           :  return a_item.system_CPU_load;
    case AbstractNodeModel::FieldId::system_memory_free        :  return a_item.system_memory_free;
    case AbstractNodeModel::FieldId::system_memory_load        :  return a_item.system_memory_load;
    case AbstractNodeModel::FieldId::system_memory_total       :  return a_item.system_memory_total;
    case AbstractNodeModel::FieldId::system_memory_total_value :  return a_item.system_memory_total_value;
    case AbstractNodeModel::FieldId::system_mac                :  return a_item.system_mac;
    case AbstractNodeModel::FieldId::system_time_update        :  return a_item.system_time_update;
    case AbstractNodeModel::FieldId::system_time_update_unix   :  return a_item.system_time_update_unix;
    case AbstractNodeModel::FieldId::system_uptime             :  return a_item.system_uptime;
    case AbstractNodeModel::FieldId::system_uptime_dashboard   :  return a_item.system_uptime_dashboard;
    }

  return QVariant();
}

void AbstractNodeModel::_setValue (AbstractNodeModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
  switch (AbstractNodeModel::FieldId (a_fieldId))
    {
    case AbstractNodeModel::FieldId::invalid: break;

    case AbstractNodeModel::FieldId::proc_DB_size              :  a_item.proc_DB_size              = a_value.toString(); break;
    case AbstractNodeModel::FieldId::proc_chain_size           :  a_item.proc_chain_size           = a_value.toString(); break;
    case AbstractNodeModel::FieldId::proc_log_size             :  a_item.proc_log_size             = a_value.toString(); break;
    case AbstractNodeModel::FieldId::proc_memory_use           :  a_item.proc_memory_use           = a_value.toInt(); break;
    case AbstractNodeModel::FieldId::proc_memory_use_value     :  a_item.proc_memory_use_value     = a_value.toString(); break;
    case AbstractNodeModel::FieldId::proc_name                 :  a_item.proc_name                 = a_value.toString(); break;
    case AbstractNodeModel::FieldId::proc_status               :  a_item.proc_status               = a_value.toString(); break;
    case AbstractNodeModel::FieldId::proc_uptime               :  a_item.proc_uptime               = a_value.toString(); break;
    case AbstractNodeModel::FieldId::proc_version              :  a_item.proc_version              = a_value.toString(); break;
    case AbstractNodeModel::FieldId::system_CPU_load           :  a_item.system_CPU_load           = a_value.toInt(); break;
    case AbstractNodeModel::FieldId::system_memory_free        :  a_item.system_memory_free        = a_value.toString(); break;
    case AbstractNodeModel::FieldId::system_memory_load        :  a_item.system_memory_load        = a_value.toInt(); break;
    case AbstractNodeModel::FieldId::system_memory_total       :  a_item.system_memory_total       = a_value.toString(); break;
    case AbstractNodeModel::FieldId::system_memory_total_value :  a_item.system_memory_total_value = a_value.toInt(); break;
    case AbstractNodeModel::FieldId::system_mac                :  a_item.system_mac                = a_value.toString(); break;
    case AbstractNodeModel::FieldId::system_time_update        :  a_item.system_time_update        = a_value.toString(); break;
    case AbstractNodeModel::FieldId::system_time_update_unix   :  a_item.system_time_update_unix   = a_value.toString().toLong(); break;
    case AbstractNodeModel::FieldId::system_uptime             :  a_item.system_uptime             = a_value.toString(); break;
    case AbstractNodeModel::FieldId::system_uptime_dashboard   :  a_item.system_uptime_dashboard   = a_value.toString(); break;
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant AbstractNodeModel::operator[] (int a_index)
{
  return get (a_index);
}

const QVariant AbstractNodeModel::operator[] (int a_index) const
{
  return get (a_index);
}

AbstractNodeModel &AbstractNodeModel::operator= (const AbstractNodeModel &a_src)
{
  *m_items  = *a_src.m_items;
  return *this;
}

AbstractNodeModel &AbstractNodeModel::operator= (AbstractNodeModel &&a_src)
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

AbstractNodeModel::Item _dummy()
{
  return AbstractNodeModel::Item
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
      QString()
  };
}

/********************************************
 * ITEM BRIDGE
 *******************************************/

ItemNodeBridge::ItemNodeBridge (ItemNodeBridge::Data *a_data)
  : d (a_data)
{
  if (!d || !d->model)
    return;
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_DB_sizeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_chain_sizeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_log_sizeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_memory_useChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_memory_use_valueChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_nameChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_statusChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_uptimeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::proc_versionChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_CPU_loadChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_memory_freeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_memory_loadChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_memory_totalChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &::ItemNodeBridge::system_memory_total_valueChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_macChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_time_updateChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_time_update_unixChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_uptimeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &ItemNodeBridge::system_uptime_dashboardChanged);

}

ItemNodeBridge::ItemNodeBridge (QObject *a_parent)
  : QObject (a_parent)
  , d (nullptr)
{

}

ItemNodeBridge::ItemNodeBridge (const ItemNodeBridge &a_src)
{
  operator = (a_src);
}

ItemNodeBridge::ItemNodeBridge (ItemNodeBridge &&a_src)
{
  operator = (std::move (a_src));
}

ItemNodeBridge::~ItemNodeBridge()
{
  delete d;
}

/* METHODS */

QString ItemNodeBridge::proc_DB_size() const
{
  return (d && d->item) ? d->item->proc_DB_size : QString();
}

void ItemNodeBridge::setProc_DB_size (const QString &proc_DB_size)
{
  if (!_beginSetValue())
    return;
  d->item->proc_DB_size = proc_DB_size;
  emit proc_DB_sizeChanged();
  _endSetValue();
}

QString ItemNodeBridge::proc_chain_size() const
{
  return (d && d->item) ? d->item->proc_chain_size : QString();
}

void ItemNodeBridge::setProc_chain_size (const QString &proc_chain_size)
{
  if (!_beginSetValue())
    return;
  d->item->proc_chain_size = proc_chain_size;
  emit proc_chain_sizeChanged();
  _endSetValue();
}

QString ItemNodeBridge::proc_log_size() const
{
  return (d && d->item) ? d->item->proc_log_size : QString();
}

void ItemNodeBridge::setProc_log_size (const QString &proc_log_size)
{
  if (!_beginSetValue())
    return;
  d->item->proc_log_size = proc_log_size;
  emit proc_log_sizeChanged();
  _endSetValue();
}

int ItemNodeBridge::proc_memory_use() const
{
  return (d && d->item) ? d->item->proc_memory_use : 0;
}

void ItemNodeBridge::setProc_memory_use (const int &proc_memory_use)
{
  if (!_beginSetValue())
    return;
  d->item->proc_memory_use = proc_memory_use;
  emit proc_memory_useChanged();
  _endSetValue();
}

QString ItemNodeBridge::proc_memory_use_value() const
{
  return (d && d->item) ? d->item->proc_memory_use_value : QString();
}

void ItemNodeBridge::setProc_memory_use_value (const QString &proc_memory_use_value)
{
  if (!_beginSetValue())
    return;
  d->item->proc_memory_use_value = proc_memory_use_value;
  emit proc_memory_use_valueChanged();
  _endSetValue();
}

QString ItemNodeBridge::proc_name() const
{
    return (d && d->item) ? d->item->proc_name : QString();
}

void ItemNodeBridge::setProc_name (const QString &proc_name)
{
  if (!_beginSetValue())
    return;
  d->item->proc_name = proc_name;
  emit proc_nameChanged();
  _endSetValue();
}

QString ItemNodeBridge::proc_status() const
{
  return (d && d->item) ? d->item->proc_status : QString();
}

void ItemNodeBridge::setProc_status (QString proc_status)
{
  if (!_beginSetValue())
    return;
  d->item->proc_status = proc_status;
  emit proc_statusChanged();
  _endSetValue();
}

QString ItemNodeBridge::proc_uptime() const
{
    return (d && d->item) ? d->item->proc_uptime : QString();
}

void ItemNodeBridge::setProc_uptime (const QString &proc_uptime)
{
  if (!_beginSetValue())
    return;
  d->item->proc_uptime = proc_uptime;
  emit proc_uptimeChanged();
  _endSetValue();
}

QString ItemNodeBridge::proc_version() const
{
  return (d && d->item) ? d->item->proc_version : QString();
}

void ItemNodeBridge::setProc_version (const QString &proc_version)
{
  if (!_beginSetValue())
    return;
  d->item->proc_version = proc_version;
  emit proc_versionChanged();
  _endSetValue();
}

int ItemNodeBridge::system_CPU_load() const
{
  return (d && d->item) ? d->item->system_CPU_load : 0;
}

void ItemNodeBridge::setSystem_CPU_load (const int &system_CPU_load)
{
  if (!_beginSetValue())
    return;
  d->item->system_CPU_load   = system_CPU_load;
  emit system_CPU_loadChanged();
  _endSetValue();
}

QString ItemNodeBridge::system_memory_free() const
{
  return (d && d->item) ? d->item->system_memory_free : QString();
}

void ItemNodeBridge::setSystem_memory_free (const QString &system_memory_free)
{
  if (!_beginSetValue())
    return;
  d->item->system_memory_free   = system_memory_free;
  emit system_memory_freeChanged();
  _endSetValue();
}

int ItemNodeBridge::system_memory_load() const
{
  return (d && d->item) ? d->item->system_memory_load : 0;
}

void ItemNodeBridge::setSystem_memory_load (const int &system_memory_load)
{
  if (!_beginSetValue())
    return;
  d->item->system_memory_load   = system_memory_load;
  emit system_memory_loadChanged();
  _endSetValue();
}

QString ItemNodeBridge::system_memory_total() const
{
  return (d && d->item) ? d->item->system_memory_total : QString();
}

void ItemNodeBridge::setSystem_memory_total (const QString &system_memory_total)
{
  if (!_beginSetValue())
    return;
  d->item->system_memory_total   = system_memory_total;
  emit system_memory_totalChanged();
  _endSetValue();
}

int ItemNodeBridge::system_memory_total_value() const
{
  return (d && d->item) ? d->item->system_memory_total_value : 0;
}

void ItemNodeBridge::setSystem_memory_total_value (const int &system_memory_total_value)
{
  if (!_beginSetValue())
    return;
  d->item->system_memory_total_value   = system_memory_total_value;
  emit system_memory_total_valueChanged();
  _endSetValue();
}

QString ItemNodeBridge::system_mac() const
{
  return (d && d->item) ? d->item->system_mac : QString();
}

void ItemNodeBridge::setSystem_mac (const QString &system_mac)
{
  if (!_beginSetValue())
    return;
  d->item->system_mac   = system_mac;
  emit system_macChanged();
  _endSetValue();
}

QString ItemNodeBridge::system_time_update() const
{
  return (d && d->item) ? d->item->system_time_update : QString();
}

void ItemNodeBridge::setSystem_time_update (const QString &system_time_update)
{
  if (!_beginSetValue())
    return;
  d->item->system_time_update   = system_time_update;
  emit system_time_updateChanged();
  _endSetValue();
}

quint64 ItemNodeBridge::system_time_update_unix() const
{
  return (d && d->item) ? d->item->system_time_update_unix : 0;
}

void ItemNodeBridge::setSystem_time_update_unix (const quint64 &system_time_update_unix)
{
  if (!_beginSetValue())
    return;
  d->item->system_time_update_unix   = system_time_update_unix;
  emit system_time_update_unixChanged();
  _endSetValue();
}

QString ItemNodeBridge::system_uptime() const
{
  return (d && d->item) ? d->item->system_uptime : QString();
}

void ItemNodeBridge::setSystem_uptime (const QString &system_uptime)
{
  if (!_beginSetValue())
    return;
  d->item->system_uptime   = system_uptime;
  emit system_uptimeChanged();
  _endSetValue();
}

QString ItemNodeBridge::system_uptime_dashboard() const
{
  return (d && d->item) ? d->item->system_uptime_dashboard : QString();
}

void ItemNodeBridge::setSystem_uptime_dashboard (const QString &system_uptime_dashboard)
{
  if (!_beginSetValue())
    return;
  d->item->system_uptime_dashboard   = system_uptime_dashboard;
  emit system_uptime_dashboardChanged();
  _endSetValue();
}

bool ItemNodeBridge::_beginSetValue()
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

void ItemNodeBridge::_endSetValue()
{
  emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemNodeBridge::operator[] (const QString &a_valueName)
{
  if (!d || !d->model || !d->item)
    return QVariant();

  int fieldId = d->model->fieldId (a_valueName);


  switch (AbstractNodeModel::FieldId (fieldId))
    {

    case AbstractNodeModel::FieldId::proc_DB_size              :  return proc_DB_size(); break;
    case AbstractNodeModel::FieldId::proc_chain_size           :  return proc_chain_size(); break;
    case AbstractNodeModel::FieldId::proc_log_size             :  return proc_log_size(); break;
    case AbstractNodeModel::FieldId::proc_memory_use           :  return proc_memory_use(); break;
    case AbstractNodeModel::FieldId::proc_memory_use_value     :  return proc_memory_use_value(); break;
    case AbstractNodeModel::FieldId::proc_name                 :  return proc_name(); break;
    case AbstractNodeModel::FieldId::proc_status               :  return proc_status(); break;
    case AbstractNodeModel::FieldId::proc_uptime               :  return proc_uptime(); break;
    case AbstractNodeModel::FieldId::proc_version              :  return proc_version(); break;
    case AbstractNodeModel::FieldId::system_CPU_load           :  return system_CPU_load(); break;
    case AbstractNodeModel::FieldId::system_memory_free        :  return system_memory_free(); break;
    case AbstractNodeModel::FieldId::system_memory_load        :  return system_memory_load(); break;
    case AbstractNodeModel::FieldId::system_memory_total       :  return system_memory_total(); break;
    case AbstractNodeModel::FieldId::system_memory_total_value :  return system_memory_total_value(); break;
    case AbstractNodeModel::FieldId::system_mac                :  return system_mac(); break;
    case AbstractNodeModel::FieldId::system_time_update        :  return system_time_update(); break;
    case AbstractNodeModel::FieldId::system_time_update_unix   :  return system_time_update_unix(); break;
    case AbstractNodeModel::FieldId::system_uptime             :  return system_uptime(); break;
    case AbstractNodeModel::FieldId::system_uptime_dashboard   :  return system_uptime_dashboard(); break;

    case AbstractNodeModel::FieldId::invalid:
     default:
      break;
    }

  return QVariant();
}

ItemNodeBridge &ItemNodeBridge::operator =(const ItemNodeBridge &a_src)
{
  if (this != &a_src)
    d = new Data (*a_src.d);
  return *this;
}

ItemNodeBridge &ItemNodeBridge::operator =(ItemNodeBridge &&a_src)
{
  if (this != &a_src)
    {
      d = std::move (a_src.d);
      a_src.d = nullptr;
    }
  return *this;
}

/*-----------------------------------------*/
