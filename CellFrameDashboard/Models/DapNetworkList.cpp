#include "DapNetworkList.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QVariant>
#include <QList>
#include <QMetaEnum>

/* DEFS */

struct ItemNetworkListBridge::Data
{
    DapNetworkList *model;
    DapNetworkList::Item *item;
    QModelIndex begin, end;

    Data (DapNetworkList *a_model, DapNetworkList::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

static const QHash<QString, DapNetworkList::DapNetworkList::FieldId> s_fieldIdMap =
    {
        {"networkName",         DapNetworkList::FieldId::networkName},
        {"networkState",               DapNetworkList::FieldId::networkState},
        {"targetState",         DapNetworkList::FieldId::targetState},
        {"address",             DapNetworkList::FieldId::address},
        {"activeLinksCount",    DapNetworkList::FieldId::activeLinksCount},
        {"linksCount",          DapNetworkList::FieldId::linksCount},
        };

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static DapNetworkList::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

DapNetworkList::DapNetworkList (QObject *a_parent)
    : QAbstractTableModel (a_parent)
    , m_items (new QList<DapNetworkList::Item>())
{
    connect (this, &DapNetworkList::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapNetworkList::DapNetworkList (const DapNetworkList &a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapNetworkList::Item>())
{
    operator= (a_src);
}

DapNetworkList::DapNetworkList (DapNetworkList &&a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapNetworkList::Item>())
{
    operator= (a_src);
}

DapNetworkList::~DapNetworkList()
{
    delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int DapNetworkList::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items->size();
}

int DapNetworkList::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapNetworkList::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapNetworkList::FieldId (role);
    const auto &item  = m_items->at (index.row());
    return _getValue (item, int (field));
}

QHash<int, QByteArray> DapNetworkList::roleNames() const
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

bool DapNetworkList::updateNetworksInfo(const QVariant& networksStateList)
{
    QJsonDocument document = QJsonDocument::fromJson(networksStateList.toByteArray());
    QJsonObject replyObj = document.object();
    QJsonArray netArr = replyObj["result"].toArray();

    if(netArr.isEmpty())
    {
        return false;
    }
    m_items->clear();
    beginResetModel ();

    for(const QJsonValue& value: netArr)
    {
        QJsonObject object = value.toObject();
        Item item;
        item.networkName    = object["name"].toString();
        item.networkState   = object["networkState"].toString();
        item.targetState    = object["targetState"].toString();
        item.address        = object["nodeAddress"].toString();
        item.activeLinksCount = object["activeLinksCount"].toString() ;
        item.linksCount     = object["linksCount"].toString();
        m_items->append(std::move(item));
    }
    endResetModel();
    return true;
}

int DapNetworkList::add (const DapNetworkList::Item &a_item)
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

void DapNetworkList::insert (int a_index, const DapNetworkList::Item &a_item)
{
    beginInsertRows (QModelIndex(), a_index, a_index);

    {
        m_items->insert (a_index, a_item);
        emit sigItemAdded (a_index);
        emit sigSizeChanged (size());
    }

    endInsertRows();

}

void DapNetworkList::remove (int a_index)
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

int DapNetworkList::indexOf (const DapNetworkList::Item &a_item) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
        if (i->networkName == a_item.networkName)
            return index;

    return -1;
}

const DapNetworkList::Item &DapNetworkList::at (int a_index) const
{
    return const_cast<DapNetworkList *> (this)->_get (a_index);
}

DapNetworkList::Item DapNetworkList::value (int a_index) const
{
    return at (a_index);
}

int DapNetworkList::size() const
{
    return m_items->size();
}

bool DapNetworkList::isEmpty() const
{
    return 0 == m_items->size();
}

void DapNetworkList::clear()
{
    beginResetModel();

    {
        m_items->clear();
        emit sigSizeChanged (size());
    }

    endResetModel();
}

QVariant DapNetworkList::get (int a_index)
{
    return QVariant::fromValue (new ItemNetworkListBridge (new ItemNetworkListBridge::Data (this, &_get (a_index))));
}

const QVariant DapNetworkList::get(int a_index) const
{
    return const_cast<DapNetworkList*>(this)->get (a_index);
}

DapNetworkList::Item &DapNetworkList::_get(int a_index)
{
    static DapNetworkList::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

const DapNetworkList::Item &DapNetworkList::_get(int a_index) const
{
    return const_cast<DapNetworkList*>(this)->_get (a_index);
}

void DapNetworkList::set (int a_index, const DapNetworkList::Item &a_item)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;
    _get (a_index) = a_item;
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapNetworkList::set (int a_index, DapNetworkList::Item &&a_item)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;
    _get (a_index) = std::move (a_item);
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int DapNetworkList::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapNetworkList::FieldId::invalid));
}

