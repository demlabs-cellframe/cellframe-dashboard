#include "DapNetworksModel.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QVariant>
#include <QList>
#include <QMetaEnum>

/* DEFS */

struct ItemNetworksModelBridge::Data
{
    DapNetworksModel *model;
    DapNetworksModel::Item *item;
    QModelIndex begin, end;

    Data (DapNetworksModel *a_model, DapNetworksModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

static const QHash<QString, DapNetworksModel::DapNetworksModel::FieldId> s_fieldIdMap =
    {
        {"networkName",         DapNetworksModel::FieldId::networkName},
        {"networkState",               DapNetworksModel::FieldId::networkState},
        {"targetState",         DapNetworksModel::FieldId::targetState},
        {"address",             DapNetworksModel::FieldId::address},
        {"activeLinksCount",    DapNetworksModel::FieldId::activeLinksCount},
        {"linksCount",          DapNetworksModel::FieldId::linksCount},
        };

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static DapNetworksModel::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

DapNetworksModel::DapNetworksModel (QObject *a_parent)
    : QAbstractTableModel (a_parent)
    , m_items (new QList<DapNetworksModel::Item>())
{
    connect (this, &DapNetworksModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapNetworksModel::DapNetworksModel (const DapNetworksModel &a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapNetworksModel::Item>())
{
    operator= (a_src);
}

DapNetworksModel::DapNetworksModel (DapNetworksModel &&a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapNetworksModel::Item>())
{
    operator= (a_src);
}

DapNetworksModel::~DapNetworksModel()
{
    delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int DapNetworksModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items->size();
}

int DapNetworksModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapNetworksModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapNetworksModel::FieldId (role);
    const auto &item  = m_items->at (index.row());
    return _getValue (item, int (field));
}

QHash<int, QByteArray> DapNetworksModel::roleNames() const
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

bool DapNetworksModel::updateNetworksInfo(const QVariant& networksStateList)
{
    qDebug() << "KTT" << "DapNetworksModel::updateNetworksInfo";
    QJsonDocument document = QJsonDocument::fromJson(networksStateList.toByteArray());
    qDebug() << "KTT" << "document:" << document.toJson(QJsonDocument::Compact);
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

int DapNetworksModel::add (const DapNetworksModel::Item &a_item)
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

void DapNetworksModel::insert (int a_index, const DapNetworksModel::Item &a_item)
{
    beginInsertRows (QModelIndex(), a_index, a_index);

    {
        m_items->insert (a_index, a_item);
        emit sigItemAdded (a_index);
        emit sigSizeChanged (size());
    }

    endInsertRows();

}

void DapNetworksModel::remove (int a_index)
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

int DapNetworksModel::indexOf (const DapNetworksModel::Item &a_item) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
        if (i->networkName == a_item.networkName)
            return index;

    return -1;
}

const DapNetworksModel::Item &DapNetworksModel::at (int a_index) const
{
    return const_cast<DapNetworksModel *> (this)->_get (a_index);
}

DapNetworksModel::Item DapNetworksModel::value (int a_index) const
{
    return at (a_index);
}

int DapNetworksModel::size() const
{
    return m_items->size();
}

bool DapNetworksModel::isEmpty() const
{
    return 0 == m_items->size();
}

void DapNetworksModel::clear()
{
    beginResetModel();

    {
        m_items->clear();
        emit sigSizeChanged (size());
    }

    endResetModel();
}

QVariant DapNetworksModel::get (int a_index)
{
    return QVariant::fromValue (new ItemNetworksModelBridge (new ItemNetworksModelBridge::Data (this, &_get (a_index))));
}

const QVariant DapNetworksModel::get(int a_index) const
{
    return const_cast<DapNetworksModel*>(this)->get (a_index);
}

DapNetworksModel::Item &DapNetworksModel::_get(int a_index)
{
    static DapNetworksModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

const DapNetworksModel::Item &DapNetworksModel::_get(int a_index) const
{
    return const_cast<DapNetworksModel*>(this)->_get (a_index);
}

void DapNetworksModel::set (int a_index, const DapNetworksModel::Item &a_item)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;
    _get (a_index) = a_item;
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapNetworksModel::set (int a_index, DapNetworksModel::Item &&a_item)
{
    if (a_index < 0 || a_index >= m_items->size())
        return;
    _get (a_index) = std::move (a_item);
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int DapNetworksModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapNetworksModel::FieldId::invalid));
}

const DapNetworksModel::Item &DapNetworksModel::getItem(int a_index) const
{
    static DapNetworksModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

DapNetworksModel::Iterator DapNetworksModel::begin()
{
    return m_items->begin();
}

DapNetworksModel::ConstIterator DapNetworksModel::cbegin() const
{
    return m_items->cbegin();
}

DapNetworksModel::Iterator DapNetworksModel::end()
{
    return m_items->end();
}

DapNetworksModel::ConstIterator DapNetworksModel::cend()
{
    return m_items->cend();
}

QVariant DapNetworksModel::_getValue (const DapNetworksModel::Item &a_item, int a_fieldId)
{
    switch (DapNetworksModel::FieldId (a_fieldId))
    {
    case DapNetworksModel::FieldId::invalid: break;

    case DapNetworksModel::FieldId::networkName       :  return a_item.networkName;
    case DapNetworksModel::FieldId::networkState      :  return a_item.networkState;
    case DapNetworksModel::FieldId::targetState       :  return a_item.targetState;
    case DapNetworksModel::FieldId::address           :  return a_item.address;
    case DapNetworksModel::FieldId::activeLinksCount  :  return a_item.activeLinksCount;
    case DapNetworksModel::FieldId::linksCount        :  return a_item.linksCount;
    }

    return QVariant();
}

void DapNetworksModel::_setValue (DapNetworksModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
    switch (DapNetworksModel::FieldId (a_fieldId))
    {
    case DapNetworksModel::FieldId::invalid: break;

    case DapNetworksModel::FieldId::networkName       :  a_item.networkName    = a_value.toString(); break;
    case DapNetworksModel::FieldId::networkState      :  a_item.networkState  = a_value.toString(); break;
    case DapNetworksModel::FieldId::targetState       :  a_item.targetState  = a_value.toString(); break;
    case DapNetworksModel::FieldId::address           :  a_item.address  = a_value.toString(); break;
    case DapNetworksModel::FieldId::activeLinksCount  :  a_item.activeLinksCount  = a_value.toInt(); break;
    case DapNetworksModel::FieldId::linksCount        :  a_item.linksCount  = a_value.toInt(); break;
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant DapNetworksModel::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapNetworksModel::operator[] (int a_index) const
{
    return get (a_index);
}

DapNetworksModel &DapNetworksModel::operator= (const DapNetworksModel &a_src)
{
    *m_items  = *a_src.m_items;
    return *this;
}

DapNetworksModel &DapNetworksModel::operator= (DapNetworksModel &&a_src)
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

DapNetworksModel::Item _dummy()
{
    return DapNetworksModel::Item();
}

/********************************************
 * ITEM BRIDGE
 *******************************************/

ItemNetworksModelBridge::ItemNetworksModelBridge (ItemNetworksModelBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemNetworksModelBridge::nameChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemNetworksModelBridge::statusProtectChanged);
}

ItemNetworksModelBridge::ItemNetworksModelBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemNetworksModelBridge::ItemNetworksModelBridge (const ItemNetworksModelBridge &a_src)
{
    operator = (a_src);
}

ItemNetworksModelBridge::ItemNetworksModelBridge (ItemNetworksModelBridge &&a_src)
{
    operator = (std::move (a_src));
}

ItemNetworksModelBridge::~ItemNetworksModelBridge()
{
    delete d;
}

/* METHODS */

QString ItemNetworksModelBridge::networkName() const
{
    return (d && d->item) ? d->item->networkName : QString();
}

void ItemNetworksModelBridge::setNetworkName(const QString &networkName)
{
    if (!_beginSetValue())
        return;
    d->item->networkName = networkName;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworksModelBridge::networkState() const
{
    return (d && d->item) ? d->item->networkState : QString();
}

void ItemNetworksModelBridge::setNetworkState(const QString &networkState)
{
    if (!_beginSetValue())
        return;
    d->item->networkState = networkState;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworksModelBridge::targetState() const
{
    return (d && d->item) ? d->item->targetState : QString();
}

void ItemNetworksModelBridge::setTargetState(const QString &targetState)
{
    if (!_beginSetValue())
        return;
    d->item->targetState = targetState;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworksModelBridge::address() const
{
    return (d && d->item) ? d->item->address : QString();
}

void ItemNetworksModelBridge::setAddress(const QString &address)
{
    if (!_beginSetValue())
        return;
    d->item->address = address;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworksModelBridge::activeLinksCount() const
{
    return (d && d->item) ? d->item->activeLinksCount : QString();
}

void ItemNetworksModelBridge::setActiveLinksCount(const QString &activeLinksCount)
{
    if (!_beginSetValue())
        return;
    d->item->activeLinksCount = activeLinksCount;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworksModelBridge::linksCount() const
{
    return (d && d->item) ? d->item->linksCount : QString();
}

void ItemNetworksModelBridge::setLinksCount(const QString &linksCount)
{
    if (!_beginSetValue())
        return;
    d->item->linksCount = linksCount;
    emit nameChanged();
    _endSetValue();
}

bool ItemNetworksModelBridge::_beginSetValue()
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

void ItemNetworksModelBridge::_endSetValue()
{
    emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemNetworksModelBridge::operator[] (const QString &a_valueName)
{
    if (!d || !d->model || !d->item)
        return QVariant();

    int fieldId = d->model->fieldId (a_valueName);


    switch (DapNetworksModel::FieldId (fieldId))
    {
    case DapNetworksModel::FieldId::networkName       :  return networkName(); break;
    case DapNetworksModel::FieldId::networkState             :  return networkState(); break;
    case DapNetworksModel::FieldId::targetState       :  return targetState(); break;
    case DapNetworksModel::FieldId::address           :  return address(); break;
    case DapNetworksModel::FieldId::activeLinksCount  :  return activeLinksCount(); break;
    case DapNetworksModel::FieldId::linksCount        :  return linksCount(); break;

    case DapNetworksModel::FieldId::invalid:
    default:
        break;
    }

    return QVariant();
}

ItemNetworksModelBridge &ItemNetworksModelBridge::operator =(const ItemNetworksModelBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemNetworksModelBridge &ItemNetworksModelBridge::operator =(ItemNetworksModelBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}
