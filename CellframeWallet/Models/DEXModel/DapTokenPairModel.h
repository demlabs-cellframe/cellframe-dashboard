#pragma once

#include <QAbstractTableModel>
#include "DEXTypes.h"

/* DEFS */
class DapTokenPairModel;

class ItemTokenPairBridge : public QObject
{
    Q_OBJECT

    friend class DapTokenPairModel;

protected:
    struct Data;

    Q_PROPERTY (QString change        READ change       NOTIFY changeChanged)
    Q_PROPERTY (QString network       READ network      NOTIFY networkChanged)
    Q_PROPERTY (QString rate          READ rate         NOTIFY rateChanged)
    Q_PROPERTY (QString token1        READ token1       NOTIFY token1Changed)
    Q_PROPERTY (QString token2        READ token2       NOTIFY token2Changed)
    Q_PROPERTY (QString displayText   READ displayText  NOTIFY displayTextChanged)


protected:
    Data *d;

protected:
    ItemTokenPairBridge (Data *a_data);
public:
    ItemTokenPairBridge (QObject *a_parent = nullptr);
    ItemTokenPairBridge (const ItemTokenPairBridge &a_src);
    ItemTokenPairBridge (ItemTokenPairBridge &&a_src);
    ~ItemTokenPairBridge();

public:
    Q_INVOKABLE QString change() const;
    Q_INVOKABLE QString network() const;
    Q_INVOKABLE QString rate() const;
    Q_INVOKABLE QString token1() const;
    Q_INVOKABLE QString token2() const;
    Q_INVOKABLE QString displayText() const;

signals:
    void changeChanged();
    void networkChanged();
    void rateChanged();
    void token1Changed();
    void token2Changed();
    void displayTextChanged();

public:
    ItemTokenPairBridge &operator = (const ItemTokenPairBridge &a_src);
    ItemTokenPairBridge &operator = (ItemTokenPairBridge &&a_src);
};
Q_DECLARE_METATYPE (ItemTokenPairBridge);

class DapTokenPairModel : public QAbstractTableModel
{
    Q_OBJECT

    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

public:
    enum class FieldId
    {
        invalid = -1,
        displayText = Qt::DisplayRole,
        token1     = Qt::UserRole,
        token2,
        network,
        change,
        rate
    };
    Q_ENUM(FieldId)

    struct Item
    {
        QString displayText = "";
        QString token1 = "";
        QString token2 = "";
        QString network = "";
        QString change = "";
        QString rate = "";

        Item& operator=(const DEX::InfoTokenPair& other)
        {
            displayText = other.displayText;
            token1 = other.token1;
            token2 = other.token2;
            network = other.network;
            change = other.change;
            rate = other.rate;
            return *this;
        }
    };

    typedef QList<DapTokenPairModel::Item>::Iterator Iterator;
    typedef QList<DapTokenPairModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapTokenPairModel (QObject *a_parent = nullptr);
    explicit DapTokenPairModel (const DapTokenPairModel &a_src);
    explicit DapTokenPairModel (DapTokenPairModel &&a_src);
    ~DapTokenPairModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public:
    void updateModel(const QList<DEX::InfoTokenPair> &data);
    void updateModel(const DEX::InfoTokenPair &data);
    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapTokenPairModel::Item &a_item) const;

    /// access item by index
    Q_INVOKABLE const DapTokenPairModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapTokenPairModel::Item value (int a_index) const;
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
    /// replace item by index
    Q_INVOKABLE void set (int a_index, const DapTokenPairModel::Item &a_item);
    /// emplace item by index
    Q_INVOKABLE void set (int a_index, DapTokenPairModel::Item &&a_item);

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapTokenPairModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();
protected:
    /// get item by index
    DapTokenPairModel::Item &_get (int a_index);
    const DapTokenPairModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapTokenPairModel::Item &a_item, int a_fieldId);
    static void _setValue (DapTokenPairModel::Item &a_item, int a_fieldId, const QVariant &a_value);

signals:
    void sizeChanged();
    void sigSizeChanged (int a_newSize);
    void sigItemAdded (int a_itemIndex);
    void sigItemRemoved (int a_itemIndex);
    void sigItemChanged (int a_itemIndex);

public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapTokenPairModel &operator= (const DapTokenPairModel &a_src);
    Q_INVOKABLE DapTokenPairModel &operator= (DapTokenPairModel &&a_src);
protected:
    QList<DapTokenPairModel::Item> m_items;
};
