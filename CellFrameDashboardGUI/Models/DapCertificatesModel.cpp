#include "DapCertificatesModel.h"

#include <QList>
#include <QMetaEnum>

struct ItemCertificatesBridge::Data
{
    DapCertificatesModel *model;
    DapCertificatesModel::Item *item;
    QModelIndex begin, end;

    Data (DapCertificatesModel *a_model, DapCertificatesModel::Item *a_item) : model (a_model), item (a_item) {}
    Data (const Data &a_src) = default;
    Data (Data &&a_src) = default;

    Data &operator =(const Data &a_src) = default;
    Data &operator =(Data &&a_src) = default;
};

static const QHash<QString, DapCertificatesModel::DapCertificatesModel::FieldId> s_fieldIdMap =
    {
        {"name", DapCertificatesModel::FieldId::name},
        {"sign", DapCertificatesModel::FieldId::sign},
        {"secondName", DapCertificatesModel::FieldId::secondName}
};

DapCertificatesModel::DapCertificatesModel (QObject *a_parent)
    : QAbstractTableModel (a_parent),
    m_items{
        {"Dylithium", "sig_dil", "Recommended"},
        {"Falcon", "sig_falcon", ""},
        {"Bliss", "sig_bliss", "Depricated"},
        {"Picnic", "sig_picnic", "Depricated"}
    }
{
    connect (this, &DapCertificatesModel::sigSizeChanged,
            this, [this]
            {
                emit sizeChanged();
            });
}

DapCertificatesModel::DapCertificatesModel (const DapCertificatesModel &a_src)
    : QAbstractTableModel (a_src.parent())
{
    operator= (a_src);
}

DapCertificatesModel::DapCertificatesModel (DapCertificatesModel &&a_src)
    : QAbstractTableModel (a_src.parent())
{
    operator= (a_src);
}

DapCertificatesModel::~DapCertificatesModel()
{
}

int DapCertificatesModel::rowCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_items.size();
}

int DapCertificatesModel::columnCount (const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return s_fieldIdMap.size();
}

QVariant DapCertificatesModel::data (const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    auto field        = DapCertificatesModel::FieldId (role);
    const auto &item  = m_items.at (index.row());
    return _getValue (item, int (field));
}

QHash<int, QByteArray> DapCertificatesModel::roleNames() const
{
    static QHash<int, QByteArray> names;

    if (names.isEmpty())
        for (auto i = s_fieldIdMap.cbegin(), e = s_fieldIdMap.cend(); i != e; i++)
            names[int (i.value())] = i.key().toUtf8();

    return names;
}

void DapCertificatesModel::setItems(const QList<DapCertificatesModel::Item> &items)
{
    beginResetModel();
    m_items = items;
    endResetModel();
    emit dataChanged(index(0, 0), index(m_items.size(), 0));
    emit sizeChanged();
}

int DapCertificatesModel::indexOf (const DapCertificatesModel::Item &a_item) const
{
    int index = 0;

    for (auto i = m_items.cbegin(), e = m_items.cend(); i != e; i++, index++)
        if (i->name == a_item.name && i->secondName == a_item.secondName && i->sign == a_item.sign)
            return index;

    return -1;
}

const DapCertificatesModel::Item &DapCertificatesModel::at (int a_index) const
{
    return const_cast<DapCertificatesModel *> (this)->_get (a_index);
}

DapCertificatesModel::Item DapCertificatesModel::value (int a_index) const
{
    return at (a_index);
}

int DapCertificatesModel::size() const
{
    return m_items.size();
}

bool DapCertificatesModel::isEmpty() const
{
    return 0 == m_items.size();
}

void DapCertificatesModel::clear()
{
    beginResetModel();

    {
        m_items.clear();
        emit sigSizeChanged (size());
    }

    endResetModel();
}

QVariant DapCertificatesModel::get (int a_index)
{
    return QVariant::fromValue (new ItemCertificatesBridge (new ItemCertificatesBridge::Data (this, &_get (a_index))));
}

const QVariant DapCertificatesModel::get(int a_index) const
{
    return const_cast<DapCertificatesModel*>(this)->get (a_index);
}

