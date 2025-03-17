#include "logmodel.h"

#include <QList>
#include <QMetaEnum>

/* DEFS */

struct LogBridge::Data
{
    LogModel *model;
    LogModel::Item *item;
    QModelIndex begin, end;

    Data (LogModel *a_model, LogModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

static const QHash<QString, LogModel::LogModel::FieldId> s_fieldIdMap =
{
    {"type", LogModel::FieldId::type},
    {"info", LogModel::FieldId::info},
    {"file", LogModel::FieldId::file},
    {"time", LogModel::FieldId::time},
    {"date", LogModel::FieldId::date},
//////////////////////////////////
};

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static LogModel::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

LogModel::LogModel (QObject *a_parent)
  : QAbstractTableModel (a_parent)
  , m_items (new QList<LogModel::Item>())
{
  //qmlRegisterType<UserModel::Item> ("com.dap.model.UserModelItem", 1, 0, "UserModelItem");
  connect (this, &LogModel::sigSizeChanged,
           this, [this]
  {
    emit sizeChanged();
  });
}

LogModel::LogModel (const LogModel &a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<LogModel::Item>())
{
  operator= (a_src);
}

LogModel::LogModel (LogModel &&a_src)
  : QAbstractTableModel (a_src.parent())
  , m_items (new QList<LogModel::Item>())
{
  operator= (a_src);
}

LogModel::~LogModel()
{
  delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int LogModel::rowCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return m_items->size();
}

int LogModel::columnCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return s_fieldIdMap.size();
}

QVariant LogModel::data (const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  auto field        = LogModel::FieldId (role);
  const auto &item  = m_items->at (index.row());
  return _getValue (item, int (field));
}

QHash<int, QByteArray> LogModel::roleNames() const
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

LogModel *LogModel::global()
{
  static LogModel model;
  return &model;
}

int LogModel::add (const LogModel::Item &a_item)
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

void LogModel::insert (int a_index, const LogModel::Item &a_item)
{
  beginInsertRows (QModelIndex(), a_index, a_index);

  {
    m_items->insert (a_index, a_item);
    emit sigItemAdded (a_index);
    emit sigSizeChanged (size());
  }

  endInsertRows();

}

void LogModel::remove (int a_index)
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

int LogModel::indexOf (const LogModel::Item &a_item) const
{
  int index = 0;

  for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
    if (i->type == a_item.type &&
        i->info == a_item.info &&
        i->file == a_item.file &&
        i->time == a_item.time &&
        i->date == a_item.date)
      return index;
  //////////////////////////////////

  return -1;
}

/*int TokenPairModel::indexOfTime(qint64 time) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
      if (i->system_time_update_unix < time)
        return index;

    return index;
}*/

const LogModel::Item &LogModel::at (int a_index) const
{
    return const_cast<LogModel *> (this)->_get (a_index);
}

LogModel::Item LogModel::value (int a_index) const
{
  return at (a_index);
}

int LogModel::size() const
{
  return m_items->size();
}

bool LogModel::isEmpty() const
{
  return 0 == m_items->size();
}

void LogModel::clear()
{
  beginResetModel();

  {
    m_items->clear();
    emit sigSizeChanged (size());
  }

  endResetModel();
}

QVariant LogModel::get (int a_index)
{
  return QVariant::fromValue (
              new LogBridge
              (new LogBridge::Data (this, &_get (a_index))));
}

const QVariant LogModel::get(int a_index) const
{
  return const_cast<LogModel*>(this)->get (a_index);
}

LogModel::Item &LogModel::_get(int a_index)
{
  static LogModel::Item dummy;

  if (a_index < 0 || a_index >= m_items->size())
    {
      dummy = _dummy();
      return dummy;
    }

  return (*m_items) [a_index];
}

const LogModel::Item &LogModel::_get(int a_index) const
{
  return const_cast<LogModel*>(this)->_get (a_index);
}

void LogModel::set (int a_index, const LogModel::Item &a_item)
{
  if (a_index < 0 || a_index >= m_items->size())
    return;
  _get (a_index) = a_item;
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void LogModel::set (int a_index, LogModel::Item &&a_item)
{
  if (a_index < 0 || a_index >= m_items->size())
    return;
  _get (a_index) = std::move (a_item);
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int LogModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, LogModel::FieldId::invalid));
}

const LogModel::Item &LogModel::getItem(int a_index) const
{
    static LogModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
      {
        dummy = _dummy();
        return dummy;
      }

    return (*m_items) [a_index];
}

LogModel::Iterator LogModel::begin()
{
  return m_items->begin();
}

LogModel::ConstIterator LogModel::cbegin() const
{
  return m_items->cbegin();
}

LogModel::Iterator LogModel::end()
{
  return m_items->end();
}

LogModel::ConstIterator LogModel::cend()
{
  return m_items->cend();
}

