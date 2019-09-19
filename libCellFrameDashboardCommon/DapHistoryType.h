#ifndef DAPHISTORYTYPE_H
#define DAPHISTORYTYPE_H

#include <QDateTime>
#include <QImage>
#include <QMap>
#include <QStringList>

/// Enumeration of transaction status
enum DapTransactionStatus {
    stUnknow,
    stPending,
    stSent,
    stReceived,
    stError
};

/// Structure for transaction item
struct DapTransactionItem {
    QDateTime Date;
    QImage  TokenPic;
    DapTransactionStatus Status;
    QString TokenName;
    QString WalletNumber;
    QString Cryptocurrency;
    QString Currency;
};

/// Class-convertor transaction status
/// @todo This class does not have all statuses
class DapTransactionStatusConvertor
{

private:
    static const QMap<DapTransactionStatus, QStringList> m_statusMap;

public:
    /// Get short text of status. CLI uses short text of transaction
    /// @param enum status of transaction
    /// @return short text of status
    static QString getShortStatus(const DapTransactionStatus aStatus);
    /// Get long text of status. Client uses long text of status
    /// @param enum status of transaction
    /// @return long text of status
    static QString getLongStatus(const DapTransactionStatus aStatus);
    /// Get enum status tranaction by short text of status tranasction
    /// @param short text of trasaction
    /// @return enum status of tranaction
    static DapTransactionStatus getStatusByShort(const QString& aShortStatus);
    /// Get enum status of tranaction by long text of transaction
    /// @param long text of transaction
    /// @return enum status of transaction
    static DapTransactionStatus getStatusByLong(const QString& aLongStatus);
    /// Get color for status of transaction
    /// @param enum status of transaction
    /// @return color for status of transaction
    static QColor getStatusColor(const DapTransactionStatus aStatus);
};

#endif // DAPHISTORYTYPE_H