const DapNetworkList::Item &DapNetworkList::getItem(int a_index) const
{
    static DapNetworkList::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

DapNetworkList::Iterator DapNetworkList::begin()
{
    return m_items->begin();
}

DapNetworkList::ConstIterator DapNetworkList::cbegin() const
{
    return m_items->cbegin();
}

DapNetworkList::Iterator DapNetworkList::end()
{
    return m_items->end();
}

DapNetworkList::ConstIterator DapNetworkList::cend()
{
    return m_items->cend();
}

QVariant DapNetworkList::_getValue (const DapNetworkList::Item &a_item, int a_fieldId)
{
    switch (DapNetworkList::FieldId (a_fieldId))
    {
    case DapNetworkList::FieldId::invalid: break;

    case DapNetworkList::FieldId::networkName       :  return a_item.networkName;
    case DapNetworkList::FieldId::networkState      :  return a_item.networkState;
    case DapNetworkList::FieldId::targetState       :  return a_item.targetState;
    case DapNetworkList::FieldId::address           :  return a_item.address;
    case DapNetworkList::FieldId::activeLinksCount  :  return a_item.activeLinksCount;
    case DapNetworkList::FieldId::linksCount        :  return a_item.linksCount;
    }

    return QVariant();
}

void DapNetworkList::_setValue (DapNetworkList::Item &a_item, int a_fieldId, const QVariant &a_value)
{
    switch (DapNetworkList::FieldId (a_fieldId))
    {
    case DapNetworkList::FieldId::invalid: break;

    case DapNetworkList::FieldId::networkName       :  a_item.networkName    = a_value.toString(); break;
    case DapNetworkList::FieldId::networkState      :  a_item.networkState  = a_value.toString(); break;
    case DapNetworkList::FieldId::targetState       :  a_item.targetState  = a_value.toString(); break;
    case DapNetworkList::FieldId::address           :  a_item.address  = a_value.toString(); break;
    case DapNetworkList::FieldId::activeLinksCount  :  a_item.activeLinksCount  = a_value.toInt(); break;
    case DapNetworkList::FieldId::linksCount        :  a_item.linksCount  = a_value.toInt(); break;
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant DapNetworkList::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapNetworkList::operator[] (int a_index) const
{
    return get (a_index);
}

DapNetworkList &DapNetworkList::operator= (const DapNetworkList &a_src)
{
    *m_items  = *a_src.m_items;
    return *this;
}

DapNetworkList &DapNetworkList::operator= (DapNetworkList &&a_src)
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

DapNetworkList::Item _dummy()
{
    return DapNetworkList::Item();
}

/********************************************
 * ITEM BRIDGE
 *******************************************/

ItemNetworkListBridge::ItemNetworkListBridge (ItemNetworkListBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemNetworkListBridge::nameChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemNetworkListBridge::statusProtectChanged);
}

ItemNetworkListBridge::ItemNetworkListBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemNetworkListBridge::ItemNetworkListBridge (const ItemNetworkListBridge &a_src)
{
    operator = (a_src);
}

ItemNetworkListBridge::ItemNetworkListBridge (ItemNetworkListBridge &&a_src)
{
    operator = (std::move (a_src));
}

ItemNetworkListBridge::~ItemNetworkListBridge()
{
    delete d;
}

/* METHODS */

QString ItemNetworkListBridge::networkName() const
{
    return (d && d->item) ? d->item->networkName : QString();
}

void ItemNetworkListBridge::setNetworkName(const QString &networkName)
{
    if (!_beginSetValue())
        return;
    d->item->networkName = networkName;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkListBridge::networkState() const
{
    return (d && d->item) ? d->item->networkState : QString();
}

void ItemNetworkListBridge::setNetworkState(const QString &networkState)
{
    if (!_beginSetValue())
        return;
    d->item->networkState = networkState;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkListBridge::targetState() const
{
    return (d && d->item) ? d->item->targetState : QString();
}

void ItemNetworkListBridge::setTargetState(const QString &targetState)
{
    if (!_beginSetValue())
        return;
    d->item->targetState = targetState;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkListBridge::address() const
{
    return (d && d->item) ? d->item->address : QString();
}

void ItemNetworkListBridge::setAddress(const QString &address)
{
    if (!_beginSetValue())
        return;
    d->item->address = address;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkListBridge::activeLinksCount() const
{
    return (d && d->item) ? d->item->activeLinksCount : QString();
}

void ItemNetworkListBridge::setActiveLinksCount(const QString &activeLinksCount)
{
    if (!_beginSetValue())
        return;
    d->item->activeLinksCount = activeLinksCount;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkListBridge::linksCount() const
{
    return (d && d->item) ? d->item->linksCount : QString();
}

void ItemNetworkListBridge::setLinksCount(const QString &linksCount)
{
    if (!_beginSetValue())
        return;
    d->item->linksCount = linksCount;
    emit nameChanged();
    _endSetValue();
}

bool ItemNetworkListBridge::_beginSetValue()
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

void ItemNetworkListBridge::_endSetValue()
{
    emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemNetworkListBridge::operator[] (const QString &a_valueName)
{
    if (!d || !d->model || !d->item)
        return QVariant();

    int fieldId = d->model->fieldId (a_valueName);


    switch (DapNetworkList::FieldId (fieldId))
    {
    case DapNetworkList::FieldId::networkName       :  return networkName(); break;
    case DapNetworkList::FieldId::networkState             :  return networkState(); break;
    case DapNetworkList::FieldId::targetState       :  return targetState(); break;
    case DapNetworkList::FieldId::address           :  return address(); break;
    case DapNetworkList::FieldId::activeLinksCount  :  return activeLinksCount(); break;
    case DapNetworkList::FieldId::linksCount        :  return linksCount(); break;

    case DapNetworkList::FieldId::invalid:
    default:
        break;
    }

    return QVariant();
}

ItemNetworkListBridge &ItemNetworkListBridge::operator =(const ItemNetworkListBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemNetworkListBridge &ItemNetworkListBridge::operator =(ItemNetworkListBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}

/*-----------------------------------------*/
