#include "DapNetworkModel.h"

#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QVariant>
#include <QList>
#include <QMetaEnum>

/* DEFS */

struct ItemNetworkModelBridge::Data
{
    DapNetworkModel *model;
    DapNetworkModel::Item *item;
    QModelIndex begin, end;

    Data (DapNetworkModel *a_model, DapNetworkModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

/* VARS */

static const QHash<QString, DapNetworkModel::DapNetworkModel::FieldId> s_fieldIdMap =
    {
        {"networkName",           DapNetworkModel::FieldId::networkName},
        {"networkState",          DapNetworkModel::FieldId::networkState},
        {"targetState",           DapNetworkModel::FieldId::targetState},
        {"address",               DapNetworkModel::FieldId::address},
        {"activeLinksCount",      DapNetworkModel::FieldId::activeLinksCount},
        {"linksCount",            DapNetworkModel::FieldId::linksCount},
        {"syncPercent",           DapNetworkModel::FieldId::syncPercent},
        {"errorMessage",          DapNetworkModel::FieldId::errorMessage},
        {"displayNetworkState",   DapNetworkModel::FieldId::displayNetworkState},
        {"displayTargetState",    DapNetworkModel::FieldId::displayTargetState},
        };

/* LINKS */
//static QVariant _getValue (const UserModel::Item &a_item, UserModel::FieldId a_field);
//static void _setValue (UserModel::Item &a_item, UserModel::FieldId a_field, const QVariant &a_value);
static DapNetworkModel::Item _dummy();

/********************************************
 * CONSTRUCT/DESTRUCT
 *******************************************/

DapNetworkModel::DapNetworkModel (QObject *a_parent)
    : QAbstractTableModel (a_parent)
    , m_items (new QList<DapNetworkModel::Item>())
{
    connect (this, &DapNetworkModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapNetworkModel::DapNetworkModel (const DapNetworkModel &a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapNetworkModel::Item>())
{
    operator= (a_src);
}

DapNetworkModel::DapNetworkModel (DapNetworkModel &&a_src)
    : QAbstractTableModel (a_src.parent())
    , m_items (new QList<DapNetworkModel::Item>())
{
    operator= (a_src);
}

DapNetworkModel::~DapNetworkModel()
{
    delete m_items;
}

/********************************************
 * OVERRIDE
 *******************************************/

int DapNetworkModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items->size();
}

int DapNetworkModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapNetworkModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapNetworkModel::FieldId (role);
    const auto &item  = m_items->at (index.row());
    return _getValue (item, int (field));
}

QHash<int, QByteArray> DapNetworkModel::roleNames() const
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

bool DapNetworkModel::updateNetworksInfo(const QVariant& networksStateList)
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
        item.networkName          = object["name"].toString();
        item.networkState         = object["networkState"].toString();
        item.targetState          = object["targetState"].toString();
        item.address              = object["nodeAddress"].toString();
        item.activeLinksCount     = object["activeLinksCount"].toString();
        item.linksCount           = object["linksCount"].toString();
        item.syncPercent          = object["syncPercent"].toString();
        item.errorMessage         = object["errorMessage"].toString();
        item.displayNetworkState  = object["displayNetworkState"].toString();
        item.displayTargetState   = object["displayTargetState"].toString();
        m_items->append(std::move(item));
    }
    endResetModel();
    return true;
}

int DapNetworkModel::add(const NetworkInfo& a_item)
{
    int index = m_items->size();

    beginInsertRows(QModelIndex(), index, index);

    {
        DapNetworkModel::Item item;
        item = a_item;
        m_items->append(item);
        emit sigSizeChanged (index + 1);
    }

    endInsertRows();

    return index;
}

void DapNetworkModel::updateModel(const NetworkInfo &a_item)
{
    bool isUpdated = false;
    for(auto& item: *m_items)
    {
        if(item.networkName == a_item.networkName)
        {
            beginResetModel();
            item = a_item;
            endResetModel();
            isUpdated = true;
            break;
        }
    }
    if(!isUpdated)
    {
        add(a_item);
    }
}

void DapNetworkModel::updateListModel(const QStringList& netList)
{
    for(int i = 0; i < m_items->size(); i++)
    {
        if(!netList.contains((*m_items)[i].networkName))
        {
            beginResetModel();
            m_items->removeAt(i);
            endResetModel();
        }
    }
    emit dataChanged(index(0, 0), index(m_items->size(), 0));
}

