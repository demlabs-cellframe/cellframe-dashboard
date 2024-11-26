#ifndef LOGMODEL_H
#define LOGMODEL_H

#include <QAbstractTableModel>

/* DEFS */

class LogModel;

class LogBridge : public QObject
{
  Q_OBJECT

  friend class LogModel;

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
  Q_PROPERTY (QString type
              READ type
              WRITE setType
              NOTIFY type)
  Q_PROPERTY (QString info
              READ info
              WRITE setInfo
              NOTIFY infoChanged)
  Q_PROPERTY (QString file
              READ file
              WRITE setFile
              NOTIFY fileChanged)
  Q_PROPERTY (QString time
              READ time
              WRITE setTime
              NOTIFY timeChanged)
  Q_PROPERTY (QString date
              READ date
              WRITE setDate
              NOTIFY dateChanged)
//////////////////////////////////
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
  LogBridge (Data *a_data);
public:
  LogBridge (QObject *a_parent = nullptr);
  LogBridge (const LogBridge &a_src);
  LogBridge (LogBridge &&a_src);
  ~LogBridge();
  /// @}

  /****************************************//**
   * @name METHODS
   *******************************************/
  /// @{
public:
  Q_INVOKABLE QString type() const;
  Q_INVOKABLE void setType (const QString &value);
  Q_INVOKABLE QString info() const;
  Q_INVOKABLE void setInfo (const QString &value);
  Q_INVOKABLE QString file() const;
  Q_INVOKABLE void setFile (const QString &value);
  Q_INVOKABLE QString time() const;
  Q_INVOKABLE void setTime (const QString &value);
  Q_INVOKABLE QString date() const;
  Q_INVOKABLE void setDate (const QString &value);
//////////////////////////////////

protected:
  bool _beginSetValue();
  void _endSetValue();
  /// @}

  /****************************************//**
   * @name SIGNALS
   *******************************************/
  /// @{
signals:

  void typeChanged();
  void infoChanged();
  void fileChanged();
  void timeChanged();
  void dateChanged();
//////////////////////////////////

  /// @}

  /****************************************//**
   * @name OPERATORS
   *******************************************/
  /// @{
public:
  QVariant operator [] (const QString &a_valueName);
  LogBridge &operator = (const LogBridge &a_src);
  LogBridge &operator = (LogBridge &&a_src);
  /// @}
};
Q_DECLARE_METATYPE (LogBridge);

class LogModel : public QAbstractTableModel
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
    invalid = -1,
    type = Qt::DisplayRole,
    info = Qt::UserRole,
    file,
    time,
    date
//////////////////////////////////
  };
  Q_ENUM(FieldId)

  struct Item
  {
      QString type;
      QString info;
      QString file;
      QString time;
      QString date;
//////////////////////////////////
  };

  typedef QList<LogModel::Item>::Iterator Iterator;
  typedef QList<LogModel::Item>::ConstIterator ConstIterator;
  /// @}

  /****************************************//**
   * @name VARS
   *******************************************/
  /// @{
protected:
  QList<LogModel::Item> *m_items;
  /// @}

  /****************************************//**
   * @name CONSTRUCT/DESTRUCT
   *******************************************/
  /// @{
public:
  explicit LogModel (QObject *a_parent = nullptr);
  explicit LogModel (const LogModel &a_src);
  explicit LogModel (LogModel &&a_src);
  ~LogModel();
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
  Q_INVOKABLE static LogModel *global();
  /// add new item to the end
  Q_INVOKABLE int add (const LogModel::Item &a_item);
  /// add new item in the middle of the list
  Q_INVOKABLE void insert(int a_index, const LogModel::Item &a_item);
  /// remove one item
  Q_INVOKABLE void remove (int a_index);
  /// find item with the same name and return it's index. otherwise returns -1
  Q_INVOKABLE int indexOf (const LogModel::Item &a_item) const;

//  Q_INVOKABLE int indexOfTime (qint64 time) const;
  /// access item by index
  Q_INVOKABLE const LogModel::Item &at (int a_index) const;
  /// get copy of item at provided index
  Q_INVOKABLE LogModel::Item value (int a_index) const;
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
  Q_INVOKABLE void set (int a_index, const LogModel::Item &a_item);
  /// emplace item by index
  Q_INVOKABLE void set (int a_index, LogModel::Item &&a_item);
//  /// get item field value
//  Q_INVOKABLE QVariant getValue (int a_index, int a_fieldId) const;
//  /// set item field value
//  Q_INVOKABLE void setValue (int a_index, int a_fieldId, const QVariant &a_value);
//  /// get item field value
//  Q_INVOKABLE QVariant getProperty (int a_index, const QString &a_fieldName) const;
//  /// set item field value
//  Q_INVOKABLE void setProperty (int a_index, const QString &a_fieldName, const QVariant &a_value);
  Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

  const LogModel::Item &getItem(int a_index) const;

  Iterator begin();
  ConstIterator cbegin() const;
  Iterator end();
  ConstIterator cend();
protected:
  /// get item by index
  LogModel::Item &_get (int a_index);
  const LogModel::Item &_get (int a_index) const;
  static QVariant _getValue (const LogModel::Item &a_item, int a_fieldId);
  static void _setValue (LogModel::Item &a_item, int a_fieldId, const QVariant &a_value);
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
  Q_INVOKABLE LogModel &operator= (const LogModel &a_src);
  Q_INVOKABLE LogModel &operator= (LogModel &&a_src);
  /// @}
};


#endif // LOGMODEL_H
