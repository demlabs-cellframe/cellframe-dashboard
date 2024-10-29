#pragma once

#include <QAbstractTableModel>

/* DEFS */
class DapStringListModel;

class ItemStringListBridge : public QObject
{
    Q_OBJECT

    friend class DapStringListModel;

protected:
    struct Data;

    Q_PROPERTY (QString name   READ name    NOTIFY nameChanged)

protected:
    Data *d;

protected:
    ItemStringListBridge (Data *a_data);
public:
    ItemStringListBridge (QObject *a_parent = nullptr);
    ItemStringListBridge (const ItemStringListBridge &a_src);
    ItemStringListBridge (ItemStringListBridge &&a_src);
    ~ItemStringListBridge();

public:
    Q_INVOKABLE QString name() const;

signals:
    void nameChanged();

public:
    ItemStringListBridge &operator = (const ItemStringListBridge &a_src);
    ItemStringListBridge &operator = (ItemStringListBridge &&a_src);
};
Q_DECLARE_METATYPE (ItemStringListBridge);

class DapStringListModel : public QAbstractTableModel
{
    Q_OBJECT

    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

public:
    enum class FieldId
    {
        invalid = -1,
        name = Qt::DisplayRole
    };
    Q_ENUM(FieldId)

    struct Item
    {
        QString name = "";
    };

    typedef QList<DapStringListModel::Item>::Iterator Iterator;
    typedef QList<DapStringListModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapStringListModel (QObject *a_parent = nullptr);
    explicit DapStringListModel (const DapStringListModel &a_src);
    explicit DapStringListModel (DapStringListModel &&a_src);
    ~DapStringListModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setStringList(const QStringList &list);

    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapStringListModel::Item &a_item) const;

    /// access item by index
    Q_INVOKABLE const DapStringListModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapStringListModel::Item value (int a_index) const;
    /// get amount of users
    Q_INVOKABLE int size() const;
    /// get true if no users exists
    Q_INVOKABLE bool isEmpty() const;
    /// remove all users
    Q_INVOKABLE void clear();
    /// get item by index
    Q_INVOKABLE QVariant get(int a_index);
    /// get item by index
    Q_INVOKABLE const QVariant get (int a_index) const;

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapStringListModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();
protected:
    /// get item by index
    DapStringListModel::Item &_get (int a_index);
    const DapStringListModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapStringListModel::Item &a_item, int a_fieldId);

signals:
    void sizeChanged();
    void sigSizeChanged (int a_newSize);

public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapStringListModel &operator= (const DapStringListModel &a_src);
    Q_INVOKABLE DapStringListModel &operator= (DapStringListModel &&a_src);
protected:
    QList<DapStringListModel::Item> m_items;
};
