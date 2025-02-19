#include "DapTokenPairModel.h"

#include <QList>
#include <QMetaEnum>

struct ItemTokenPairBridge::Data
{
    DapTokenPairModel *model;
    DapTokenPairModel::Item *item;
    QModelIndex begin, end;

    Data (DapTokenPairModel *a_model, DapTokenPairModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapTokenPairModel::DapTokenPairModel::FieldId> s_fieldIdMap =
{
    {"change",      DapTokenPairModel::FieldId::change},
    {"network",     DapTokenPairModel::FieldId::network},
    {"rate",        DapTokenPairModel::FieldId::rate},
    {"token1",      DapTokenPairModel::FieldId::token1},
    {"token2",      DapTokenPairModel::FieldId::token2},
    {"displayText", DapTokenPairModel::FieldId::displayText}
};

DapTokenPairModel::DapTokenPairModel (QObject *a_parent)
  : QAbstractTableModel (a_parent)
{
  connect (this, &DapTokenPairModel::sigSizeChanged,
           this, [this]
  {
    emit sizeChanged();
  });
}

DapTokenPairModel::DapTokenPairModel (const DapTokenPairModel &a_src)
  : QAbstractTableModel (a_src.parent())
{
  operator= (a_src);
}

DapTokenPairModel::DapTokenPairModel (DapTokenPairModel &&a_src)
  : QAbstractTableModel (a_src.parent())
{
  operator= (a_src);
}

DapTokenPairModel::~DapTokenPairModel()
{
}

int DapTokenPairModel::rowCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return m_items.size();
}

int DapTokenPairModel::columnCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return s_fieldIdMap.size();
}

QVariant DapTokenPairModel::data (const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  auto field        = DapTokenPairModel::FieldId (role);
  const auto &item  = m_items.at (index.row());
  return _getValue (item, int (field));
}

QHash<int, QByteArray> DapTokenPairModel::roleNames() const
{
  static QHash<int, QByteArray> names;

  if (names.isEmpty())
    for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
      names[int (i.value())] = i.key().toUtf8();

  return names;
}

void DapTokenPairModel::updateModel(const QList<DEX::InfoTokenPair>& data)
{
  beginResetModel();
  {
    m_items.clear();
    for(const auto& item: data)
    {
      DapTokenPairModel::Item tmpItem;
      tmpItem.token1 = item.token1;
      tmpItem.token2 = item.token2;
      tmpItem.change = item.change;
      tmpItem.displayText = item.displayText;
      tmpItem.network = item.network;
      tmpItem.rate = item.rate;
      m_items.append(std::move(tmpItem));
    }
  }
  endResetModel();
}

void DapTokenPairModel::updateModel(const DEX::InfoTokenPair &data)
{
  for(int i = 0; i < m_items.size(); i++)
  {
    if(m_items[i].displayText == data.displayText)
    {
      beginInsertRows (QModelIndex(), i, i);
      m_items[i] = data;
      endInsertRows();
      return;
    }
  }
}

int DapTokenPairModel::indexOf (const DapTokenPairModel::Item &a_item) const
{
  int index = 0;

  for (auto i = m_items.cbegin(), e = m_items.cend(); i != e; i++, index++)
    if (i->displayText == a_item.displayText)
      return index;

  return -1;
}

const DapTokenPairModel::Item &DapTokenPairModel::at (int a_index) const
{
    return const_cast<DapTokenPairModel *> (this)->_get (a_index);
}

DapTokenPairModel::Item DapTokenPairModel::value (int a_index) const
{
  return at (a_index);
}

int DapTokenPairModel::size() const
{
  return m_items.size();
}

bool DapTokenPairModel::isEmpty() const
{
  return 0 == m_items.size();
}

void DapTokenPairModel::clear()
{
  beginResetModel();

  {
    m_items.clear();
    emit sigSizeChanged (size());
  }

  endResetModel();
}

QVariant DapTokenPairModel::get (int a_index)
{
  return QVariant::fromValue (new ItemTokenPairBridge (new ItemTokenPairBridge::Data (this, &_get (a_index))));
}

const QVariant DapTokenPairModel::get(int a_index) const
{
  return const_cast<DapTokenPairModel*>(this)->get (a_index);
}

DapTokenPairModel::Item &DapTokenPairModel::_get(int a_index)
{
  static DapTokenPairModel::Item dummy;

  if (a_index < 0 || a_index >= m_items.size())
    {
      dummy = DapTokenPairModel::Item();
      return dummy;
    }

  return m_items[a_index];
}

const DapTokenPairModel::Item &DapTokenPairModel::_get(int a_index) const
{
  return const_cast<DapTokenPairModel*>(this)->_get (a_index);
}

void DapTokenPairModel::set (int a_index, const DapTokenPairModel::Item &a_item)
{
  if (a_index < 0 || a_index >= m_items.size())
    return;
  _get (a_index) = a_item;
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapTokenPairModel::set (int a_index, DapTokenPairModel::Item &&a_item)
{
  if (a_index < 0 || a_index >= m_items.size())
    return;
  _get (a_index) = std::move (a_item);
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int DapTokenPairModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapTokenPairModel::FieldId::invalid));
}

