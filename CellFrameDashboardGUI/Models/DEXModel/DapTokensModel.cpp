#include "DapTokensModel.h"

#include <QList>
#include <QMetaEnum>

struct ItemTokensListBridge::Data
{
    DapTokensModel *model;
    DapTokensModel::Item *item;
    QModelIndex begin, end;

    Data (DapTokensModel *a_model, DapTokensModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapTokensModel::DapTokensModel::FieldId> s_fieldIdMap =
{
    {"change",      DapTokensModel::FieldId::change},
    {"network",     DapTokensModel::FieldId::network},
    {"rate",        DapTokensModel::FieldId::rate},
    {"token1",      DapTokensModel::FieldId::token1},
    {"token2",      DapTokensModel::FieldId::token2},
    {"displayText", DapTokensModel::FieldId::displayText}
};

DapTokensModel::DapTokensModel (QObject *a_parent)
  : QAbstractTableModel (a_parent)
{
  connect (this, &DapTokensModel::sigSizeChanged,
           this, [this]
  {
    emit sizeChanged();
  });
}

DapTokensModel::DapTokensModel (const DapTokensModel &a_src)
  : QAbstractTableModel (a_src.parent())
{
  operator= (a_src);
}

DapTokensModel::DapTokensModel (DapTokensModel &&a_src)
  : QAbstractTableModel (a_src.parent())
{
  operator= (a_src);
}

DapTokensModel::~DapTokensModel()
{
}

int DapTokensModel::rowCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return m_items.size();
}

int DapTokensModel::columnCount (const QModelIndex &parent) const
{
  if (parent.isValid())
    return 0;

  return s_fieldIdMap.size();
}

QVariant DapTokensModel::data (const QModelIndex &index, int role) const
{
  if (!index.isValid())
    return QVariant();

  auto field        = DapTokensModel::FieldId (role);
  const auto &item  = m_items.at (index.row());
  return _getValue (item, int (field));
}

QHash<int, QByteArray> DapTokensModel::roleNames() const
{
  static QHash<int, QByteArray> names;

  if (names.isEmpty())
    for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
      names[int (i.value())] = i.key().toUtf8();

  return names;
}

void DapTokensModel::updateModel(const QList<DEX::InfoTokenPair>& data)
{
    qDebug() << "KTT" << "updateModel NEW class" << data.size();
  beginResetModel();
  {
    m_items.clear();
    for(const auto& item: data)
    {
      DapTokensModel::Item tmpItem;
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
   qDebug() << "KTT" << "updateModel NEW class finish" << data.size();
}

void DapTokensModel::updateModel(const DEX::InfoTokenPair &data)
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

int DapTokensModel::indexOf (const DapTokensModel::Item &a_item) const
{
  int index = 0;

  for (auto i = m_items.cbegin(), e = m_items.cend(); i != e; i++, index++)
    if (i->displayText == a_item.displayText)
      return index;

  return -1;
}

const DapTokensModel::Item &DapTokensModel::at (int a_index) const
{
    return const_cast<DapTokensModel *> (this)->_get (a_index);
}

DapTokensModel::Item DapTokensModel::value (int a_index) const
{
  return at (a_index);
}

int DapTokensModel::size() const
{
  return m_items.size();
}

bool DapTokensModel::isEmpty() const
{
  return 0 == m_items.size();
}

void DapTokensModel::clear()
{
  beginResetModel();

  {
    m_items.clear();
    emit sigSizeChanged (size());
  }

  endResetModel();
}

QVariant DapTokensModel::get (int a_index)
{
  return QVariant::fromValue (new ItemTokensListBridge (new ItemTokensListBridge::Data (this, &_get (a_index))));
}

const QVariant DapTokensModel::get(int a_index) const
{
  return const_cast<DapTokensModel*>(this)->get (a_index);
}

DapTokensModel::Item &DapTokensModel::_get(int a_index)
{
  static DapTokensModel::Item dummy;

  if (a_index < 0 || a_index >= m_items.size())
    {
      dummy = DapTokensModel::Item();
      return dummy;
    }

  return m_items[a_index];
}

const DapTokensModel::Item &DapTokensModel::_get(int a_index) const
{
  return const_cast<DapTokensModel*>(this)->_get (a_index);
}

void DapTokensModel::set (int a_index, const DapTokensModel::Item &a_item)
{
  if (a_index < 0 || a_index >= m_items.size())
    return;
  _get (a_index) = a_item;
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapTokensModel::set (int a_index, DapTokensModel::Item &&a_item)
{
  if (a_index < 0 || a_index >= m_items.size())
    return;
  _get (a_index) = std::move (a_item);
  emit sigItemChanged (a_index);
  emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int DapTokensModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapTokensModel::FieldId::invalid));
}

const DapTokensModel::Item &DapTokensModel::getItem(int a_index) const
{
    static DapTokensModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
      {
        dummy = DapTokensModel::Item();
        return dummy;
      }

    return m_items[a_index];
}

DapTokensModel::Iterator DapTokensModel::begin()
{
  return m_items.begin();
}

DapTokensModel::ConstIterator DapTokensModel::cbegin() const
{
  return m_items.cbegin();
}

DapTokensModel::Iterator DapTokensModel::end()
{
  return m_items.end();
}

DapTokensModel::ConstIterator DapTokensModel::cend()
{
  return m_items.cend();
}

QVariant DapTokensModel::_getValue (const DapTokensModel::Item &a_item, int a_fieldId)
{
  switch (DapTokensModel::FieldId (a_fieldId))
    {
    case DapTokensModel::FieldId::invalid: break;

    case DapTokensModel::FieldId::change:      return a_item.change;
    case DapTokensModel::FieldId::network:     return a_item.network;
    case DapTokensModel::FieldId::rate:        return a_item.rate;
    case DapTokensModel::FieldId::token1:      return a_item.token1;
    case DapTokensModel::FieldId::token2:      return a_item.token2;
    case DapTokensModel::FieldId::displayText: return a_item.displayText;
    }

  return QVariant();
}

void DapTokensModel::_setValue (DapTokensModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
  switch (DapTokensModel::FieldId (a_fieldId))
    {
    case DapTokensModel::FieldId::invalid: break;

    case DapTokensModel::FieldId::change:      a_item.change       = a_value.toString(); break;
    case DapTokensModel::FieldId::network:     a_item.network      = a_value.toString(); break;
    case DapTokensModel::FieldId::rate:        a_item.rate         = a_value.toString(); break;
    case DapTokensModel::FieldId::token1:      a_item.token1       = a_value.toString(); break;
    case DapTokensModel::FieldId::token2:      a_item.token2       = a_value.toString(); break;
    case DapTokensModel::FieldId::displayText: a_item.displayText  = a_value.toString(); break;
    }
}

QVariant DapTokensModel::operator[] (int a_index)
{
  return get (a_index);
}

const QVariant DapTokensModel::operator[] (int a_index) const
{
  return get (a_index);
}

DapTokensModel &DapTokensModel::operator= (const DapTokensModel &a_src)
{
  m_items  = a_src.m_items;
  return *this;
}

DapTokensModel &DapTokensModel::operator= (DapTokensModel &&a_src)
{
  if (this != &a_src)
    {
      m_items       = a_src.m_items;
    }
  return *this;
}

ItemTokensListBridge::ItemTokensListBridge (ItemTokensListBridge::Data *a_data)
  : d (a_data)
{
  if (!d || !d->model)
    return;
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensListBridge::changeChanged);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensListBridge::networkChanged);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensListBridge::rateChanged);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensListBridge::token1Changed);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensListBridge::token2Changed);
  connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemTokensListBridge::displayTextChanged);
}

