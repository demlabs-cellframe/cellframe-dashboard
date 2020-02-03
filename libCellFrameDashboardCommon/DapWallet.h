#ifndef DAPWALLET_H
#define DAPWALLET_H

#include <QObject>
#include <QString>
#include <QList>
#include <QQmlEngine>

#include "DapWalletToken.h"

class DapWallet : public QObject
{
    Q_OBJECT

    QString         m_sName;
    double          m_dBalance {0.0};
    QString         m_sIcon;
    QString         m_sAddress = "private";
    QStringList     m_aNetworks;
    QMap<QString, QString>   m_aAddresses;
    mutable QList<DapWalletToken*>   m_aTokens;

public:
    Q_INVOKABLE explicit DapWallet(QObject * parent = nullptr);
    Q_INVOKABLE DapWallet(const DapWallet& aWallet);
    Q_INVOKABLE DapWallet& operator=(const DapWallet& aToken);


    Q_PROPERTY(QString Name MEMBER m_sName READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(double Balance MEMBER m_dBalance READ getBalance WRITE setBalance NOTIFY balanceChanged)
    Q_PROPERTY(QString Icon MEMBER m_sIcon READ getIcon WRITE setIcon NOTIFY iconChanged)
    Q_PROPERTY(QString Address MEMBER m_sAddress READ getAddress NOTIFY addressChanged)
    Q_PROPERTY(QStringList Networks MEMBER m_aNetworks READ getNetworks NOTIFY networksChanged)
    Q_PROPERTY(QList<QObject*> Tokens READ getTokens NOTIFY tokensChanged)


    friend QDataStream& operator << (QDataStream& aOut, const DapWallet& aToken);
    friend QDataStream& operator >> (QDataStream& aOut, DapWallet& aToken);
    friend bool operator == (const DapWallet &aWalletFirst, const DapWallet &aWalletSecond);

    static DapWallet fromVariant(const QVariant& aWallet);

signals:
    void nameChanged(const QString& asName);
    void balanceChanged(const double& adBalance);
    void iconChanged(const QString &asIcon);
    void addressChanged(const QString& asAddress);
    void networkAdded(const QString& asNetwork);
    void networksChanged(const QStringList& asNetworks);
    void tokensChanged(const QList<QObject*> asTokens);
    void tokenAdded(const DapWalletToken& asNetwork);

public slots:
    QString getName() const;
    void setName(const QString &asName);
    double getBalance() const;
    void setBalance(const double& adBalance);
    QString getIcon() const;
    void setIcon(const QString &sIcon);
    void addNetwork(const QString& asNetwork);
    QStringList getNetworks() const;
    Q_INVOKABLE void setAddress(const QString& asNetwork);
    QString getAddress() const;
    void addAddress(const QString &aiAddress, const QString& asNetwork);
    Q_INVOKABLE QString findAddress(const QString &asNetwork) const;
    QMap<QString, QString> getAddresses() const;
    void addToken(DapWalletToken *asToken);
    Q_INVOKABLE QList<DapWalletToken*> findTokens(const QString& asNetwork);
    Q_INVOKABLE QList<QObject*> getTokens() const;
};

Q_DECLARE_METATYPE(DapWallet)


#endif // DAPWALLET_H
