#ifndef DAPNETWORKSMODEL_H
#define DAPNETWORKSMODEL_H

#include "QAbstractTableModel"

class DapNetworksModel;

class ItemNetworksModelBridge : public QObject
{
    Q_OBJECT

    friend class DapNetworksModel;

    /****************************************//**
   * @name DEFS
   *******************************************/
    /// @{
protected:
    struct Data;
    /// @}

    /****************************************//**
   * @name PROPERTIES
   *******************************************/
    /// @{
    Q_PROPERTY (QString networkName     READ networkName     WRITE setNetworkName)
    Q_PROPERTY (QString networkState   READ networkState   WRITE setNetworkState)
    Q_PROPERTY (QString targetState     READ targetState     WRITE setTargetState )
    Q_PROPERTY (QString address   READ address   WRITE setAddress)
    Q_PROPERTY (QString activeLinksCount     READ activeLinksCount     WRITE setActiveLinksCount)
    Q_PROPERTY (QString linksCount   READ linksCount   WRITE setLinksCount)
    /// @}

    /****************************************//**
   * @name VARS
   *******************************************/
    /// @{
protected:
    Data *d;
    /// @}

    /****************************************//**
   * @name CONSTRUCT/DESTRUCT
   *******************************************/
    /// @{
protected:
    ItemNetworksModelBridge (Data *a_data);
public:
    ItemNetworksModelBridge (QObject *a_parent = nullptr);
    ItemNetworksModelBridge (const ItemNetworksModelBridge &a_src);
    ItemNetworksModelBridge (ItemNetworksModelBridge &&a_src);
    ~ItemNetworksModelBridge();
    /// @}

    /****************************************//**
   * @name METHODS
   *******************************************/
    /// @{
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

protected:
    bool _beginSetValue();
    void _endSetValue();
    /// @}

    /****************************************//**
   * @name SIGNALS
   *******************************************/
    /// @{
signals:
    void nameChanged();
    void statusProtectChanged();
    /// @}

    /****************************************//**
   * @name OPERATORS
   *******************************************/
    /// @{
public:
    QVariant operator [] (const QString &a_valueName);
    ItemNetworksModelBridge &operator = (const ItemNetworksModelBridge &a_src);
    ItemNetworksModelBridge &operator = (ItemNetworksModelBridge &&a_src);
    /// @}
};
Q_DECLARE_METATYPE (ItemNetworksModelBridge);

class DapNetworksModel : public QAbstractTableModel
{
    Q_OBJECT

    /****************************************//**
   * @name PROPERTIES
   *******************************************/
    /// @{
    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)
    /// @}

    /****************************************//**
   * @name DEFS
   *******************************************/
    /// @{
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
        linksCount
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
    };

    typedef QList<DapNetworksModel::Item>::Iterator Iterator;
    typedef QList<DapNetworksModel::Item>::ConstIterator ConstIterator;
    /// @}

    /****************************************//**
   * @name VARS
   *******************************************/
    /// @{
protected:
    QList<DapNetworksModel::Item> *m_items;
    /// @}

    /****************************************//**
   * @name CONSTRUCT/DESTRUCT
   *******************************************/
    /// @{
public:
    explicit DapNetworksModel (QObject *a_parent = nullptr);
    explicit DapNetworksModel (const DapNetworksModel &a_src);
    explicit DapNetworksModel (DapNetworksModel &&a_src);
    ~DapNetworksModel();
    /// @}

    /****************************************//**
   * @name OVERRIDE
   *******************************************/
    /// @{
public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;
    /// @}

    /****************************************//**
   * @name METHODS
   *******************************************/
    /// @{
public:
    /// get global singleton instance
    // Q_INVOKABLE static DapNetworkList *global();

    Q_INVOKABLE bool updateNetworksInfo(const QVariant& networksStateList);

    /// add new item to the end
    Q_INVOKABLE int add (const DapNetworksModel::Item &a_item);
    /// add new item in the middle of the list
    Q_INVOKABLE void insert(int a_index, const DapNetworksModel::Item &a_item);
    /// remove one item
    Q_INVOKABLE void remove (int a_index);
    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapNetworksModel::Item &a_item) const;

    /// access item by index
    Q_INVOKABLE const DapNetworksModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapNetworksModel::Item value (int a_index) const;
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
    Q_INVOKABLE void set (int a_index, const DapNetworksModel::Item &a_item);
    /// emplace item by index
    Q_INVOKABLE void set (int a_index, DapNetworksModel::Item &&a_item);

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapNetworksModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();
protected:
    /// get item by index
    DapNetworksModel::Item &_get (int a_index);
    const DapNetworksModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapNetworksModel::Item &a_item, int a_fieldId);
    static void _setValue (DapNetworksModel::Item &a_item, int a_fieldId, const QVariant &a_value);
    /// @}

    /****************************************//**
   * @name SIGNALS
   *******************************************/
    /// @{
signals:
    void sizeChanged(); ///< used to notify. not same as sigSizeChanged
    void sigSizeChanged (int a_newSize);
    void sigItemAdded (int a_itemIndex);
    void sigItemRemoved (int a_itemIndex);
    void sigItemChanged (int a_itemIndex);
    /// @}

    /****************************************//**
   * @name OPERATORS
   *******************************************/
    /// @{
public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapNetworksModel &operator= (const DapNetworksModel &a_src);
    Q_INVOKABLE DapNetworksModel &operator= (DapNetworksModel &&a_src);
    /// @}
};

/*-----------------------------------------*/

#endif // DapNetworkList_H
