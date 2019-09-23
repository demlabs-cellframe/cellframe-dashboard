#ifndef DAPCHAINWALLETHANDLER_H
#define DAPCHAINWALLETHANDLER_H

#include <QObject>
#include <QProcess>
#include <QRegExp>
#include <QDebug>

class DapChainWalletHandler : public QObject
{
    Q_OBJECT

private:
    QString m_CurrentNetwork;

protected:
    virtual QString parse(const QByteArray& aWalletAddress);

public:
    explicit DapChainWalletHandler(QObject *parent = nullptr);

signals:

public slots:
    QStringList createWallet(const QString& asNameWallet);
    void removeWallet(const QString& asNameWallet);
    QMap<QString, QVariant> getWallets();
    QStringList getWalletInfo(const QString& asNameWallet);
    QString sendToken(const QString &asSendWallet, const QString& asAddressReceiver, const QString& asToken, const QString& aAmount);
    void setCurrentNetwork(const QString& aNetwork);
};

#endif // DAPCHAINWALLETHANDLER_H