void DapNetworkModel::insert(int a_index, const DapNetworkModel::Item &a_item)
{
    beginInsertRows (QModelIndex(), a_index, a_index);

    {
        m_items->insert (a_index, a_item);
        emit sigItemAdded (a_index);
        emit sigSizeChanged (size());
    }

    endInsertRows();

}

void DapNetworkModel::remove (int a_index)
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

void DapNetworkModel::remove(const QStringList& list)
{
    QMutableListIterator<DapNetworkModel::Item> nets(*m_items);
    while(nets.hasNext())
    {
        auto netItem = nets.next();
        if(list.contains(netItem.networkName))
        {
            nets.remove();
        }
    }
}

int DapNetworkModel::indexOf (const DapNetworkModel::Item &a_item) const
{
    int index = 0;

    for (auto i = m_items->cbegin(), e = m_items->cend(); i != e; i++, index++)
        if (i->networkName == a_item.networkName)
            return index;

    return -1;
}

const DapNetworkModel::Item &DapNetworkModel::at (int a_index) const
{
    return const_cast<DapNetworkModel *> (this)->_get (a_index);
}

DapNetworkModel::Item DapNetworkModel::value (int a_index) const
{
    return at (a_index);
}

int DapNetworkModel::size() const
{
    return m_items->size();
}

bool DapNetworkModel::isEmpty() const
{
    return 0 == m_items->size();
}

void DapNetworkModel::clear()
{
    beginResetModel();

    {
        m_items->clear();
        emit sigSizeChanged (size());
    }

    endResetModel();
}

QVariant DapNetworkModel::get (int a_index)
{
    return QVariant::fromValue (new ItemNetworkModelBridge (new ItemNetworkModelBridge::Data (this, &_get (a_index))));
}

const QVariant DapNetworkModel::get(int a_index) const
{
    return const_cast<DapNetworkModel*>(this)->get (a_index);
}

DapNetworkModel::Item &DapNetworkModel::_get(int a_index)
{
    static DapNetworkModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

const DapNetworkModel::Item &DapNetworkModel::_get(int a_index) const
{
    return const_cast<DapNetworkModel*>(this)->_get (a_index);
}

void DapNetworkModel::set(int a_index, const NetworkInfo& a_item)
{
    if(a_index < 0 || a_index >= m_items->size())
        return;

    _get(a_index) = a_item;
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

void DapNetworkModel::set(int a_index, NetworkInfo &&a_item)
{
    if(a_index < 0 || a_index >= m_items->size())
        return;
    _get(a_index) = std::move(a_item);
    emit sigItemChanged (a_index);
    emit dataChanged (index (a_index, 0), index (a_index, 0));
}

int DapNetworkModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapNetworkModel::FieldId::invalid));
}

const DapNetworkModel::Item &DapNetworkModel::getItem(int a_index) const
{
    static DapNetworkModel::Item dummy;

    if (a_index < 0 || a_index >= m_items->size())
    {
        dummy = _dummy();
        return dummy;
    }

    return (*m_items) [a_index];
}

DapNetworkModel::Iterator DapNetworkModel::begin()
{
    return m_items->begin();
}

DapNetworkModel::ConstIterator DapNetworkModel::cbegin() const
{
    return m_items->cbegin();
}

DapNetworkModel::Iterator DapNetworkModel::end()
{
    return m_items->end();
}

DapNetworkModel::ConstIterator DapNetworkModel::cend()
{
    return m_items->cend();
}

QVariant DapNetworkModel::_getValue (const DapNetworkModel::Item &a_item, int a_fieldId)
{
    switch (DapNetworkModel::FieldId (a_fieldId))
    {
    case DapNetworkModel::FieldId::invalid: break;

    case DapNetworkModel::FieldId::networkName          :  return a_item.networkName;
    case DapNetworkModel::FieldId::networkState         :  return a_item.networkState;
    case DapNetworkModel::FieldId::targetState          :  return a_item.targetState;
    case DapNetworkModel::FieldId::address              :  return a_item.address;
    case DapNetworkModel::FieldId::activeLinksCount     :  return a_item.activeLinksCount;
    case DapNetworkModel::FieldId::linksCount           :  return a_item.linksCount;
    case DapNetworkModel::FieldId::syncPercent          :  return a_item.syncPercent;
    case DapNetworkModel::FieldId::errorMessage         :  return a_item.errorMessage;
    case DapNetworkModel::FieldId::displayNetworkState  :  return a_item.displayNetworkState;
    case DapNetworkModel::FieldId::displayTargetState   :  return a_item.displayTargetState;
    }

    return QVariant();
}

