#pragma once

#include <QAbstractTableModel>
#include "DEXTypes.h"

/* DEFS */
class DapTokensModel;

class ItemTokensListBridge : public QObject
{
    Q_OBJECT

    friend class DapTokensModel;

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
    ItemTokensListBridge (Data *a_data);
public:
    ItemTokensListBridge (QObject *a_parent = nullptr);
    ItemTokensListBridge (const ItemTokensListBridge &a_src);
    ItemTokensListBridge (ItemTokensListBridge &&a_src);
    ~ItemTokensListBridge();

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
    ItemTokensListBridge &operator = (const ItemTokensListBridge &a_src);
    ItemTokensListBridge &operator = (ItemTokensListBridge &&a_src);
};
Q_DECLARE_METATYPE (ItemTokensListBridge);

class DapTokensModel : public QAbstractTableModel
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

    typedef QList<DapTokensModel::Item>::Iterator Iterator;
    typedef QList<DapTokensModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapTokensModel (QObject *a_parent = nullptr);
    explicit DapTokensModel (const DapTokensModel &a_src);
    explicit DapTokensModel (DapTokensModel &&a_src);
    ~DapTokensModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public:
    void updateModel(const QList<DEX::InfoTokenPair> &data);
    void updateModel(const DEX::InfoTokenPair &data);
    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapTokensModel::Item &a_item) const;

    /// access item by index
    Q_INVOKABLE const DapTokensModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapTokensModel::Item value (int a_index) const;
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
    Q_INVOKABLE void set (int a_index, const DapTokensModel::Item &a_item);
    /// emplace item by index
    Q_INVOKABLE void set (int a_index, DapTokensModel::Item &&a_item);

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapTokensModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();
protected:
    /// get item by index
    DapTokensModel::Item &_get (int a_index);
    const DapTokensModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapTokensModel::Item &a_item, int a_fieldId);
    static void _setValue (DapTokensModel::Item &a_item, int a_fieldId, const QVariant &a_value);

signals:
    void sizeChanged();
    void sigSizeChanged (int a_newSize);
    void sigItemAdded (int a_itemIndex);
    void sigItemRemoved (int a_itemIndex);
    void sigItemChanged (int a_itemIndex);

public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapTokensModel &operator= (const DapTokensModel &a_src);
    Q_INVOKABLE DapTokensModel &operator= (DapTokensModel &&a_src);
protected:
    QList<DapTokensModel::Item> m_items;
};
