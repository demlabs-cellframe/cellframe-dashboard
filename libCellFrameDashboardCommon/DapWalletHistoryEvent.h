#ifndef DAPWALLETHISTORYEVENT_H
#define DAPWALLETHISTORYEVENT_H

#include <QObject>
#include <QString>
#include <QDataStream>

class DapWalletHistoryEvent : public QObject
{
    Q_OBJECT

    QString m_sWallet;
    /// Token name.
    QString m_sName;
    /// Token balance.
    QString  m_sStatus;

    double  m_dAmount {0.0};

    QString m_sDate;

public:
    explicit DapWalletHistoryEvent(QObject *parent = nullptr);
    DapWalletHistoryEvent(const DapWalletHistoryEvent& aHistoryEvent);
    DapWalletHistoryEvent& operator=(const DapWalletHistoryEvent& aHistoryEvent);
    bool operator==(const DapWalletHistoryEvent& aHistoryEvent) const;

    Q_PROPERTY(QString Wallet MEMBER m_sWallet READ getWallet WRITE setWallet NOTIFY walletChanged)
    Q_PROPERTY(QString Name MEMBER m_sName READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(double Amount MEMBER m_dAmount READ getAmount WRITE setAmount NOTIFY amountChanged)
    Q_PROPERTY(QString Status MEMBER m_sName READ getStatus WRITE setStatus NOTIFY statusChanged)
    Q_PROPERTY(QString Date MEMBER m_dAmount READ getDate WRITE setDate NOTIFY dateChanged)

    friend QDataStream& operator << (QDataStream& aOut, const DapWalletHistoryEvent& aHistoryEvent);
    friend QDataStream& operator >> (QDataStream& aOut, DapWalletHistoryEvent& aHistoryEvent);

signals:
    void walletChanged(const QString& asWallet);
    void nameChanged(const QString& asName);
    void amountChanged(const double& adAmount);
    void statusChanged(const QString& asStatus);
    void dateChanged(const QString& asDate);

public slots:
    QString getWallet() const;
    void setWallet(const QString &sWallet);
    QString getName() const;
    void setName(const QString &sName);
    double getAmount() const;
    void setAmount(double dAmount);
    QString getStatus() const;
    void setStatus(const QString &sStatus);
    QString getDate() const;
    void setDate(const QString &sDate);
};

#endif // DAPWALLETHISTORYEVENT_H
