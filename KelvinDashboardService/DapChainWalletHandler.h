#ifndef DAPCHAINWALLETHANDLER_H
#define DAPCHAINWALLETHANDLER_H

#include <QObject>
#include <QProcess>
#include <QRegExp>
#include <QDebug>

class DapChainWalletHandler : public QObject
{
    Q_OBJECT

protected:
    virtual QString parse(const QByteArray& aWalletAddress);

public:
    explicit DapChainWalletHandler(QObject *parent = nullptr);

signals:

public slots:
    QStringList createWallet(const QString& asNameWallet);
    QMap<QString, QVariant> getWallets();
    QStringList getWalletInfo(const QString& asNameWallet);
    QString sendToken(const QString &asSendWallet, const QString& asAddressReceiver, const QString& asToken, const double& aAmount);
};

#endif // DAPCHAINWALLETHANDLER_H
