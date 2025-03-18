#ifndef DAPABSTRACTDIAGNOSTICMODEL_H
#define DAPABSTRACTDIAGNOSTICMODEL_H

#include <QAbstractTableModel>

/* DEFS */
class DapAbstractDiagnosticModel;

class ItemDiagnosticBridge : public QObject
{
  Q_OBJECT

  friend class DapAbstractDiagnosticModel;

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
  Q_PROPERTY (QString proc_DB_size              READ proc_DB_size               WRITE setProc_DB_size               NOTIFY proc_DB_sizeChanged)
  Q_PROPERTY (QString proc_chain_size           READ proc_chain_size            WRITE setProc_chain_size            NOTIFY proc_chain_sizeChanged)
  Q_PROPERTY (QString proc_log_size             READ proc_log_size              WRITE setProc_log_size              NOTIFY proc_log_sizeChanged)
  Q_PROPERTY (int     proc_memory_use           READ proc_memory_use            WRITE setProc_memory_use            NOTIFY proc_memory_useChanged)
  Q_PROPERTY (QString proc_memory_use_value     READ proc_memory_use_value      WRITE setProc_memory_use_value      NOTIFY proc_memory_use_valueChanged)
  Q_PROPERTY (QString proc_name                 READ proc_name                  WRITE setProc_name                  NOTIFY proc_nameChanged)
  Q_PROPERTY (QString proc_status               READ proc_status                WRITE setProc_status                NOTIFY proc_statusChanged)
  Q_PROPERTY (QString proc_uptime               READ proc_uptime                WRITE setProc_uptime                NOTIFY proc_uptimeChanged)
  Q_PROPERTY (QString proc_version              READ proc_version               WRITE setProc_version               NOTIFY proc_versionChanged)
  Q_PROPERTY (int     system_CPU_load           READ system_CPU_load            WRITE setSystem_CPU_load            NOTIFY system_CPU_loadChanged)
  Q_PROPERTY (QString system_memory_free        READ system_memory_free         WRITE setSystem_memory_free         NOTIFY system_memory_freeChanged)
  Q_PROPERTY (int     system_memory_load        READ system_memory_load         WRITE setSystem_memory_load         NOTIFY system_memory_loadChanged)
  Q_PROPERTY (QString system_memory_total       READ system_memory_total        WRITE setSystem_memory_total        NOTIFY system_memory_totalChanged)
  Q_PROPERTY (int     system_memory_total_value READ system_memory_total_value  WRITE setSystem_memory_total_value  NOTIFY system_memory_total_valueChanged)
  Q_PROPERTY (QString system_mac                READ system_mac                 WRITE setSystem_mac                 NOTIFY system_macChanged)
  Q_PROPERTY (QString system_time_update        READ system_time_update         WRITE setSystem_time_update         NOTIFY system_time_updateChanged)
  Q_PROPERTY (quint64 system_time_update_unix   READ system_time_update_unix    WRITE setSystem_time_update_unix    NOTIFY system_time_update_unixChanged)
  Q_PROPERTY (QString system_uptime             READ system_uptime              WRITE setSystem_uptime              NOTIFY system_uptimeChanged)
  Q_PROPERTY (QString system_uptime_wallet   READ system_uptime_wallet    WRITE setsystem_uptime_wallet    NOTIFY system_uptime_walletChanged)
  Q_PROPERTY (QString system_node_name          READ system_node_name           WRITE setSystem_node_name           NOTIFY system_node_nameChanged)
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
  ItemDiagnosticBridge (Data *a_data);
public:
  ItemDiagnosticBridge (QObject *a_parent = nullptr);
  ItemDiagnosticBridge (const ItemDiagnosticBridge &a_src);
  ItemDiagnosticBridge (ItemDiagnosticBridge &&a_src);
  ~ItemDiagnosticBridge();
  /// @}

  /****************************************//**
   * @name METHODS
   *******************************************/
  /// @{
public:
  Q_INVOKABLE QString proc_DB_size() const;
  Q_INVOKABLE void setProc_DB_size (const QString &proc_DB_size);

  Q_INVOKABLE QString proc_chain_size() const;
  Q_INVOKABLE void setProc_chain_size (const QString &proc_chain_size);

  Q_INVOKABLE QString proc_log_size() const;
  Q_INVOKABLE void setProc_log_size (const QString &proc_log_size);