const DapTokenPairModel::Item &DapTokenPairModel::getItem(int a_index) const
{
    static DapTokenPairModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
      {
        dummy = DapTokenPairModel::Item();
        return dummy;
      }

    return m_items[a_index];
}

DapTokenPairModel::Iterator DapTokenPairModel::begin()
{
  return m_items.begin();
}

DapTokenPairModel::ConstIterator DapTokenPairModel::cbegin() const
{
  return m_items.cbegin();
}

DapTokenPairModel::Iterator DapTokenPairModel::end()
{
  return m_items.end();
}

DapTokenPairModel::ConstIterator DapTokenPairModel::cend()
{
  return m_items.cend();
}

QVariant DapTokenPairModel::_getValue (const DapTokenPairModel::Item &a_item, int a_fieldId)
{
  switch (DapTokenPairModel::FieldId (a_fieldId))
    {
    case DapTokenPairModel::FieldId::invalid: break;

    case DapTokenPairModel::FieldId::change:      return a_item.change;
    case DapTokenPairModel::FieldId::network:     return a_item.network;
    case DapTokenPairModel::FieldId::rate:        return a_item.rate;
    case DapTokenPairModel::FieldId::token1:      return a_item.token1;
    case DapTokenPairModel::FieldId::token2:      return a_item.token2;
    case DapTokenPairModel::FieldId::displayText: return a_item.displayText;
    }

  return QVariant();
}

void DapTokenPairModel::_setValue (DapTokenPairModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
  switch (DapTokenPairModel::FieldId (a_fieldId))
    {
    case DapTokenPairModel::FieldId::invalid: break;

    case DapTokenPairModel::FieldId::change:      a_item.change       = a_value.toString(); break;
    case DapTokenPairModel::FieldId::network:     a_item.network      = a_value.toString(); break;
    case DapTokenPairModel::FieldId::rate:        a_item.rate         = a_value.toString(); break;
    case DapTokenPairModel::FieldId::token1:      a_item.token1       = a_value.toString(); break;
    case DapTokenPairModel::FieldId::token2:      a_item.token2       = a_value.toString(); break;
    case DapTokenPairModel::FieldId::displayText: a_item.displayText  = a_value.toString(); break;
    }
}

QVariant DapTokenPairModel::operator[] (int a_index)
{
  return get (a_index);
}

const QVariant DapTokenPairModel::operator[] (int a_index) const
{
  return get (a_index);
}

DapTokenPairModel &DapTokenPairModel::operator= (const DapTokenPairModel &a_src)
{
  m_items  = a_src.m_items;
  return *this;
}

DapTokenPairModel &DapTokenPairModel::operator= (DapTokenPairModel &&a_src)
{
  if (this != &a_src)
    {
      m_items       = a_src.m_items;
    }
  return *this;
}

ItemTokenPairBridge::ItemTokenPairBridge (ItemTokenPairBridge::Data *a_data)
  : d (a_data)
{
  if (!d || !d->model)
    return;
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokenPairBridge::changeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokenPairBridge::networkChanged);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokenPairBridge::rateChanged);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokenPairBridge::token1Changed);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokenPairBridge::token2Changed);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokenPairBridge::displayTextChanged);
}

ItemTokenPairBridge::ItemTokenPairBridge (QObject *a_parent)
  : QObject (a_parent)
  , d (nullptr)
{

}

ItemTokenPairBridge::ItemTokenPairBridge (const ItemTokenPairBridge &a_src)
    : QObject ()
{
  operator = (a_src);
}

ItemTokenPairBridge::ItemTokenPairBridge (ItemTokenPairBridge &&a_src)
    : QObject ()
{
  operator = (std::move (a_src));
}

ItemTokenPairBridge::~ItemTokenPairBridge()
{
  delete d;
}

QString ItemTokenPairBridge::change() const
{
  return (d && d->item) ? d->item->change : QString();
}

QString ItemTokenPairBridge::network() const
{
  return (d && d->item) ? d->item->network : QString();
}

QString ItemTokenPairBridge::rate() const
{
  return (d && d->item) ? d->item->rate : QString();
}

QString ItemTokenPairBridge::token1() const
{
  return (d && d->item) ? d->item->token1 : QString();
}

QString ItemTokenPairBridge::token2() const
{
  return (d && d->item) ? d->item->token2 : QString();
}

QString ItemTokenPairBridge::displayText() const
{
    return (d && d->item) ? d->item->displayText : QString();
}

ItemTokenPairBridge &ItemTokenPairBridge::operator =(const ItemTokenPairBridge &a_src)
{
  if (this != &a_src)
    d = new Data (*a_src.d);
  return *this;
}

ItemTokenPairBridge &ItemTokenPairBridge::operator =(ItemTokenPairBridge &&a_src)
{
  if (this != &a_src)
    {
      d = std::move (a_src.d);
      a_src.d = nullptr;
    }
  return *this;
}
