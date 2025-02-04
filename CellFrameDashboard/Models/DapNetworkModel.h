#ifndef DAPNETWORKMODEL_H
#define DAPNETWORKMODEL_H

#include <QAbstractTableModel>
#include "DapNetworksTypes.h"

class DapNetworkModel;

class ItemNetworkModelBridge : public QObject
{
    Q_OBJECT

    friend class DapNetworkModel;

protected:
    struct Data;

    Q_PROPERTY (QString networkName          READ networkName          WRITE setNetworkName)
    Q_PROPERTY (QString networkState         READ networkState         WRITE setNetworkState)
    Q_PROPERTY (QString targetState          READ targetState          WRITE setTargetState )
    Q_PROPERTY (QString address              READ address              WRITE setAddress)
    Q_PROPERTY (QString activeLinksCount     READ activeLinksCount     WRITE setActiveLinksCount)
    Q_PROPERTY (QString linksCount           READ linksCount           WRITE setLinksCount)
    Q_PROPERTY (QString syncPercent          READ syncPercent          WRITE setSyncPercent)
    Q_PROPERTY (QString errorMessage         READ errorMessage         WRITE setErrorMessage)
    Q_PROPERTY (QString displayNetworkState  READ displayNetworkState  WRITE setDisplayNetworkState)
    Q_PROPERTY (QString displayTargetState   READ displayTargetState   WRITE setDisplayTargetState)

protected:
    Data *d;

protected:
    ItemNetworkModelBridge (Data *a_data);
public:
    ItemNetworkModelBridge (QObject *a_parent = nullptr);
    ItemNetworkModelBridge (const ItemNetworkModelBridge &a_src);
    ItemNetworkModelBridge (ItemNetworkModelBridge &&a_src);
    ItemNetworkModelBridge (const NetworkInfo& a_item);
    ~ItemNetworkModelBridge();

public:

    Q_INVOKABLE QString networkName() const;
    Q_INVOKABLE void setNetworkName(const QString &networkName);

    Q_INVOKABLE QString networkState() const;
    Q_INVOKABLE void setNetworkState(const QString &networkState);

    Q_INVOKABLE QString targetState() const;
    Q_INVOKABLE void setTargetState(const QString &targetState);

    Q_INVOKABLE QString address() const;
    Q_INVOKABLE void setAddress(const QString &address);

    Q_INVOKABLE QString activeLinksCount() const;
    Q_INVOKABLE void setActiveLinksCount(const QString &activeLinksCount);

    Q_INVOKABLE QString linksCount() const;
    Q_INVOKABLE void setLinksCount(const QString &linksCount);

    Q_INVOKABLE QString syncPercent() const;
    Q_INVOKABLE void setSyncPercent(const QString &linksCount);

    Q_INVOKABLE QString errorMessage() const;
    Q_INVOKABLE void setErrorMessage(const QString &linksCount);

    Q_INVOKABLE QString displayNetworkState() const;
    Q_INVOKABLE void setDisplayNetworkState(const QString &linksCount);

    Q_INVOKABLE QString displayTargetState() const;
    Q_INVOKABLE void setDisplayTargetState(const QString &linksCount);

protected:
    bool _beginSetValue();
    void _endSetValue();

signals:
    void nameChanged();
    void statusProtectChanged();

public:
    QVariant operator [] (const QString &a_valueName);
    ItemNetworkModelBridge &operator = (const ItemNetworkModelBridge &a_src);
    ItemNetworkModelBridge &operator = (ItemNetworkModelBridge &&a_src);

};
Q_DECLARE_METATYPE (ItemNetworkModelBridge);

class DapNetworkModel : public QAbstractTableModel
{
    Q_OBJECT

    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

public:
    // item fields
    enum class FieldId
    {
        invalid  = -1,
        networkName  = Qt::DisplayRole,
        networkState,
        targetState,
        address,
        activeLinksCount,
        linksCount,
        syncPercent,
        errorMessage,
        displayNetworkState,
        displayTargetState
    };
    Q_ENUM(FieldId)

    /// history data
    struct Item
    {
        QString networkName = "";
        QString networkState = "";
        QString targetState = "";
        QString address = "";
        QString activeLinksCount = "";
        QString linksCount = "";
        QString syncPercent = "";
        QString errorMessage = "";
        QString displayNetworkState = "";
        QString displayTargetState = "";


        Item &operator = (const NetworkInfo &other);
    };

    typedef QList<DapNetworkModel::Item>::Iterator Iterator;
    typedef QList<DapNetworkModel::Item>::ConstIterator ConstIterator;

protected:
    QList<DapNetworkModel::Item> *m_items;

public:
    explicit DapNetworkModel (QObject *a_parent = nullptr);
    explicit DapNetworkModel (const DapNetworkModel &a_src);
    explicit DapNetworkModel (DapNetworkModel &&a_src);
    ~DapNetworkModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public:
    Q_INVOKABLE bool updateNetworksInfo(const QVariant& networksStateList);

    /// add new item to the end
    Q_INVOKABLE int add(const NetworkInfo &a_item);

    void updateModel(const NetworkInfo &a_item);

    void updateListModel(const QStringList& netList);

    /// add new item in the middle of the list
    Q_INVOKABLE void insert(int a_index, const DapNetworkModel::Item &a_item);
    /// remove one item
    Q_INVOKABLE void remove (int a_index);
    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapNetworkModel::Item &a_item) const;

    /// access item by index
    Q_INVOKABLE const DapNetworkModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapNetworkModel::Item value (int a_index) const;
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
    Q_INVOKABLE void set (int a_index, const NetworkInfo &info);
    /// emplace item by index
    Q_INVOKABLE void set (int a_index, NetworkInfo &&a_item);

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapNetworkModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();
protected:
    /// get item by index
    DapNetworkModel::Item &_get (int a_index);
    const DapNetworkModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapNetworkModel::Item &a_item, int a_fieldId);
    static void _setValue (DapNetworkModel::Item &a_item, int a_fieldId, const QVariant &a_value);

signals:
    void sizeChanged(); ///< used to notify. not same as sigSizeChanged
    void sigSizeChanged (int a_newSize);
    void sigItemAdded (int a_itemIndex);
    void sigItemRemoved (int a_itemIndex);
    void sigItemChanged (int a_itemIndex);

public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapNetworkModel &operator= (const DapNetworkModel &a_src);
    Q_INVOKABLE DapNetworkModel &operator= (DapNetworkModel &&a_src);
};

#endif // DAPNETWORKMODEL_H