  Q_INVOKABLE int proc_memory_use() const;
  Q_INVOKABLE void setProc_memory_use (const int &proc_memory_use);

  Q_INVOKABLE QString proc_memory_use_value() const;
  Q_INVOKABLE void setProc_memory_use_value (const QString &proc_memory_use_value);

  Q_INVOKABLE QString proc_name() const;
  Q_INVOKABLE void setProc_name (const QString &proc_name);

  Q_INVOKABLE QString proc_status() const;
  Q_INVOKABLE void setProc_status (QString proc_status);

  Q_INVOKABLE QString proc_uptime() const;
  Q_INVOKABLE void setProc_uptime (const QString &proc_uptime);

  Q_INVOKABLE QString proc_version() const;
  Q_INVOKABLE void setProc_version (const QString &proc_version);

  Q_INVOKABLE int system_CPU_load() const;
  Q_INVOKABLE void setSystem_CPU_load (const int &system_CPU_load);

  Q_INVOKABLE QString system_memory_free() const;
  Q_INVOKABLE void setSystem_memory_free (const QString &system_memory_free);

  Q_INVOKABLE int system_memory_load() const;
  Q_INVOKABLE void setSystem_memory_load (const int &system_memory_load);

  Q_INVOKABLE QString system_memory_total() const;
  Q_INVOKABLE void setSystem_memory_total (const QString &system_memory_total);

  Q_INVOKABLE int system_memory_total_value() const;
  Q_INVOKABLE void setSystem_memory_total_value (const int &system_memory_total_value);

  Q_INVOKABLE QString system_mac() const;
  Q_INVOKABLE void setSystem_mac (const QString &system_mac);

  Q_INVOKABLE QString system_time_update() const;
  Q_INVOKABLE void setSystem_time_update (const QString &system_time_update);

  Q_INVOKABLE quint64 system_time_update_unix() const;
  Q_INVOKABLE void setSystem_time_update_unix (const quint64 &system_time_update_unix);

  Q_INVOKABLE QString system_uptime() const;
  Q_INVOKABLE void setSystem_uptime (const QString &system_uptime);

  Q_INVOKABLE QString system_uptime_wallet() const;
  Q_INVOKABLE void setsystem_uptime_wallet (const QString &system_uptime_wallet);

  Q_INVOKABLE QString system_node_name() const;
  Q_INVOKABLE void setSystem_node_name (const QString &system_node_name);
protected:
  bool _beginSetValue();
  void _endSetValue();
  /// @}

  /****************************************//**
   * @name SIGNALS
   *******************************************/
  /// @{
signals:
  void proc_DB_sizeChanged();
  void proc_chain_sizeChanged();
  void proc_log_sizeChanged();
  void proc_memory_useChanged();
  void proc_memory_use_valueChanged();
  void proc_nameChanged();
  void proc_statusChanged();
  void proc_uptimeChanged();
  void proc_versionChanged();
  void system_CPU_loadChanged();
  void system_memory_freeChanged();
  void system_memory_loadChanged();
  void system_memory_totalChanged();
  void system_memory_total_valueChanged();
  void system_macChanged();
  void system_time_updateChanged();
  void system_time_update_unixChanged();
  void system_uptimeChanged();
  void system_uptime_walletChanged();
  void system_node_nameChanged();
  /// @}

  /****************************************//**
   * @name OPERATORS
   *******************************************/
  /// @{
public:
  QVariant operator [] (const QString &a_valueName);
  ItemDiagnosticBridge &operator = (const ItemDiagnosticBridge &a_src);
  ItemDiagnosticBridge &operator = (ItemDiagnosticBridge &&a_src);
  /// @}
};
Q_DECLARE_METATYPE (ItemDiagnosticBridge);

class DapAbstractDiagnosticModel : public QAbstractTableModel
{
  Q_OBJECT

