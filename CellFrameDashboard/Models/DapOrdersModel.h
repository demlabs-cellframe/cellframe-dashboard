#ifndef DAPORDERSMODEL_H
#define DAPORDERSMODEL_H

#include <QAbstractTableModel>

class DapOrdersModel;

class ItemOrdersBridge : public QObject
{
    Q_OBJECT

    friend class DapOrdersModel;

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

    Q_PROPERTY (QString hash           READ hash          WRITE setHash           NOTIFY hashChanged          )
    Q_PROPERTY (QString network        READ network       WRITE setNetwork        NOTIFY networkChanged       )

    //VPN and Stake orders properties
    Q_PROPERTY (QString version        READ version       WRITE setVersion        NOTIFY versionChanged       )
    Q_PROPERTY (QString direction      READ direction     WRITE setDirection      NOTIFY directionChanged     )
    Q_PROPERTY (QString created        READ created       WRITE setCreated        NOTIFY createdChanged       )
    Q_PROPERTY (QString srv_uid        READ srv_uid       WRITE setSrv_uid        NOTIFY srv_uidChanged       )
    Q_PROPERTY (QString price          READ price         WRITE setPrice          NOTIFY priceChanged         )
    Q_PROPERTY (QString price_unit     READ price_unit    WRITE setPrice_unit     NOTIFY price_unitChanged    )
    Q_PROPERTY (QString price_token    READ price_token   WRITE setPrice_token    NOTIFY price_tokenChanged   )
    Q_PROPERTY (QString node_addr      READ node_addr     WRITE setNode_addr      NOTIFY node_addrChanged     )
    Q_PROPERTY (QString node_location  READ node_location WRITE setNode_location  NOTIFY node_locationChanged )
    Q_PROPERTY (QString tx_cond_hash   READ tx_cond_hash  WRITE setTx_cond_hash   NOTIFY tx_cond_hashChanged  )
    Q_PROPERTY (QString ext            READ ext           WRITE setExt            NOTIFY extChanged           )
    Q_PROPERTY (QString pkey           READ pkey          WRITE setPkey           NOTIFY pkeyChanged          )
    Q_PROPERTY (QString units          READ units         WRITE setUnits          NOTIFY unitsChanged         )

    //DEX orders properties
    Q_PROPERTY (QString status     READ status        WRITE setStatus      NOTIFY statusChanged      )
    Q_PROPERTY (QString amount     READ amount        WRITE setAmount      NOTIFY amountChanged      )
    Q_PROPERTY (QString buyToken   READ buyToken      WRITE setBuyToken    NOTIFY buyTokenChanged    )
    Q_PROPERTY (QString sellToken  READ sellToken     WRITE setSellToken   NOTIFY sellTokenChanged   )
    Q_PROPERTY (QString rate       READ rate          WRITE setRate        NOTIFY rateChanged        )
    Q_PROPERTY (QString filled     READ filled        WRITE setFilled      NOTIFY filledChanged      )
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
    ItemOrdersBridge (Data *a_data);
public:
    ItemOrdersBridge (QObject *a_parent = nullptr);
    ItemOrdersBridge (const ItemOrdersBridge &a_src);
    ItemOrdersBridge (ItemOrdersBridge &&a_src);
    ~ItemOrdersBridge();
    /// @}

    /****************************************//**
   * @name METHODS
   *******************************************/
    /// @{
public:
    Q_INVOKABLE QString hash() const;
    Q_INVOKABLE void setHash (const QString &hash);

    Q_INVOKABLE QString network() const;
    Q_INVOKABLE void setNetwork (const QString &network);

    Q_INVOKABLE QString version() const;
    Q_INVOKABLE void setVersion (const QString &version);

    Q_INVOKABLE QString direction() const;
    Q_INVOKABLE void setDirection (const QString &direction);

    Q_INVOKABLE QString created() const;
    Q_INVOKABLE void setCreated (const QString &created);

    Q_INVOKABLE QString srv_uid() const;
    Q_INVOKABLE void setSrv_uid (const QString &srv_uid);

    Q_INVOKABLE QString price() const;
    Q_INVOKABLE void setPrice (const QString &price);

    Q_INVOKABLE QString price_unit() const;
    Q_INVOKABLE void setPrice_unit (const QString &price_unit);

    Q_INVOKABLE QString price_token() const;
    Q_INVOKABLE void setPrice_token (const QString &price_token);

    Q_INVOKABLE QString node_addr() const;
    Q_INVOKABLE void setNode_addr (const QString &node_addr);

    Q_INVOKABLE QString node_location() const;
    Q_INVOKABLE void setNode_location (const QString &node_location);

    Q_INVOKABLE QString tx_cond_hash() const;
    Q_INVOKABLE void setTx_cond_hash (const QString &tx_cond_hash);

    Q_INVOKABLE QString ext() const;
    Q_INVOKABLE void setExt (const QString &ext);

    Q_INVOKABLE QString pkey() const;
    Q_INVOKABLE void setPkey (const QString &pkey);

    Q_INVOKABLE QString units() const;
    Q_INVOKABLE void setUnits (const QString &units);

    Q_INVOKABLE QString status() const;
    Q_INVOKABLE void setStatus (const QString &status);