QVariant LogModel::_getValue (const LogModel::Item &a_item, int a_fieldId)
{
  switch (LogModel::FieldId (a_fieldId))
    {
      case LogModel::FieldId::invalid:
          break;
      case LogModel::FieldId::type:
          return a_item.type;
      case LogModel::FieldId::info:
          return a_item.info;
      case LogModel::FieldId::file:
          return a_item.file;
      case LogModel::FieldId::time:
          return a_item.time;
      case LogModel::FieldId::date:
          return a_item.date;
//////////////////////////////////
    }

  return QVariant();
}

void LogModel::_setValue (LogModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
  switch (LogModel::FieldId (a_fieldId))
    {
      case LogModel::FieldId::invalid:
          break;
      case LogModel::FieldId::type:
          a_item.type = a_value.toString();
          break;
      case LogModel::FieldId::info:
          a_item.info = a_value.toString();
          break;
      case LogModel::FieldId::file:
          a_item.file = a_value.toString();
          break;
      case LogModel::FieldId::time:
          a_item.time = a_value.toString();
          break;
      case LogModel::FieldId::date:
          a_item.date = a_value.toString();
          break;
//////////////////////////////////
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant LogModel::operator[] (int a_index)
{
  return get (a_index);
}

const QVariant LogModel::operator[] (int a_index) const
{
  return get (a_index);
}

LogModel &LogModel::operator= (const LogModel &a_src)
{
  *m_items  = *a_src.m_items;
  return *this;
}

LogModel &LogModel::operator= (LogModel &&a_src)
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

LogModel::Item _dummy()
{
  return LogModel::Item
  {
      QString(),
      QString(),
      QString(),
      QString(),
      QString()
//////////////////////////////////
  };
}

/********************************************
 * ITEM BRIDGE
 *******************************************/

LogBridge::LogBridge (LogBridge::Data *a_data)
  : d (a_data)
{
  if (!d || !d->model)
    return;

  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &LogBridge::typeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &LogBridge::infoChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &LogBridge::fileChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &LogBridge::timeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged,
           this, &LogBridge::dateChanged);
//////////////////////////////////
}

LogBridge::LogBridge (QObject *a_parent)
  : QObject (a_parent)
  , d (nullptr)
{

}

LogBridge::LogBridge (const LogBridge &a_src)
{
  operator = (a_src);
}

LogBridge::LogBridge (LogBridge &&a_src)
{
  operator = (std::move (a_src));
}

LogBridge::~LogBridge()
{
    delete d;
}

/* METHODS */

QString LogBridge::type() const
{
    return (d && d->item) ? d->item->type : QString();
}

void LogBridge::setType(const QString &value)
{
    if (!_beginSetValue())
      return;
    d->item->type = value;
    emit typeChanged();
    _endSetValue();
}

QString LogBridge::info() const
{
    return (d && d->item) ? d->item->info : QString();
}

void LogBridge::setInfo(const QString &value)
{
    if (!_beginSetValue())
      return;
    d->item->info = value;
    emit infoChanged();
    _endSetValue();
}

QString LogBridge::file() const
{
    return (d && d->item) ? d->item->file : QString();
}

void LogBridge::setFile(const QString &value)
{
    if (!_beginSetValue())
      return;
    d->item->file = value;
    emit fileChanged();
    _endSetValue();
}

QString LogBridge::time() const
{
    return (d && d->item) ? d->item->time : QString();
}

void LogBridge::setTime(const QString &value)
{
    if (!_beginSetValue())
      return;
    d->item->time = value;
    emit timeChanged();
    _endSetValue();
}

QString LogBridge::date() const
{
    return (d && d->item) ? d->item->date : QString();
}

void LogBridge::setDate(const QString &value)
{
    if (!_beginSetValue())
      return;
    d->item->date = value;
    emit dateChanged();
    _endSetValue();
}

//////////////////////////////////

bool LogBridge::_beginSetValue()
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

void LogBridge::_endSetValue()
{
  emit d->model->dataChanged (d->begin, d->end);
}

QVariant LogBridge::operator[] (const QString &a_valueName)
{
  if (!d || !d->model || !d->item)
    return QVariant();

  int fieldId = d->model->fieldId (a_valueName);


  switch (LogModel::FieldId (fieldId))
    {
      case LogModel::FieldId::type:
          return type();
          break;
      case LogModel::FieldId::info:
          return info();
          break;
      case LogModel::FieldId::file:
          return file();
          break;
      case LogModel::FieldId::time:
          return time();
          break;
      case LogModel::FieldId::date:
          return date();
          break;
//////////////////////////////////

      case LogModel::FieldId::invalid:
      default:
          break;
    }

  return QVariant();
}

LogBridge &LogBridge::operator =(const LogBridge &a_src)
{
  if (this != &a_src)
    d = new Data (*a_src.d);
  return *this;
}

LogBridge &LogBridge::operator =(LogBridge &&a_src)
{
  if (this != &a_src)
    {
      d = std::move (a_src.d);
      a_src.d = nullptr;
    }
  return *this;
}
