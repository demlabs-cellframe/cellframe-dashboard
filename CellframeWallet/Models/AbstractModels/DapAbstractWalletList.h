#ifndef DAPABSTRACTWALLETLIST_H
#define DAPABSTRACTWALLETLIST_H

#include <QAbstractTableModel>

class DapAbstractWalletList;

class ItemWalletListBridge : public QObject
{
  Q_OBJECT

  friend class DapAbstractWalletList;

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
  Q_PROPERTY (QString name     READ name     WRITE setName    NOTIFY nameChanged)
  Q_PROPERTY (QString statusProtect   READ statusProtect   WRITE setStatusProtect   NOTIFY statusProtectChanged)
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
  ItemWalletListBridge (Data *a_data);
public:
  ItemWalletListBridge (QObject *a_parent = nullptr);
  ItemWalletListBridge (const ItemWalletListBridge &a_src);
  ItemWalletListBridge (ItemWalletListBridge &&a_src);
  ~ItemWalletListBridge();
  /// @}

  /****************************************//**
   * @name METHODS
   *******************************************/
  /// @{
public:
  Q_INVOKABLE QString name() const;
  Q_INVOKABLE void setName (const QString &name);

  Q_INVOKABLE QString statusProtect() const;
  Q_INVOKABLE void setStatusProtect (const QString &statusProtect);

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
  ItemWalletListBridge &operator = (const ItemWalletListBridge &a_src);
  ItemWalletListBridge &operator = (ItemWalletListBridge &&a_src);
  /// @}
};
Q_DECLARE_METATYPE (ItemWalletListBridge);

class DapAbstractWalletList : public QAbstractTableModel
{
  Q_OBJECT

  friend class DapWalletListModel;

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
    name     = Qt::DisplayRole,
    statusProtect   = Qt::UserRole,
  };
  Q_ENUM(FieldId)

  /// history data
  struct Item
  {
      QString name;
      QString statusProtect;
  };

  typedef QList<DapAbstractWalletList::Item>::Iterator Iterator;
  typedef QList<DapAbstractWalletList::Item>::ConstIterator ConstIterator;
  /// @}

  /****************************************//**
   * @name VARS
   *******************************************/
  /// @{
protected:
  QList<DapAbstractWalletList::Item> *m_items;
  /// @}

  /****************************************//**
   * @name CONSTRUCT/DESTRUCT
   *******************************************/
  /// @{
public:
  explicit DapAbstractWalletList (QObject *a_parent = nullptr);
  explicit DapAbstractWalletList (const DapAbstractWalletList &a_src);
  explicit DapAbstractWalletList (DapAbstractWalletList &&a_src);
  ~DapAbstractWalletList();
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
  Q_INVOKABLE static DapAbstractWalletList *global();
  /// add new item to the end
  Q_INVOKABLE int add (const DapAbstractWalletList::Item &a_item);
  /// add new item in the middle of the list
  Q_INVOKABLE void insert(int a_index, const DapAbstractWalletList::Item &a_item);
  /// remove one item
  Q_INVOKABLE void remove (int a_index);
  /// find item with the same name and return it's index. otherwise returns -1
  Q_INVOKABLE int indexOf (const DapAbstractWalletList::Item &a_item) const;

  /// access item by index
  Q_INVOKABLE const DapAbstractWalletList::Item &at (int a_index) const;
  /// get copy of item at provided index
  Q_INVOKABLE DapAbstractWalletList::Item value (int a_index) const;
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
  Q_INVOKABLE void set (int a_index, const DapAbstractWalletList::Item &a_item);
  /// emplace item by index
  Q_INVOKABLE void set (int a_index, DapAbstractWalletList::Item &&a_item);
//  /// get item field value
//  Q_INVOKABLE QVariant getValue (int a_index, int a_fieldId) const;
//  /// set item field value
//  Q_INVOKABLE void setValue (int a_index, int a_fieldId, const QVariant &a_value);
//  /// get item field value
//  Q_INVOKABLE QVariant getProperty (int a_index, const QString &a_fieldName) const;
//  /// set item field value
//  Q_INVOKABLE void setProperty (int a_index, const QString &a_fieldName, const QVariant &a_value);
  Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

  const DapAbstractWalletList::Item &getItem(int a_index) const;

  Iterator begin();
  ConstIterator cbegin() const;
  Iterator end();
  ConstIterator cend();
protected:
  /// get item by index
  DapAbstractWalletList::Item &_get (int a_index);
  const DapAbstractWalletList::Item &_get (int a_index) const;
  static QVariant _getValue (const DapAbstractWalletList::Item &a_item, int a_fieldId);
  static void _setValue (DapAbstractWalletList::Item &a_item, int a_fieldId, const QVariant &a_value);
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
  Q_INVOKABLE DapAbstractWalletList &operator= (const DapAbstractWalletList &a_src);
  Q_INVOKABLE DapAbstractWalletList &operator= (DapAbstractWalletList &&a_src);
  /// @}
};

/*-----------------------------------------*/

#endif // DAPABSTRACTWALLETLIST_H
