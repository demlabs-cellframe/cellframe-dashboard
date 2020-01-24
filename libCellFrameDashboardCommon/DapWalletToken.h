#ifndef DAPWALLETTOKEN_H
#define DAPWALLETTOKEN_H

#include <QObject>
#include <QString>
#include <QDataStream>

class DapWalletToken : public QObject
{
    Q_OBJECT

    /// Token name.
    QString m_sName;
    /// Token balance.
    double  m_dBalance {0.0};
    /// Token emission.
    quint64 m_iEmission {0};
    /// Network.
    QString m_sNetwork;

public:
    explicit DapWalletToken(const QString& asName = QString(), QObject *parent = nullptr);
    DapWalletToken(const DapWalletToken& aToken);
    DapWalletToken& operator=(const DapWalletToken& aToken);
    bool operator==(const DapWalletToken& aToken) const;

    Q_PROPERTY(QString Name MEMBER m_sName READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(double Balance MEMBER m_dBalance READ getBalance WRITE setBalance NOTIFY balanceChanged)
    Q_PROPERTY(quint64 Emission MEMBER m_iEmission READ getEmission WRITE setEmission NOTIFY emissionChanged)
    Q_PROPERTY(QString Network MEMBER m_sNetwork READ getNetwork WRITE setNetwork NOTIFY networkChanged)


    friend QDataStream& operator << (QDataStream& aOut, const DapWalletToken& aToken);
    friend QDataStream& operator >> (QDataStream& aOut, DapWalletToken& aToken);

signals:
    void nameChanged(const QString & asName);
    void balanceChanged(const double & adBalance);
    void emissionChanged(const qint64& aiEmission);
    void networkChanged(const QString &asNetwork);

public slots:
    QString getName() const;
    void setName(const QString &sName);
    double getBalance() const;
    void setBalance(double dBalance);
    quint64 getEmission() const;
    void setEmission(const quint64 &iEmission);
    QString getNetwork() const;
    void setNetwork(const QString &sNetwork);
};

Q_DECLARE_METATYPE(DapWalletToken)

#endif // DAPWALLETTOKEN_H
