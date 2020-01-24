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
    QList<QString>  m_aNetworks;
    QMap<QString, QString>   m_aAddress;
    QList<DapWalletToken>   m_aTokens;

public:
    Q_INVOKABLE explicit DapWallet(const QString& asName = QString(), QObject * parent = nullptr);
    Q_INVOKABLE DapWallet(const DapWallet& aToken);
    Q_INVOKABLE DapWallet& operator=(const DapWallet& aToken);

    Q_PROPERTY(QString Name MEMBER m_sName READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QList<QString> Networks MEMBER m_aNetworks READ getNetworks NOTIFY networkAdded)


    friend QDataStream& operator << (QDataStream& aOut, const DapWallet& aToken);
    friend QDataStream& operator >> (QDataStream& aOut, DapWallet& aToken);

    Q_INVOKABLE QObject* fromVariant(const QVariant& aWallet);

signals:
    void nameChanged(const QString& asName);
    void networkAdded(const QString& asName);

public slots:

    QString getName() const;
    void setName(const QString &sName);
    void addNetwork(const QString& asNetwork);
    QList<QString>& getNetworks();
    void setAddress(const QString &aiAddress, const QString& asNetwork);
    QString getAddress(const QString& asNetwork);
    void addToken(DapWalletToken asName);
    QList<DapWalletToken*> getTokens(const QString& asNetwork);



};

Q_DECLARE_METATYPE(DapWallet)


#endif // DAPWALLET_H