    Q_INVOKABLE QString amount() const;
    Q_INVOKABLE void setAmount (const QString &amount);

    Q_INVOKABLE QString buyToken() const;
    Q_INVOKABLE void setBuyToken (const QString &buyToken);

    Q_INVOKABLE QString sellToken() const;
    Q_INVOKABLE void setSellToken (const QString &sellToken);

    Q_INVOKABLE QString rate() const;
    Q_INVOKABLE void setRate (const QString &rate);

    Q_INVOKABLE QString filled() const;
    Q_INVOKABLE void setFilled (const QString &filled);
protected:
    bool _beginSetValue();
    void _endSetValue();
    /// @}

    /****************************************//**
   * @name SIGNALS
   *******************************************/
    /// @{
signals:
    void hashChanged();
    void networkChanged();
    void versionChanged();
    void directionChanged();
    void createdChanged();
    void srv_uidChanged();
    void priceChanged();
    void price_unitChanged();
    void price_tokenChanged();
    void node_addrChanged();
    void node_locationChanged();
    void tx_cond_hashChanged();
    void extChanged();
    void pkeyChanged();
    void unitsChanged();
    void rateChanged();
    void buyTokenChanged();
    void amountChanged();
    void sellTokenChanged();
    void statusChanged();
    void filledChanged();
    /// @}

    /****************************************//**
   * @name OPERATORS
   *******************************************/
    /// @{
public:
    QVariant operator [] (const QString &a_valueName);
    ItemOrdersBridge &operator = (const ItemOrdersBridge &a_src);
    ItemOrdersBridge &operator = (ItemOrdersBridge &&a_src);
    /// @}
};
Q_DECLARE_METATYPE (ItemOrdersBridge);

class DapOrdersModel : public QAbstractTableModel
{
    Q_OBJECT

    friend class Rules;

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
        invalid    = -1,
        hash       = Qt::DisplayRole,
        network    = Qt::UserRole,
        version,
        direction,
        created,
        srv_uid,
        price,
        price_unit,
        price_token,
        node_addr,
        node_location,
        tx_cond_hash,
        ext,
        pkey,
        units,
        rate,
        buyToken,
        amount,
        sellToken,
        status,
        filled
    };
    Q_ENUM(FieldId)

    /// history data
    struct Item
    {
        QString hash;
        QString network;
        QString version;
        QString direction;
        QString created;
        QString srv_uid;
        QString price;
        QString price_unit;
        QString price_token;
        QString node_addr;
        QString node_location;
        QString tx_cond_hash;
        QString ext;
        QString pkey;
        QString units;
        QString status;
        QString amount;
        QString buyToken;
        QString sellToken;
        QString rate;
        QString filled;
    };

    typedef QList<DapOrdersModel::Item>::Iterator Iterator;
    typedef QList<DapOrdersModel::Item>::ConstIterator ConstIterator;
    /// @}

    /****************************************//**
   * @name VARS
   *******************************************/
    /// @{
protected:
    QList<DapOrdersModel::Item> *m_items;
    /// @}

    /****************************************//**
   * @name CONSTRUCT/DESTRUCT
   *******************************************/
    /// @{
public:
    explicit DapOrdersModel (QObject *a_parent = nullptr);
    explicit DapOrdersModel (const DapOrdersModel &a_src);
    explicit DapOrdersModel (DapOrdersModel &&a_src);
    ~DapOrdersModel();
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
    Q_INVOKABLE static DapOrdersModel *global();
    /// add new item to the end
    Q_INVOKABLE int add (const DapOrdersModel::Item &a_item);
    /// add new item in the middle of the list
    Q_INVOKABLE void insert(int a_index, const DapOrdersModel::Item &a_item);
    /// remove one item
    Q_INVOKABLE void remove (int a_index);
    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapOrdersModel::Item &a_item) const;
    /// access item by index
    Q_INVOKABLE const DapOrdersModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapOrdersModel::Item value (int a_index) const;
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
    Q_INVOKABLE void set (int a_index, const DapOrdersModel::Item &a_item);
    /// emplace item by index
    Q_INVOKABLE void set (int a_index, DapOrdersModel::Item &&a_item);
    //  /// get item field value
    //  Q_INVOKABLE QVariant getValue (int a_index, int a_fieldId) const;
    //  /// set item field value
    //  Q_INVOKABLE void setValue (int a_index, int a_fieldId, const QVariant &a_value);
    //  /// get item field value
    //  Q_INVOKABLE QVariant getProperty (int a_index, const QString &a_fieldName) const;
    //  /// set item field value
    //  Q_INVOKABLE void setProperty (int a_index, const QString &a_fieldName, const QVariant &a_value);
    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapOrdersModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();
protected:
    /// get item by index
    DapOrdersModel::Item &_get (int a_index);
    const DapOrdersModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapOrdersModel::Item &a_item, int a_fieldId);
    static void _setValue (DapOrdersModel::Item &a_item, int a_fieldId, const QVariant &a_value);
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
    Q_INVOKABLE DapOrdersModel &operator= (const DapOrdersModel &a_src);
    Q_INVOKABLE DapOrdersModel &operator= (DapOrdersModel &&a_src);
    /// @}

};

#endif // DAPORDERSMODEL_H