void DapNetworkModel::_setValue (DapNetworkModel::Item &a_item, int a_fieldId, const QVariant &a_value)
{
    switch (DapNetworkModel::FieldId (a_fieldId))
    {
    case DapNetworkModel::FieldId::invalid: break;

    case DapNetworkModel::FieldId::networkName          :  a_item.networkName          = a_value.toString(); break;
    case DapNetworkModel::FieldId::networkState         :  a_item.networkState         = a_value.toString(); break;
    case DapNetworkModel::FieldId::targetState          :  a_item.targetState          = a_value.toString(); break;
    case DapNetworkModel::FieldId::address              :  a_item.address              = a_value.toString(); break;
    case DapNetworkModel::FieldId::activeLinksCount     :  a_item.activeLinksCount     = a_value.toString(); break;
    case DapNetworkModel::FieldId::linksCount           :  a_item.linksCount           = a_value.toString(); break;
    case DapNetworkModel::FieldId::syncPercent          :  a_item.syncPercent          = a_value.toString(); break;
    case DapNetworkModel::FieldId::errorMessage         :  a_item.errorMessage         = a_value.toString(); break;
    case DapNetworkModel::FieldId::displayNetworkState  :  a_item.displayNetworkState  = a_value.toString(); break;
    case DapNetworkModel::FieldId::displayTargetState   :  a_item.displayTargetState   = a_value.toString(); break;
    }
}

/********************************************
 * OPERATORS
 *******************************************/

QVariant DapNetworkModel::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapNetworkModel::operator[] (int a_index) const
{
    return get (a_index);
}

DapNetworkModel &DapNetworkModel::operator= (const DapNetworkModel &a_src)
{
    *m_items  = *a_src.m_items;
    return *this;
}

DapNetworkModel &DapNetworkModel::operator= (DapNetworkModel &&a_src)
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

DapNetworkModel::Item _dummy()
{
    return DapNetworkModel::Item();
}

/********************************************
 * ITEM BRIDGE
 *******************************************/

ItemNetworkModelBridge::ItemNetworkModelBridge (ItemNetworkModelBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemNetworkModelBridge::nameChanged);
    connect (d->model, &QAbstractTableModel::dataChanged,
            this, &ItemNetworkModelBridge::statusProtectChanged);
}

ItemNetworkModelBridge::ItemNetworkModelBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemNetworkModelBridge::ItemNetworkModelBridge (const ItemNetworkModelBridge &a_src)
{
    operator = (a_src);
}

ItemNetworkModelBridge::ItemNetworkModelBridge (ItemNetworkModelBridge &&a_src)
{
    operator = (std::move (a_src));
}

ItemNetworkModelBridge::~ItemNetworkModelBridge()
{
    delete d;
}

/* METHODS */

QString ItemNetworkModelBridge::networkName() const
{
    return (d && d->item) ? d->item->networkName : QString();
}

