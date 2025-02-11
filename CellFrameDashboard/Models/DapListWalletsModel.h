#pragma once

#include <QAbstractTableModel>
#include "DapInfoWalletModel.h"
#include <QJsonDocument>
#include "../Modules/Wallet/CommonWallet/DapWalletInfo.h"

class DapListWalletsModel;

class ItemListWalletBridge : public QObject
{
    Q_OBJECT

    friend class DapListWalletsModel;

protected:
    struct Data;

    Q_PROPERTY (QString walletName              READ walletName             NOTIFY walletNameChanged)
    Q_PROPERTY (QString statusProtected           READ statusProtected          NOTIFY statusProtectedChanged)
    Q_PROPERTY (bool isLoad                     READ isLoad                 NOTIFY isLoadChanged)

protected:
    Data *d;   

protected:
    ItemListWalletBridge (Data *a_data);
public:
    ItemListWalletBridge (QObject *a_parent = nullptr);
    ItemListWalletBridge (const ItemListWalletBridge &a_src);
    ItemListWalletBridge (ItemListWalletBridge &&a_src);
    ~ItemListWalletBridge();

public:
    Q_INVOKABLE QString walletName() const;

    Q_INVOKABLE QString statusProtected() const;

    Q_INVOKABLE bool isLoad() const;

    Q_INVOKABLE DapInfoWalletModel* walletModel() const;

signals:
    void walletNameChanged();
    void statusProtectedChanged();
    void isLoadChanged();

public:
    ItemListWalletBridge &operator = (const ItemListWalletBridge &a_src);
    ItemListWalletBridge &operator = (ItemListWalletBridge &&a_src);

};
Q_DECLARE_METATYPE (ItemListWalletBridge);

class DapListWalletsModel : public QAbstractTableModel
{
    Q_OBJECT

public:

    enum class FieldId
    {
        invalid = -1,
        walletName = Qt::DisplayRole,
        isLoad     = Qt::UserRole,
        statusProtected,
        walletModel
    };
    Q_ENUM(FieldId)

    struct Item
    {
        QString walletName = QString();
        QString statusProtected = QString();
        bool isLoad = false;
    };

    using itemListType = QList<DapListWalletsModel::Item>;

    Q_PROPERTY (int count READ size NOTIFY sizeChanged)

    typedef QList<DapListWalletsModel::Item>::Iterator Iterator;
    typedef QList<DapListWalletsModel::Item>::ConstIterator ConstIterator;

public:
    explicit DapListWalletsModel (QObject *a_parent = nullptr);
    explicit DapListWalletsModel (const DapListWalletsModel &a_src);
    explicit DapListWalletsModel (DapListWalletsModel &&a_src);
    ~DapListWalletsModel();

    Q_INVOKABLE int size() const { return m_items.size(); }
    Q_INVOKABLE QVariant get(int a_index);
    Q_INVOKABLE const QVariant get(int a_index) const;

    int rowCount (const QModelIndex &parent = QModelIndex()) const override;
    int columnCount (const QModelIndex &parent = QModelIndex()) const override;
    QVariant data (const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void updateWallets(const QMap<QString, CommonWallet::WalletInfo> &wallets);
    void clear();
private:

    DapListWalletsModel::Item &_get (int a_index);
    const DapListWalletsModel::Item &_get (int a_index) const;
signals:
    void createModel();

    void sizeChanged();
    void sigSizeChanged (int a_newSize);

protected:
    itemListType m_items;
};