DapCertificatesModel::Item &DapCertificatesModel::_get(int a_index)
{
    static DapCertificatesModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {
        dummy = DapCertificatesModel::Item();
        return dummy;
    }

    return m_items[a_index];
}

const DapCertificatesModel::Item &DapCertificatesModel::_get(int a_index) const
{
    return const_cast<DapCertificatesModel*>(this)->_get (a_index);
}

int DapCertificatesModel::fieldId (const QString &a_fieldName) const
{
    return int (s_fieldIdMap.value (a_fieldName, DapCertificatesModel::FieldId::invalid));
}

const DapCertificatesModel::Item &DapCertificatesModel::getItem(int a_index) const
{
    static DapCertificatesModel::Item dummy;

    if (a_index < 0 || a_index >= m_items.size())
    {
        dummy = DapCertificatesModel::Item();
        return dummy;
    }

    return m_items[a_index];
}

DapCertificatesModel::Iterator DapCertificatesModel::begin()
{
    return m_items.begin();
}

DapCertificatesModel::ConstIterator DapCertificatesModel::cbegin() const
{
    return m_items.cbegin();
}

DapCertificatesModel::Iterator DapCertificatesModel::end()
{
    return m_items.end();
}

DapCertificatesModel::ConstIterator DapCertificatesModel::cend()
{
    return m_items.cend();
}

QVariant DapCertificatesModel::_getValue (const DapCertificatesModel::Item &a_item, int a_fieldId)
{
    switch (DapCertificatesModel::FieldId (a_fieldId))
    {
        case DapCertificatesModel::FieldId::invalid:    break;
        case DapCertificatesModel::FieldId::name:       return a_item.name;
        case DapCertificatesModel::FieldId::sign:        return a_item.sign;
        case DapCertificatesModel::FieldId::secondName: return a_item.secondName;
    }

    return QVariant();
}

QVariant DapCertificatesModel::operator[] (int a_index)
{
    return get (a_index);
}

const QVariant DapCertificatesModel::operator[] (int a_index) const
{
    return get (a_index);
}

DapCertificatesModel &DapCertificatesModel::operator= (const DapCertificatesModel &a_src)
{
    m_items  = a_src.m_items;
    return *this;
}

DapCertificatesModel &DapCertificatesModel::operator= (DapCertificatesModel &&a_src)
{
    if (this != &a_src)
    {
        m_items       = a_src.m_items;
    }
    return *this;
}

ItemCertificatesBridge::ItemCertificatesBridge (ItemCertificatesBridge::Data *a_data)
    : d (a_data)
{
    if (!d || !d->model)
        return;
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemCertificatesBridge::nameChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemCertificatesBridge::signChanged);
    connect (d->model, &QAbstractTableModel::dataChanged, this, &ItemCertificatesBridge::secondNameChanged);
}

ItemCertificatesBridge::ItemCertificatesBridge (QObject *a_parent)
    : QObject (a_parent)
    , d (nullptr)
{

}

ItemCertificatesBridge::ItemCertificatesBridge (const ItemCertificatesBridge &a_src)
    : QObject ()
{
    operator = (a_src);
}

ItemCertificatesBridge::ItemCertificatesBridge (ItemCertificatesBridge &&a_src)
    : QObject ()
{
    operator = (std::move (a_src));
}

ItemCertificatesBridge::~ItemCertificatesBridge()
{
    delete d;
}

QString ItemCertificatesBridge::name() const
{
    return (d && d->item) ? d->item->name : QString();
}

QString ItemCertificatesBridge::sign() const
{
    return (d && d->item) ? d->item->sign : QString();
}

QString ItemCertificatesBridge::secondName() const
{
    return (d && d->item) ? d->item->secondName : QString();
}


ItemCertificatesBridge &ItemCertificatesBridge::operator =(const ItemCertificatesBridge &a_src)
{
    if (this != &a_src)
        d = new Data (*a_src.d);
    return *this;
}

ItemCertificatesBridge &ItemCertificatesBridge::operator =(ItemCertificatesBridge &&a_src)
{
    if (this != &a_src)
    {
        d = std::move (a_src.d);
        a_src.d = nullptr;
    }
    return *this;
}
