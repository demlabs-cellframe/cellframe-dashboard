#ifndef DAPHISTORYTYPE_H
#define DAPHISTORYTYPE_H

#include <QDateTime>
#include <QImage>
#include <QMap>
#include <QStringList>

enum DapTransactionStatus {
    stUnknow,
    stPending,
    stSent,
    stReceived,
    stError
};

struct DapTransactionItem {
    QDateTime Date;
    QImage  TokenPic;
    DapTransactionStatus Status;
    QString TokenName;
    QString WalletNumber;
    QString Cryptocurrency;
    QString Currency;
};

class DapTransactionStatusConvertor
{

private:
    static const QMap<DapTransactionStatus, QStringList> m_statusMap;

public:
    static QString getShortStatus(const DapTransactionStatus aStatus);
    static QString getLongStatus(const DapTransactionStatus aStatus);
    static DapTransactionStatus getStatusByShort(const QString& aShortStatus);
    static DapTransactionStatus getStatusByLong(const QString& aLongStatus);
    static QColor getStatusColor(const DapTransactionStatus aStatus);
};

#endif // DAPHISTORYTYPE_H
