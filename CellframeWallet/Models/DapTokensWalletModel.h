#pragma once

#include <QAbstractTableModel>
#include "../Modules/Wallet/CommonWallet/DapWalletInfo.h"

class DapTokensWalletModel;

class ItemTokensBridge : public QObject
{
    Q_OBJECT

    friend class DapTokensWalletModel;

protected:
    struct Data;

    Q_PROPERTY (QString tokenName           READ tokenName          NOTIFY tokenNameChanged)
    Q_PROPERTY (QString value               READ value              NOTIFY valueChanged)
    Q_PROPERTY (QString valueDatoshi        READ valueDatoshi       NOTIFY valueDatoshiChanged)
    Q_PROPERTY (QString tiker               READ tiker              NOTIFY tikerChanged)
    Q_PROPERTY (QString network             READ network            NOTIFY networkChanged)
    Q_PROPERTY (QString availableDatoshi    READ availableDatoshi   NOTIFY availableDatoshiChanged)
    Q_PROPERTY (QString availableCoins      READ availableCoins     NOTIFY availableCoinsChanged)

protected:
    Data *d;

protected:
    ItemTokensBridge (Data *a_data);
public:
    ItemTokensBridge (QObject *a_parent = nullptr);
    ItemTokensBridge (const ItemTokensBridge &a_src);
    ItemTokensBridge (ItemTokensBridge &&a_src);
    ~ItemTokensBridge();

public:
    Q_INVOKABLE QString tokenName() const;
    Q_INVOKABLE QString value() const;
    Q_INVOKABLE QString valueDatoshi() const;
    Q_INVOKABLE QString tiker() const;
    Q_INVOKABLE QString network() const;
    Q_INVOKABLE QString availableDatoshi() const;
    Q_INVOKABLE QString availableCoins() const;

signals:
    void tokenNameChanged();
    void valueChanged();
    void valueDatoshiChanged();
    void tikerChanged();
    void networkChanged();
    void availableDatoshiChanged();
    void availableCoinsChanged();
public:
    ItemTokensBridge &operator = (const ItemTokensBridge &a_src);
    ItemTokensBridge &operator = (ItemTokensBridge &&a_src);
};
Q_DECLARE_METATYPE (ItemTokensBridge)

class DapTokensWalletModel : public QAbstractTableModel
{
    Q_OBJECT
public:

    enum class FieldId
    {
        invalid = -1,
        tokenName = Qt::DisplayRole,
        value     = Qt::UserRole,
        valueDatoshi,
        tiker,
        network,
        availableDatoshi,
        availableCoins        
    };
    Q_ENUM(FieldId)

    struct Item
    {
        QString tokenName = QString();
        QString value = QString();
        QString valueDatoshi = QString();
        QString tiker = QString();
        QString network = QString();
        QString availableDatoshi = QString();
        QString availableCoins = QString();

        Item() = default;
        Item(const CommonWallet::WalletTokensInfo& token)
            : tokenName(token.tokenName)
            , value(token.value)
            , valueDatoshi(token.datoshi)
            , tiker(token.ticker)
            , network(token.network)
            , availableDatoshi(token.availableDatoshi)
            , availableCoins(token.availableCoins)            
        {}
    };

    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

    typedef QList<DapTokensWalletModel::Item>::Iterator Iterator;
    typedef QList<DapTokensWalletModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapTokensWalletModel (QObject *a_parent = nullptr);
    explicit DapTokensWalletModel (const DapTokensWalletModel &a_src);
    explicit DapTokensWalletModel (DapTokensWalletModel &&a_src);
    ~DapTokensWalletModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public:
    void updateAllToken(const QList<CommonWallet::WalletTokensInfo> &tokens);
    void addToken(const CommonWallet::WalletTokensInfo& token);
    void setDataFromOtherModel(const QList<DapTokensWalletModel::Item>& items);

    /// find item with the same name and return it's index. otherwise returns -1
    Q_INVOKABLE int indexOf (const DapTokensWalletModel::Item &a_item) const;
    /// access item by index
    Q_INVOKABLE const DapTokensWalletModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapTokensWalletModel::Item value (int a_index) const;
    /// get amount of users
    Q_INVOKABLE int size() const;
    /// get item by index
    Q_INVOKABLE QVariant get(int a_index);
    /// get item by index
    Q_INVOKABLE const QVariant get (int a_index) const;
    Q_INVOKABLE QVariant get (const QString& tokenName) const;

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapTokensWalletModel::Item &getItem(int a_index) const;
    const QList<DapTokensWalletModel::Item>& getData() const { return m_items;}
    ConstIterator cbegin() const;
    ConstIterator cend();
protected:

    DapTokensWalletModel::Item &_get (int a_index);
    const DapTokensWalletModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapTokensWalletModel::Item &a_item, int a_fieldId);

signals:
    void sizeChanged();
    void sigSizeChanged (int a_newSize);
public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapTokensWalletModel &operator= (const DapTokensWalletModel &a_src);
    Q_INVOKABLE DapTokensWalletModel &operator= (DapTokensWalletModel &&a_src);

protected:
    QList<DapTokensWalletModel::Item> m_items;
};