void ItemNetworkModelBridge::setNetworkName(const QString &networkName)
{
    if (!_beginSetValue())
        return;
    d->item->networkName = networkName;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::networkState() const
{
    return (d && d->item) ? d->item->networkState : QString();
}

void ItemNetworkModelBridge::setNetworkState(const QString &networkState)
{
    if (!_beginSetValue())
        return;
    d->item->networkState = networkState;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::targetState() const
{
    return (d && d->item) ? d->item->targetState : QString();
}

void ItemNetworkModelBridge::setTargetState(const QString &targetState)
{
    if (!_beginSetValue())
        return;
    d->item->targetState = targetState;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::address() const
{
    return (d && d->item) ? d->item->address : QString();
}

void ItemNetworkModelBridge::setAddress(const QString &address)
{
    if (!_beginSetValue())
        return;
    d->item->address = address;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::activeLinksCount() const
{
    return (d && d->item) ? d->item->activeLinksCount : QString();
}

void ItemNetworkModelBridge::setActiveLinksCount(const QString &activeLinksCount)
{
    if (!_beginSetValue())
        return;
    d->item->activeLinksCount = activeLinksCount;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::linksCount() const
{
    return (d && d->item) ? d->item->linksCount : QString();
}

void ItemNetworkModelBridge::setLinksCount(const QString &linksCount)
{
    if (!_beginSetValue())
        return;
    d->item->linksCount = linksCount;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::syncPercent() const
{
    return (d && d->item) ? d->item->syncPercent : QString();
}

void ItemNetworkModelBridge::setSyncPercent(const QString &syncPercent)
{
    if (!_beginSetValue())
        return;
    d->item->syncPercent = syncPercent;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::errorMessage() const
{
    return (d && d->item) ? d->item->errorMessage : QString();
}

void ItemNetworkModelBridge::setErrorMessage(const QString &errorMessage)
{
    if (!_beginSetValue())
        return;
    d->item->errorMessage = errorMessage;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::displayNetworkState() const
{
    return (d && d->item) ? d->item->displayNetworkState : QString();
}

void ItemNetworkModelBridge::setDisplayNetworkState(const QString &displayNetworkState)
{
    if (!_beginSetValue())
        return;
    d->item->displayNetworkState = displayNetworkState;
    emit nameChanged();
    _endSetValue();
}

QString ItemNetworkModelBridge::displayTargetState() const
{
    return (d && d->item) ? d->item->displayTargetState : QString();
}

void ItemNetworkModelBridge::setDisplayTargetState(const QString &displayTargetState)
{
    if (!_beginSetValue())
        return;
    d->item->displayTargetState = displayTargetState;
    emit nameChanged();
    _endSetValue();
}

bool ItemNetworkModelBridge::_beginSetValue()
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

void ItemNetworkModelBridge::_endSetValue()
{
    emit d->model->dataChanged (d->begin, d->end);
}

QVariant ItemNetworkModelBridge::operator[] (const QString &a_valueName)
{
    if (!d || !d->model || !d->item)
        return QVariant();

    int fieldId = d->model->fieldId (a_valueName);


    switch (DapNetworkModel::FieldId (fieldId))
    {
    case DapNetworkModel::FieldId::networkName          :  return networkName(); break;
    case DapNetworkModel::FieldId::networkState         :  return networkState(); break;
    case DapNetworkModel::FieldId::targetState          :  return targetState(); break;
    case DapNetworkModel::FieldId::address              :  return address(); break;
    case DapNetworkModel::FieldId::activeLinksCount     :  return activeLinksCount(); break;
    case DapNetworkModel::FieldId::linksCount           :  return linksCount(); break;
    case DapNetworkModel::FieldId::syncPercent          :  return syncPercent(); break;
    case DapNetworkModel::FieldId::errorMessage         :  return errorMessage(); break;
    case DapNetworkModel::FieldId::displayNetworkState  :  return displayNetworkState(); break;
    case DapNetworkModel::FieldId::displayTargetState   :  return displayTargetState(); break;

    case DapNetworkModel::FieldId::invalid:
    default:
        break;
    }

    return QVariant();
}

DapNetworkModel::Item &DapNetworkModel::Item::operator=(const NetworkInfo &other)
{
    this->networkName = other.networkName;
    this->networkState = other.networkState;
    this->targetState = other.targetState;
    this->address = other.address;
    this->activeLinksCount = other.activeLinksCount;
    this->linksCount = other.linksCount;
    this->syncPercent = other.syncPercent;
    this->errorMessage = other.errorMessage;
    this->displayNetworkState = other.displayNetworkState;
    this->displayTargetState = other.displayTargetState;
    return *this;
}
ItemNetworkModelBridge::ItemNetworkModelBridge (const NetworkInfo& a_item)
{
    operator = (a_item);
}
// ItemNetworkModelBridge &ItemNetworkModelBridge::operator = (const NetworkInfo &&other)
// {
//     d->item->networkName = other.networkName;
//     d->item->networkState = other.networkState;
//     d->item->targetState = other.targetState;
//     d->item->address = other.address;
//     d->item->activeLinksCount = other.activeLinksCount;
//     d->item->linksCount = other.linksCount;
//     d->item->syncPercent = other.syncPercent;
//     d->item->errorMessage = other.errorMessage;
//     d->item->displayNetworkState = other.displayNetworkState;
//     d->item->displayTargetState = other.displayTargetState;
//     return *this;
// }

ItemNetworkModelBridge &ItemNetworkModelBridge::operator =(const ItemNetworkModelBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemNetworkModelBridge &ItemNetworkModelBridge::operator =(ItemNetworkModelBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}

/*-----------------------------------------*/
