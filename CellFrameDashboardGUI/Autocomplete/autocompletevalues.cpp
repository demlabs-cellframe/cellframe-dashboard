#include "autocompletevalues.h"
#include <QDir>
#include <QFile>
#include <QDebug>

#ifdef Q_OS_WIN
#include "registry.h"
#define PRIV_CERT_PATH QString("%1/cellframe-node/var/lib/ca/").arg(regGetUsrPath())
#define PUB_CERT_PATH QString("%1/cellframe-node/share/ca/").arg(regGetUsrPath())
#define NETWORKS_PATH QString("%1/cellframe-node/etc/network/").arg(regGetUsrPath())
#endif

#ifdef Q_OS_MAC
#define PUB_CERT_PATH QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/share/ca/").arg(getenv("USER"))
#define PRIV_CERT_PATH QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/var/lib/ca/").arg(getenv("USER"))
#define NETWORKS_PATH QString("/Users/%1/Applications/Cellframe.app/Contents/Resources/etc/network/").arg(getenv("USER"))
#endif

#ifdef Q_OS_LINUX
#define PUB_CERT_PATH QString("/opt/cellframe-node/share/ca")
#define PRIV_CERT_PATH QString("/opt/cellframe-node/var/lib/ca")
#define NETWORKS_PATH QString("/opt/cellframe-node/etc/network/")
#endif

void AutocompleteValues::_getCerts()
{
    QDir pubDir(PUB_CERT_PATH);
    pubDir.setFilter(QDir::Files | QDir::Hidden);
    QStringList files = pubDir.entryList();
    for (int i = 0; i < files.length(); ++i)
    {
        QString s = files[i].remove(".dcert");
        if (s != "." && s != "..")
            pubCerts.append(s);
    }

    QDir privDir(PRIV_CERT_PATH);
    privDir.setFilter(QDir::Files | QDir::Hidden);
    files = privDir.entryList();
    for (int i = 0; i < files.length(); ++i)
    {
        QString s = files[i].remove(".dcert");
        if (s != "." && s != "..")
            privCerts.append(s);
    }
}

void AutocompleteValues::_getNetworks()
{
    QDir netDir(NETWORKS_PATH);
    netDir.setFilter(QDir::Files | QDir::Hidden);
    QStringList files = netDir.entryList();
    for (int i = 0; i < files.length(); ++i)
    {
        QString s = files[i].remove(".cfg");
        s = files[i].remove(".tpl");
        if (s != "." && s != "..")
            networks.append(s);
    }
    networks.removeDuplicates();
}

AutocompleteValues::AutocompleteValues(DapServiceController *_serviceController, QObject *parent)
    : QObject{parent}
{
    serviceController = _serviceController;

    connect(serviceController, &DapServiceController::walletsInfoReceived, [=] (const QVariant& walletList)
    {
        QByteArray  array = QByteArray::fromHex(walletList.toByteArray());
        QList<DapWallet> tempWallets;

        QDataStream in(&array, QIODevice::ReadOnly);
        in >> tempWallets;

        auto begin = tempWallets.begin();
        auto end = tempWallets.end();
        DapWallet * wallet = nullptr;
        for(;begin != end; ++begin)
        {
            wallet = new DapWallet(*begin);
            wallets.append(wallet->getName());
            QList<QObject*> _tokens = wallet->getTokens();

            for (int i = 0; i < _tokens.length(); ++i)
            {
                DapToken *token = (DapToken *)(_tokens[i]);
                tokens.append(token->name());
            }

            for (int i = 0; i < _tokens.length(); ++i)
                delete(_tokens[i]);
        }

        delete(wallet);
    });

    _getCerts();
    _getNetworks();
}

QStringList AutocompleteValues::getPubCerts()
{
    return pubCerts;
}

QStringList AutocompleteValues::getPrivCerts()
{
    return privCerts;
}

QStringList AutocompleteValues::getNetworks()
{
    return networks;
}

QStringList AutocompleteValues::getWallets()
{
    return wallets;
}

QStringList AutocompleteValues::getTokens()
{
    return tokens;
}
