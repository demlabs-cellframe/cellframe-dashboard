#ifndef HISTORYMODEL_H
#define HISTORYMODEL_H

#include <QAbstractTableModel>

/* DEFS */
class HistoryModel;

class ItemBridge : public QObject
{
  Q_OBJECT

  friend class HistoryModel;

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
  Q_PROPERTY (QString tx_status     READ tx_status     WRITE setTx_status     NOTIFY tx_statusChanged)
  Q_PROPERTY (QString tx_hash       READ tx_hash       WRITE setTx_hash       NOTIFY tx_hashChanged)
  Q_PROPERTY (QString atom          READ atom          WRITE setAtom          NOTIFY atomChanged)
  Q_PROPERTY (QString network       READ network       WRITE setNetwork       NOTIFY networkChanged)
  Q_PROPERTY (QString wallet_name   READ wallet_name   WRITE setWallet_name   NOTIFY wallet_nameChanged)
  Q_PROPERTY (QString date          READ date          WRITE setDate          NOTIFY dateChanged)
  Q_PROPERTY (qint64 date_to_secs  READ date_to_secs  WRITE setDate_to_secs  NOTIFY date_to_secsChanged)
  Q_PROPERTY (QString address       READ address       WRITE setAddress       NOTIFY addressChanged)
  Q_PROPERTY (QString status        READ status        WRITE setStatus        NOTIFY statusChanged)
  Q_PROPERTY (QString token         READ token         WRITE setToken         NOTIFY tokenChanged)
  Q_PROPERTY (QString direction     READ direction     WRITE setDirection     NOTIFY directionChanged)
  Q_PROPERTY (QString value         READ value         WRITE setValue         NOTIFY valueChanged)
  Q_PROPERTY (QString fee           READ fee           WRITE setFee           NOTIFY feeChanged)
  Q_PROPERTY (QString fee_token     READ fee_token     WRITE setFee_token     NOTIFY fee_tokenChanged)
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
  ItemBridge (Data *a_data);
public:
  ItemBridge (QObject *a_parent = nullptr);
  ItemBridge (const ItemBridge &a_src);
  ItemBridge (ItemBridge &&a_src);
  ~ItemBridge();
  /// @}

  /****************************************//**
   * @name METHODS
   *******************************************/
  /// @{
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

  Q_INVOKABLE QString fee() const;
  Q_INVOKABLE void setFee (const QString &fee);

  Q_INVOKABLE QString fee_token() const;
  Q_INVOKABLE void setFee_token (const QString &fee_token);
protected:
  bool _beginSetValue();
  void _endSetValue();
  /// @}

  /****************************************//**
   * @name SIGNALS
   *******************************************/
  /// @{
signals:
  void tx_statusChanged();
  void tx_hashChanged();
  void atomChanged();
  void networkChanged();
  void wallet_nameChanged();
  void dateChanged();
  void date_to_secsChanged();
  void addressChanged();
  void statusChanged();
  void tokenChanged();
  void directionChanged();
  void valueChanged();
  void feeChanged();
  void fee_tokenChanged();
  /// @}

  /****************************************//**
   * @name OPERATORS
   *******************************************/
  /// @{
public:
  QVariant operator [] (const QString &a_valueName);
  ItemBridge &operator = (const ItemBridge &a_src);
  ItemBridge &operator = (ItemBridge &&a_src);
  /// @}
};
Q_DECLARE_METATYPE (ItemBridge);

class HistoryModel : public QAbstractTableModel
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
    invalid = -1,
    tx_status = Qt::DisplayRole,
    tx_hash     = Qt::UserRole,
    atom,
    network,
    wallet_name,
    date,
    date_to_secs,
    address,
    status,
    token,
    direction,
    value,
    fee,
    fee_token
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
    QString address;
    QString status;
    QString token;
    QString direction;
    QString value;
    QString fee;
    QString fee_token;

  };

  typedef QList<HistoryModel::Item>::Iterator Iterator;
  typedef QList<HistoryModel::Item>::ConstIterator ConstIterator;
  /// @}

  /****************************************//**
   * @name VARS
   *******************************************/
  /// @{
protected:
  QList<HistoryModel::Item> *m_items;
  /// @}

  /****************************************//**
   * @name CONSTRUCT/DESTRUCT
   *******************************************/
  /// @{
public:
  explicit HistoryModel (QObject *a_parent = nullptr);
  explicit HistoryModel (const HistoryModel &a_src);
  explicit HistoryModel (HistoryModel &&a_src);
  ~HistoryModel();
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
  Q_INVOKABLE static HistoryModel *global();
  /// add new item to the end
  Q_INVOKABLE int add (const HistoryModel::Item &a_item);
  /// add new item in the middle of the list
  Q_INVOKABLE void insert(int a_index, const HistoryModel::Item &a_item);
  /// remove one item
  Q_INVOKABLE void remove (int a_index);
  /// find item with the same name and return it's index. otherwise returns -1
  Q_INVOKABLE int indexOf (const HistoryModel::Item &a_item) const;

  Q_INVOKABLE int indexOfTime (qint64 time) const;
  /// access item by index
  Q_INVOKABLE const HistoryModel::Item &at (int a_index) const;
  /// get copy of item at provided index
  Q_INVOKABLE HistoryModel::Item value (int a_index) const;
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
  Q_INVOKABLE void set (int a_index, const HistoryModel::Item &a_item);
  /// emplace item by index
  Q_INVOKABLE void set (int a_index, HistoryModel::Item &&a_item);
//  /// get item field value
//  Q_INVOKABLE QVariant getValue (int a_index, int a_fieldId) const;
//  /// set item field value
//  Q_INVOKABLE void setValue (int a_index, int a_fieldId, const QVariant &a_value);
//  /// get item field value
//  Q_INVOKABLE QVariant getProperty (int a_index, const QString &a_fieldName) const;
//  /// set item field value
//  Q_INVOKABLE void setProperty (int a_index, const QString &a_fieldName, const QVariant &a_value);
  Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

  const HistoryModel::Item &getItem(int a_index) const;

  Iterator begin();
  ConstIterator cbegin() const;
  Iterator end();
  ConstIterator cend();
protected:
  /// get item by index
  HistoryModel::Item &_get (int a_index);
  const HistoryModel::Item &_get (int a_index) const;
  static QVariant _getValue (const HistoryModel::Item &a_item, int a_fieldId);
  static void _setValue (HistoryModel::Item &a_item, int a_fieldId, const QVariant &a_value);
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
  Q_INVOKABLE HistoryModel &operator= (const HistoryModel &a_src);
  Q_INVOKABLE HistoryModel &operator= (HistoryModel &&a_src);
  /// @}
};

/*-----------------------------------------*/

#endif // HISTORYMODEL_H

