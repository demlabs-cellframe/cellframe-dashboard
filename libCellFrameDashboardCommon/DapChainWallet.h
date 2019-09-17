#ifndef DAPCHAINWALLET_H
#define DAPCHAINWALLET_H

#include <QObject>
#include <QString>

class DapChainWallet : public QObject
{
    Q_OBJECT

    QString m_sIconPath;
    QString m_sName;
    QString m_sAddress;
    QStringList  m_balance;
    QStringList  m_tokens;
    int m_iCount;

public:
    DapChainWallet(QObject *parent = nullptr) { Q_UNUSED(parent)}
    DapChainWallet(const QString& asIconPath, const QString &asName, const QString  &asAddresss, const QStringList &aBalance, const QStringList& aTokens, QObject * parent = nullptr);
    DapChainWallet(const QString& asIconPath, const QString &asName, const QString  &asAddresss, QObject * parent = nullptr);


    Q_PROPERTY(QString iconPath MEMBER m_sIconPath READ getIconPath WRITE setIconPath NOTIFY iconPathChanged)
    Q_PROPERTY(QString name MEMBER m_sName READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString address MEMBER m_sAddress READ getAddress WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(QStringList balance MEMBER m_balance READ getBalance WRITE setBalance NOTIFY balanceChanged)
    Q_PROPERTY(QStringList tokens MEMBER m_tokens READ getTokens WRITE setTokens NOTIFY tokensChanged)
    Q_PROPERTY(int count MEMBER m_iCount READ getCount)

    /// Get name of wallet
    QString getName() const;
    /// Set name for wallet
    void setName(const QString &asName);
    /// Get address of wallet
    QString getAddress() const;
    /// Set address for wallet
    void setAddress(const QString &asAddress);

    /// Get icon path
    QString getIconPath() const;
    /// Set icon path
    void setIconPath(const QString &asIconPath);

    /// Get balance
    QStringList getBalance() const;
    /// Set balance
    void setBalance(const QStringList& aBalance);
    
    /// Get tokens name
    QStringList getTokens() const;
    /// Set tokens name
    void setTokens(const QStringList& aTokens);

    /// get number of tokens
    int getCount() const;

signals:
    /// Signal changes for icon path
    void iconPathChanged(const QString& asIconPath);
    /// Signal changes for name of wallet
    void nameChanged(const QString& asName);
    /// Signal changes for address of wallet
    void addressChanged(const QString& asAddress);
    /// Signal changes for balance
    void balanceChanged(const QStringList& aBalance);
    /// Signal changes for tokens
    void tokensChanged(const QStringList& aTokens);

};

#endif // DAPCHAINWALLET_H
