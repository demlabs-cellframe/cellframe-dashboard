#ifndef DAPCHAINWALLET_H
#define DAPCHAINWALLET_H

#include <QObject>
#include <QString>
#include <QList>
#include <QDataStream>

struct DapChainWalletData
{
    QString IconPath;
    QString Name;
    QString Address;
    QString Network;

    friend QDataStream& operator << (QDataStream& aOut, const DapChainWalletData& aData)
    {
        aOut << aData.IconPath
             << aData.Name
             << aData.Address
             << aData.Network;
        return aOut;
    }

    friend QDataStream& operator >> (QDataStream& aOut, DapChainWalletData& aData)
    {
        aOut >> aData.IconPath
             >> aData.Name
             >> aData.Address
             >> aData.Network;
        return aOut;
    }

    DapChainWalletData& operator = (const DapChainWalletData& aData)
    {
        IconPath = aData.IconPath;
        Name = aData.Name;
        Address = aData.Address;
        Network = aData.Network;
        return *this;
    }

    bool operator == (const DapChainWalletData& aData) const {
        return Address == aData.Address;
    }
};

struct DapChainWalletTokenData {
    QString Name;
    double Balance;
    quint64 Emission;

    friend QDataStream& operator << (QDataStream& aOut, const DapChainWalletTokenData& aData)
    {
        aOut << aData.Name
             << aData.Balance
             << aData.Emission;
        return aOut;
    }

    friend QDataStream& operator >> (QDataStream& aOut, DapChainWalletTokenData& aData)
    {
        aOut >> aData.Name
             >> aData.Balance
             >> aData.Emission;
        return aOut;
    }

    DapChainWalletTokenData& operator = (const DapChainWalletTokenData& aData)
    {
        Name = aData.Name;
        Balance = aData.Balance;
        Emission = aData.Emission;
        return *this;
    }

    bool operator == (const DapChainWalletTokenData& aData) const {
        return Name == aData.Name;
    }
};

class DapChainWalletTokenItem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(double balance READ balance WRITE setBalance NOTIFY balanceChanged)
    Q_PROPERTY(quint64 emission READ emission WRITE setEmission NOTIFY emissionChanged)
    Q_PROPERTY(QString wallet READ wallet)

private:
    QString m_wallet;
    QString m_name;
    double m_balance;
    quint64 m_emission;

public:
    explicit DapChainWalletTokenItem(const QString& aWalletAddress, QObject *parent = nullptr);
    explicit DapChainWalletTokenItem(const QString& aWalletAddress, const DapChainWalletTokenData& aData, QObject *parent = nullptr);

    QString name() const;
    double balance() const;
    quint64 emission() const;
    QString wallet() const;

public slots:
    void setName(const QString& aName);
    void setBalance(const double aBalance);
    void setEmission(const quint64 aEmission);
    void setData(const DapChainWalletTokenData& aData);

signals:
    void nameChanged(QString name);
    void balanceChanged(double balance);
    void emissionChanged(quint64 emission);
};

typedef QList<DapChainWalletTokenItem*> DapChainWalletTokenItemList;
typedef QList<DapChainWalletTokenData> DapChainWalletTokenList;
typedef QPair<DapChainWalletData, DapChainWalletTokenItemList> DapChainWalletPair;








class DapChainWallet : public QObject
{
    Q_OBJECT

    /// Icon path
    QString m_sIconPath;
    /// Name of wallet
    QString m_sName;
    /// Address of wallet
    QString m_sAddress;
    /// Balance
    QStringList  m_balance;
    /// Tokens name
    QStringList  m_tokens;
    /// number of tokens
    int m_iCount;

public:
    /// Standard constructor
    DapChainWallet(QObject *parent = nullptr) { Q_UNUSED(parent)}
    /// overloaded constructor
    /// @param asIconPath Path icon
    /// @param asName Name of wallet
    /// @param asAddresss Address for wallet
    /// @param aBalance Balance
    /// @param aTokens Tokens name
    DapChainWallet(const QString& asIconPath, const QString &asName, const QString  &asAddress, const QStringList &aBalance, const QStringList& aTokens, QObject * parent = nullptr);
    /// overloaded constructor
    /// @param asIconPath Path icon
    /// @param asName Name of wallet
    /// @param asAddresss Address for wallet
    DapChainWallet(const QString& asIconPath, const QString &asName, const QString  &asAddress, QObject * parent = nullptr);


    Q_PROPERTY(QString iconPath MEMBER m_sIconPath READ getIconPath WRITE setIconPath NOTIFY iconPathChanged)
    Q_PROPERTY(QString name MEMBER m_sName READ getName WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString address MEMBER m_sAddress READ getAddress WRITE setAddress NOTIFY addressChanged)
    Q_PROPERTY(QStringList balance MEMBER m_balance READ getBalance WRITE setBalance NOTIFY balanceChanged)
    Q_PROPERTY(QStringList tokens MEMBER m_tokens READ getTokens WRITE setTokens NOTIFY tokensChanged)
    Q_PROPERTY(int count MEMBER m_iCount READ getCount)

    /// Get name of wallet
    /// @return name of wallet
    QString getName() const;
    /// Set name of wallet
    /// @param asName name of wallet
    void setName(const QString &asName);
    /// Get address of wallet
    /// @return Address of wallet
    QString getAddress() const;
    /// Set address for wallet
    /// @param asAddress address for wallet
    void setAddress(const QString &asAddress);

    /// Get icon path
    /// @return Icon path
    QString getIconPath() const;
    /// Set icon path
    /// @param asIconPath Icon path
    void setIconPath(const QString &asIconPath);

    /// Get balance
    QStringList getBalance() const;
    /// Set balance
    void setBalance(const QStringList& aBalance);
    
    /// Get tokens name
    /// @return tokens name
    QStringList getTokens() const;
    /// Set tokens name
    /// @param aTokens tokens name
    void setTokens(const QStringList& aTokens);

    /// get number of tokens
    /// @return number of tokens
    int getCount() const;

signals:
    /// Signal changes for icon path
    /// @param asIconPath Icon path
    void iconPathChanged(const QString& asIconPath);
    /// Signal changes for name of wallet
    /// @param asName name of wallet
    void nameChanged(const QString& asName);
    /// Signal changes for address of wallet
    /// @param asAddress address of wallet
    void addressChanged(const QString& asAddress);
    /// Signal changes for balance
    /// @param aBalance balance
    void balanceChanged(const QStringList& aBalance);
    /// Signal changes for tokens
    /// @param aTokens tokens name
    void tokensChanged(const QStringList& aTokens);

};

#endif // DAPCHAINWALLET_H