  friend class DapDiagnosticModel;

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
    invalid         = -1,
    proc_DB_size    = Qt::DisplayRole,
    proc_chain_size = Qt::UserRole,
    proc_log_size,
    proc_memory_use,
    proc_memory_use_value,
    proc_name,
    proc_status,
    proc_uptime,
    proc_version,
    system_CPU_load,
    system_memory_free,
    system_memory_load,
    system_memory_total,
    system_memory_total_value,
    system_mac,
    system_time_update,
    system_time_update_unix,
    system_uptime,
    system_uptime_wallet,
    system_node_name,
  };
  Q_ENUM(FieldId)

  /// history data
  struct Item
  {
      QString proc_DB_size;
      QString proc_chain_size;
      QString proc_log_size;
      int proc_memory_use;
      QString proc_memory_use_value;
      QString proc_name;
      QString proc_status;
      QString proc_uptime;
      QString proc_version;
      int system_CPU_load;
      QString system_memory_free;
      int system_memory_load;
      QString system_memory_total;
      int system_memory_total_value;
      QString system_mac;
      QString system_time_update;
      quint64 system_time_update_unix;
      QString system_uptime;
      QString system_uptime_wallet;
      QString system_node_name;
  };

  typedef QList<DapAbstractDiagnosticModel::Item>::Iterator Iterator;
  typedef QList<DapAbstractDiagnosticModel::Item>::ConstIterator ConstIterator;
  /// @}

  /****************************************//**
   * @name VARS
   *******************************************/
  /// @{
protected:
  QList<DapAbstractDiagnosticModel::Item> *m_items;
  /// @}

  /****************************************//**
   * @name CONSTRUCT/DESTRUCT
   *******************************************/
  /// @{
public:
  explicit DapAbstractDiagnosticModel (QObject *a_parent = nullptr);
  explicit DapAbstractDiagnosticModel (const DapAbstractDiagnosticModel &a_src);
  explicit DapAbstractDiagnosticModel (DapAbstractDiagnosticModel &&a_src);
  ~DapAbstractDiagnosticModel();
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
  Q_INVOKABLE static DapAbstractDiagnosticModel *global();
  /// add new item to the end
  Q_INVOKABLE int add (const DapAbstractDiagnosticModel::Item &a_item);
  /// add new item in the middle of the list
  Q_INVOKABLE void insert(int a_index, const DapAbstractDiagnosticModel::Item &a_item);
  /// remove one item
  Q_INVOKABLE void remove (int a_index);
  /// find item with the same name and return it's index. otherwise returns -1
  Q_INVOKABLE int indexOf (const DapAbstractDiagnosticModel::Item &a_item) const;

  Q_INVOKABLE int indexOfTime (qint64 time) const;
  /// access item by index
  Q_INVOKABLE const DapAbstractDiagnosticModel::Item &at (int a_index) const;
  /// get copy of item at provided index
  Q_INVOKABLE DapAbstractDiagnosticModel::Item value (int a_index) const;
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
  Q_INVOKABLE void set (int a_index, const DapAbstractDiagnosticModel::Item &a_item);
  /// emplace item by index
  Q_INVOKABLE void set (int a_index, DapAbstractDiagnosticModel::Item &&a_item);
//  /// get item field value
//  Q_INVOKABLE QVariant getValue (int a_index, int a_fieldId) const;
//  /// set item field value
//  Q_INVOKABLE void setValue (int a_index, int a_fieldId, const QVariant &a_value);
//  /// get item field value
//  Q_INVOKABLE QVariant getProperty (int a_index, const QString &a_fieldName) const;
//  /// set item field value
//  Q_INVOKABLE void setProperty (int a_index, const QString &a_fieldName, const QVariant &a_value);
  Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

  const DapAbstractDiagnosticModel::Item &getItem(int a_index) const;

  Iterator begin();
  ConstIterator cbegin() const;
  Iterator end();
  ConstIterator cend();
protected:
  /// get item by index
  DapAbstractDiagnosticModel::Item &_get (int a_index);
  const DapAbstractDiagnosticModel::Item &_get (int a_index) const;
  static QVariant _getValue (const DapAbstractDiagnosticModel::Item &a_item, int a_fieldId);
  static void _setValue (DapAbstractDiagnosticModel::Item &a_item, int a_fieldId, const QVariant &a_value);
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
  Q_INVOKABLE DapAbstractDiagnosticModel &operator= (const DapAbstractDiagnosticModel &a_src);
  Q_INVOKABLE DapAbstractDiagnosticModel &operator= (DapAbstractDiagnosticModel &&a_src);
  /// @}
};

/*-----------------------------------------*/



#endif // DAPABSTRACTDIAGNOSTICMODEL_H
