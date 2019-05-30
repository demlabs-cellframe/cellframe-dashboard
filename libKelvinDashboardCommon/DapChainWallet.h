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
    QString  m_balance;

public:
    DapChainWallet(QObject *parent = nullptr) { Q_UNUSED(parent)}
    DapChainWallet(const QString& asIconPath, const QString &asName, const QString  &asAddresss, const QString &aBalance, QObject * parent = nullptr);
    DapChainWallet(const QString& asIconPath, const QString &asName, const QString  &asAddresss, QObject * parent = nullptr);


    Q_PROPERTY(QString iconPath MEMBER m_sIconPath READ getIconPath WRITE setIconPath NOTIFY iconPathChanged)
    Q_PROPERTY(QString name MEMBER m_sName READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString address MEMBER m_sAddress READ getAddress WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(QString balance MEMBER m_balance READ getBalance WRITE setBalance NOTIFY balanceChanged)

    QString getName() const;
    void setName(const QString &asName);
    QString getAddress() const;
    void setAddress(const QString &asAddress);

    QString getIconPath() const;
    void setIconPath(const QString &asIconPath);

    QString getBalance() const;
    void setBalance(const QString& aBalance);

signals:
    void iconPathChanged(const QString& asIconPath);
    void nameChanged(const QString& asName);
    void addressChanged(const QString& asAddress);
    void balanceChanged(const QString& aBalance);

};

#endif // DAPCHAINWALLET_H
