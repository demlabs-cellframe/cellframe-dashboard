#ifndef DAPHISTORYMODEL_H
#define DAPHISTORYMODEL_H

#include <QAbstractTableModel>
#include <QSet>

/* DEFS */
class DapHistoryModel;

class ItemHistoryBridge : public QObject
{
    Q_OBJECT

    friend class DapHistoryModel;

protected:
    struct Data;

    Q_PROPERTY (QString tx_status     READ tx_status     WRITE setTx_status     NOTIFY tx_statusChanged)
    Q_PROPERTY (QString tx_hash       READ tx_hash       WRITE setTx_hash       NOTIFY tx_hashChanged)
    Q_PROPERTY (QString atom          READ atom          WRITE setAtom          NOTIFY atomChanged)
    Q_PROPERTY (QString network       READ network       WRITE setNetwork       NOTIFY networkChanged)
    Q_PROPERTY (QString wallet_name   READ wallet_name   WRITE setWallet_name   NOTIFY wallet_nameChanged)
    Q_PROPERTY (QString date          READ date          WRITE setDate          NOTIFY dateChanged)
    Q_PROPERTY (qint64 date_to_secs   READ date_to_secs  WRITE setDate_to_secs  NOTIFY date_to_secsChanged)
    Q_PROPERTY (QString time          READ time          WRITE setTime          NOTIFY timeChanged)
    Q_PROPERTY (QString address       READ address       WRITE setAddress       NOTIFY addressChanged)
    Q_PROPERTY (QString status        READ status        WRITE setStatus        NOTIFY statusChanged)
    Q_PROPERTY (QString token         READ token         WRITE setToken         NOTIFY tokenChanged)
    Q_PROPERTY (QString direction     READ direction     WRITE setDirection     NOTIFY directionChanged)
    Q_PROPERTY (QString value         READ value         WRITE setValue         NOTIFY valueChanged)
    Q_PROPERTY (QString m_value       READ m_value       WRITE setM_Value       NOTIFY m_valueChanged)
    Q_PROPERTY (QString m_token       READ m_token       WRITE setM_token       NOTIFY m_tokenChanged)
    Q_PROPERTY (QString m_direction   READ m_direction   WRITE setM_direction   NOTIFY m_directionChanged)
    Q_PROPERTY (QString fee           READ fee           WRITE setFee           NOTIFY feeChanged)
    Q_PROPERTY (QString fee_token     READ fee_token     WRITE setFee_token     NOTIFY fee_tokenChanged)
    Q_PROPERTY (QString fee_net       READ fee_net       WRITE setFee_net       NOTIFY fee_netChanged)
    Q_PROPERTY (QString x_value       READ x_value       WRITE setX_Value       NOTIFY x_valueChanged)
    Q_PROPERTY (QString x_token       READ x_token       WRITE setX_token       NOTIFY x_tokenChanged)
    Q_PROPERTY (QString x_direction   READ x_direction   WRITE setX_direction   NOTIFY x_directionChanged)

protected:
    Data *d;

protected:
    ItemHistoryBridge (Data *a_data);
public:
    ItemHistoryBridge (QObject *a_parent = nullptr);
    ItemHistoryBridge (const ItemHistoryBridge &a_src);
    ItemHistoryBridge (ItemHistoryBridge &&a_src);
    ~ItemHistoryBridge();

public:
    Q_INVOKABLE QString tx_status() const;
    Q_INVOKABLE void setTx_status (const QString &tx_status);

    Q_INVOKABLE QString tx_hash() const;
    Q_INVOKABLE void setTx_hash (const QString &tx_hash);

    Q_INVOKABLE QString atom() const;
    Q_INVOKABLE void setAtom (const QString &atom);

    Q_INVOKABLE QString network() const;
    Q_INVOKABLE void setNetwork (const QString &network);

    Q_INVOKABLE QString wallet_name() const;
    Q_INVOKABLE void setWallet_name (const QString &wallet_name);

    Q_INVOKABLE QString date() const;
    Q_INVOKABLE void setDate (const QString &date);

    Q_INVOKABLE qint64 date_to_secs() const;
    Q_INVOKABLE void setDate_to_secs (qint64 date_to_secs);

    Q_INVOKABLE QString time() const;
    Q_INVOKABLE void setTime (const QString &time);

    Q_INVOKABLE QString address() const;
    Q_INVOKABLE void setAddress (const QString &address);

    Q_INVOKABLE QString status() const;
    Q_INVOKABLE void setStatus (const QString &status);

    Q_INVOKABLE QString token() const;
    Q_INVOKABLE void setToken (const QString &token);

    Q_INVOKABLE QString direction() const;
    Q_INVOKABLE void setDirection (const QString &direction);

    Q_INVOKABLE QString value() const;
    Q_INVOKABLE void setValue (const QString &value);

    Q_INVOKABLE QString m_value() const;
    Q_INVOKABLE void setM_Value (const QString &m_value);

    Q_INVOKABLE QString m_token() const;
    Q_INVOKABLE void setM_token (const QString &m_token);

