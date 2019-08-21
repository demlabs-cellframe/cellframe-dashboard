#ifndef DAPSCREENHISTORYMODEL_H
#define DAPSCREENHISTORYMODEL_H

#include <QDebug>
#include <QImage>
#include <QAbstractListModel>
#include <QDateTime>
#include "DapHistoryType.h"

#define MASK_FOR_MODEL QString("MMMM, dd")

class DapScreenHistoryModel : public QAbstractListModel
{
    Q_OBJECT

public:
//    enum DapTransactionStatus {
//        Pending,
//        Sent,
//        Received,
//        Error
//    };
//    Q_ENUM(DapTransactionStatus)

//    struct DapTransactionItem {
//        QDateTime Date;
//        QImage  TokenPic;
//        DapTransactionStatus Status;
//        QString TokenName;
//        QString WalletNumber;
//        QString Cryptocurrency;
//        QString Currency;
//    };

    enum {
        DisplayDateRole = Qt::UserRole,
        DateRole,
        DisplayNameTokenRole,
        DisplayNumberWalletRole,
        DisplayStatusRole,
        StatusColorRole,
        DisplayCryptocurrency,
        DisplayCurrency
    };

private:
    QList<DapTransactionItem> m_elementList;

public:
    explicit DapScreenHistoryModel(QObject *parent = nullptr);
    static DapScreenHistoryModel &getInstance();

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

public slots:
    void receiveNewData(const QVariant& aData);
};

#endif // DAPSCREENHISTORYMODEL_H