ItemTokensListBridge::ItemTokensListBridge (QObject *a_parent)
  : QObject (a_parent)
  , d (nullptr)
{

}

ItemTokensListBridge::ItemTokensListBridge (const ItemTokensListBridge &a_src)
    : QObject ()
{
  operator = (a_src);
}

ItemTokensListBridge::ItemTokensListBridge (ItemTokensListBridge &&a_src)
    : QObject ()
{
  operator = (std::move (a_src));
}

ItemTokensListBridge::~ItemTokensListBridge()
{
  delete d;
}

QString ItemTokensListBridge::change() const
{
  return (d && d->item) ? d->item->change : QString();
}

QString ItemTokensListBridge::network() const
{
  return (d && d->item) ? d->item->network : QString();
}

QString ItemTokensListBridge::rate() const
{
  return (d && d->item) ? d->item->rate : QString();
}

QString ItemTokensListBridge::token1() const
{
  return (d && d->item) ? d->item->token1 : QString();
}

QString ItemTokensListBridge::token2() const
{
  return (d && d->item) ? d->item->token2 : QString();
}

QString ItemTokensListBridge::displayText() const
{
    return (d && d->item) ? d->item->displayText : QString();
}

ItemTokensListBridge &ItemTokensListBridge::operator =(const ItemTokensListBridge &a_src)
{
  if (this != &a_src)
    d = new Data (*a_src.d);
  return *this;
}

ItemTokensListBridge &ItemTokensListBridge::operator =(ItemTokensListBridge &&a_src)
{
  if (this != &a_src)
    {
      d = std::move (a_src.d);
      a_src.d = nullptr;
    }
  return *this;
}
