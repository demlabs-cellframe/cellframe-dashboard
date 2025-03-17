#pragma once

#include <QAbstractTableModel>
#include "DapTokensWalletModel.h"
#include "../Modules/Wallet/CommonWallet/DapWalletInfo.h"
#include "TokenProxyModel.h"

class DapInfoWalletModel;

class ItemItemBridge : public QObject
{
    Q_OBJECT

    friend class DapInfoWalletModel;

protected:
    struct Data;

    Q_PROPERTY (QString networkName                         READ networkName        NOTIFY networkNameChanged)
    Q_PROPERTY (QString address                             READ address            NOTIFY addressChanged)
    Q_PROPERTY (bool isLoad                                 READ isLoad             NOTIFY isLoadChanged)
    Q_PROPERTY (DapTokensWalletModel* networkTokensModel    READ networkTokensModel NOTIFY networkTokensChanged)

protected:
    Data *d;

protected:
    ItemItemBridge (Data *a_data);
public:
    ItemItemBridge (QObject *a_parent = nullptr);
    ItemItemBridge (const ItemItemBridge &a_src);
    ItemItemBridge (ItemItemBridge &&a_src);
    ~ItemItemBridge();

public:
    Q_INVOKABLE QString networkName() const;
    Q_INVOKABLE QString address() const;
    Q_INVOKABLE bool isLoad() const;
    Q_INVOKABLE DapTokensWalletModel *networkTokensModel() const;

signals:
    void networkNameChanged();
    void addressChanged();
    void isLoadChanged();
    void networkTokensChanged();

public:
    ItemItemBridge &operator = (const ItemItemBridge &a_src);
    ItemItemBridge &operator = (ItemItemBridge &&a_src);
};
Q_DECLARE_METATYPE (ItemItemBridge);

class DapInfoWalletModel : public QAbstractTableModel
{
    Q_OBJECT

    Q_PROPERTY (int size READ size NOTIFY sizeChanged)
    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

public:

    enum class FieldId
    {
        invalid = -1,
        networkName = Qt::DisplayRole,
        address     = Qt::UserRole,
        isLoad,
        networkTokensModel
    };
    Q_ENUM(FieldId)

    struct Item
    {
        QString networkName = QString();
        QString address = QString();
        bool isLoad = false;
        DapTokensWalletModel* networkTokensModel = nullptr;

        Item(): networkTokensModel(new DapTokensWalletModel()){}
    };

    typedef QList<DapInfoWalletModel::Item>::Iterator Iterator;
    typedef QList<DapInfoWalletModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapInfoWalletModel (QObject *a_parent = nullptr);
    explicit DapInfoWalletModel (const DapInfoWalletModel &a_src);
    explicit DapInfoWalletModel (DapInfoWalletModel &&a_src);
    ~DapInfoWalletModel();

public:
    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;

    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public:
    void addClearNetwork(const QString& networkName);
    void updateModel(const QMap<QString, CommonWallet::WalletNetworkInfo>& networksInfo);

    Q_INVOKABLE DapTokensWalletModel* getModel(int index) const;
    Q_INVOKABLE DapTokensWalletModel* getModel(const QString& networkName) const;

    Q_INVOKABLE QStringList getFilterModel(const QString& networkName, const QString& token1, const QString& token2);
    /// remove one item
    Q_INVOKABLE void remove (int a_index);
    /// access item by index
    Q_INVOKABLE const DapInfoWalletModel::Item &at (int a_index) const;
    /// get copy of item at provided index
    Q_INVOKABLE DapInfoWalletModel::Item value (int a_index) const;
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
    Q_INVOKABLE void set (int a_index, const DapInfoWalletModel::Item &a_item);
    /// emplace item by index
    Q_INVOKABLE void set (int a_index, DapInfoWalletModel::Item &&a_item);

    Q_INVOKABLE int fieldId (const QString &a_fieldName) const;

    const DapInfoWalletModel::Item &getItem(int a_index) const;

protected:

    DapInfoWalletModel::Item &_get (int a_index);
    const DapInfoWalletModel::Item &_get (int a_index) const;
    static QVariant _getValue (const DapInfoWalletModel::Item &a_item, int a_fieldId);

signals:
    void sizeChanged();
    void sigSizeChanged (int a_newSize);
    void sigItemAdded (int a_itemIndex);
    void sigItemRemoved (int a_itemIndex);
    void sigItemChanged (int a_itemIndex);

public:
    Q_INVOKABLE QVariant operator [](int a_index);
    Q_INVOKABLE const QVariant operator[] (int a_index) const;
    Q_INVOKABLE DapInfoWalletModel &operator= (const DapInfoWalletModel &a_src);
    Q_INVOKABLE DapInfoWalletModel &operator= (DapInfoWalletModel &&a_src);

protected:
    QList<DapInfoWalletModel::Item*> m_items;
};

