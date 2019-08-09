#include "DapScreenHistoryModel.h"

DapScreenHistoryModel::DapScreenHistoryModel(QObject *parent)
    : QAbstractListModel(parent)
{
    for(int i = 0; i < 5; i++)
    {
        DapTransactionItem element;
        element.TokenName = QString("token %1").arg(i);
        element.Date = "today";
        element.WalletNumber = "number wallet";
        element.Status = "sent";
        m_elementList.append(element);
    }

    for(int i = 0; i < 5; i++)
    {
        DapTransactionItem element;
        element.TokenName = QString("token %1").arg(i);
        element.Date = "yesterday";
        element.WalletNumber = "number wallet";
        element.Status = "sent";
        m_elementList.append(element);
    }
}

DapScreenHistoryModel& DapScreenHistoryModel::getInstance()
{
    static DapScreenHistoryModel instance;
    return instance;
}

QHash<int, QByteArray> DapScreenHistoryModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[DisplayDateRole] = "date";
    names[DisplayNameTokenRole] = "tokenName";
    names[DisplayNumberWalletRole] = "numberWallet";
    return names;
}

int DapScreenHistoryModel::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid()) return 0;

    // FIXME: Implement me!
    return m_elementList.count();
}

QVariant DapScreenHistoryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) return QVariant();

    switch (role)
    {
        case DisplayDateRole: return m_elementList.at(index.row()).Date;
        case DisplayNameTokenRole: return m_elementList.at(index.row()).TokenName;
        case DisplayNumberWalletRole: return m_elementList.at(index.row()).WalletNumber;
        default: return QVariant();
    }
}
