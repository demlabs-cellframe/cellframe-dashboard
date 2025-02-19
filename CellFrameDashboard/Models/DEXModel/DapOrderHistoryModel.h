#pragma once

#include <QAbstractTableModel>
#include "DEXTypes.h"

/* DEFS */
class DapOrderHistoryModel;

class ItemOrderHistoryBridge : public QObject
{
    Q_OBJECT

    friend class DapOrderHistoryModel;

protected:
    struct Data;

    Q_PROPERTY (QString date            READ date           NOTIFY dateChanged)
    Q_PROPERTY (QString unixDate        READ unixDate       NOTIFY unixDateChanged)
    Q_PROPERTY (QString pair            READ pair           NOTIFY pairChanged)
    Q_PROPERTY (QString type            READ type           NOTIFY typeChanged)
    Q_PROPERTY (QString side            READ side           NOTIFY sideChanged)
    Q_PROPERTY (QString hash            READ hash           NOTIFY hashChanged)
    Q_PROPERTY (QString price           READ price          NOTIFY priceChanged)
    Q_PROPERTY (QString filled          READ filled         NOTIFY filledChanged)
    Q_PROPERTY (QString amount          READ amount         NOTIFY amountChanged)
    Q_PROPERTY (QString status          READ status         NOTIFY statusChanged)
    Q_PROPERTY (QString network         READ network        NOTIFY networkChanged)
    Q_PROPERTY (QString tokenBuy        READ tokenBuy       NOTIFY tokenBuyChanged)
    Q_PROPERTY (QString tokenSell       READ tokenSell      NOTIFY tokenSellChanged)
    Q_PROPERTY (QString tokenBuyOrigin  READ tokenBuyOrigin NOTIFY tokenBuyOriginChanged)
    Q_PROPERTY (QString tokenSellOrigin READ tokenSellOrigin NOTIFY tokenSellOriginChanged)
    Q_PROPERTY (QString adaptiveSide    READ adaptiveSide   NOTIFY adaptiveSideChanged)
    Q_PROPERTY (QString adaptivePair    READ adaptivePair   NOTIFY adaptivePairChanged)
    Q_PROPERTY (QString rateOrigin      READ rateOrigin     NOTIFY rateOriginChanged)

protected:
    Data *d;

protected:
    ItemOrderHistoryBridge (Data *a_data);
public:
    ItemOrderHistoryBridge (QObject *a_parent = nullptr);
    ItemOrderHistoryBridge (const ItemOrderHistoryBridge &a_src);
    ItemOrderHistoryBridge (ItemOrderHistoryBridge &&a_src);
    ~ItemOrderHistoryBridge();

public:
    Q_INVOKABLE QString date() const;
    Q_INVOKABLE QString unixDate() const;
    Q_INVOKABLE QString pair() const;
    Q_INVOKABLE QString type() const;
    Q_INVOKABLE QString side() const;
    Q_INVOKABLE QString hash() const;
    Q_INVOKABLE QString price() const;
    Q_INVOKABLE QString filled() const;
    Q_INVOKABLE QString amount() const;
    Q_INVOKABLE QString status() const;
    Q_INVOKABLE QString network() const;
    Q_INVOKABLE QString tokenBuy() const;
    Q_INVOKABLE QString tokenSell() const;
    Q_INVOKABLE QString tokenBuyOrigin() const;
    Q_INVOKABLE QString tokenSellOrigin() const;  
    Q_INVOKABLE QString adaptiveSide() const;  
    Q_INVOKABLE QString adaptivePair() const; 
    Q_INVOKABLE QString rateOrigin() const; 
signals:
    void dateChanged();
    void unixDateChanged();
    void pairChanged();
    void typeChanged();
    void sideChanged();
    void hashChanged();
    void priceChanged();
    void filledChanged();
    void amountChanged();
    void statusChanged();
    void networkChanged();
    void tokenBuyChanged();
    void tokenSellChanged();
    void tokenBuyOriginChanged();
    void tokenSellOriginChanged();
    void adaptiveSideChanged();
    void adaptivePairChanged();
    void rateOriginChanged();
public:
    ItemOrderHistoryBridge &operator = (const ItemOrderHistoryBridge &a_src);
    ItemOrderHistoryBridge &operator = (ItemOrderHistoryBridge &&a_src);
};
Q_DECLARE_METATYPE (ItemOrderHistoryBridge);

class DapOrderHistoryModel : public QAbstractTableModel
{
    Q_OBJECT

    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

public:
    enum class FieldId
    {
        invalid = -1,
        pair = Qt::DisplayRole,
        date     = Qt::UserRole,
        unixDate,
        type,
        side,
        hash,
        price,
        filled,
        amount,
        status,
        network,
        tokenBuy,
        tokenSell,
        tokenBuyOrigin,
        tokenSellOrigin,
        adaptiveSide,
        adaptivePair,
        rateOrigin
    };
    Q_ENUM(FieldId)

    struct Item
    {
        QString pair = "";
        QString date = "";
        QString unixDate = "";
        QString type = "";
        QString side = "";
        QString hash = "";
        QString price = "";
        QString filled = "";
        QString amount = "";
        QString status = "";
        QString network = "";
        QString tokenBuy = "";
        QString tokenSell = "";
        QString tokenBuyOrigin = "";
        QString tokenSellOrigin = "";
        QString adaptiveSide = "";
        QString adaptivePair = "";     
        QString rateOrigin = "";  
    };

    typedef QList<DapOrderHistoryModel::Item>::Iterator Iterator;
    typedef QList<DapOrderHistoryModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapOrderHistoryModel (QObject *a_parent = nullptr);
    explicit DapOrderHistoryModel (const DapOrderHistoryModel &a_src);
    explicit DapOrderHistoryModel (DapOrderHistoryModel &&a_src);
    ~DapOrderHistoryModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public:
    void updateModel(const QList<DEX::Order> &data);

    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapOrderHistoryModel::Item &a_item) const;

    /// access item by index
    Q_INVOKABLE const DapOrderHistoryModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapOrderHistoryModel::Item value (int a_index) const;
    Q_INVOKABLE DapOrderHistoryModel::Item value (const QString& hash) const;

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
    Q_INVOKABLE void set (int a_index, const DapOrderHistoryModel::Item &a_item);
    /// emplace item by index
    Q_INVOKABLE void set (int a_index, DapOrderHistoryModel::Item &&a_item);

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;


    const QList<DapOrderHistoryModel::Item>& getListModel() const { return m_items; }
    const DapOrderHistoryModel::Item &getItem(int a_index) const;

    Iterator begin();
    ConstIterator cbegin() const;
    Iterator end();
    ConstIterator cend();
protected:
    /// get item by index
    DapOrderHistoryModel::Item &_get (int a_index);
    const DapOrderHistoryModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapOrderHistoryModel::Item &a_item, int a_fieldId);

    void updateAtaptiveSide();

signals:
    void sizeChanged();
    void sigSizeChanged (int a_newSize);
    void sigItemAdded (int a_itemIndex);
    void sigItemRemoved (int a_itemIndex);
    void sigItemChanged (int a_itemIndex);

public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapOrderHistoryModel &operator= (const DapOrderHistoryModel &a_src);
    Q_INVOKABLE DapOrderHistoryModel &operator= (DapOrderHistoryModel &&a_src);
protected:
    QList<DapOrderHistoryModel::Item> m_items;
};
