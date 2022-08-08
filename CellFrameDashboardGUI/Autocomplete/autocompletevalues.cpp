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
        s = files[i].remove(".dpkg-new");
        if (s != "." && s != "..")
            networks.append(s);
    }
    networks.removeDuplicates();
}

void AutocompleteValues::_getChains()
{
    QProcess process;
    QString command = QString("%1 net list chains").arg(CLI_PATH);
    process.start(command);
    process.waitForFinished(-1);
    QString result = QString::fromLatin1(process.readAll());

    result = result.remove("Networks:\n\t");
    result = result.remove(":");
    result = result.remove("\n");
    result = result.remove("\r");
    QStringList list = result.split("\t");
    list.removeAll("");

    QString netKey = list[0];
    QStringList chainList;

    for (int i = 1; i < list.length(); ++i)
    {
        if (!networks.contains(list[i]))
        {
            chainList.append(list[i]);
            chains.append(list[i]);
            if (chainNets.keys().contains(list[i]))
                chainNets[list[i]].append(netKey);
            else
                chainNets.insert(list[i], {netKey});
        }
        else
        {
            netChains.insert(netKey, chainList);
            chainList.clear();
            netKey = list[i];
        }
    }
    netChains.insert(netKey, chainList);
    chains.removeDuplicates();
    for (int i = 0; i < chainNets.keys().length(); ++i)
    {
        chainNets[chainNets.keys()[i]].removeDuplicates();
    }
}

void AutocompleteValues::_getMempoolTokens()
{
    for (int i = 0; i < networks.length(); ++i)
    {
        QProcess process2;
        QString command = QString("%1 ledger list coins -net %2").arg(CLI_PATH).arg(networks[i]);
        process2.start(command);
        process2.waitForFinished(-1);
        QString result = QString::fromLatin1(process2.readAll());

        QStringList list = result.split("\n");
        QStringList resList;

        for (int j = 0; j < list.length(); ++j)
            if (list[j].contains("Token name"))
                resList.append(list[j]);

        for (int j = 0; j < resList.length(); ++j)
        {
            int k = 12;
            QString tokenName = "";
            while (resList[j][k] != '\'')
            {
                tokenName += resList[j][k];
                ++k;
            }
            resList[j] = tokenName;
        }
        mempoolTokens.insert(networks[i], resList);
    }
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
    _getChains();
    _getMempoolTokens();
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

QStringList AutocompleteValues::getAllChains()
{
    return chains;
}

QStringList AutocompleteValues::getChainsByNetwork(const QString &netName)
{
    return netChains[netName];
}

QStringList AutocompleteValues::getNetworkByChain(const QString &chainName)
{
    return chainNets[chainName];
}

QStringList AutocompleteValues::getAllMempoolTokens()
{
    QStringList res = {};
    for (int i = 0; i < mempoolTokens.keys().length(); ++i)
    {
        res += mempoolTokens[mempoolTokens.keys()[i]];
    }
    return res;
}

QStringList AutocompleteValues::getMempoolTokensByNetwork(const QString &netName)
{
    return mempoolTokens[netName];
}