    Q_INVOKABLE QString m_direction() const;
    Q_INVOKABLE void setM_direction (const QString &direction);

    Q_INVOKABLE QString x_value() const;
    Q_INVOKABLE void setX_Value (const QString &x_value);

    Q_INVOKABLE QString x_token() const;
    Q_INVOKABLE void setX_token (const QString &x_token);

    Q_INVOKABLE QString x_direction() const;
    Q_INVOKABLE void setX_direction (const QString &x_direction);

    Q_INVOKABLE QString fee() const;
    Q_INVOKABLE void setFee (const QString &fee);

    Q_INVOKABLE QString fee_token() const;
    Q_INVOKABLE void setFee_token (const QString &fee_token);

    Q_INVOKABLE QString fee_net() const;
    Q_INVOKABLE void setFee_net (const QString &fee_net);
protected:
    bool _beginSetValue();
    void _endSetValue();

signals:
    void tx_statusChanged();
    void tx_hashChanged();
    void atomChanged();
    void networkChanged();
    void wallet_nameChanged();
    void dateChanged();
    void date_to_secsChanged();
    void timeChanged();
    void addressChanged();
    void statusChanged();
    void tokenChanged();
    void directionChanged();
    void valueChanged();
    void m_valueChanged();
    void m_tokenChanged();
    void m_directionChanged();
    void x_valueChanged();
    void x_tokenChanged();
    void x_directionChanged();
    void feeChanged();
    void fee_tokenChanged();
    void fee_netChanged();

public:
    QVariant operator [] (const QString &a_valueName);
    ItemHistoryBridge &operator = (const ItemHistoryBridge &a_src);
    ItemHistoryBridge &operator = (ItemHistoryBridge &&a_src);
    /// @}
};
Q_DECLARE_METATYPE (ItemHistoryBridge);

class DapHistoryModel : public QAbstractTableModel
{
    Q_OBJECT

    friend class Rules;

    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

public:
    // item fields
    enum class FieldId
    {
        invalid = -1,
        tx_status = Qt::DisplayRole,
        tx_hash     = Qt::UserRole,
        atom,
        network,
        wallet_name,
        date,
        date_to_secs,
        time,
        address,
        status,
        token,
        direction,
        value,
        m_value,
        m_token,
        m_direction,
        x_value,
        x_token,
        x_direction,
        fee,
        fee_token,
        fee_net
    };
    Q_ENUM(FieldId)

    /// history data
    struct Item
    {
        QString tx_status;
        QString tx_hash;
        QString atom;
        QString network;
        QString wallet_name;
        QString date;
        qint64 date_to_secs;
        QString time;
        QString address;
        QString status;
        QString token;
        QString direction;
        QString value;
        QString m_value;
        QString m_token;
        QString m_direction;
        QString x_value;
        QString x_token;
        QString x_direction;
        QString fee;
        QString fee_token;
        QString fee_net;
        QString queue_hash;
    };

    typedef QList<DapHistoryModel::Item>::Iterator Iterator;
    typedef QList<DapHistoryModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapHistoryModel (QObject *a_parent = nullptr);
    explicit DapHistoryModel (const DapHistoryModel &a_src);
    explicit DapHistoryModel (DapHistoryModel &&a_src);
    ~DapHistoryModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public:
    /// get global singleton instance
    Q_INVOKABLE static DapHistoryModel *global();

    bool updateModel(const QList<Item>& historyList);
    /// add new item to the end
    Q_INVOKABLE int add (const DapHistoryModel::Item &a_item);
    /// add new item in the middle of the list
    Q_INVOKABLE void insert(int a_index, const DapHistoryModel::Item &a_item);
    /// remove one item
    Q_INVOKABLE void remove (int a_index);
    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapHistoryModel::Item &a_item) const;

    Q_INVOKABLE int indexOfTime (qint64 time) const;
    /// access item by index
    Q_INVOKABLE const DapHistoryModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapHistoryModel::Item value (int a_index) const;
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
    Q_INVOKABLE void set (int a_index, const DapHistoryModel::Item &a_item);
    /// emplace item by index
    Q_INVOKABLE void set (int a_index, DapHistoryModel::Item &&a_item);

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapHistoryModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();

    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapHistoryModel &operator= (const DapHistoryModel &a_src);
    Q_INVOKABLE DapHistoryModel &operator= (DapHistoryModel &&a_src);
protected:
    /// get item by index
    DapHistoryModel::Item &_get (int a_index);
    const DapHistoryModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapHistoryModel::Item &a_item, int a_fieldId);
    static void _setValue (DapHistoryModel::Item &a_item, int a_fieldId, const QVariant &a_value);

signals:
    void sizeChanged(); ///< used to notify. not same as sigSizeChanged
    void sigSizeChanged (int a_newSize);
    void sigItemAdded (int a_itemIndex);
    void sigItemRemoved (int a_itemIndex);
    void sigItemChanged (int a_itemIndex);

protected:
    QList<DapHistoryModel::Item> *m_items;
    QSet<QString> m_hash;
};

#endif // DAPHISTORYMODEL_H
