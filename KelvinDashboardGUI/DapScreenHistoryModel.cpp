#include "DapScreenHistoryModel.h"

DapScreenHistoryModel::DapScreenHistoryModel(QObject *parent)
    : QAbstractListModel(parent)
{

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

void DapScreenHistoryModel::receiveNewData(const QVariant& aData)
{
    beginResetModel();
    QList<QVariant> dataList = aData.toList();
    m_elementList.clear();

    for(int i = 0; i < dataList.count(); i++)
    {
        //  Description QStringList
        //  ------------------------
        //  0:  date
        //  1:  status
        //  2:  currency
        //  3:  token
        //  4:  wallet_to
        //  5:  wallet_from

        QStringList dataItem = dataList.at(i).toStringList();
        DapTransactionItem item;
        item.Date = QDateTime::fromString(dataItem.at(0), "ddd MMM dd h:mm:ss YYYY");
        item.Status = static_cast<DapTransactionStatus>(dataItem.at(1).toInt());
        item.Cryptocurrency = dataItem.at(2);
        item.TokenName = dataItem.at(3);
        item.WalletNumber = dataItem.at(5);
        item.Currency = "$ 0 USD";          //  TODO:
        m_elementList.append(item);
    }
    endResetModel();
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
        case DisplayDateRole:
        {
            QDateTime currentTime = QDateTime::currentDateTime();
            QDateTime itemDate = m_elementList.at(index.row()).Date;
            if(currentTime == itemDate) return QString("Today");
            return itemDate.toString(MASK_FOR_MODEL);
        }
        case DisplayNameTokenRole:      return m_elementList.at(index.row()).TokenName;
        case DisplayNumberWalletRole:   return m_elementList.at(index.row()).WalletNumber;
        case DisplayStatusRole:         return m_elementList.at(index.row()).Status;
        case DisplayCryptocurrency:     return m_elementList.at(index.row()).Cryptocurrency;
        case DisplayCurrency:           return m_elementList.at(index.row()).Currency;
        default:                        return QVariant();
    }
}
