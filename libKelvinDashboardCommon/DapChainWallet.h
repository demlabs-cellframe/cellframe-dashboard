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

public:
    DapChainWallet(QObject *parent = nullptr) {}
    DapChainWallet(const QString& asIconPath, const QString &asName, const QString  &asAddresss, QObject * parent = nullptr);

    Q_PROPERTY(QString iconPath MEMBER m_sIconPath READ getIconPath WRITE setIconPath NOTIFY iconPathChanged)
    Q_PROPERTY(QString name MEMBER m_sName READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString address MEMBER m_sAddress READ getAddress WRITE setAddress NOTIFY addressChanged)

    QString getName() const;
    void setName(const QString &asName);
    QString getAddress() const;
    void setAddress(const QString &asAddress);

    QString getIconPath() const;
    void setIconPath(const QString &asIconPath);

signals:
    void iconPathChanged(const QString& asIconPath);
    void nameChanged(const QString& asName);
    void addressChanged(const QString& asAddress);

};

#endif // DAPCHAINWALLET_H
