#include "DapStringListModel.h"

#include <QList>
#include <QMetaEnum>

struct ItemStringListBridge::Data
{
    DapStringListModel *model;
    DapStringListModel::Item *item;
    QModelIndex begin, end;

    Data (DapStringListModel *a_model, DapStringListModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapStringListModel::DapStringListModel::FieldId> s_fieldIdMap =
{
    {"name",      DapStringListModel::FieldId::name},
};

DapStringListModel::DapStringListModel (QObject *a_parent)
  : QAbstractTableModel (a_parent)
{
  connect (this, &DapStringListModel::sigSizeChanged,
           this, [this]
  {
    emit sizeChanged();
  });
}

DapStringListModel::DapStringListModel (const DapStringListModel &a_src)
  : QAbstractTableModel (a_src.parent())
{
  operator= (a_src);
}

DapStringListModel::DapStringListModel (DapStringListModel &&a_src)
  : QAbstractTableModel (a_src.parent())
{
  operator= (a_src);
}

DapStringListModel::~DapStringListModel()
{
}

int DapStringListModel::rowCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return m_items.size();
}

int DapStringListModel::columnCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return s_fieldIdMap.size();
}

QVariant DapStringListModel::data (const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  auto field        = DapStringListModel::FieldId (role);
  const auto &item  = m_items.at (index.row());
  return _getValue (item, int (field));
}

QHash<int, QByteArray> DapStringListModel::roleNames() const
{
  static QHash<int, QByteArray> names;

  if (names.isEmpty())
    for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
      names[int (i.value())] = i.key().toUtf8();

  return names;
}

void DapStringListModel::setStringList(const QStringList &list)
{
  beginResetModel();
  {
    m_items.clear();
    for(const auto& item: list)
    {
      DapStringListModel::Item tmpItem;
      tmpItem.name = item;
      m_items.append(std::move(tmpItem));
    }
  }
  endResetModel();
  emit dataChanged(index (0, 0), index (m_items.size(), 0));
  emit sizeChanged();
}

int DapStringListModel::indexOf (const DapStringListModel::Item &a_item) const
{
  int index = 0;

  for (auto i = m_items.cbegin(), e = m_items.cend(); i != e; i++, index++)
    if (i->name == a_item.name)
      return index;

  return -1;
}

const DapStringListModel::Item &DapStringListModel::at (int a_index) const
{
    return const_cast<DapStringListModel *> (this)->_get (a_index);
}

DapStringListModel::Item DapStringListModel::value (int a_index) const
{
  return at (a_index);
}

int DapStringListModel::size() const
{
  return m_items.size();
}

bool DapStringListModel::isEmpty() const
{
  return 0 == m_items.size();
}

void DapStringListModel::clear()
{
  beginResetModel();

  {
    m_items.clear();
    emit sigSizeChanged (size());
  }

  endResetModel();
}

QVariant DapStringListModel::get (int a_index)
{
  return QVariant::fromValue (new ItemStringListBridge (new ItemStringListBridge::Data (this, &_get (a_index))));
}

const QVariant DapStringListModel::get(int a_index) const
{
  return const_cast<DapStringListModel*>(this)->get (a_index);
}

DapStringListModel::Item &DapStringListModel::_get(int a_index)
{
  static DapStringListModel::Item dummy;

  if (a_index < 0 || a_index >= m_items.size())
    {
      dummy = DapStringListModel::Item();
      return dummy;
    }

  return m_items[a_index];
}

const DapStringListModel::Item &DapStringListModel::_get(int a_index) const
{
  return const_cast<DapStringListModel*>(this)->_get (a_index);
}

int DapStringListModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapStringListModel::FieldId::invalid));
}

const DapStringListModel::Item &DapStringListModel::getItem(int a_index) const
{
    static DapStringListModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
      {
        dummy = DapStringListModel::Item();
        return dummy;
      }

    return m_items[a_index];
}

DapStringListModel::Iterator DapStringListModel::begin()
{
  return m_items.begin();
}

DapStringListModel::ConstIterator DapStringListModel::cbegin() const
{
  return m_items.cbegin();
}

DapStringListModel::Iterator DapStringListModel::end()
{
  return m_items.end();
}

DapStringListModel::ConstIterator DapStringListModel::cend()
{
  return m_items.cend();
}

QVariant DapStringListModel::_getValue (const DapStringListModel::Item &a_item, int a_fieldId)
{
  switch (DapStringListModel::FieldId (a_fieldId))
    {
    case DapStringListModel::FieldId::invalid: break;

    case DapStringListModel::FieldId::name:      return a_item.name;
    }

  return QVariant();
}

QVariant DapStringListModel::operator[] (int a_index)
{
  return get (a_index);
}

const QVariant DapStringListModel::operator[] (int a_index) const
{
  return get (a_index);
}

DapStringListModel &DapStringListModel::operator= (const DapStringListModel &a_src)
{
  m_items  = a_src.m_items;
  return *this;
}

DapStringListModel &DapStringListModel::operator= (DapStringListModel &&a_src)
{
  if (this != &a_src)
    {
      m_items       = a_src.m_items;
    }
  return *this;
}

ItemStringListBridge::ItemStringListBridge (ItemStringListBridge::Data *a_data)
  : d (a_data)
{
  if (!d || !d->model)
    return;
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemStringListBridge::nameChanged);
}

ItemStringListBridge::ItemStringListBridge (QObject *a_parent)
  : QObject (a_parent)
  , d (nullptr)
{

}

ItemStringListBridge::ItemStringListBridge (const ItemStringListBridge &a_src)
    : QObject ()
{
  operator = (a_src);
}

ItemStringListBridge::ItemStringListBridge (ItemStringListBridge &&a_src)
    : QObject ()
{
  operator = (std::move (a_src));
}

ItemStringListBridge::~ItemStringListBridge()
{
  delete d;
}

QString ItemStringListBridge::name() const
{
  return (d && d->item) ? d->item->name : QString();
}

ItemStringListBridge &ItemStringListBridge::operator =(const ItemStringListBridge &a_src)
{
  if (this != &a_src)
    d = new Data (*a_src.d);
  return *this;
}

ItemStringListBridge &ItemStringListBridge::operator =(ItemStringListBridge &&a_src)
{
  if (this != &a_src)
    {
      d = std::move (a_src.d);
      a_src.d = nullptr;
    }
  return *this;
}
