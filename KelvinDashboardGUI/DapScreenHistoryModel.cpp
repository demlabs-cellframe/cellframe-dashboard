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
    names[DateRole] = "dateRole";
    names[StatusColorRole] = "statusColor";
    return names;
}

QString DapScreenHistoryModel::toConvertCurrency(const QString& aMoney) const
{
    QString money;

    QStringList major = aMoney.split(".");
    if(!major.isEmpty()) money = major.at(0);
    else money = aMoney;

    for (int i = money.size() - 3; i >= 1; i -= 3)
        money.insert(i, ' ');

    if(major.count() > 1) money.append("." + major.at(1));

    return money;
}

void DapScreenHistoryModel::receiveNewData(const QVariant& aData)
{
    if(!aData.isValid())
    {
        qWarning() << "New history data is not valid";
        return;
    }

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
        item.Date = QDateTime::fromString(dataItem.at(0), Qt::RFC2822Date);
        item.Status = static_cast<DapTransactionStatus>(dataItem.at(1).toInt());
        item.Cryptocurrency = dataItem.at(2);
        item.TokenName = dataItem.at(3);
        item.WalletNumber = dataItem.at(5);
        //  TODO: Later we should convert currency
        item.Currency = QString::number(dataItem.at(2).toDouble() * 0.98);

        switch (item.Status) {
            case DapTransactionStatus::stSent:
                item.Cryptocurrency.prepend("- ");
                item.Currency.prepend("- $ ");
            break;
            case DapTransactionStatus::stReceived:
                item.Cryptocurrency.prepend("+ ");
                item.Currency.prepend("+ $ ");
            break;
            default: break;
        }

        item.Cryptocurrency = toConvertCurrency(item.Cryptocurrency);
        item.Cryptocurrency += " " + item.TokenName;
        item.Currency.append(" USD");

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
            if(currentTime.date() == itemDate.date()) return QString("Today");
            return itemDate.toString(MASK_FOR_MODEL);
        }
        case DisplayNameTokenRole:      return m_elementList.at(index.row()).TokenName;
        case DisplayNumberWalletRole:   return m_elementList.at(index.row()).WalletNumber;
        case DisplayStatusRole:         return DapTransactionStatusConvertor::getLongStatus(m_elementList.at(index.row()).Status);
        case DisplayCryptocurrency:     return m_elementList.at(index.row()).Cryptocurrency;
        case DisplayCurrency:           return m_elementList.at(index.row()).Currency;
        case DateRole:                  return m_elementList.at(index.row()).Date;
        case StatusColorRole:           return DapTransactionStatusConvertor::getStatusColor(m_elementList.at(index.row()).Status);
        case StatusRole:                return m_elementList.at(index.row()).Status;
        default:                        return QVariant();
    }
}
