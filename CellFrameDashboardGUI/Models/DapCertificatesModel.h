#pragma once

#include <QAbstractTableModel>

/* DEFS */
class DapCertificatesModel;

class ItemCertificatesBridge : public QObject
{
    Q_OBJECT

    friend class DapCertificatesModel;

protected:
    struct Data;

    Q_PROPERTY (QString name   READ name    NOTIFY nameChanged)
    Q_PROPERTY (QString sign   READ sign    NOTIFY signChanged)
    Q_PROPERTY (QString secondName   READ secondName    NOTIFY secondNameChanged)

protected:
    Data *d;

protected:
    ItemCertificatesBridge (Data *a_data);
public:
    ItemCertificatesBridge (QObject *a_parent = nullptr);
    ItemCertificatesBridge (const ItemCertificatesBridge &a_src);
    ItemCertificatesBridge (ItemCertificatesBridge &&a_src);
    ~ItemCertificatesBridge();

public:
    Q_INVOKABLE QString name() const;
    Q_INVOKABLE QString sign() const;
    Q_INVOKABLE QString secondName() const;

signals:
    void nameChanged();
    void signChanged();
    void secondNameChanged();

public:
    ItemCertificatesBridge &operator = (const ItemCertificatesBridge &a_src);
    ItemCertificatesBridge &operator = (ItemCertificatesBridge &&a_src);
};
Q_DECLARE_METATYPE (ItemCertificatesBridge);

class DapCertificatesModel : public QAbstractTableModel
{
    Q_OBJECT

    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

public:
    enum class FieldId
    {
        invalid = -1,
        name = Qt::DisplayRole,
        sign = Qt::UserRole + 1,
        secondName = Qt::UserRole + 2
    };
    Q_ENUM(FieldId)

    struct Item
    {
        QString name = "";
        QString sign = "";
        QString secondName = "";

        Item() = default;
        Item(const QString &n, const QString &s, const QString &sn) : name(n), sign(s), secondName(sn) {}
    };

    typedef QList<DapCertificatesModel::Item>::Iterator Iterator;
    typedef QList<DapCertificatesModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapCertificatesModel (QObject *a_parent = nullptr);
    explicit DapCertificatesModel (const DapCertificatesModel &a_src);
    explicit DapCertificatesModel (DapCertificatesModel &&a_src);
    ~DapCertificatesModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void setItems(const QList<DapCertificatesModel::Item> &items);

    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapCertificatesModel::Item &a_item) const;

    /// access item by index
    Q_INVOKABLE const DapCertificatesModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapCertificatesModel::Item value (int a_index) const;
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

    const DapCertificatesModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();
protected:
    /// get item by index
    DapCertificatesModel::Item &_get (int a_index);
    const DapCertificatesModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapCertificatesModel::Item &a_item, int a_fieldId);

signals:
    void sizeChanged();
    void sigSizeChanged (int a_newSize);

public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapCertificatesModel &operator= (const DapCertificatesModel &a_src);
    Q_INVOKABLE DapCertificatesModel &operator= (DapCertificatesModel &&a_src);
protected:
    QList<DapCertificatesModel::Item> m_items;
};
