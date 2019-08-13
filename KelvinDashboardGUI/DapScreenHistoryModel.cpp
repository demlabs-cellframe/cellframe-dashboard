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
        element.Status = "Sent";
        element.Currency = QString("$ 1020201010%1").arg(i);
        element.Cryptocurrency = QString("KLV 4443222111%1").arg(i);
        m_elementList.append(element);
    }

    for(int i = 0; i < 5; i++)
    {
        DapTransactionItem element;
        element.TokenName = QString("token %1").arg(i);
        element.Date = "yesterday";
        element.WalletNumber = "number wallet";
        element.Status = "Error";
        element.Currency = QString("$ 15647475623820%1").arg(i);
        element.Cryptocurrency = QString("KLV 454535453%1").arg(i);
        m_elementList.append(element);
    }

//    DapTransactionItem element;
//    element.TokenName = QString("token new");
//    element.Date = "today";
//    element.WalletNumber = "number wallet 1221";
//    element.Status = "sent";
//    element.Currency = QString("$ 1555444");
//    element.Cryptocurrency = QString("KLV 44433");
//    m_elementList.append(element);
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
    names[DisplayStatusRole] = "txStatus";
    names[DisplayCryptocurrency] = "cryptocurrency";
    names[DisplayCurrency] = "currency";
    return names;
}

int DapScreenHistoryModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) return 0;
    return m_elementList.count();
}

QVariant DapScreenHistoryModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid()) return QVariant();

    switch (role)
    {
        case DisplayDateRole:           return m_elementList.at(index.row()).Date;
        case DisplayNameTokenRole:      return m_elementList.at(index.row()).TokenName;
        case DisplayNumberWalletRole:   return m_elementList.at(index.row()).WalletNumber;
        case DisplayStatusRole:         return m_elementList.at(index.row()).Status;
        case DisplayCryptocurrency:     return m_elementList.at(index.row()).Cryptocurrency;
        case DisplayCurrency:           return m_elementList.at(index.row()).Currency;
        default:                        return QVariant();
    }
}
